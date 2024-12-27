require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    context 'when a group exists' do
      before do
        FactoryBot.create(:group, name: 'group-1')
      end

      it 'returns successful response for correct query' do
        get '/users/group-1'

        expect(response.status).to eq 200
        expect(JSON.parse(response.body, symbolize_names: true)).to(
          include(
            "@context": ["https://www.w3.org/ns/activitystreams"],
            id: "https://test.com/users/group-1",
            type: "Group",
            inbox: "https://test.com/users/group-1/inbox",
            outbox: "https://test.com/users/group-1/outbox",
          )
        )
      end

      it 'returns 404 for incorrect query' do
        get '/users/group-2'

        expect(response.status).to eq 404
      end
    end
  end
end
