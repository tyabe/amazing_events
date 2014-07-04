require 'spec_helper'

RSpec.describe "UsersController" do

  let!(:user) { create :user }

  describe 'GET retire' do
    context '未ログインユーザがアクセスしたとき' do
      before { get app.url(:users, :retire) }

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスしたとき' do
      before { get app.url(:users, :retire), {}, 'rack.session' => { user_id: user.id } }

      it '200を返すこと' do
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'DELETE destroy' do
    context '未ログインユーザがアクセスしたとき' do
      before do
        csrf_token = SecureRandom.hex(32)
        delete app.url(:users, :destroy), { authenticity_token: csrf_token }, 'rack.session' => { csrf: csrf_token }
      end

      it_should_behave_like '認証が必要なページ'
    end

    context 'ログインユーザがアクセスしたとき' do
      context 'current_user.destroy が true を返すとき' do
        before do
          allow_any_instance_of(User).to receive(:destroy).and_return(true)
          csrf_token = SecureRandom.hex(32)
          delete app.url(:users, :destroy), { authenticity_token: csrf_token }, 'rack.session' => { user_id: user.id, csrf: csrf_token }
        end

        it 'session[:user_id] がnilであること' do
          expect(session[:user_id]).to be_nil
        end

        it 'トップページにリダイレクトされること' do
          expect(last_response).to be_redirect
          follow_redirect!
          expect(last_request.path).to eq app.url(:welcome, :index)
        end
      end

      context 'current_user.destroy が false を返すとき' do
        before do
          allow_any_instance_of(User).to receive(:destroy).and_return(false)
          csrf_token = SecureRandom.hex(32)
          delete app.url(:users, :destroy), { authenticity_token: csrf_token }, 'rack.session' => { user_id: user.id, csrf: csrf_token }
        end

        it 'retire を render していること' do
          expect(last_response).to_not be_redirect
        end
      end
    end
  end
end
