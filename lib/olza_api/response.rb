require 'json'
require 'base64'

module OlzaApi
  class Response

    attr_accessor :http_status, :errors, :processed_shipments , :body, :labels_pdf

    # response is not suitable for processing if http_status is not 200
    def initialize(http_status, body = nil, labels_pdf = nil)
      @errors = []
      @processed_shipments = []
      @http_status = http_status
      if @http_status == 200
        @body = parse_body(body)
        parse_errors
        @processed_shipments = parse_processed_shipments(@body)
        @labels_pdf = get_labels_pdf(@body)
      else
        @body = nil
      end
    end

    def response_code
      @body['status']['responseCode'].to_i if @body
    end

    def response_message
      @body['status']['responseDescription'] if @body
    end

    def valid?
      response_code == 0 && !errors.any?
    end

    def parse_errors
      @errors = ResponseValidator.new.validate_response(self)
    end

    #creates array hash of processed shipments in each request.
    def parse_processed_shipments(parsed_body)
      shipments = {}
      if parsed_body['response']['list_processed'].any?
        processed_requests = parsed_body['response']['list_processed']
        processed_requests.each do |key, value|
          shipments[key] = value
        end
      end

      shipments
    end

    #returns temp pdf file with labels
    def get_labels_pdf(parsed_body)
      if parsed_body['response']['data_stream']
        pdf = Tempfile.new('labels.pdf')
        File.open(pdf.path.to_s, 'wb') do |f|
          f.write(Base64.decode64(parsed_body['response']['data_stream']))
        end
        pdf
      end

    end

    private

    def parse_body(body)
      JSON.parse(body)
    rescue
      ""
    end

  end
end