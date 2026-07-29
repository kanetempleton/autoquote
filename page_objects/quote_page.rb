class QuotePage < BasePage
    def load
        visit_page('/')
    end

    def fill_age(age)
        fill_in 'age', with: age
    end

    def fill_vehicle_year(year)
        fill_in 'vehicle_year', with: year
    end

    def fill_zip(zip)
        fill_in 'zip', with: zip
    end

    def submit
        click_button 'Get Quote'
    end

    def fill_and_submit(age:, vehicle_year:, zip:)
        fill_age(age)
        fill_vehicle_year(vehicle_year)
        fill_zip(zip)
        submit
    end
end