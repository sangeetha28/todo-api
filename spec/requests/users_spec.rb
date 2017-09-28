require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  describe 'POST /signup' do
    let!(:user) { build(:user) }
    let(:headers) { valid_header.except('Authorization') }

    let(:valid_attributes) do
      attributes_for(:user, password_confirmation: user.password)
    end

  describe 'POST /signup' do

    context 'when request is valid' do
      p "#{valid_attributes.to_json}"
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json['message']).to match(/Account created Successfully/)
      end

      it 'returns a authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

  end

  context 'when request is Invalid' do
    before { post '/signup', params: {}, headers: headers }

    it 'does not create users' do
      expect(response).to have_http_status(422)
    end
    it 'returns failure message' do
      expect(json['message']).to match(/Validation failed: Password can't be blank, Name can't be blank, Email address can't be blank, Password digest can't be blank/)
    end

  end
end
end
