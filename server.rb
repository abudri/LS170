# from LS170, Lesson 1: https://launchschool.com/lessons/cac53b94/assignments/a32ebc5e

require 'socket'

def parse_request(request_line)
  http_method, path_params, http = request_line.split(' ') # get the above by splitting request line
  path, params = path_params.split('?') # get the path and params separate, separate at beggining of query string
  params = params.split('&').each_with_object({}) do |pair, hash| # gives an array of two elements 'rolls=2', and 'sides=6' then we do each with object
    key, value = pair.split('=') # like "sides=6".split('=')
    hash[key] = value # assign a key value pair to the hash {}
  end # returns the hash
  [http_method, path, params] # want to return this array
end

server = TCPServer.new('localhost', 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/ # recommended per lesson, see: https://launchschool.com/lessons/cac53b94/assignments/4d46009e
  puts request_line

  http_method, path, params = parse_request(request_line)  # calls function at top of line, assigns each individual index item of array to each variable
  client.puts "HTTP/1.1 200 OK" # required to get a well-formed response required by Chrome in order to render text in browser
  client.puts "Content-Type: text/html" # header
  client.puts # empty line before body
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  # client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls!</h1>"
  rolls = params['rolls'].to_i # gives rolls as int, number of dice
  sides = params['sides'].to_i # gives sides as int

  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>" # puts out the number for this particular die roll, in paragraph tags
  end
  client.puts "</html>"
  client.puts "</body>"
  client.close
end
