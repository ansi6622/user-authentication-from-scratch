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
    erb :register
  end

  post '/register' do
    email = params[:email]
    password_hash = BCrypt::Password.create(params[:password])

    user_id = DB[:users].insert(:email => email, :password => password_hash)

    session[:user_id] = user_id
    redirect '/'
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
end