# hello_world.rb

require_relative 'advice' # advice.rb file in our same project directory, gives random strings for /advice path of app

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/' # when visiting root path just tell them "Hello World"
      ['200', {"Content-Type" => 'text/html'}, ["<html><body><h2>Hello World!</h2></body></html>"]]
    when '/advice' # when visitin /advice path, use advice.rb and create new instance of Advice class, and call #generate instance method to get random string of advice
      piece_of_advice = Advice.new.generate    # random piece of advice
      ['200', {"Content-Type" => 'text/html'}, ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]]
    else # if they visit a non-existent path for which we don't have a coded response, send back a 404 message, nice!
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '48'},
        ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end
  end
end
