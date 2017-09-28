class AuthenticateUser

  def initialize(email_address, password)
    @email=email_address
    @password=password
  end

  #Service API entry point
  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :email, :password


  def user
    user ||= User.find_by(email_address: email)
    return user if user && user.authenticate(password)
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end
  end
