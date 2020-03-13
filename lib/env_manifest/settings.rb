module EnvSettings
  class Settings
    def initialize
      load_defaults
      validate
    end

    def [](key)
      val = ENV[key]
      return val
    end

    private

    def load_defaults
      manifest.env.each do |key, value|
        ENV[key] = value.value if ENV[key].nil? || ENV[key] == ''
      end
    end

    def validate
      required_envs.each do |key, _value|
        raise MissingRequiredEnv, "Missing #{key}" unless ENV[key].present?
      end
    end

    def required_envs
      @required_envs ||= manifest.env.select { |_key, value| value.required }
    end

    def manifest
      AppManifest(app_json)
    end

    def app_json
      file = File.read(File.join(File.dirname(__FILE__), '../app.json'))
      JSON.parse(file)
    end

    class MissingRequiredEnv < StandardError; end
  end
end
