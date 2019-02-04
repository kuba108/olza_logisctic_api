module OlzaApi
  class RequestMaker

    attr_accessor :api_user, :api_pwd, :api_laguage

    def initialize(api_user, api_pwd, api_language)
      @api_user = api_user
      @api_pwd = api_pwd
      @api_laguage = api_language
    end

    def send_post_request(url, payload = nil)
      request = Request.new(:post, url, build_data(payload).to_json)
      connection = create_connection(url)
      raw_response  = connection.post do |req|
        req.body = request.payload
      end

      response = build_response(raw_response)
      if response.valid?
        {
          result: 'success',
          response: response,
          response_status: response.response_code,
          msg: "All packages was processed correctly."
        }
      else
        response.parse_errors
        {
            result: 'error',
            response: response,
            response_status: response.response_code,
            errors: response.errors,
            msg: "Some errors during processing occured. Check response Hash"
        }
      end
    end
    private

    # prepare header into JSON with given credentials
    def build_header
      {header:{apiUser: @api_user,
       apiPassword: @api_pwd,
      language: @api_laguage}}
    end

    #merge header and provided data hashes
    def build_data(data)
      header = build_header
      full_data = header.merge(data)
      return full_data
    end

    def create_connection(url)
      Faraday.new(url: url) do |conn|
        conn.request :json
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end

    def build_response(raw_response, ignore_body = false)
      if ignore_body
        Response.new(raw_response.status)
      else
        Response.new(raw_response.status, raw_response.body)
      end
    end


  end
end
