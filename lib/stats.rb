module Stats

  class StatsCollection
    def initialize &block
      @providers = []
      instance_eval(&block)
    end

    def fetch &group
      @providers.map { |p| p.fetch(&group) }.reduce(&:full_outer_join!)
    end

    private

    def provider model, &block
      @providers << StatsProvider.new(model, &block)
    end
  end

  class StatsProvider
    attr_reader :model, :attrmap

    def initialize model, &block
      @model = model
      @attrmap = {}
      @statmap = {}
      instance_eval(&block)
    end

    def fetch &group
      stats = @model.all.group_by(&wrap_proc(&group))
      stats.default = get_stats []
      # compute stats
      stats.each do |key, records|
        stats[key] = get_stats records
      end
    end

    private

    def attribute name, target
      @attrmap[name] = target
    end

    def stat name, &block
      @statmap[name] = Proc.new(&block)
    end

    def wrap_proc &block
      ObjectWrapper.new(self).wrap_proc(&block)
    end

    def get_stats records
      @statmap.inject({}) do |hash, (name, meth)|
        hash.update name => meth.yield(records)
      end
    end

  end

  class ObjectWrapper

    def initialize provider
      provider.model.instance_methods.each do |name|
        # define delegates
        if not respond_to? name
          define_singleton_method name do
            @object.send(name)
          end
        end
      end
      # define the attrmap methods
      provider.attrmap.each do |name, target|
        define_singleton_method(name) do
          @object.send(target)
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

  def self.collection &block
    StatsCollection.new(&block)
  end

  def self.test
    Stats::collection do
      provider Commit do
        attribute 'coder', 'coder_id'
        attribute 'repository', 'repository_id'

        stat 'commits'    do |cs| cs.count end
        stat 'additions'  do |cs| cs.map(&:additions).sum end
        stat :deletions   do |cs| cs.map(&:deletions).sum end
      end
    end
  end

end

class Hash
  def full_outer_join! other
    self.each do |key, value|
      self[key].merge! other[key]
    end

    other.each do |key, value|
      if not has_key? key
        self[key] = self[key].merge other[key]
      end
    end
    self
  end
end
