# config.ru
# we want to run a very simple application, called HelloWorld which will return "Hello World!" to the client. 

require_relative 'app'

run App.new