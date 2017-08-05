require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  describe 'GET /TODO' do
    before { get '/todos' }

    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns response 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /TODO/:id' do
    before { get "/todos/#{todo_id}" }

    it 'returns todo' do
      expect(json).not_to be_empty
      puts "todo id is #{todos.first.id}"
      puts "json is #{json}"
      puts "JSON ID IS #{json[:id]}"
      expect(json["id"]).to eq(todo_id)
    end

    it 'returns response 200' do
      expect(response).to have_http_status(200)
    end
  end
  context 'when ID does not exist' do
    let(:todo_id) { 100 }

    describe 'GET /TODO' do
      before { get "/todos/#{todo_id}" }

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
    let(:valid_attributes) { {title: 'Lorem', created_by: '1'} }


    context 'when request is valid' do
      before { post '/todos/', params: valid_attributes }

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
      before { post '/todos/', params: {title: 'Foobar'} }

      it 'returns staus as 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns error' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end


    end


  end
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { {title: 'Shopping'} }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes }

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
    before { delete "/todos/#{todo_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
