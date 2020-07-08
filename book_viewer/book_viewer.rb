require "tilt/erubis" # lesson 3, Assignment: https://launchschool.com/lessons/c3578b91/assignments/d6969b5b
require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Abdullah's Book Viewer App"
  @contents = File.readlines("data/toc.txt") # formerly @table_of_contents.  This is Table of Contents
  erb :home  # gets views/home/erb.  recall this is like the erb() method you wrote in the 4 parts series on using Rack app and making a makeshift framwork in earlier assignment
end

# get "/chapters/:number" do
#   @chapter_contents = File.readlines("data/{:number}.text")
# end

get "/chapters/:number" do
  @contents = File.readlines("data/toc.txt") # formerly @table_of_contents.  This is Table of Contents
  number = params[:number].to_i # was a string from URL params passed above in the :number url param, converting to Integer for array usage
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt") # formerly @chapter_contents.  This is a chapter's contents
  erb :chapter
end

# practice
get "/show/:name" do
  params[:name]
end