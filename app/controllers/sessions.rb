AmazingEvents::App.controllers :sessions do

  get :create, '/auth/:provider/callback' do
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect url(:welcome, :index), notice: 'ログインしました'
  end

  get :destroy, '/logout' do
    session.clear
    redirect url(:welcome, :index), notice: 'ログアウトしました'
  end

end
