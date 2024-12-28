require 'rails_helper'

RSpec.describe "SignatureVerifications", type: :request do
  describe "signed controller" do
    before do
      stub_tests_controller
    end

    after { Rails.application.reload_routes! }

    context 'without signature' do
      it "fail with 401" do
        get '/users/test-1/inbox'

        expect(response).to have_http_status(401)
      end
    end

    context 'with signature from a known actor' do
      let!(:public_key) { <<~PUBKEY }
        -----BEGIN PUBLIC KEY-----
        MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxFuoZpefMWHsMseZbxDH
        6rDMCC3sbUnl23/bFp9OuUZkz3dUAc/wMJPxymto5ygXZVpkyU784vGMEt3KtpKR
        NiM9CKlZ+5t4IL488NnL05bR4W/qSpqD+mMv9dr8cnB5dAlHv5KZA6ICRrJj4OKP
        Tu0MNKIWp7a7q+ZzS5lZ67nUPOfzH7ThG6udZ4iCy5ir2jLcIUPIpuIhNH5GoyC4
        5Jkh2/kvJAcAkk+kIb2W55lMaIlqXd3RVTc+psTSN/nznF2S70R8mlwG+DfgMR+n
        Im91z/N9HSXpY7kDI2j7Z32eoNxbpE1tzktOf+w9RLEDIjJ+joYIu3CaTzHEtFQy
        QQIDAQAB
        -----END PUBLIC KEY-----
      PUBKEY
      let!(:actor) { FactoryBot.create(:remote_account, name: 'genya0407', domain: 'social.genya0407.link', uri: 'https://social.genya0407.link/users/genya0407', public_key: public_key) }
      let!(:valid_headers) {
        {
          "HOST": "spindler.genya0407.link",
          "CONTENT_TYPE": "application/activity+json",
          "DATE": "Sat, 28 Dec 2024 03:46:42 GMT",
          "DIGEST": "SHA-256=N0eAbNJ7GnXbu/+8O93k1hT76JN1oTyGDf/HnTahxJE=",
          "SIGNATURE": "keyId=\"https://social.genya0407.link/users/genya0407#main-key\",algorithm=\"rsa-sha256\",headers=\"(request-target) host date digest content-type\",signature=\"YWOZvysGXnozmyHiyTRyKnNuYQSTlVTXJ1UFF++/f3LWp52gs9AYsNCSlM84krvbYnjeoHmaFLXp8t8WVRQh+AgujSG52b9bRC4otWeVDZHb4y0nT0JF9ZJ7khDCTZ8aG+UpDdPVEGbu8TqGWJuPqISagW7daZGugJa01kB7J2Uhiatw24bM5LqoPDrIJahJkvhPAaWbRS85g3473Qh5JaSLVqlfJnDlzq9FlfRGx1WV94Ba6WoMHL0Da/UAKyqdHVHbEutVqdGXwELt1/xxj6XCs8hOIheQAFiCnZVgdxek9nuxx0H0L9gO+oRA4CBqNJ6OTFSKIpPx5Vyu+ngZmQ==\""
        }
      }
      let!(:valid_body) {
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          "id": "https://social.genya0407.link/users/genya0407#follows/2445/undo",
          "type": "Undo",
          "actor": "https://social.genya0407.link/users/genya0407",
          "object": {
            "id": "https://social.genya0407.link/39f1b541-a0ba-435f-b86a-675e9b143895",
            "type": "Follow",
            "actor": "https://social.genya0407.link/users/genya0407",
            "object": "https://spindler.genya0407.link/users/test-1"
          }
        }
      }

      context 'with valid request' do
        before do
          # Signature checking is time-dependent, so travel to a fixed date
          travel_to '2024-12-28T03:47:00Z'
        end

        it "success" do
          post(
            '/users/test-1/inbox',
            headers: valid_headers,
            params: JSON.generate(valid_body)
          )

          expect(response).to have_http_status(200)
        end
      end

      context 'with wrong time' do
        before do
          # travel to wrong time
          travel_to '2024-12-29T03:47:00Z'
        end

        it "fail with 401" do
          post(
            '/users/test-1/inbox',
            headers: valid_headers,
            params: JSON.generate(valid_body)
          )

          expect(response).to have_http_status(401)
        end
      end

      context 'with wrong body' do
        before do
          # Signature checking is time-dependent, so travel to a fixed date
          travel_to '2024-12-28T03:47:00Z'
        end

        it "fail with 401" do
          post(
            '/users/test-1/inbox',
             headers: valid_headers,
             params: JSON.generate(valid_body.merge(extra_field: 'aaa'))
          )

          expect(response).to have_http_status(401)
        end
      end
    end
  end

  private

  def stub_tests_controller
    stub_const('TestsController', activitypub_tests_controller)

    Rails.application.routes.draw do
      match :via => [ :get, :post ], '/users/test-1/inbox' => 'tests#signature_required'
    end
  end

  def activitypub_tests_controller
    Class.new(ApplicationController) do
      before_action :require_actor_signature!

      def signature_required
        render json: {
          signed_request: signed_request?,
          signature_actor_id: signed_request_actor&.id&.to_s
        }.merge(signature_verification_failure_reason || {})
      end
    end
  end
end
