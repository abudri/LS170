# from LS170, Lesson 1, Assignment 6: https://launchschool.com/lessons/cac53b94/assignments/3e3dd1f9

require 'socket'

def parse_request(request_line)
  http_method, path_params, http = request_line.split(' ') # get the above by splitting request line, such as "GET /?dice=2&rolls=6 HTTP/1.1", splitting it at the spaces 
  path, params = path_params.split('?') # get the path and params separate, separate at beggining of query string, so /?dice=2&rolls=6 HTTP/1.1" splits to "/" and "dice=2&rolls=6 HTTP/1.1"
  params = (params || "").split('&').each_with_object({}) do |pair, hash| # gives an array of two elements 'rolls=2', and 'sides=6' then we do each with object
    key, value = pair.split('=') # like "sides=6".split('=')
    hash[key] = value # assign a key value pair to the hash {}
  end # returns the hash
  [http_method, path, params] # want to return this array
end

server = TCPServer.new('localhost', 3003)  # this is our TCP server which provides a connection with which we send HTTP requests over

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/ # recommended per lesson, see: https://launchschool.com/lessons/cac53b94/assignments/4d46009e, also appears to be handled in
  # this lesson https://launchschool.com/lessons/cac53b94/assignments/423845e1, where he does `next unless request_line`, so checking for presence of a request and goes to next one if not present
  puts request_line # puts this out to the terminal (not the browser)

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
  # new code for counter program, otherwise this is same as the server.rb file that has our dice_rolling_program with a server
  client.puts "<h1>Counter</h1>"
  number = params["number"].to_i # this is from the url, meaning http://localhost:3003/?number=29, "number" is from that
  client.puts "<p>The current number is #{number}.</p>"
  client.puts "<a href='?number=#{number + 1}'>Plus one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"
  client.puts "</body>"
  client.puts "</html>"
  client.close
end
