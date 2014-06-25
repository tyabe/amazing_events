AmazingEvents::App.controllers :events do
  before(except: :show) { authenticate }

  get :new do
    @event = current_user.created_events.build
    @event.start_time = DateTime.now
    @event.end_time = DateTime.now
    render :new
  end

  post :create, '/events' do
    @event = current_user.created_events.build(params[:event])
    if @event.save
      redirect url(:events, :show, @event.id), notice: '作成しました'
    else
      render :new
    end
  end

  get :show, '/events/:id' do
    @event = Event.find(params[:id])
    @tickets = @event.tickets.includes(:user).order(:created_at)
    render :show
  end

  get :edit, with: :id do
    @event = current_user.created_events.find(params[:id])
    render :edit
  end

  patch :update, '/events/:id' do
    @event = current_user.created_events.find(params[:id])
    if @event.update(params[:event])
      redirect url(:events, :show, @event.id), notice: '更新しました'
    else
      render :edit
    end
  end

  delete :destroy, '/events/:id' do
    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect url(:welcome, :index), notice: '削除しました'
  end

end
