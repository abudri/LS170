# hello_world.rb

require_relative 'advice' # advice.rb file in our same project directory, gives random strings for /advice path of app
require_relative 'monroe' # monroe.rb, our framework basically

class App < Monroe # our rack app App inherits from our makeshift framework, Monroe, found in monroe.rb
  def call(env)
    case env['REQUEST_PATH']
    when '/' # when visiting root path just tell them "Hello World"
      status = '200'
      headers = { "Content-Type" => 'text/html' }
      response(status, headers) do
        erb :index # calls private `erb(filename)` method, and note that by interpolating symbol :index, it is converted to a string to give "views/index.erb"
      end
    when '/advice' # when visitin /advice path, use advice.rb and create new instance of Advice class, and call #generate instance method to get random string of advice
      piece_of_advice = Advice.new.generate    # random piece of advice
      status = '200'
      headers = { "Content-Type" => 'text/html' }
      response(status, headers) do
        erb :advice, message: piece_of_advice # gives to erb() method the views/advice.erb file, as well as a new Advice object in piece_of_advice
      end
    else # if they visit a non-existent path for which we don't have a coded response, send back a 404 message, nice!
      status = '404'
      headers = { "Content-Type" => 'text/html', "Content-Length" => '61' }
      response(status, headers) do
        erb :not_found # takes us to 'views/not_found.erb' content when this path is visited
      end
    end
  end
end