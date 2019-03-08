module OlzaApi
  class HttpStatusError < StandardError
    attr_reader :data

    def initialize(body, message)
      super(message)
      @body = body
    end
  end
end

