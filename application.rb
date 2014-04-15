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
    erb :log_in
  end

  post '/log_in' do
    email = params[:email]

    user = DB[:users].where(email: email).to_a.first

    session[:user_id] = user[:id]

    redirect '/'
  end

  get '/log_out' do
    session.clear
    redirect '/'
  end
end