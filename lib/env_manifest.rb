require "env_manifest/version"
require "env_manifest/settings"

module EnvManifest
  class Error < StandardError; end

  def self.load
    Settings.new
  end
end
