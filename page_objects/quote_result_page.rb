class QuoteResultPage < BasePage
    def result_section
        find('#result', visible: true)   # proper wait — no sleep
    end

    def has_quote?
        result_section.has_text?('Your Quote')
    end

    def has_error?
        result_section.has_css?('.error')
    end

    def quote_id
        result_section.text[/Quote ID:\s*(.+)/, 1]&.strip
    end

    def premium
        result_section.text[/Premium:\s*\$?([\d.]+)/, 1]
    end

    def error_message
        result_section.find('.error').text
    end
end