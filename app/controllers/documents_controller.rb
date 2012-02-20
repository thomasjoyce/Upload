class DocumentsController < ApplicationController
  
    def new
      @document = Document.new
    end 

    # create the document in rails, then send json back to our javascript to populate the form that will be
    # going to amazon.
    def create
      @document = Document.new(params[:doc])
      render :json => {
        :policy => s3_upload_policy_document, 
        :signature => s3_upload_signature, 
        :key => @document.s3_key, 
        :success_action_redirect => s3_confirm_path(@document)
      }
    end

    # just in case you need to do anything after the document gets uploaded to amazon.
    # but since we are sending our docs via a hidden iframe, we don't need to show the user a 
    # thank-you page.
    def s3_confirm
      head :ok
    end

    private

    # generate the policy document that amazon is expecting.
    def s3_upload_policy_document
      return @policy if @policy
      ret = {"expiration" => 5.minutes.from_now.utc.xmlschema,
        "conditions" =>  [ 
          {"bucket" =>  "jesuspower"}, 
          ["starts-with", "$key", ''],
          {"acl" => "private"},
          {"success_action_status" => "200"},
          ["content-length-range", 0, 1048576]
        ]
      }
      @policy = Base64.encode64(ret.to_json).gsub(/\n/,'')
    end

    # sign our request by Base64 encoding the policy document.
    def s3_upload_signature
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), 
                                  "IYVQwvpTETfhyDAaUIm5YoQNlMRHHkpKAa6wUjwn", 
                                  s3_upload_policy_document)).gsub("\n","")
    end
    
end
