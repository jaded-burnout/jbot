# frozen_string_literal: true

class WebFetcher
  LOGGED_OUT_TRIGGER_TEXT = "CLICK HERE TO REGISTER YOUR ACCOUNT"
  BASE_URL = "https://forums.somethingawful.com"

  def initialize(path: nil, thread_id: nil)
    if path
      @path = path
    elsif thread_id
      @path = "/showthread.php?threadid=#{thread_id}"
    else
      raise ArgumentError.new("A path or thread ID must be provided")
    end

    if File.exist?(cookies_file)
      @cookies = HTTP::CookieJar.new
      @cookies.load(cookies_file.to_s)
    end
  end

  def fetch_page(page_number: 1)
    get_authenticated(url_for(page_number: page_number))
  end

private

  attr_reader :path, :cookies

  def get_authenticated(url)
    log_in unless logged_in?

    puts "Fetching #{url}"

    body = HTTP.cookies(cookies).get(url).to_s

    if body.include?(LOGGED_OUT_TRIGGER_TEXT)
      expire_cookies
      log_in
    end

    return body
  end

  def log_in
    raise "Cannot log in without a username and password set" if username_or_password_missing?

    puts "Logging in as #{username}"

    response = HTTP
      .post(BASE_URL + "/account.php", form: {
        action: "login",
        username: username,
        password: password,
      })
      .flush

    case response.code
    when 302
      if (location = response["location"]).include?("loginerror")
        raise "Error authenticating, redirected to #{location}"
      else
        @cookies = response.cookies
        @cookies.save(cookies_file)
      end
    else
      raise "Unhandled response code: #{response.code}"
    end
  end

  def url_for(page_number:)
    url = BASE_URL + path

    if page_number > 1
      url + "&perpage=40&pagenumber=#{page_number}"
    else
      url
    end
  end

  def username
    ENV["USERNAME"]
  end

  def password
    ENV["PASSWORD"]
  end

  def logged_in?
    !@cookies.nil?
  end

  def username_or_password_missing?
    username.nil? || username.empty? || password.nil? || password.empty?
  end

  def cookies_file
    $application.root + ".cookies"
  end

  def expire_cookies
    @cookies = nil
    cookies_file.truncate(0)
  end
end
