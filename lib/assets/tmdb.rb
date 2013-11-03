require "cgi"
require "json"
require "rest-client"

class Tmdb

	API_URL = "http://api.themoviedb.org/3/"

	def initialize
		@key = "29588c40b1a3ef6254fd1b6c86fbb9a9"
		@params = { "api_key" => @key }
	end

	def getConfig
		url = buildUrl("configuration", @params)
		RestClient.get url
	end

	def imageUrl(type, size, file_path)
		config = JSON.parse(getConfig)
		base_url = config['images']['base_url']
		if config['images'][type + '_sizes'].include?(size)
			base_url + size + file_path
		end
	end

	def movieInfo(id)
		url = buildUrl("movie/#{id}",@params)
		JSON.parse(RestClient.get url)
	end

	def searchMovie(title)
		@params["query"] = title
		@params["include_adult"] = false
		url = buildUrl("search/movie", @params)
		JSON.parse(RestClient.get url)
	end

	def movieTrailer(id)
		url = buildUrl("movie/#{id}/trailers", @params)	
		trailers = JSON.parse(RestClient.get url)	
        if trailers["youtube"][0] == nil
        	return "No Trailer available for this Movie"
        else
	        trailers["youtube"][0]["source"]
		end
	end

	private

		# Return a full valid address with parameters
		def buildUrl(path,params)
			return API_URL + "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')) if not params.nil?
		end
end