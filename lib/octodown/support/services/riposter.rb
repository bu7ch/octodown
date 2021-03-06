module Octodown
  module Support
    module Services
      class Riposter
        def self.call(file, &listener_callback)
          require 'listen'

          path = File.dirname(File.expand_path(file.path))
          regex = Regexp.new(file.path)
          Listen.to(path, only: regex, &listener_callback).start
        end
      end
    end
  end
end
