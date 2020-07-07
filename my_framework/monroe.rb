# monroe.rb
# Part 4 Article, makings of our own framework here and we are just calling the framework Monroe: https://launchschool.com/blog/growing-your-own-web-framework-with-rack-part-4

class Monroe
  def erb(filename, local = {})   # updated erb method, Part 4. assigns to variable `local` an empty hash if a `message: piece_of_advice` hash isn't passed in as an argument
    b = binding # this calls Kernel#binding (Kernel module is included in Object class), and this anything part of the binding is passed wherever binding is passed, such as in .result(b) further below
    message = local[:message]  # we only have a message if '/advice' is visited in the `call(env)`` method, '/' and non-existent (404) paths wont have/use this.
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result(b)
  end

  def response(status, headers, body = '')
    body = yield if block_given? #  if we do want to use a view template, then we pass it in as a block of code to our response method. Otherwise, we allow the user to specify the response value as a third method argument.
    [status, headers, [body]]
  end
end