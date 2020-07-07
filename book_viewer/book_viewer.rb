require "tilt/erubis" # lesson 3, Assignment: https://launchschool.com/lessons/c3578b91/assignments/d6969b5b
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Abdullah's Book Viewer App"
  @table_of_contents = File.readlines("data/toc.txt")
  erb :home  # gets views/home/erb.  recall this is like the erb() method you wrote in the 4 parts series on using Rack app and making a makeshift framwork in earlier assignment
end
