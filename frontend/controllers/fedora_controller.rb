require 'tempfile'

class FedoraController < ApplicationController
end

class JobsController < ApplicationController


  def create
    begin
     files = [] 
      if params[:doid] 
        dobj = JSONModel(:digital_object).find(params[:doid]) 
        temp = Tempfile.new('metadata.json') 
        temp.write(dobj.to_json)       
        temp.rewind
        file = ActionDispatch::Http::UploadedFile.new({
          :filename => File.basename(temp),
          :content_type => "application/json",
          :tempfile => temp
        })
        
       files << file 
      end
      files = files + params['files']  
      job = Job.new(params['job']['import_type'], Hash[Array(files).reject(&:blank?).map {|file|
        [file.original_filename, file.tempfile]
       }])
    rescue JSONModel::ValidationException => e
      @exceptions = e.invalid_object._exceptions
      @job = e.invalid_object

      if params[:iframePOST] # IE saviour. Render the form in a textarea for the AjaxPost plugin to pick out.
         return render_aspace_partial :partial => "jobs/form_for_iframepost", :status => 400
      else
         return render_aspace_partial :partial => "jobs/form", :status => 400
      end
    end

    if params[:iframePOST] # IE saviour. Render the form in a textarea for the AjaxPost plugin to pick out.
      render :text => "<textarea data-type='json'>#{job.upload.to_json}</textarea>"
    else
      render :json => job.upload
    end
  end

end
