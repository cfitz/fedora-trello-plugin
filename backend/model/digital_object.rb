module Trello

  def self.included(base)
      base.extend(ClassMethods)
  end

  module ClassMethods
        def trello_email
          'chrisfitzpatrick5+lkagzqgc8pvrb9x54rgx@boards.trello.com'
        end
        
        def create_from_json(json, opts = {})
            obj = super
            if obj.respond_to? :title
              subject = "Digitize #{obj.title} - #{obj.digital_object_id}"
            else 
              subject = "Please review #{obj.file_uri}" 
            end


            email_trello(obj,'chrisfitzpatrick5+othnehbmtbkftbtga2qv@boards.trello.com', subject)
            obj
        end


        def email_trello( obj, email, subject ) 
            if obj.uri 
              uri = obj.uri.split("/").pop(2).join("/")
              email = email
              Pony.mail({
                :to => email,  
                :subject => subject, 
                :body => "http://localhost:8080/#{uri}",
                :via => :smtp,
                :via_options => {
                    :address              => 'smtp.gmail.com',
                    :port                 => '587',
                    :enable_starttls_auto => true,
                    :user_name            => "ADD YOUR EMAIL HERE",
                    :password             => "ADD YOUR PASSWORD",
                    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
                  }
              })
            end
          end


    end
    
    def update_from_json(json, extra_values = {}, apply_nested_records = true)
        obj = super
        if obj.respond_to? :title
          subject = "Digitize #{obj.title} - #{obj.digital_object_id}"
        else 
          subject = "Please review #{obj.file_uri}" 
        end
        self.class.email_trello(obj,'chrisfitzpatrick5+lkagzqgc8pvrb9x54rgx@boards.trello.com', subject)
        obj
    end

  end

  class FileVersion < Sequel::Model(:file_version)
    include Trello
  end
 
  class DigitalObject < Sequel::Model(:digital_object)
    include Trello
  end
