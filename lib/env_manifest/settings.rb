require 'app_manifest'

module EnvManifest
  class Settings
    attr_reader :file_path

    def initialize(file_path)
      @file_path = file_path
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
        if ENV[key].nil? || ENV[key] == ''
          ENV[key] = value.value || manifest.environments&.dig(Rails.env)&.env[key].value
        end
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
      file = File.read(file_path)
      JSON.parse(file)
    end

    class MissingRequiredEnv < StandardError; end
  end
end
