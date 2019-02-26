require 'json'
require 'base64'

module OlzaApi
  class Response

    attr_accessor :message
    attr_reader :http_status

    # response is not suitable for processing if http_status is not 200
    def initialize(http_status, body = nil)
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

    def message
      if has_errors?
        @message = "Some errors in shipment processing occured"
      else
        @message = "All shipments were processed"
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
      validator = ResponseValidator.new()
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