module RepoFilters
  def self.track?(repo)
    filters.all? { |k, v| FILTER_LAMBDAS[k].call(v, repo) }
  end

  private

  def self.filters
    Rails.application.config.repository_filters
  end

  FILTER_LAMBDAS = {
    only:    ->(list, repo) { list.include? repo['name'] },
    except:  ->(list, repo) { !list.include? repo['name'] },
    private: ->(bool, repo) { bool == repo['private'] }
  }
end
