module ControllerSpecHelper
  def token_generator(user_id)
    puts "user id is #{user_id}"
   JsonWebToken.encode({user_id: user_id})
  end

  def expired_token_generator(user_id)
    JsonWebToken.encode({user_id: user_id},Time.now.to_i - 10)
  end

  def valid_header
    {
      "Authorization" => token_generator(user_id),
      "content-Type" => "application/json"
    }
  end


  def invalid_header
    {
      "Authorization" => nil,
      "content-Type" => "application/json"
    }
  end

end