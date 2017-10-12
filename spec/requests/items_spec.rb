require 'rails_helper'

RSpec.describe 'Todos Items API', type: :request do
  let(:user) { create(:user)}
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  let(:headers) {valid_header}

  # Test suite for GET /todos/:todo_id/items

  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items", headers: headers }

    context 'when todo exists' do
      it 'returns status code 200' do
        puts "todo id is #{todo_id}"
        puts "item is #{id}"
        expect(response).to have_http_status(200)
      end

      it 'returns all todo items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo with 'id'=0/)
      end
    end
  end

  # Test suite for GET /todos/:todo_id/items/:id
  describe 'GET /todos/:todo_id/items/:id' do
    before { get "/todos/#{todo_id}/items/#{id}" , headers: headers }


    context 'when todo item exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns a todo item' do
        expect(json['id']).to eq(id)
      end
    end


    context 'when todo item exists does not exist' do
      let(:id) { 100 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a couldnot find message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end

    describe 'POST /todos/:todo_id/items' do
      let!(:valid_attributes) { {name:'lorem', done: true} }

      context 'when item is poseted successfully' do
        before { post "/todos/#{todo_id}/items", params: valid_attributes.to_json , headers: headers }
        it 'returns status code ' do
          expect(response).to have_http_status(201)
        end

        it 'returns status code ' do
          expect(response).to have_http_status(201)
        end
      end

      context 'Invalid paramaters' do
        before { post "/todos/#{todo_id}/items", params: {},headers: headers }
        it 'returns status code ' do
          expect(response).to have_http_status(422)
        end

        it 'returns status code' do
          expect(response.body).to match(/Validation failed: Name can't be blank/)
        end
      end

    end

    describe 'PUT /todos/:todo_id/items/:id' do
      let!(:valid_attributes) { {name: 'Mozart'} }

      context 'when item is updated successfully' do
        before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes.to_json , headers: headers}

        it 'returns 200 when item exists ' do
          expect(response).to have_http_status(204)
        end

        it 'returns updated name ' do
          updated_item = Item.find(id)
          expect(updated_item.id).to eq(id)
        end
      end

      context 'Invalid id' do
        let(:id) { 0 }
        before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes.to_json, headers: headers }
        it 'returns status code when item doesnt exist ' do
          expect(response).to have_http_status(404)
        end

        it 'returns error message' do
          expect(response.body).to match(/Couldn't find Item/)
        end
      end
    end

    describe 'DELETE /todos/:id' do
      before { delete "/todos/#{todo_id}/items/#{id}" ,headers: headers}

      it 'returns status code 201' do
        expect(response).to have_http_status(204)
    end
  end
end
end