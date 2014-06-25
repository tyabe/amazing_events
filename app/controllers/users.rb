AmazingEvents::App.controllers :users do
  before { authenticate }

  get :retire do
    render :retire
  end

  delete :destroy do
    if current_user.destroy
      session.clear
      redirect url(:welcome, :index), notice: '退会完了しました'
    else
      render :retire
    end
  end

end
