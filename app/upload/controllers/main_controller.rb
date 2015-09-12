module Upload
  class MainController < Volt::ModelController
    def index
      @id = ".upload_#{generate_id}"
      page._uploads << {id: id}
      page._updated
    end

    def id
      page._updated
      @id[1..-1]
    end

    private
    def generate_id
      alpha = ('a'..'z').to_a + ('A'..'Z').to_a
      64.times.map { alpha.sample }.join
    end

    def upload(args = {})
      @collection = args["collection"]
      @buffer = args["buffer"]
      @association = args["association"]

      if @collection
        @collection.then do |a|
          @model_class = a.class.to_s.to_sym
          @model_id = a.id
          initiate_file_reader
        end
      else
        initiate_file_reader
      end
    end

    def initiate_file_reader
      `
        var reader = new FileReader();

        reader.onload = function(e) {
          var dataURL = reader.result;
          $( #{@id} ).data('data-url', dataURL)
          #{ save_upload }
        }
        

        reader.readAsDataURL($( #{@id} )[0].files[0])
      `
    end

    def save_upload
      data = `$( #{@id} ).data('data-url')`
      if @collection
        UploadTasks.upload(@model_class, @model_id, @association, data)
      else
        @buffer.send("_#{@association}_buffer=", data)
      end
    end
    
  end
end
