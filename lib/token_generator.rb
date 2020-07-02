class TokenGenerator
  SECRET = ENV["TOKEN_SECRET"].freeze
  ENCRYPTION_ALGORITHM = "HS256".freeze

  def self.generate_token(payload)
    JWT.encode(payload, SECRET, ENCRYPTION_ALGORITHM)
  end

  # Truth/falsey response
  def self.verify_token(token, payload: nil)
    decoded_payload = JWT.decode(token, SECRET, true, { algorithm: ENCRYPTION_ALGORITHM })
      .first.deep_symbolize_keys

    return false if payload unless decoded_payload == payload

    decoded_payload
  rescue JWT::DecodeError
    false
  end
end
