require "net/http"
require "uri"


def _get_metadata(endpoint)
	uri = URI.parse("http://169.254.169.254/latest/meta-data/#{endpoint}")
	response = Net::HTTP.get_response(uri)
end

def my_private_ip
	_get_metadata("local-ipv4").body
end

def my_instance_id
	_get_metadata("instance-id")
end

def is_reachable?(host)
	`ping -c 1 #{host}`
 	$?.success?
end

