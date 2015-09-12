class Volt::Model
	def save_buffered_attachments(array=[])
		# TODO: automatically detect buffered attachments
		return if array == []

		array.each do |attachment|
			next if !(data = self.get("#{attachment}_buffer"))
			UploadTasks.upload(self.class.to_s, self.id, attachment, data)
			self.set("#{attachment}_buffer", "")
		end
	end
end