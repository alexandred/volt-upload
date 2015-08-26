module Volt
	module Associations
		module ClassMethods
			def saves(association, options={})
				collection ||= options.fetch(:for)
				container ||= options.fetch(:in, self.get_default_container)
				key = "#{collection.underscore.singularize}_id"
				field(key)
				field("association_name")

				if self.container_hash[collection]
					self.container_hash[collection].merge!({association => container})
				else
					self.container_hash[collection] = {association => container}
				end
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

				    array_model = root.get(collection).where(foreign_key => lookup_key, association_name: method_name.to_s).last
				    
				    array_model
				end

				define_method(:"#{method_name}=") do |obj|
					obj.then do |a|
					    a.set(foreign_key, get(local_key))
					    a.set("association_name", method_name.to_s)
					    a.set("container", obj.class.get_attachment_container(self, method_name).to_s)
					end
					store.get(collection) << obj

					return obj
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
				    array_model = root.get(collection).where(foreign_key => lookup_key, association_name: method_name.to_s.singularize)
				    
				    new_path = array_model.options[:path]
				    array_model.path = self.path + new_path
				    array_model.parent = self

				    array_model.options[:association_name] = method_name.to_s
				    array_model.options[:container] = collection.camelize.singularize.constantize.get_attachment_container(self, method_name.to_sym)

				    array_model
				end
			end
		end
	end
end