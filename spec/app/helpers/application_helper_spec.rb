require 'spec_helper'

RSpec.describe "AmazingEvents::App::ApplicationHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend AmazingEvents::App::ApplicationHelper }
  subject { helpers }

  describe '#url_for_twitter' do
    it '引数とした渡したユーザの twitter URLを返すこと' do
      user = create :user, nickname: 'tyabe'

      expect(subject.url_for_twitter(user)).to eq 'https://twitter.com/tyabe'
    end
  end
end
