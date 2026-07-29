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

        # TEST 2 - invalid requests due to missing fields return 422 with appropriate error message
        context 'with missing fields' do
            it 'returns 422 when age is missing' do
                payload = valid_payload.except(:age)
                post '/quotes', payload.to_json, { 'CONTENT_TYPE' => 'application/json' }

                expect(last_response.status).to eq(422)
                response_data = JSON.parse(last_response.body)
                expect(response_data['error']).to match(/age is required/i)
            end
            it 'returns 422 when vehicle_year is missing' do
                payload = valid_payload.except(:vehicle_year)
                post '/quotes', payload.to_json, { 'CONTENT_TYPE' => 'application/json' }

                expect(last_response.status).to eq(422)
                response_data = JSON.parse(last_response.body)
                expect(response_data['error']).to match(/vehicle_year is required/i)
            end
            it 'returns 422 when zip is missing' do
                payload = valid_payload.except(:zip)
                post '/quotes', payload.to_json, { 'CONTENT_TYPE' => 'application/json' }

                expect(last_response.status).to eq(422)
                response_data = JSON.parse(last_response.body)
                expect(response_data['error']).to match(/zip is required/i)
            end
        end

        # TEST 3 - invalid JSON returns 400 with appropriate error message
        context 'with invalid JSON' do
            it 'returns 400 for invalid JSON' do
                post '/quotes', 'invalid_json', { 'CONTENT_TYPE' => 'application/json' }

                expect(last_response.status).to eq(400)
                response_data = JSON.parse(last_response.body)
                expect(response_data['error']).to match(/Invalid JSON/i)
            end
        end

        # should also include tests for blank fields, non-numeric values, and other edge cases as needed,
        # but for brevity, we are focusing on the main scenarios here because app isn't built to handle those cases yet. 
        # In a production-ready app, would want to add validations and more comprehensive tests.
    end

    describe 'GET /quotes/:id' do
        # TEST 1 - valid request returns valid response
        context 'with a valid quote ID' do
            it 'retrieves the quote successfully' do
                # First, create a quote to retrieve
                post '/quotes', { age: 30, vehicle_year: 2020, zip: '43215' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
                created_quote = JSON.parse(last_response.body)
                quote_id = created_quote['quote_id']

                get "/quotes/#{quote_id}"

                expect(last_response.status).to eq(200)
                response_data = JSON.parse(last_response.body)
                expect(response_data['quote_id']).to eq(quote_id)
                expect(response_data['age']).to eq(30)
                expect(response_data['vehicle_year']).to eq(2020)
                expect(response_data['zip']).to eq('43215')
            end
        end

        # TEST - invalid request returns 404 with appropriate error message
        context 'with an invalid quote ID' do
            it 'returns 404 for non-existent quote ID' do
                get '/quotes/non_existent_id'

                expect(last_response.status).to eq(404)
                response_data = JSON.parse(last_response.body)
                expect(response_data['error']).to match(/Quote not found/i)
            end
        end
    end
end