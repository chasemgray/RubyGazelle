require 'httparty'
require 'json'
require 'recursive-open-struct'
require 'net/http'

module RubyGazelle
  class Gazelle
    include HTTParty

    REQUESTS = {index: '/ajax.php?action=index', user_profile: '/ajax.php?action=user', inbox: '/ajax.php?action=inbox',
      conversation: '/ajax.php?action=inbox&type=viewconv', top10: '/ajax.php?action=top10',
      user_search: '/ajax.php?action=usersearch', request_search: '/ajax.php?action=requests',
      torrent_search: '/ajax.php?action=browse', bookmarks: '/ajax.php?action=bookmarks',
      subscriptions: '/ajax.php?action=subscriptions', forum_categories: '/ajax.php?action=forum&type=main',
      forum: '/ajax.php?action=forum&type=viewforum', forum_thread: '/ajax.php?action=forum&type=viewthread',
      artist: '/ajax.php?action=artist', torrent_group: '/ajax.php?action=torrentgroup',
      request: '/ajax.php?action=request', notifications: '/ajax.php?action=notifications',
      rippy: '/ajax.php?action=rippy&format=json', announcement: '/ajax.php?action=announcements'}

    def initialize(login_page, username, password)
      @username = username
      response = Net::HTTP.post_form(URI(login_page), {username: username, password: password})
      set_cookie = response['Set-Cookie']
      cfduid = /__cfduid=[^;]*/.match(set_cookie)[0]
      session = /session=[^;]*/.match(set_cookie)[0]
      @cookie = "#{cfduid}; #{session}"
    end

    def self.connect(options, &block)
      options[:site] ||= 'https://ssl.what.cd'

      options[:login] ||= '/login.php'

      #throw exception for not providing username if !options[:username] || !options[:password]

      base_uri options[:site]

      gazelle_connection = new("#{options[:site]}#{options[:login]}", options[:username], options[:password])

      if block_given?
        gazelle_connection.instance_eval(&block)
      end

      gazelle_connection
    end

    def user(id)
      make_request(REQUESTS[:user_profile], :id => id)
    end

    def index
      make_request(REQUESTS[:index])
    end

    def inbox(options = {})
      make_request(REQUESTS[:inbox], options)
    end

    def conversation(id)
      make_request(REQUESTS[:conversation], :id => id)
    end

    def top(limit = 10, type)
      #Users returns empty results.
      make_request(REQUESTS[:top10], :type => type, :limit => limit)
    end

    def search(type, options)
      type = type.to_sym
      if type == :users
        make_request(REQUESTS[:user_search], options)
      elsif type == :requests
        make_request(REQUESTS[:request_search], options)
      elsif type == :torrents
        make_request(REQUESTS[:torrent_search], options)
      else
        throw Exception
      end
    end

    def bookmarks(options = {})
      make_request(REQUESTS[:bookmarks], options)
    end

    def subscriptions(options = {})
      make_request(REQUESTS[:subscriptions], options)
    end

    def forum_categories
      make_request(REQUESTS[:forum_categories])
    end

    def forum(id, options = {})
      make_request(REQUESTS[:forum], {:forumid => id}.merge(options))
    end

    def forum_thread(options = {})
      make_request(REQUESTS[:forum_thread], options)
    end

    def artist(id)
      make_request(REQUESTS[:artist], :id => id)
    end

    def torrent_group(id)
      make_request(REQUESTS[:torrent_group], :id => id)
    end

    def request(id, options = {})
      make_request(REQUESTS[:request], {:id => id}.merge(options))
    end

    def notifications(options = {})
      make_request(REQUESTS[:notifications], options)
    end

    def rippy
      self.class.get(REQUESTS[:rippy], :headers => {'Cookie' => @cookie})['rippy']
    end

    def announcements
      make_request("#{REQUESTS[:announcement]}")
    end

    private

    def make_request(page, options = {})
      response = self.class.get(page, :query => options, :headers => {'Cookie' => @cookie})


      #response isn't consistently formatted
      response = response.parsed_response || response
      #not sure why sometimes the response doesn't get parsed correctly
      response = JSON.parse(response) if response.is_a?(String)

      status = response['status']
      response = response['response']

      throw Exception unless status.eql? 'success'


      if response.is_a?(Array)
        response.collect{|el| RecursiveOpenStruct.new(el)}
      else
        RecursiveOpenStruct.new(response)
      end
    end
  end
end
