require "tilt/erubis" # lesson 3, Assignment: https://launchschool.com/lessons/c3578b91/assignments/d6969b5b
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt") # a before filter, good for setting up globally needed data for both "/" and "/chapters/:number" routes. # formerly @table_of_contents.  This is Table of Contents. Before Filter assignment: https://launchschool.com/lessons/c3578b91/assignments/801b30c3
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index| # split at empty lines - which indicate paragraph separation points - and place <p> html tags around said paragraphs. Note in this assignment they called it `line` instead of `paragraph` for block variables: https://launchschool.com/lessons/c3578b91/assignments/13a608d9
      "<p id=paragraph#{index}>#{line}</p>" # this method from assignment: https://launchschool.com/lessons/c3578b91/assignments/517ff8ae
    end.join
  end

  def highlight(text, term)
    text.gsub(term, %(<strong>#{term}</strong>))  # note that %(hello there) returns "hello there", so this appears to just return an entire string bolded
  end
end

# Calls the block for each chapter, passing that chapter's number, name, and  contents.
# for Search result purposes, searching each chapter.  So getting contents of each chapter. Assignment: https://launchschool.com/lessons/c3578b91/assignments/f2358cb8
def each_chapter  # called in chapters_matching(query) method
    @contents.each_with_index do |name, index| # going through each chapter in array of chapter names, @contents that is
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents # these 3 variables are yielded to a block as block arguments if a block is given (a block is given), one is given in def chapters_matching(query) body
  end
end

def chapters_matching(query)
  results = []
  return results unless query

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?  # this will be an array index with a hash containing number and name hashes, and a nested hash of `matches`
  end
  results # return results, the chapters that have that queried word/s in them
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

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect "/" # use Sinatra's not_found method to redirect to home page "/" if they visit a non-existent route
end

# practice from one of the lesson 3 assignments on routing parameters
# get "/show/:name" do
#   params[:name]
# end
