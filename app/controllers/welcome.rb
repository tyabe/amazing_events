AmazingEvents::App.controllers :welcome do
  get :index, '/' do
    @events = Event.page(params[:page]).per(per).
      where('start_time > ?', Time.zone.now).order(:start_time)
    render :index
  end

end
