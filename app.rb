require 'sinatra'
require 'sinatra/json'
require './my_user_app'

# Enable sessions
set :port, 8080
set :bind, '0.0.0.0'
set :views, './views'

enable :sessions

# Initialize the User model
user_model = User.new

# Configure custom logger
configure do
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

# GET on /users (Returns all users without password)
get '/users' do
  users = user_model.all.map { |user| user.reject { |k| k == :password } }
  json users
end

# POST on /users (Creates a user and returns the user without password)
post '/users' do
  user_info = {
    firstname: params[:firstname],
    lastname: params[:lastname],
    age: params[:age],
    password: params[:password],
    email: params[:email]
  }
  user_id = user_model.create(user_info)
  user = user_model.find(user_id).reject { |k| k == :password }
  json user
end

# POST on /sign_in (Authenticates the user and creates a session)
post '/sign_in' do
  email = params[:email]
  password = params[:password]
  logger.info "Attempting to sign in with email: #{email}"
  
  user = user_model.all.find { |u| u[:email] == email && u[:password] == password }
  
  if user
    session[:user_id] = user[:id]
    logger.info "User logged in: #{session[:user_id]}"
    json user.reject { |k| k == :password }
  else
    logger.info "Invalid email or password"
    halt 401, json({ error: 'Invalid email or password' })
  end
end

# PUT on /users (Updates the current user's password, requires login)
put '/users' do
  if session[:user_id]
    new_password = params[:password]
    if new_password.nil? || new_password.strip.empty?
      halt 400, json({ error: 'Password cannot be empty' })
    else
      logger.info "Updating password for user: #{session[:user_id]}"
      user_model.update_password(session[:user_id], new_password)
      logger.info "Password updated for user: #{session[:user_id]}"
      status 204
    end
  else
    halt 401, json({ error: 'Not logged in' })
  end
end

# DELETE on /sign_out (Logs out the current user)
delete '/sign_out' do
  if session[:user_id]
    logger.info "Signing out user: #{session[:user_id]}"
    session.clear
    logger.info "Session after clear: #{session.inspect}"
    status 204
  else
    logger.info "No user logged in"
    halt 401, json({ error: 'Not logged in' })
  end
end

# DELETE on /users (Deletes the current user, requires login)
delete '/users' do
  if session[:user_id]
    user_model.destroy(session[:user_id])
    session.clear
    status 204
  else
    halt 401, json({ error: 'Not logged in' })
  end
end