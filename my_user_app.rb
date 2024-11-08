# FILE: my_user_app.rb
require 'json'

class User
  def initialize(file_path = 'users.json')
    @file_path = file_path
    @users = load_users
    @next_id = @users.empty? ? 1 : @users.map { |user| user[:id] }.max + 1
  end

  def all
    @users
  end

  def create(user_info)
    user_info[:id] = @next_id
    @next_id += 1
    @users << user_info
    save_users
    user_info[:id]
  end

  def find(user_id)
    @users.find { |user| user[:id] == user_id }
  end

  def update_password(user_id, new_password)
    user = find(user_id)
    if user
      user[:password] = new_password
      save_users
    else
      raise "User not found"
    end
  end

  def destroy(user_id)
    @users.reject! { |user| user[:id] == user_id }
    save_users
  end

  private

  def load_users
    if File.exist?(@file_path)
      JSON.parse(File.read(@file_path), symbolize_names: true)
    else
      []
    end
  end

  def save_users
    File.write(@file_path, JSON.pretty_generate(@users))
  end
end