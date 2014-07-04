require 'spec_helper'

describe 'ユーザが、イベント情報一覧を閲覧する' do

  let!(:past_event) { create :event, name: 'ルビーでビール', start_time: 3.days.ago }
  let!(:event_1) { create :event, name: 'Padrino勉強会', start_time: 1.day.from_now }
  let!(:event_2) { create :event, name: 'ネコハッカソン', start_time: 3.days.from_now }
  let!(:event_3) { create :event, name: 'We love Padrino', start_time: 4.days.from_now }

  context 'トップページに遷移したとき' do
    before { visit root_path }

    it '"イベント一覧"と表示されていること' do
      expect(page).to have_content('イベント一覧')
    end

    it '開催日時が現在時間以降のイベント名のみ表示されていること' do
      expect(page).to have_content(event_1.name)
      expect(page).to have_content(event_2.name)
      expect(page).to have_content(event_3.name)
      expect(page).to have_no_content(past_event.name)
    end

    context 'かつ、イベント名を入力して"検索"ボタンを押したとき' do
      before do
        fill_in 'イベント名', with: 'Padrino'
        click_button '検索'
      end

      it '検索内容に合致するイベント名のみ表示されていること' do
        expect(page).to have_content(event_1.name)
        expect(page).to have_no_content(event_2.name)
        expect(page).to have_content(event_3.name)
        expect(page).to have_no_content(past_event.name)
      end
    end

    context 'かつ、開催日を入力して"検索"ボタンを押したとき' do
      before do
        search_time = 2.days.from_now
        select search_time.year,  from: 'q_date_1i'
        select search_time.month, from: 'q_date_2i'
        select search_time.day,   from: 'q_date_3i'
        click_button '検索'
      end

      it '検索内容に合致するイベント名のみ表示されていること' do
        expect(page).to have_no_content(event_1.name)
        expect(page).to have_content(event_2.name)
        expect(page).to have_content(event_3.name)
        expect(page).to have_no_content(past_event.name)
      end
    end

    context 'かつ、イベント名と開催日を入力して"検索"ボタンを押したとき' do
      before do
        fill_in 'イベント名', with: 'Padrino'
        search_time = 2.days.from_now
        select search_time.year,  from: 'q_date_1i'
        select search_time.month, from: 'q_date_2i'
        select search_time.day,   from: 'q_date_3i'
        click_button '検索'
      end

      it '検索内容に合致するイベント名のみ表示されていること' do
        expect(page).to have_no_content(event_1.name)
        expect(page).to have_no_content(event_2.name)
        expect(page).to have_content(event_3.name)
        expect(page).to have_no_content(past_event.name)
      end
    end
  end

  context '2件でページネーションする設定トップページに遷移したとき' do
    before do
      allow_any_instance_of(AmazingEvents::App).to receive(:per) { 2 }
      visit root_path
    end

    it '開催日時が現在時刻以降のイベント名が2件表示されていること' do
      expect(page).to have_content(event_1.name)
      expect(page).to have_content(event_2.name)
      expect(page).to have_no_content(event_3.name)
      expect(page).to have_no_content(past_event.name)
    end

    context 'かつ"次 ›"をクリックしたとき' do
      before do
        click_link '次 ›'
      end
      it '次に表示されるべきイベント名が表示されていること' do
        expect(page).to have_no_content(event_1.name)
        expect(page).to have_no_content(event_2.name)
        expect(page).to have_content(event_3.name)
        expect(page).to have_no_content(past_event.name)
      end
    end
  end
end
