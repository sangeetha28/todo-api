require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  let(:user) { create(:user) }
  # Mock `Authorization` header
  let(:headers) { {'Authorization' => token_generator(user.id)} }
  # Invalid request subject
  let(:invalid_headers) { {'Authorization' => nil} }

  describe 'authorize requests' do
    # returns user object when request is valid
    context 'when request is valid' do

      before { allow(request).to receive(:header).and_return(headers)}

      it 'returns a current user' do
        expect(subject.instance_eval {authorize_request}).to eq(user)
      end
    end

    context 'when token is missing' do

      before { allow(request).to receive(:invalid_header).and_return(invalid_headers)}

      it 'throws an exception' do
        expect{ subject.instance_eval {authorize_request}}.
          to raise_error(ExceptionHandler::MissingToken, /Missing token/)
      end
    end
end
end