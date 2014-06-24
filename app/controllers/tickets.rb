AmazingEvents::App.controllers :tickets, parent: :events do
  before { authenticate }

  get :new do
    raise Sinatra::NotFound, 'ログイン状態で tickets_new にアクセス'
  end

  post :create, '/events/:event_id/tickets' do
    ticket = current_user.tickets.build do |t|
      t.event_id = params[:event_id]
      t.comment  = params[:ticket][:comment]
    end
    if ticket.save
      flash[:notice] = 'このイベントに参加表明しました'
      status 201
    else
      status 422
      content_type :json
      { messages: ticket.errors.full_messages }.to_json
    end
  end

end
