namespace :movies do
  desc "Fetch the latest popular movies from TMDB"
  task fetch: :environment do
  	tmdb = Tmdb.new
  	cols = Movie.columns.map { |c| c.name }
  	cols.map! {|value|
  		if(value == "poster")
  			"poster_path"
  		elsif(value == "backdrop")
  			"backdrop_path"
  		elsif(value == "tag_line")
  			"tagline"  				
  		else
  			value
  		end
  	}

  	puts "Getting current list of popular movies...."
  	movies = tmdb.popularMovies 

  	if movies
  		puts "Success!! now saving the records!"
  		movies.each do |movie|
  			genres = []
  			puts "----> Fetching trailer for #{movie["title"]}..."
  			trailer = tmdb.movieTrailer(movie["id"])

  			params = movie.select{|key, value| cols.include?(key) }
  			params["genres"].each {|x| genres.push(x["name"])}
  			

  			newMovie = Movie.new( title: params["title"],
			  					  tmdb_id: params["id"],
			  					  overview: params["overview"],
			  					  poster: params["poster_path"],
			  					  backdrop: params["backdrop_path"],
			  					  genres: genres,
			  					  youtube_id: trailer,
			  					  budget: params["budget"],
			  					  homepage: params["homepage"],
			  					  release_date: params["release_date"],
			  					  tag_line: params["tagline"],
			  					  popular: true
			  					)

  			if newMovie.save
  				puts "----> Successfully added #{newMovie.title}"
  				puts "\n"
  			end
  		end
  	end
  end

end
