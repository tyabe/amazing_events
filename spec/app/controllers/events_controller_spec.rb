require 'spec_helper'

RSpec.describe "EventsController" do

  let!(:csrf_token) { SecureRandom.hex(32) }

  describe 'GET show' do
    let!(:event) { create :event }
    let!(:bob) { create :user, nickname: 'bob' }
    let!(:alice) { create :user, nickname: 'alice' }
    let!(:ticket_bob) { create :ticket, event: event, user: bob }
    let!(:ticket_alice) { create :ticket, event: event, user: alice }

    context 'イベントに参加表明していないユーザがアクセスしたとき' do
      before { get app.url(:events, :show, id: event.id) }

      it '@event に、リクエストした Event オブジェクトが格納されていること' do
        expect(last_application.assigns(:event)).to eq(event)
      end

      it '@ticket に、nil が格納されていること' do
        expect(last_application.assigns(:ticket)).to be_nil
      end

      it '@tickets に、イベント参加表明者のTicketオブジェクトが格納されていること' do
        expect(last_application.assigns(:tickets)).to match_array([ticket_bob, ticket_alice])
      end
    end

    context 'イベントに参加表明しているログインユーザがアクセスしたとき' do
      before { get app.url(:events, :show, id: event.id), {}, 'rack.session' => { user_id: bob.id } }

      it '@event に、リクエストした Event オブジェクトが格納されていること' do
        expect(last_application.assigns(:event)).to eq(event)
      end

      it '@ticket に、アクセスしたユーザのTicketオブジェクトが格納されていること' do
        expect(last_application.assigns(:ticket)).to eq(ticket_bob)
      end

      it '@tickets に、イベント参加表明者のTicketオブジェクトが格納されていること' do
        expect(last_application.assigns(:tickets)).to match_array([ticket_bob, ticket_alice])
      end
    end
  end

  describe 'GET new' do
    context '未ログインユーザがアクセスしたとき' do
      before { get app.url(:events, :new) }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスしたとき' do
      before do
        user = create :user
        get app.url(:events, :new), {}, 'rack.session' => { user_id: user.id }
      end

      it 'ステータスコードとして200が返ること' do
        expect(last_response.status).to eq(200)
      end

      it '@eventに、新規Eventオブジェクトが格納されていること' do
        expect(last_application.assigns(:event)).to be_is_a(Event)
        expect(last_application.assigns(:event)).to be_new_record
      end
    end
  end

  describe 'POST create' do
    context '未ログインユーザがアクセスしたとき' do
      before { post app.url(:events, :create), { event: attributes_for(:event) } }

      it '403を返すこと' do
        expect(last_response.status).to eq(403)
      end
    end

    context 'ログインユーザがアクセスしたとき' do
      let!(:bob) { create :user, nickname: 'bob' }
      let!(:before_count) { Event.count }

      context 'パラメータが正しいとき' do
        it 'Eventレコードが1件増えること' do
          expect { post app.url(:events, :create),
            { event: attributes_for(:event), authenticity_token: csrf_token },
            'rack.session' => { user_id: bob.id, csrf: csrf_token }
          }.to change { Event.count }.by(1)
        end

        it '@eventのshowアクションにリダイレクトすること' do
          post app.url(:events, :create),
            { event: attributes_for(:event), authenticity_token: csrf_token },
            'rack.session' => { user_id: bob.id, csrf: csrf_token }

          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq app.url(:events, :show, last_application.assigns(:event).id)
        end
      end

      context 'パラメータが不正なとき' do
        it 'Eventレコードの件数に変化がないこと' do
          expect { post app.url(:events, :create),
            { event: attributes_for(:invalid_event), authenticity_token: csrf_token },
            'rack.session' => { user_id: bob.id, csrf: csrf_token }
          }.to_not change { Event.count }
        end
      end

    end
  end

  describe 'GET edit' do
    let!(:owner) { create :user }
    let!(:event) { create :event, owner: owner }

    context '未ログインユーザがアクセスしたとき' do
      before { get app.url(:events, :edit, id: event.id) }

      it_should_behave_like '認証が必要なページ'
    end


    context 'ログインユーザかつイベントを作成したユーザがアクセスしたとき' do
      before { get app.url(:events, :edit, id: event.id), {}, 'rack.session' => { user_id: owner.id } }

      it '@eventに、リクエストしたEventオブジェクトが格納されていること' do
        expect(last_application.assigns(:event)).to eq(event)
      end
    end

    context 'ログインユーザかつイベントを作成していないユーザがアクセスしたとき' do
      let!(:not_owner) { create :user }
      before { get app.url(:events, :edit, id: event.id), {}, 'rack.session' => { user_id: not_owner.id } }

      it '404を返すこと' do
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'PATCH update' do
    let!(:owner) { create :user }
    let!(:event) { create :event, owner: owner }

    context '未ログインユーザがアクセスしたとき' do
      before { patch app.url(:events, :update, id: event.id), { event: attributes_for(:event) }, 'rack.session' => { user_id: owner.id } }

      it '403を返すこと' do
        expect(last_response.status).to eq(403)
      end
    end

    context 'ログインユーザかつイベントを作成したユーザがアクセスしたとき' do
      context 'かつパラメータが正しいとき' do
        before do
          csrf_token = SecureRandom.hex(32)
          patch app.url(:events, :update, id: event.id), {
            event: attributes_for(:event, name: 'Padrino勉強会', place: '都内某所', content: 'Padrinoを勉強しよう', start_time: Time.zone.local(2014, 1, 1, 10, 0), end_time: Time.zone.local(2014, 1, 1, 19, 0)),
            authenticity_token: csrf_token
          }, 'rack.session' => { user_id: owner.id, csrf: csrf_token  }
        end

        it 'Eventレコードが正しく変更されていること' do
          event.reload
          expect(event.name).to eq('Padrino勉強会')
          expect(event.place).to eq('都内某所')
          expect(event.content).to eq('Padrinoを勉強しよう')
          expect(event.start_time).to eq(Time.zone.local(2014, 1, 1, 10, 0))
          expect(event.end_time).to eq(Time.zone.local(2014, 1, 1, 19, 0))
        end

        it '@eventのshowアクションにリダイレクトすること' do
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq app.url(:events, :show, last_application.assigns(:event).id)
        end
      end

      context 'かつパラメータが不正なとき' do
        it 'Eventレコードが変更されていないこと' do
          csrf_token = SecureRandom.hex(32)
          expect {
            patch app.url(:events, :update, id: event.id), {
            event: attributes_for(:event, name: '', place: '都内某所', content: 'Padrinoを勉強しよう', start_time: Time.zone.local(2014, 1, 1, 10, 0), end_time: Time.zone.local(2014, 1, 1, 19, 0)),
            authenticity_token: csrf_token
          }, 'rack.session' => { user_id: owner.id, csrf: csrf_token  }
          }.not_to change { event.reload }
        end
      end
    end

    context 'ログインユーザかつイベントを作成していないユーザがアクセスしたとき' do
      let!(:not_owner) { create :user }

      before do
        patch app.url(:events, :update, id: event.id),
          { event: attributes_for(:event), authenticity_token: csrf_token },
          'rack.session' => { user_id: not_owner.id, csrf: csrf_token  }
      end

      it '404を返すこと' do
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:owner) { create :user }
    let!(:event) { create :event, owner: owner }

    context '未ログインユーザがアクセスしたとき' do
      before { delete app.url(:events, :destroy, id: event.id) }

      it '403を返すこと' do
        expect(last_response.status).to eq(403)
      end
    end

    context 'ログインユーザかつイベントを作成したユーザがクセスしたとき' do
      it 'Eventレコードが1件減っていること' do
      expect { delete app.url(:events, :destroy, id: event.id),
            { authenticity_token: csrf_token },
            'rack.session' => { user_id: owner.id, csrf: csrf_token }
          }.to change { Event.count }.by(-1)
      end

      it 'トップページにリダイレクトすること' do
        delete app.url(:events, :destroy, id: event.id),
          { authenticity_token: csrf_token },
          'rack.session' => { user_id: owner.id, csrf: csrf_token }

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq app.url(:welcome, :index)
      end
    end

    context 'ログインユーザかつイベントを作成していないユーザがクセスしたとき' do
      let!(:not_owner) { create :user }

      it 'Eventレコードが減っていないこと' do
      expect { delete app.url(:events, :destroy, id: event.id),
            { authenticity_token: csrf_token },
            'rack.session' => { user_id: not_owner.id, csrf: csrf_token }
          }.to_not change { Event.count }
      end
    end
  end

end
