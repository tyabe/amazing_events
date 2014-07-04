require 'spec_helper'

RSpec.describe "TicketsController" do

  let!(:event) { create :event }

  describe 'GET new' do
    context '未ログインユーザがアクセスしたとき' do
      before { get app.url(:tickets, :new, event_id: event.id) }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスしたとき' do
      let!(:user) { create :user }
      before { get app.url(:tickets, :new, event_id: event.id), {}, 'rack.session' => { user_id: user.id } }

      it '404を返すこと' do
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'POST create' do
    context '未ログインユーザがアクセスしたとき' do
      before do
        csrf_token = SecureRandom.hex(32)
        post app.url(:tickets, :create, event_id: event.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { csrf: csrf_token }
      end

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスしたとき' do
      let!(:user) { create :user }

      context 'パラメータが正しいとき' do
        it 'ステータスコードとして201が返ること' do
          csrf_token = SecureRandom.hex(32)
          post app.url(:tickets, :create, event_id: event.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { user_id: user.id, csrf: csrf_token }
          expect(last_response.status).to eq(201)
        end

        it 'Ticketレコードが1件増えること' do
          csrf_token = SecureRandom.hex(32)
          expect { post app.url(:tickets, :create, event_id: event.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { user_id: user.id, csrf: csrf_token } }.
            to change { Ticket.count }.by(1)
        end
      end

      context 'パラメータが不正なとき' do
        it '422が返ること' do
          csrf_token = SecureRandom.hex(32)
          post app.url(:tickets, :create, event_id: event.id), { ticket: attributes_for(:invalid_ticket, user: user, event: event), authenticity_token: csrf_token }, 'rack.session' => { user_id: user.id, csrf: csrf_token }
          expect(last_response.status).to eq(422)
        end

        it 'Ticketレコードの件数に変化がないこと' do
          csrf_token = SecureRandom.hex(32)
          expect { post app.url(:tickets, :create, event_id: event.id), { ticket: attributes_for(:invalid_ticket, user: user, event: event), authenticity_token: csrf_token }, 'rack.session' => { user_id: user.id, csrf: csrf_token } }.
            not_to change { Ticket.count }
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:owner) { create :user }
    let!(:ticket) { create :ticket, user: owner, event: event }

    context '未ログインユーザがアクセスしたとき' do
      before do
        csrf_token = SecureRandom.hex(32)
        delete app.url(:tickets, :destroy, event_id: event.id, id: ticket.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { csrf: csrf_token }
      end

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザかつ参加表明に紐付いているユーザがアクセスしたとき' do
      it 'Ticketレコードの件数が1件減っていること' do
        csrf_token = SecureRandom.hex(32)
        expect { delete app.url(:tickets, :destroy, event_id: event.id, id: ticket.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { user_id: owner.id, csrf: csrf_token } }.
          to change { Ticket.count }.by(-1)
      end

      it 'リクエストしたeventのshowアクションにリダイレクトすること' do
        csrf_token = SecureRandom.hex(32)
        delete app.url(:tickets, :destroy, event_id: event.id, id: ticket.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { user_id: owner.id, csrf: csrf_token }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq app.url(:events, :show, id: event.id)
      end
    end

    context 'ログインユーザかつ参加表明に紐付いていないユーザがアクセスしたとき' do
      let!(:not_owner) { create :user }

      it 'Ticketレコードの件数が減っていないこと' do
        csrf_token = SecureRandom.hex(32)
        expect { delete app.url(:tickets, :destroy, event_id: event.id, id: ticket.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { user_id: not_owner.id, csrf: csrf_token } }.
          not_to change { Ticket.count }
      end

      it '404を返すこと' do
        csrf_token = SecureRandom.hex(32)
        delete app.url(:tickets, :destroy, event_id: event.id, id: ticket.id), { ticket: { comment: 'コメント' }, authenticity_token: csrf_token }, 'rack.session' => { user_id: not_owner.id, csrf: csrf_token }
        expect(last_response.status).to eq(404)
      end
    end
  end

end
