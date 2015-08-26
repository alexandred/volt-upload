module Volt
	class ArrayModel
		def create(model={})
			if self.options[:association_name] && self.options[:container]
				create_new_model(model.merge(association_name: self.options[:association_name].to_s.singularize, container: self.options[:container]), :create)
			else
				create_new_model(model, :create)
			end
		end
		
		methods = [:<<, :append]

		methods.each do |method_name|
			define_method(method_name) do |model|
				if self.options[:association_name]
					create_new_model(model.merge(association_name: self.options[:association_name].to_s.singularize), method_name)
				else
					create_new_model(model, method_name)
				end
			end
		end
	end
end