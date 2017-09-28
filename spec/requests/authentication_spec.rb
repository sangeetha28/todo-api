# require 'rails_helper'
#
# RSpec.describe AuthenticationController, type: :request do
#
#   describe 'POST auth/login' do
#     let!(:user) {create(:user)}
#     let(:headers) {valid_headers.except('Authorization')}
#     let(:valid_credentials) do
#       {
#         email: user.email,
#         password: user.pssword
#
#       }.to_json
#     end
#
#     let(:invalid_credentials) do
#       {
#         email: Faker::Internet.email,
#         password: Faker::Internet.password
#       }.to_json
#     end
#   end
#
#
#   context 'when request is valid' do
#     before { post 'auth/login', params: valid_credentials, headers: headers}
#
#     it 'returns auth Token' do
#       expect(json['auth_token']).not_to_be_nil
#     end
#   end
#
#   context 'when request is valid' do
#     before { post 'auth/login', params: invalid_credentials, headers: headers}
#
#     it 'returns Invalid credentails message' do
#       expect(json['message']).to match(/Invalid Credentials/)
#     end
#   end
#
# end


# spec/requests/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  # Authentication test suite
  describe 'POST /auth/login' do
    # create test user
    let!(:user) { create(:user) }
    # set headers for authorization
    let(:headers) { valid_header.except('Authorization') }
    # set test valid and invalid credentials
    let(:valid_credentials) do
      {
        email: user.email_address,
        password: user.password_digest
      }.to_json
    end
    let(:invalid_credentials) do
      {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }.to_json
    end

    # set request.headers to our custon headers
    # before { allow(request).to receive(:headers).and_return(headers) }

    # returns auth token when request is valid
    context 'When request is valid' do
      before { post '/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      before { post '/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
