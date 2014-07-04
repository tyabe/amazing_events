module LoginHelper
  module Feature
    def login
      visit root_path
      click_link 'Twitterでログイン'
    end
  end
end
