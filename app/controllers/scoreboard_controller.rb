class ScoreboardController < ApplicationController

  def table
  end

  def rows
    @coders = Coder.with_stats(:additions, :deletions, :commit_count, :score)
                   .order(score: :desc)

    # TODO: whitelist filters
    if params[:filters]
      filters = parse_params params[:filters].to_h
      @coders = @coders.where(filters)
    end

    @coders = @coders.to_a
    render partial: 'rows'
  end

  private
  def parse_params hash
    hash.each do |key, value|
      if value.is_a? Hash
        hash[key] = parse_param value
      end
    end
  end

  def parse_param hash
    ParamConverters.each do |keys, block|
      if hash.keys == keys
        return block.yield(*keys.map {|k| hash[k]})
      end
    end
    hash
  end

  ParamConverters = {
    ['timeframe_begin', 'timeframe_end'] => proc do |b, e|
      Range.new DateTime.parse(b), DateTime.parse(e)
    end
  }

end
