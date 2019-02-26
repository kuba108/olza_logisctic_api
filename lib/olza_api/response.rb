require 'json'
require 'base64'
require_relative 'Errors/http_status_error'

module OlzaApi
  class Response

    attr_accessor :http_status, :error_list, :processed_list, :body, :labels_pdf

    # response is not suitable for processing if http_status is not 200
    def initialize(http_status, body = nil)
      @http_status = http_status
      if @http_status == 200
        @body = parse_body(body)
      else
        raise HttpStatusError.new(body, "Http status is #{@http_status}")
      end
    end

    def response_code
      @body['status']['responseCode'].to_i if @body
    end

    def response_message
      @body['status']['responseDescription'] if @body
    end

    def error_list
      @body['response']['list_error'] if @body
    end

    def processed_list
      @body['response']['list_processed'] if @body
    end

    # Returns temp pdf file with labels
    def get_labels_pdf
      if @body['response']['data_stream']
        pdf = Tempfile.new('labels.pdf')
        File.open(pdf.path.to_s, 'wb') do |f|
          f.write(Base64.decode64(parsed_body['response']['data_stream']))
        end
        pdf
      end
    end

    def valid?
      validator = ResponseValidator.new()
      validator.validate_response(@body)
    end

    def errors?
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