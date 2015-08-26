require "yaml"

cloudinary_config_yaml = YAML.load(IO.read("config/cloudinary.yml"))[Volt.env.to_s]
Volt.configure do |config|
	config.public.cloudinary_config = { cloud_name: cloudinary_config_yaml["cloud_name"], api_key: cloudinary_config_yaml["api_key"]}
end

module Volt
  class Upload
  end
end
