module AmazingEvents
  class App
    module ApplicationHelper
      def url_for_twitter(user)
        "https://twitter.com/#{user.nickname}"
      end
    end

    helpers ApplicationHelper
  end
end
