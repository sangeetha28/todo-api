class AuthorizeAPIRequests

  def initialize(header={})
    @header=header
  end

  #Service API entry point
  def call
    {
      user: user
    }
  end

  private

  attr_reader :header

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  rescue ActiveRecord::RecordNotFound => e
    # raise custom error
    raise(
      ExceptionHandler::InvalidToken,
      ("#{Message.invalid_token} #{e.message}")
    )
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(auth_header_token)
  end

  def auth_header_token
    puts "inside auth header token"
    if header['Authorization'].present?
      return header['Authorization'].split(' ').last
    end
    raise(ExceptionHandler::MissingToken, Message.missing_token)
  end
end