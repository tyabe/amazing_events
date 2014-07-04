require 'spec_helper'

RSpec.describe "SessionsController" do

  describe 'GET create' do
    context 'User.find_or_create_from_auth_hash が id: 1 のオブジェクトを返すとき' do

      before do
        get app.url(:sessions, :create, provider: 'twitter'), {}, "omniauth.auth" => OmniAuth.config.mock_auth[:twitter]
      end

      it 'session[:user_id] に 1 が格納されること' do
        expect(session[:user_id]).to eq 1
      end

      it 'トップページにリダイレクトすること' do
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq app.url(:welcome, :index)
      end
    end
  end

  describe 'GET destroy' do
    context 'session[:user_id] に 1 が格納されているとき' do
      before do
        get app.url(:sessions, :destroy), {}, 'rack.session' => { user_id: 1 }
      end

      it 'session[:user_id] が nil であること' do
        expect(session[:user_id]).to be_nil
      end

      it 'トップページにリダイレクトすること' do
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq app.url(:welcome, :index)
      end
    end
  end
end
