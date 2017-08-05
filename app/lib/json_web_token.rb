class JsonWebToken

  HMAC_SECRET= Rails.application.secrets.secret_key_base

  def self.encode(payload, exp=24.hours.from_now)
    payload[:exp]=exp.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    #first index in decoded array
    body=JWT.decode(token, HMAC_SECRET)[0]
    puts "decode body is #{body}"
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError => e
    raise ExceptionHandler::ExpiredSignature, e.message
  end


end