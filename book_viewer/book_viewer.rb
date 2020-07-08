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

get "/chapters/1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt") # formerly @table_of_contents.  This is Table of Contents
  @chapter = File.read("data/chp1.txt") # formerly @chapter_contents.  This is a chapter's contents
  erb :chapter
end