require 'json/ext'
require 'uri'
class SimpleTest
  def broadcast_message(channel, content)
    message = { channel: channel, data: content, ext: { auth_token: 'your_secret' }}
    uri = URI.parse('https://52.203.147.228:8080/faye')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(message: message.to_json)
    http.request(request)
  end

  def tester(thread_num = 1, num = 10)
    for i in 1..num
      i < num ? broadcast_message('/test', {thread: thread_num, count: i} ) : broadcast_message('/test', {thread: thread_num, count: i, success: true} )
    end
  end
end
