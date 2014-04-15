require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)

    # initialize any other instance variables for you
    # application below this comment. One example would be repositories
    # to store things in a database.

  end

  get '/' do
    user_id = session[:user_id]
    user = DB[:users].where(id: user_id).first

    erb :index, locals: {user: user}
  end

  get '/register' do
    erb :register, locals: {error: nil}
  end

  post '/register' do
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    other_users_with_email = DB[:users].where(email: email).to_a

    if other_users_with_email.length > 0
      erb :register, locals: {error: 'Email is already taken'}
    elsif password.empty?
      erb :register, locals: {error: 'Password must not be blank'}
    elsif password.length < 3
      erb :register, locals: {error: 'Password must be at least three characters'}
    elsif password != password_confirmation
      erb :register, locals: {error: 'Password and confirmation do not match'}
    else
      password_hash = BCrypt::Password.create(password)

      user_id = DB[:users].insert(:email => email, :password => password_hash)

      session[:user_id] = user_id
      redirect '/'
    end

  end

  get '/log_in' do
    erb :log_in, locals: {error: nil}
  end

  post '/log_in' do
    email = params[:email]
    password = params[:password]

    user = DB[:users].where(email: email).to_a.first

    if user.nil?
      erb :log_in, locals: {error: 'Email / password is invalid'}
    elsif BCrypt::Password.new(user[:password]) == password
      session[:user_id] = user[:id]

      redirect '/'
    else
      erb :log_in, locals: {error: 'Email / password is invalid'}
    end
  end

  get '/log_out' do
    session.clear
    redirect '/'
  end

  get '/users' do
    user = DB[:users].where(id: session[:user_id]).to_a.first

    if user[:administrator]
      erb :users, locals: {users: DB[:users].to_a}
    else
      redirect '/not_authorized'
    end
  end

  get '/not_authorized' do
    erb :not_authorized
  end
end