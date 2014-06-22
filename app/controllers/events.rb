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
    render :show
  end

end
