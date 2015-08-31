# Monkey patches of ActiveRecord::Base

module ActiveRecord
  class Base
    include Rails.application.routes.url_helpers

    def base_uri
      url_for(self)
    rescue NoMethodError
      url_for(self.class)
    end
  end
end
