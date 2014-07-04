require 'spec_helper'

RSpec.describe "App" do
  before do
    app.controllers :anonymous do
      before(:require_login) { authenticate }
      get :runtime_error do
        raise
      end

      get :not_found_error do
        raise ActiveRecord::RecordNotFound
      end

      get :routing_error do
        raise Sinatra::NotFound
      end

      get :require_login do
        'hello!'
      end
    end
  end

  context 'ActiveRecord::RecordNotFound を raise したとき' do
    it '404を返すこと' do
      get app.url(:anonymous, :not_found_error)
      expect(last_response.status).to eq(404)
    end
  end

  context 'Sinatra::NotFound を raise したとき' do
    it '404を返すこと' do
      get app.url(:anonymous, :routing_error)
      expect(last_response.status).to eq(404)
    end
  end

  context "RuntimeErrorをraiseしたとき" do
    it '500を返すこと' do
      get app.url(:anonymous, :runtime_error)
      expect(last_response.status).to eq(500)
    end
  end

  context '#authenticate が before_action として設定されているアクションを実行したとき' do
    context 'かつログイン中なとき' do
      it 'ステータスコードとして200が返ること' do
        get app.url(:anonymous, :require_login), {}, 'rack.session' => { user_id: 1 }
        expect(last_response.status).to eq(200)
      end
    end

    context 'かつ未ログイン中なとき' do
      it 'トップページにリダイレクトすること' do
        get app.url(:anonymous, :require_login)
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq app.url(:welcome, :index)
      end
    end
  end

end
