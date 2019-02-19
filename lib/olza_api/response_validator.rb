module OlzaApi
  class ResponseValidator

    def validate_response(response)
      errors = []
      if response.body['response']['list_error'].any?
        error_packages = response.body['response']['list_error']
        error_packages.each do |package|
          errors << package
        end
      end
      errors
    end

  end
end