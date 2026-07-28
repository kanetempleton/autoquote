require 'sinatra'
require 'json'
require 'securerandom'

set :bind, '0.0.0.0'
set :port, 43595

# In-memory store
QUOTES = {}

helpers do
  def calculate_premium(age, vehicle_year, zip)
    base = 500.0
    age_factor = age.to_i < 25 ? 1.5 : (age.to_i > 65 ? 1.3 : 1.0)
    year_factor = vehicle_year.to_i < 2015 ? 1.4 : 1.0
    zip_factor = zip.to_s.start_with?('9') ? 1.2 : 1.0  # simple mock
    (base * age_factor * year_factor * zip_factor).round(2)
  end
end

# ---------- API ----------

post '/quotes' do
  content_type :json

  begin
    data = JSON.parse(request.body.read)
  rescue JSON::ParserError
    status 400
    return { error: 'Invalid JSON' }.to_json
  end

  age          = data['age']
  vehicle_year = data['vehicle_year']
  zip          = data['zip']

  if age.nil? || vehicle_year.nil? || zip.nil?
    status 422
    return { error: 'Missing required fields: age, vehicle_year, zip' }.to_json
  end

  quote_id = SecureRandom.uuid
  premium  = calculate_premium(age, vehicle_year, zip)

  quote = {
    quote_id:     quote_id,
    age:          age,
    vehicle_year: vehicle_year,
    zip:          zip,
    premium:      premium
  }

  QUOTES[quote_id] = quote

  status 201
  quote.to_json
end

get '/quotes/:id' do
  content_type :json

  quote = QUOTES[params[:id]]
  if quote.nil?
    status 404
    return { error: 'Quote not found' }.to_json
  end

  quote.to_json
end

# ---------- Frontend ----------

get '/' do
  <<-HTML
  <!DOCTYPE html>
  <html>
  <head>
    <title>AutoQuote</title>
    <style>
      body { font-family: system-ui, sans-serif; max-width: 500px; margin: 40px auto; padding: 0 20px; }
      label { display: block; margin-top: 12px; font-weight: 600; }
      input { width: 100%; padding: 8px; margin-top: 4px; box-sizing: border-box; }
      button { margin-top: 20px; padding: 10px 20px; background: #0066cc; color: white; border: none; cursor: pointer; }
      #result { margin-top: 30px; padding: 15px; background: #f0f7ff; border-radius: 6px; display: none; }
      .error { color: #c00; }
    </style>
  </head>
  <body>
    <h1>Get an Auto Quote</h1>
    <form id="quoteForm">
      <label>Age</label>
      <input type="number" id="age" required min="16" max="100">

      <label>Vehicle Year</label>
      <input type="number" id="vehicle_year" required min="1990" max="2026">

      <label>ZIP Code</label>
      <input type="text" id="zip" required pattern="[0-9]{5}">

      <button type="submit">Get Quote</button>
    </form>

    <div id="result"></div>

    <script>
      document.getElementById('quoteForm').addEventListener('submit', async (e) => {
        e.preventDefault();
        const resultDiv = document.getElementById('result');
        resultDiv.style.display = 'block';
        resultDiv.innerHTML = 'Calculating...';

        const payload = {
          age: parseInt(document.getElementById('age').value),
          vehicle_year: parseInt(document.getElementById('vehicle_year').value),
          zip: document.getElementById('zip').value
        };

        try {
          const res = await fetch('/quotes', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
          });
          const data = await res.json();

          if (!res.ok) {
            resultDiv.innerHTML = `<p class="error">${data.error || 'Something went wrong'}</p>`;
            return;
          }

          resultDiv.innerHTML = `
            <h3>Your Quote</h3>
            <p><strong>Quote ID:</strong> ${data.quote_id}</p>
            <p><strong>Premium:</strong> $${data.premium.toFixed(2)}</p>
            <p>Age: ${data.age} | Vehicle: ${data.vehicle_year} | ZIP: ${data.zip}</p>
          `;
        } catch (err) {
          resultDiv.innerHTML = `<p class="error">Network error</p>`;
        }
      });
    </script>
  </body>
  </html>
  HTML
end