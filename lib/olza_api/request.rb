module OlzaApi
  class Request

    attr_accessor :method, :url, :payload

    def initialize(method, url,  payload)
      @method = method
      @url = url
      @payload = payload
    end

  end
end