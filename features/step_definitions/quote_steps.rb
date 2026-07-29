Given('I am on the quote form page') do
    @quote_page = QuotePage.new
    @quote_page.load
end

When('I fill in the form with age {string}, vehicle year {string}, and zip {string}') do |age, year, zip|
    @quote_page.fill_and_submit(
        age: age,
        vehicle_year: year,
        zip: zip
    )
end

When('I submit the form') do
    # already submitted inside fill_and_submit — kept for readability
end

Then('I should see a quote result') do
    @result_page = QuoteResultPage.new
    expect(@result_page).to have_quote
end

Then('the quote should include a quote ID and premium') do
    expect(@result_page.quote_id).not_to be_nil
    expect(@result_page.premium).not_to be_nil
    expect(@result_page.premium.to_f).to be > 0
end

Then('I should see an error message') do
    @result_page = QuoteResultPage.new
    expect(@result_page).to have_error
end