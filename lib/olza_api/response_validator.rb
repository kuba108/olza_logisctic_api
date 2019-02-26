require_relative 'Errors/api_error'
require_relative 'Errors/processing_error'
require_relative 'Errors/response_error'
require_relative 'Errors/spedition_error'
require_relative 'Errors/validation_error'

module OlzaApi
  class ResponseValidator

    def validate_response(response_body)

      if !response_body['status'].is_a?(Hash)
        raise ResponseError.new('Malformed status')
      end

      if !response_body['status']['responseCode']
        raise ResponseError.new('Malformed response code')
      end

      if !response_body['status']['responseDescription']
        raise ResponseError.new('Malformed response description')
      end

      if !response_body['response'].any?
        raise ResponseError.new('Malformed response payload')
      end

      if response_body['status']['responseCode'] == 900
        raise ValidationError.new(ApiError.create_message_from_api_status(response_body['status']))
      end

      if response_body['status']['responseCode'] == 901
        raise SpeditionError.new(ApiError.create_message_from_api_status(response_body['status']))
      end

      if response_body['status']['responseCode'] != 0
        raise ProcessingError.new(ApiError.create_message_from_api_status(response_body['status']))
      end

      true

    end
  end
end