require 'net/https'
require 'yaml'

def post_chatwork_api
  url = "https://api.chatwork.com/v2/rooms/#{room_id}/messages"
  uri = URI.parse(url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true # HTTPSでよろしく
  request = Net::HTTP::Post.new(uri.request_uri)
  request.add_field "X-ChatWorkToken", api_key
  request.set_form_data :body => body_text
  response = https.request(request)
  puts response.body
end

def api_key
  yaml = YAML.load_file("./setting.yml")
  yaml["api_key"]
end

def body_text
  "ライブカメラのアドレスはこちらです。\n http://#{ip_address}:8080"
end

def ip_address
  Socket.getifaddrs.select{|x|
    x.name == "wlan0" and x.addr.ipv4?
  }.first.addr.ip_address
end

def room_id
  yaml = YAML.load_file("./setting.yml")
  yaml["myself"]
end

post_chatwork_api
