require 'rails_helper'

RSpec.describe "WellKnown::Webfingers", type: :request do
  describe "GET /.well-known/webfinger" do
    context 'when a group exists' do
      before do
        FactoryBot.create(:group, name: 'group-1')
      end

      it 'returns successful response for correct query' do
        get '/.well-known/webfinger', params: { resource: "acct:group-1@test.com" }

        expect(response.status).to eq 200
        expect(JSON.parse(response.body, symbolize_names: true)).to(
          include(
            subject: "acct:group-1@test.com",
            links: [
              {
                rel: "self",
                type: "application/activity+json",
                href: "https://test.com/users/group-1"
              }
            ]
          )
        )
      end

      it 'returns 404 for incorrect query' do
        get '/.well-known/webfinger', params: { resource: "acct:group-2@test.com" }

        expect(response.status).to eq 404
      end
    end
  end
end
