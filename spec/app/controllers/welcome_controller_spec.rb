require 'spec_helper'

RSpec.describe "WelcomeController" do
  before do
    owner = create :user
    20.times{ create :event, owner: owner }
    get app.url(:welcome, :index)
  end

  it 'ステータスコードとして200が返ること' do
    expect(last_response.status).to eq(200)
  end

  it '@events に、イベントオブジェクトが格納されていること' do
    expect(last_application.assigns(:events)).to be_present
    expect(last_application.assigns(:events).first).to be_is_a(Event)
  end
end
