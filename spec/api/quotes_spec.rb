require 'spec_helper'

RSpec.describe 'Quotes API', type: :request do
 # clear the in-memory store before each test to ensure isolation
  before do
    QUOTES.clear
  end

  # Test the POST /quotes endpoint
  describe 'POST /quotes' do
    # create test payload 
    let(:valid_payload) do {
        age: 30,
        vehicle_year: 2020,
        zip: '43215'
    } end

    # TEST 1 - valid request returns valid response
    # checks that all required fields are present and that the premium is calculated correctly
    context 'with a valid request' do
        it 'creates a valid quote and returns 201' do
            post '/quotes', valid_payload.to_json, { 'CONTENT_TYPE' => 'application/json' }

            expect(last_response.status).to eq(201)
            response_data = JSON.parse(last_response.body)
            expect(response_data['quote_id']).not_to be_nil
            expect(response_data['age']).to eq(valid_payload[:age])
            expect(response_data['vehicle_year']).to eq(valid_payload[:vehicle_year])
            expect(response_data['zip']).to eq(valid_payload[:zip])
            expect(response_data['premium']).to be_a(Float)
            expect(response_data['premium']).to be > 0
        end
    end



end
end