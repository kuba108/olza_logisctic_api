require 'json'
require 'base64'

module OlzaApi
  class Response

    attr_reader :http_status, :body

    def initialize(http_status, body = nil)
      @http_status = http_status
      @body = parse_body(body)
    end

    def response_code
      @body['status']['responseCode'].to_i if @body
    end

    def response_description
      @body['status']['responseDescription'] if @body
    end

    def error_list
      @body['response']['list_error'] if @body
    end

    def processed_list
      @body['response']['list_processed'] if @body
    end

    def result
      if has_errors?
        "error"
      else
        "success"
      end
    end

    # Returns temp pdf file with labels
    def get_labels_pdf
      if @body['response']['data_stream']
        pdf = Tempfile.new('labels.pdf')
        File.open(pdf.path.to_s, 'wb') do |f|
          f.write(Base64.decode64(@body['response']['data_stream']))
        end
        pdf
      else
        raise PdfDataStreamError.new("No data stream included in response.")
      end
    end

    def valid?
      validator = ResponseValidator.new
      validator.validate_response(@body)
    end

    def has_errors?
      error_list.any?
    end

    private

    def parse_body(body)
      JSON.parse(body)
    rescue
      ""
    end

  end
end