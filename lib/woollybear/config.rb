module WoollyBear
  module Configuration

    class Settings
      attr_accessor :wait, :authenticate, :username, :password, :username_field,
                    :password_field, :login_action, :sensitive_data

      def initialize
        self.wait = 0
        self.authenticate = false
      end
    end

    attr_accessor :settings

    def self.configuration
      @settings ||= Settings.new
    end

    def self.set
      yield(configuration) if block_given?
    end

    def self.get(config)
      @settings.send(config)
    end

  end
end
