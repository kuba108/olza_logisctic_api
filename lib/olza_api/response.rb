require 'json'

module OlzaApi
  class Response

    attr_accessor :http_status, :body, :errors

    # response is not suitable for processing if http_status is not 200
    def initialize(http_status, body = nil)
      @errors = []
      @http_status = http_status
      if @http_status == 200
        @body = parse_body(body)
        parse_errors
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

    private

    def parse_body(body)
      JSON.parse(body)
    rescue
      ""
    end
  end
end