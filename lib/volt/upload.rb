require "yaml"
if File.file?("config/cloudinary.yml")
	require 'cloudinary'

	# Workaround for cloudinary gem incompatibility, TODO: why is this happening?
	ENV["CLOUDINARY_ENV"] = Volt.env.to_s
	struct = OpenStruct.new((YAML.load(ERB.new(IO.read(Cloudinary.config_dir.join("cloudinary.yml"))).result)[Cloudinary.config_env] rescue {}))
	Cloudinary.config
	Cloudinary.set_config(struct.to_h)

	cloudinary_config_yaml = struct.to_h
	Volt.configure do |config|
		config.public.cloudinary_config = { cloud_name: cloudinary_config_yaml[:cloud_name], api_key: cloudinary_config_yaml[:api_key]}
		config.public.cloudinary = true
	end
else
	Volt.configure do |config|
		config.public.cloudinary = false
	end
end


module Volt
  class Upload
  end
end
