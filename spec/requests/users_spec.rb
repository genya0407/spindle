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
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:"@context"]).to eq [ "https://www.w3.org/ns/activitystreams", "https://w3id.org/security/v1" ]
        expect(json[:id]).to eq "https://www.example.com/users/group-1"
        expect(json[:type]).to eq "Group"
        expect(json[:inbox]).to eq "https://www.example.com/users/group-1/inbox"
      end

      it 'returns 404 for incorrect query' do
        get '/users/group-2'

        expect(response.status).to eq 404
      end
    end
  end
end
