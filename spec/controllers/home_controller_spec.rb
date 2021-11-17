require 'rails_helper'

describe HomeController do
  describe "GET 'index'" do
    it 'returns http success' do
      stub_request(:get, 'http://localhost:8080/api/recommended_tags').
        to_return(status: 200, body: '[]', headers: {})

      get 'index'
      expect(response).to be_success
    end
  end
end
