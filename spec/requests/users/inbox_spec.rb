require 'rails_helper'

RSpec.describe "Users::Inboxes", type: :request do
  describe "POST /inbox" do
    let!(:remote_account) { FactoryBot.create(:remote_account) }
    let!(:group) { FactoryBot.create(:group) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:signed_request_actor).and_return(remote_account)
    end

    describe "Follow" do
      context 'when not followed yet' do
        it 'creates followership' do
          post "/users/#{group.name}/inbox", headers: { 'Content-Type': 'application/json' }, params: { "type": "Follow" }.to_json

          expect(response.status).to eq 204
          expect(group.following_accounts.first).to eq(remote_account)
        end
      end

      context 'when followed already' do
        before do
          group.followerships.create!(remote_account: remote_account)
        end

        it 'creates followership' do
          post "/users/#{group.name}/inbox", headers: { 'Content-Type': 'application/json' }, params: { "type": "Follow" }.to_json

          expect(response.status).to eq 204
          expect(group.following_accounts.first).to eq(remote_account)
        end
      end

      context 'when the group does not exist' do
        it 'returns 404' do
          post "/users/hoge/inbox", headers: { 'Content-Type': 'application/json' }, params: { "type": "Follow" }.to_json

          expect(response.status).to eq 404
        end
      end
    end

    describe "Unfollow" do
      context 'when not followed yet' do
        it 'creates followership' do
          post "/users/#{group.name}/inbox", headers: { 'Content-Type': 'application/json' }, params: { "type": "Undo", object: { type: "Follow" } }.to_json

          expect(response.status).to eq 204
          expect(group.following_accounts.first).to eq(nil)
        end
      end

      context 'when followed already' do
        before do
          group.followerships.create!(remote_account: remote_account)
        end

        it 'creates followership' do
          post "/users/#{group.name}/inbox", headers: { 'Content-Type': 'application/json' }, params: { "type": "Undo", object: { type: "Follow" } }.to_json

          expect(response.status).to eq 204
          expect(group.following_accounts.first).to eq(nil)
        end
      end

      context 'when the group does not exist' do
        it 'returns 404' do
          post "/users/hoge/inbox", headers: { 'Content-Type': 'application/json' }, params: { "type": "Undo", object: { type: "Follow" } }.to_json

          expect(response.status).to eq 404
        end
      end
    end
  end
end
