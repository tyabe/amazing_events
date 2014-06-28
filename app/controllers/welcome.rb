AmazingEvents::App.controllers :welcome do
  get :index, '/' do
    @q = EventSearchForm.new(params[:q])
    @events = @q.search.page(params[:page]).per(per)
    render :index
  end

end
