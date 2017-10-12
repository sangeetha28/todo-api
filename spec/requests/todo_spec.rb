require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10,created_by: user.id) }
  let(:todo_id) { todos.first.id }
  let(:headers) {valid_header}


  describe 'GET /TODO' do
    before { get '/todos' ,params: {}, headers: headers }

    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns response 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /TODO/:id' do
    before { get "/todos/#{todo_id}" , params: {}, headers: headers}

    it 'returns todo' do
      expect(json).not_to be_empty
      expect(json["id"]).to eq(todo_id)
    end

    it 'returns response 200' do
      expect(response).to have_http_status(200)
    end
  end

  context 'when ID does not exist' do
    let(:todo_id) { 100 }

    describe 'GET /TODO' do
      before { get "/todos/#{todo_id}", params: {}, headers: headers }

      it 'returns status 404' do
        puts "response is #{response}"
        expect(response).to have_http_status(404)
      end

      it 'returns not found message ' do
        expect(response.body).to match(/Couldn't find Todo with 'id'=#{todo_id}/)
      end
    end
  end


  describe 'POST /TODOS' do
    let(:valid_attributes) { {title: 'Lorem', created_by: user.id.to_s} }


    context 'when request is valid' do
      before { post "/todos/", params: valid_attributes.to_json , headers: headers}

      it 'returns staus as 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns title' do
        expect(json["title"]).to eq('Lorem')
      end

      it 'returns created by' do
        expect(json["created_by"]).to eq('1')
      end

    end

    context 'when request is Invalid' do
      let(:valid_attributes) { {title: nil}.to_json }
      before { post '/todos/', params: valid_attributes, headers: headers }

      it 'returns staus as 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end


  describe 'PUT /todos/:id' do
    let(:valid_attributes) { {title: 'Shopping'} }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes.to_json, headers: headers}

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
