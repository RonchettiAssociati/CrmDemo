#!/usr/bin/ruby
# ./redirect_stderr.rb

$KCODE = "UTF-8"

require "rubygems"
require "cgi"
require "logger"
require "net/http"


file = File.open("RoACrm_log.log", File::WRONLY | File::APPEND | File::CREAT)
$stderr = file


#------------------------------------------------------------
def couch_read(uri)
	couch_result = Net::HTTP.start("127.0.0.1", "5984") {|http|
		http.get(uri)
    }
  	return couch_result.code, couch_result["content-type"],couch_result.body
end
#------------------------------------------------------------
def couch_read_attach(uri)
	couch_result = Net::HTTP.start("127.0.0.1", "5984") {|http|
		http.get(uri)
    }
  	return couch_result.code, couch_result["content-type"],couch_result.body
end
#------------------------------------------------------------
def couch_write(uri, json)
  req = Net::HTTP::Put.new(uri)
  req["content-type"] = "application/json"
  req.body = json
  
  @logger.info "RoAServer - req.body = json #{req.body}"
  
	couch_result = Net::HTTP.start("127.0.0.1", "5984") {|http|
		http.request(req)
    }
  	return couch_result.code, couch_result["content-type"],couch_result.body
 end
#------------------------------------------------------------
def couch_write_attach(key, request)
	
	file = request.params["file"][0]
	file.open
	data = file.read
	file.close

	mime_types = {
	  ".doc"  	=> 	"application/msword",
	  ".html" 	=> 	"text/html",
	  ".htm"  	=> 	"text/html",
	  ".odt" 	=> 	"application/vnd.oasis.opendocument.text",
	  ".pdf"  	=> 	"application/pdf",
	  ".txt"  	=> 	"text/plain; charset=utf-8",
	  ".jpg"  	=> 	"image/jpeg",
	  ".jpeg" 	=> 	"image/jpeg",
	  ".png"  	=> 	"image/png",
	  ".ppt" 	=> 	"application/vnd.ms-powerpoint",
	  ".xls"	=>	"application/vnd.ms-excel",
	  ".doc"	=>	"application/vnd.ms-word" }
	  
	put_uri = URI.encode(key)
	put_data = data
	put_fileextension = "." << key.split("?")[0].split(".")[1]
	put_headers = {	"Content-Type" => mime_types[put_fileextension]}
	
	http = Net::HTTP.new("127.0.0.1", "5984")
	response = http.send_request("PUT", put_uri, put_data, put_headers) 
	
	@logger.info "RoAServer - Couchwrite FINE #{response.inspect}"
	return response.code, response.message, response.body
 end
#------------------------------------------------------------
 def login_request(uri)
	couch_result = Net::HTTP.start("127.0.0.1", "5984") {|http|
		http.get(uri)
    }
  	return couch_result.code, couch_result["content-type"],couch_result.body
 end
#------------------------------------------------------------


@logger = Logger.new(file)
@logger.datetime_format = "%Y-%m-%d %H:%M:%S "
@logger.info "RoAServer - Started -"


client_request = CGI.new
params = client_request.params
# params = ::JSON.parse(params)
query_hash = CGI::parse(client_request.query_string)

@logger.info "RoAServer - prima del parse #{client_request.query_string} -"

action = query_hash["action"][0]
member = query_hash["member"][0]
key = query_hash["key"][0]	
doc = query_hash["doc"][0]

@logger.info "RoAServer - dopo il parse query_hash['doc'][0] #{query_hash["doc"][0]} -"
@logger.info "RoAServer - dopo il parse doc #{doc} -"

if    action == "readDoc" 
			then couch_code,couch_content_type,couch_body = couch_read(key)
		
elsif action == "writeDoc"
			then couch_code,couch_content_type,couch_body = couch_write(key, doc)

elsif action == "readAttach"
			then couch_code,couch_content_type,couch_body = couch_read_attach(key)
			
elsif action == "uploadAttachment"
			then
			couch_code,couch_content_type,couch_body = couch_write_attach(key, client_request)
			 			
elsif action == "loginRequest"
			then couch_code,couch_content_type,couch_body = login_request(key)
			
else  logger.error "RoAServer - Illegal request Received "

end


couch_content_type = "text/plain; charset=utf-8"
client_request.out( "status"  => couch_code,
					 "type"    => couch_content_type) {couch_body}
			  