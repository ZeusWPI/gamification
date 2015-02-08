module Stats

  class StatsBuilder
    def initialize &block
      @targets = {}
      @providers = ProviderCollection.new
      instance_eval(&block)
    end

    def get_stats target, stats
      target = @targets[target].try do |t|
        t.fetch @providers, stats
      end
    end

    def add_target target
      @targets[target.name] = target
    end

    def provider model, &block
      @providers.add_provider Provider.new(model, &block)
    end

    def target name, &block
      @targets[name] = Target.new(name, &block)
    end

  end

  class Target
    attr_reader :name

    def initialize name, &block
      @name = name
      if block
        instance_eval(&block)
      else
        set_defaults
      end
    end

    def group_by &block
      @group_by = Proc.new(&block)
    end

    def merge_with model, attr = :id
      @merge = Proc.new do |stats|
        model.where(attr => stats.keys).map do |obj|
          obj.attributes.merge! stats[obj.send(attr)]
        end
      end
    end

    def postproc &block
      @postproc = Proc.new(&block)
    end

    def fetch provider, stats
      res = provider.fetch_stats stats, &@group_by
      res = @merge.call(res) if @merge
      res = @postproc.call(res) if @postproc
      res
    end

    private
    def set_defaults
      model = @name.classify.constantize
      if defined? model and model < ActiveRecord::Base
        group_by { |obj| obj.send(@name + '_id') }
        merge_with model
      else
        group_by { |obj| obj.send(@name) }
      end
    end
  end

  class ProviderCollection
    def initialize
      @providers = {}
    end

    def fetch_stats stats, &group
      statmap = stats.group_by { |s| @providers[s] }
      statmap.delete nil # Cannot provide these stats
      # Fetch and merge stats
      statmap.map {|p, ss| p.fetch_stats(ss, &group)}.reduce do |a,b|
        (a.keys | b.keys).inject({}) do |hash, key|
          hash.update key => a[key].merge(b[key])
        end
      end
    end

    def add_provider provider
      provider.statmap.each_key do |key|
        @providers[key] = provider
      end
    end

    private


  end

  class Provider
    attr_reader :model, :attrmap, :statmap

    def initialize model, &block
      @model = model
      @attrmap = {}
      @statmap = {}
      instance_eval(&block)
    end

    def fetch_stats stats, &group
      hash = query.group_by(&wrap_proc(&group))
      hash.default = get_stats stats, []
      # compute stats
      hash.each do |key, records|
        hash[key] = get_stats stats, records
      end
    end

    private

    def attribute name, target=name, through: nil
      @attrmap[name] = Attribute.new name, target, through: through
    end

    def stat name, &block
      @statmap[name] = Proc.new(&block)
    end

    def query
      links = @attrmap.values.map(&:link).compact
      @model.includes(links)
    end

    def wrap_proc &block
      RecordWrapper.new(self).wrap_proc(&block)
    end

    def get_stats stats, records
      stats.inject({}) do |hash, stat|
        hash.update stat => @statmap[stat].yield(records)
      end
    end

  end

  class Attribute
    attr_reader :name, :link

    def initialize name, target, through: nil
      @name = name
      @target = target
      @link = through
    end

    def get record
      record = record.send(@link) if @link
      record.send(@target)
    end
  end

  class RecordWrapper

    def initialize provider
      # delegate methods
      provider.model.attribute_names.each do |name|
        define_singleton_method name do
          @object.send(name)
        end
      end
      # define attrmap methods
      provider.attrmap.each do |name, attrib|
        define_singleton_method(name) do
          attrib.get @object
        end
      end
    end

    def wrap_proc &block
      Proc.new do |a|
        @object = a
        block.yield(self)
      end
    end
  end

  def self.builder &block
    StatsBuilder.new(&block)
  end

  def self.test
    Stats::builder do
      target 'coder'
      target 'repository'
      target 'month' do
        group_by { |a| a.date.try(&:month) }
      end

      provider Commit do
        stat 'commits'    do |cs| cs.count end
        stat 'additions'  do |cs| cs.map(&:additions).sum end
        stat 'deletions'  do |cs| cs.map(&:deletions).sum end
      end

      provider Bounty do
        attribute :date, :claimed_at
        attribute :coder_id, :claimant_id
        attribute :repository_id, through: :issue

        stat 'claimed' do |bs| bs.map(&:claimed_value).sum end
      end
    end
  end

end
