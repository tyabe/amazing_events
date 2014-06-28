module AmazingEvents
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Mailer
    register Padrino::Helpers
    register Kaminari::Helpers::SinatraHelpers

    enable :sessions

    use OmniAuth::Builder do
      provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      return unless session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end

    def authenticate
      return if logged_in?
      redirect url(:welcome, :index), alert: 'ログインしてください'
    end

    def error404
      status 404
      render :error404
    end

    error ActiveRecord::RecordNotFound, Sinatra::NotFound, 404 do
      error404
    end

    error 500 do
      status 500
      render :error500
    end

  end
end
