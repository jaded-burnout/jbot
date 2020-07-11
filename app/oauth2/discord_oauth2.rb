class DiscordOauth2
  SECONDS_BETWEEN_REQUESTS_LIMIT = 4
  INTEGRATION_NAME = "Discord".freeze

  def self.authorise_url(user_id:)
    new.authorise_url(user_id: user_id)
  end

  def self.get_token(code, hmac:, user_id:)
    new.get_token(code, hmac: hmac, user_id: user_id)
  end

  def authorise_url(user_id:)
    oauth2_client.auth_code.authorize_url(
      client_id: client_id,
      redirect_uri: redirect_uri,
      response_type: "code",

      state: generate_hmac(user_id),

      # https://discord.com/developers/docs/topics/oauth2#authorization-code-grant
      # The space here will be escaped properly by the library.
      scope: ["identify", "guilds"].join(" "),
    )
  end

  def get_token(code, hmac:, user_id:)
    raise "Incorrect HMAC" unless verify_hmac(hmac, user_id)

    oauth2_client.auth_code.get_token(code,
      client_id: client_id,
      client_secret: client_secret,
      grant_type: "authorization_code",
      redirect_uri: redirect_uri,
    )
  end

  def initialize(user = nil)
    @user = user
  end

  def get(path)
    raise ArgumentError.new("Invalid path") if path.blank?

    rate_limit

    refresh!

    Rails.logger.info("#{integration_name} GET request to #{path}")

    response = oauth2_access_token.get(path, headers: { "Accept" => "application/json" })
    parsed_response = response.parsed

    if parsed_response.is_a?(Array)
      parsed_response.map { |r| r.deep_symbolize_keys }
    else
      parsed_response.deep_symbolize_keys
    end
  rescue OAuth2::Error => e
    Rails.logger.warn(e.message)

    refreshed_on_error ||= false
    unless refreshed_on_error
      Rails.logger.warn("Refreshing due to error")
      refreshed_on_error = true
      refresh!(force: true)
      retry
    end
  end

  def expired?
    oauth2_access_token.expired?
  end

private

  def refresh!(force: false)
    if expired? || force
      Rails.logger.info("#{integration_name} token #{force ? 'forced' : 'expired'}, refreshing")

      rate_limit

      @oauth2_access_token = @oauth2_access_token.refresh!
      user.discord_update_token(oauth2_access_token)
    end
  end

  def oauth2_access_token
    @oauth2_access_token ||= OAuth2::AccessToken.from_hash(oauth2_client,
      access_token: user.discord_access_token,
      refresh_token: user.discord_refresh_token,
    )
  end

  def oauth2_client
    @oauth2_client ||= Rails.application.config.discord_oauth2_client
  end

  def rate_limit
    return if ENV["DISABLE_RATE_LIMITING"]

    if (seconds = seconds_since_last_request) < SECONDS_BETWEEN_REQUESTS_LIMIT
      delay = SECONDS_BETWEEN_REQUESTS_LIMIT - seconds
      Rails.logger.info("Rate limiting #{integration_name} requests, delaying for #{delay} seconds")
      sleep(delay)
    end

    @time_of_last_request = Time.now
  end

  def seconds_since_last_request
    return Float::INFINITY if @time_of_last_request.nil?
    Time.now - @time_of_last_request
  end

  def redirect_uri
    Rails.application.routes.url_helpers.authentication_discord_callback_url
  end

  def integration_name
    INTEGRATION_NAME
  end

  def client_id
    ENV["DISCORD_CLIENT_ID"]
  end

  def client_secret
    ENV["DISCORD_CLIENT_SECRET"]
  end

  def generate_hmac(user_id)
    TokenGenerator.generate_token(
      user_id: user_id,
      action: "discord:identify"
    )
  end

  def verify_hmac(hmac, user_id)
    hmac == generate_hmac(user_id)
  end

  attr_reader *%I[
    user
  ].freeze
end
