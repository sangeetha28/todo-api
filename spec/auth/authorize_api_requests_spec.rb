require 'rails_helper'

RSpec.describe AuthorizeAPIRequests do
  # Create test user
  let(:user) { create(:user) }
  # Mock `Authorization` header
  let(:header) { {'Authorization' => token_generator(user.id)} }
  # Invalid request subject
  subject(:invalid_request_obj) { described_class.new({}) }
  # Valid request subject
  subject(:request_obj) { described_class.new(header) }

  # Test Suite for AuthorizeApiRequest#call
  # This is our entry point into the service class
  describe '#call' do
    # returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        puts "request object is #{request_obj}"
        result = request_obj.call
        puts "result object is #{result[:user]}"
        puts "user object is #{user}"
        expect(result[:user]).to eq(user)
      end
    end

    # returns error message when invalid request
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) {  described_class.new('Authorization' => token_generator(5))}
          # custom helper method `token_generator`

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end

      context 'when token is expired' do
        let(:header) { {'Authorization' =>  expired_token_generator(user.id)} }
        subject(:request_obj) { described_class.new(header) }

        it 'raises an signature has expired error' do
          expect { request_obj.call }
            .to raise_error(
                  ExceptionHandler::ExpiredSignature,
                  /Signature has expired/
                )
        end
      end
    end
  end
end