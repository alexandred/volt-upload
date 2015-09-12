if Volt.config.public.cloudinary
	cloud_name = Volt.config.public.cloudinary_config.cloud_name
	api_key = Volt.config.public.cloudinary_config.api_key
	`$.cloudinary.config({ cloud_name: cloud_name, api_key: api_key})`
end