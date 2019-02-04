module OlzaApi
  class Request

    attr_accessor :method, :url, :header, :payload

    def initialize(method, url, header, payload)
      @method = method
      @url = url
      @header = header
      @payload = payload
    end

  end
end