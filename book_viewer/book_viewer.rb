require "tilt/erubis" # lesson 3, Assignment: https://launchschool.com/lessons/c3578b91/assignments/d6969b5b
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt") # a before filter, good for setting up globally needed data for both "/" and "/chapters/:number" routes. # formerly @table_of_contents.  This is Table of Contents. Before Filter assignment: https://launchschool.com/lessons/c3578b91/assignments/801b30c3
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph| # split at empty lines - which indicate paragraph separation points - and place <p> html tags around said paragraphs
      "<p>#{paragraph}</p>" # this method from assignment: https://launchschool.com/lessons/c3578b91/assignments/517ff8ae
    end.join
  end
end

get "/" do
  @title = "Abdullah's Book Viewer App"
  erb :home  # gets views/home/erb.  recall this is like the erb() method you wrote in the 4 parts series on using Rack app and making a makeshift framwork in earlier assignment
end

# get "/chapters/:number" do
#   @chapter_contents = File.readlines("data/{:number}.text")
# end

get "/chapters/:number" do
  number = params[:number].to_i # was a string from URL params passed above in the :number url param, converting to Integer for array usage
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover? number # in case they pass into the URL param in a non-integer value for :number or non-existent :number for chapter. See: https://launchschool.com/lessons/c3578b91/assignments/a648853a
  
  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt") # formerly @chapter_contents.  This is a chapter's contents
  erb :chapter
end

not_found do
  redirect "/" # use Sinatra's not_found method to redirect to home page "/" if they visit a non-existent route
end

# practice from one of the lesson 3 assignments on routing parameters
# get "/show/:name" do
#   params[:name]
# end