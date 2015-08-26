module Volt
	module Associations
		module ClassMethods
			def stores(options={})
				collection ||= options.fetch(:for)
				key = "#{collection.underscore.singularize}_id"
				field(key)
				field("attachment_name")
			end

			def attachment(method_name, options = {})
				if method_name.plural?
					raise NameError, "attachment takes a singluar association name"
				end

				collection ||= options.fetch(:collection, "attachment").pluralize

				foreign_key ||= "#{to_s.underscore.singularize}_id"
				local_key   ||= :id

				define_method(method_name) do
				    lookup_key = get(local_key)

				    array_model = root.get(collection).where(foreign_key => lookup_key, attachment_name: method_name.to_s).first
				    
				    array_model
				end

				define_method(:"#{method_name}=") do |obj|
					obj.then do |a|
						#a.set("attachment_name", method_name.to_s)
					    a.set(foreign_key, get(local_key))
					end
				end

			end

			def attachments(method_name, options={})
				if method_name.singular?
					raise NameError, "attachments takes a plural association name"
				end

				collection ||= options.fetch(:collection, "attachment").pluralize

				foreign_key ||= "#{to_s.underscore.singularize}_id"
				local_key   ||= :id

				define_method(method_name) do
				    lookup_key = get(local_key)
				    array_model = root.get(collection).where(foreign_key => lookup_key, attachment_name: method_name.to_s.singularize)
				    
				    new_path = array_model.options[:path]
				    array_model.path = self.path + new_path
				    array_model.parent = self

				    array_model
				end
			end
		end
	end
end