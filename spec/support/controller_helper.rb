shared_examples '認証が必要なページ' do
  it 'トップページにリダイレクトすること' do
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.path).to eq app.url(:welcome, :index)
  end
end
