require "tilt/erubis" # lesson 3, Assignment: https://launchschool.com/lessons/c3578b91/assignments/d6969b5b
require "sinatra"
require "sinatra/reloader"
require "yaml" # lets us use Ruby 2 and greater's implementation of YAML, part of Ruby standard library called Psych: https://ruby-doc.org/stdlib-2.3.0/libdoc/psych/rdoc/Psych.html, https://launchschool.com/lessons/c3578b91/assignments/36890ee9
# note that `YAML == Psych` when you require "yaml", so you can use YAML.load_file, which is more conventional


before do
  @users = YAML.load_file("users.yaml") # Returns the yaml contained in filename as a Ruby object, in this case a hash with nested hashes for the various sub-attributes of each user, https://ruby-doc.org/stdlib-1.8.6/libdoc/yaml/rdoc/YAML.html#method-c-load_file
end

helpers do
  def count_interests(users)
    users.reduce(0) do |sum, (name, user)|
      sum + user[:interests].size
    end
  end
end

get "/" do  # home page listing all the users 
  redirect "/users"
end

get "/users" do  # home page listing all the users 
  @title = "Users & Interests"
  erb :users
end

get "/:user_name" do # individual user pages
  @user_name = params[:user_name].to_sym # we convert it back to this for the `<% unless name == @user_name %>` check in views/user.erb
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]

  erb :user
end