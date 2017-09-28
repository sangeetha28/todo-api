require 'rails_helper'


RSpec.describe AuthenticateUser do

  let(:user) { create(:user)}
  let(:valid_request_obj) {described_class.new(user.email_address,user.password_digest)}
  let(:invalid_request_obj){ described_class.new('foo@bar','pass')}

  describe 'call' do
  context 'valid user credential request' do
    it 'returns token on successful credential validation' do
      token = valid_request_obj.call
      expect(token).not_to_be_nil
    end
  end

  context 'Invalid user credential request' do
    it 'raises exception on validation failure' do
      expect{invalid_request_obj.call}.to raise_error( ExceptionHandler::AuthenticationError, /Invalid Credentials/)
    end
  end
  end
  end