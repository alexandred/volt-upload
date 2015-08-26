class UploadTasks < Volt::Task
  def upload(parent, id, association, data)
  	model = store.get(parent.to_sym.underscore.pluralize).where(id: id).first.sync
  	Attachment.save_data(model, association.to_sym, data).id
  end
end