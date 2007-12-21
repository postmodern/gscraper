module URI
  class HTTP

    # Query parameters
    attr_reader :query_params

    #
    # Creates a new URI::HTTP object and initializes query_params as a
    # new Hash.
    #
    def initialize(*args)
      super(*args)

      @query_params = {}
      parse_query_params
    end

    #
    # Sets the query data and updates query_params.
    #
    def query=(query_str)
      new_query = super(query_str)
      parse_query_params
      return new_query
    end

    protected

    #
    # Parses the query parameters from the query data, populating
    # query_params with the parsed parameters.
    #
    def parse_query_params
      @query_params.clear

      if @query
        @query.split('&').each do |param|
          name, value = param.split('=')

          if value
            @query_params[name] = URI.decode(value)
          else
            @query_params[name] = nil
          end
        end
      end
    end

    private

    # :nodoc:
    def path_query
      str = @path

      unless @query_params.empty?
        str += '?' + @query_params.to_a.map { |name,value|
          if value==true
            "#{name}=active"
          elsif value
            "#{name}=#{URI.encode(value.to_s)}"
          else
            "#{name}="
          end
        }.join('&')
      end

      return str
    end

  end
end
