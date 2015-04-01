module RepoFilters
  def self.track? repo
    filters.all? { |k,v| FilterLambdas[k].call(v,repo) }
  end

  private
  def self.filters
    Rails.application.config.repository_filters
  end

  FilterLambdas = {
    only:    ->(list, repo){ list.include? repo['name'] },
    except:  ->(list, repo){ not list.include? repo['name'] },
    private: ->(bool, repo){ bool == repo['private'] }
  }
end
