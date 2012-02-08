require 'hashr'

module Ifdoc
  class Config < ::Hashr
    def validate!
      unless copy?
        self.copy = { }
      end

      unless html?
        self.html = Ifdoc.root('data', 'templates', 'index.haml')
      end

      config_error "No CSS template to use." unless css?
      config_error "No output_path." unless output_path?
      config_error "No sources defined." unless sources?
      config_error "Sources should be an array." unless sources.is_a?(Array)
    end

  private
    def config_error(str)
      raise "Config error: #{str}"
    end
  end
end
