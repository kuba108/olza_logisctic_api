require_relative 'Errors/api_error'

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
        if response.errors?
          if response.get_labels_pdf != nil
            {
                result: 'error',
                msg: "Errors in sihpments occured.",
                processed_list: response.processed_list,
                error_list: response.error_list,
                pdf: response.get_labels_pdf,
                body: response
            }
          else
            {
                result: 'error',
                msg: "Erorrs in shipments occured.",
                processed_list: response.processed_list,
                error_list: response.error_list,
                body: response
            }
          end
        else
          if response.get_labels_pdf != nil
            {
                result: 'success',
                processed_list: response.processed_list,
                msg: "All packages was processed correctly.",
                pdf: response.get_labels_pdf,
                body: response
            }
          else
            {
                result: 'success',
                processed_list: response.processed_list,
                msg: "All packages was processed correctly.",
                body: response
            }
          end
        end
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
      if ignore_body
        Response.new(raw_response.status)
      else
        Response.new(raw_response.status, raw_response.body)
      end
    end
  end
end
