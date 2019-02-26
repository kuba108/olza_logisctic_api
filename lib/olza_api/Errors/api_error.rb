module OlzaApi
  class ApiError < StandardError

    def initialize(message)
      super(message)
    end

    def self.create_message_from_api_status(error_data)
      "\nError code: #{error_data['responseCode']}  \nError Descrtiption: #{error_data['responseDescription']}"
    end
  end
end
