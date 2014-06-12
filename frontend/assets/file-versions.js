$(function() {
  
  var doid =$('form#new_digital_object').attr('data-update-monitor-record-uri');
  if (typeof doid !== 'undefined' ) {
    $(document).on("subrecordcreated.aspace", function(e, object_name, formel) {
      var btn  = $("<a href='javascript:void(0)' class='btn btn-mini pull-right file-instance-uploader'><span class='icon-upload'></span></a>"); 
      formel.prepend(btn);
      btn.on('click', function(e) {
        e.preventDefault();  
        window.open('/jobs/new?importType=fedora-import&doId=' + doid, '_blank');
      });
    });
  }; 
  
})
