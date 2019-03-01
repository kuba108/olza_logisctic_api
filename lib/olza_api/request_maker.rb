module OlzaApi
  class RequestMaker

    attr_accessor :api_user, :api_pwd, :api_laguage

    def initialize(api_user, api_pwd, api_language)
      @api_user = api_user
      @api_pwd = api_pwd
      @api_language = api_language
    end

    def send_post_request(url, payload = nil)
      request = Request.new(:post, url, build_data(payload).to_json)
      connection = create_connection(url)
      raw_response  = connection.post do |req|
        req.body = request.payload
      end

      response = build_response(raw_response)

      if response.valid?
        response
      end
    end

    private

    # Prepares header into JSON with given credentials.
    def build_header
      {
        header: {
          apiUser: @api_user,
          apiPassword: @api_pwd,
          language: @api_language
        }
      }
    end

    # Merges header and provided data hashes.
    def build_data(data)
      header = build_header
      header.merge(data)
    end

    def create_connection(url)
      Faraday.new(url: url) do |conn|
        conn.request :json
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end

    def build_response(raw_response, ignore_body = false)
      raise HttpStatusError.new(raw_response, "Http status is #{raw_response.status}") if raw_response.status != 200

      if ignore_body
        Response.new(raw_response.status)
      else
        Response.new(raw_response.status, raw_response.body)
      end
    end
  end
end
