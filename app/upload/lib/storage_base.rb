class StorageBase < Volt::Model
	if RUBY_PLATFORM == "opal"
		require 'native'
	end

	field :data, String
	field :container, String
	field :format, String

	@@container_hash = {}
	@@default_container = :db

	def self.get_default_container
		@@default_container
	end
	
	def self.default_container(container)
		@@default_container = container
	end

	def self.container_hash
		@@container_hash
	end

	def self.save_data(model,association,data)
		container = self.get_attachment_container(model, association)

		if association.plural?
			collection = model.send(association)
			model = collection.create
		else
			model = model.send(:"#{association}=", self.new)
		end
		
		model.data = data

		case container
			when :db
				#
			when :local
				self.save_to_local(model)
			when :cloudinary
				self.save_to_cloudinary(model)
		end
		return model
	end

	def self.save_to_local(model)
		unless RUBY_PLATFORM == "opal"
			data = model.data.match(/data:(.*)\/(.*);base64,(.*)/)
			data_type = data[1]
			data_format = data[2]
			data_file = data[3]

			model.format = data_format

			Dir.mkdir("public") unless File.exists?("public")

			File.open("public/#{model.id}.#{data_format}", "wb") do |f|
				f.truncate(0)
				f.write Base64.decode64(data_file)
			end
		end
		model.data = ""
	end

	def self.save_to_cloudinary(model)
		Cloudinary::Uploader.upload(model.data, public_id: model.id)
		model.data = ""
	end

	def url
		case container
			when "db"
				return self.data
			when "local"
				return "#{self.id}.#{self.format}"
			when "cloudinary"
				cloudinary_id = self.id
				return `$.cloudinary.image(cloudinary_id).attr("src")`
		end
	end

	def cloudinary_url(options={})
		if container != "cloudinary"
			raise NameError, "not a cloudinary image"
		end
		cloudinary_id = self.id
		cloudinary_options = options.to_n
		return `$.cloudinary.image(cloudinary_id, cloudinary_options).attr("src")`
	end

	def self.get_attachment_container(model, association)
		self.container_hash.fetch(model.class.to_s.to_sym.underscore.singularize).fetch(association)
	end
end