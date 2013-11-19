require "cgi"
require "json"
require "rest-client"

class Tmdb

	API_URL = "http://api.themoviedb.org/3/"

	@@config = nil

	def initialize
		@key = "29588c40b1a3ef6254fd1b6c86fbb9a9"
		@params = { "api_key" => @key }
		if @@config == nil
			getConfig
		end
	end

	def getConfig
		url = buildUrl("configuration", @params)
		@@config = RestClient.get url
	end

	def imageUrl(type, size, file_path)
		config = JSON.parse(@@config)
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

	def popularMovies
		pop_movies = []

		url = buildUrl("movie/popular", @params)
		movies = JSON.parse(RestClient.get url)
		movies["results"].each do |movie|
			pop_movies << movieInfo(movie["id"])
		end
		pop_movies
	end

	def upcomingMovies
		upcoming_movies = []

		url = buildUrl("movie/upcoming", @params)
		movies = JSON.parse(RestClient.get url)
		movies["results"].each do |movie|
			upcoming_movies.push(movieInfo(movie["id"]))
		end
		upcoming_movies
	end

	def highest_rated
		h_rated = []

		url = buildUrl("movie/top_rated", @params)
		movies = JSON.parse(RestClient.get url)
		movies["results"].each do |movie|
			h_rated.push(movieInfo(movie["id"]))
		end
		h_rated
	end

	private

		# Return a full valid address with parameters
		def buildUrl(path,params)
			return API_URL + "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')) if not params.nil?
		end
end