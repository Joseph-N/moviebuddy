namespace :movies do

  desc "Fetch the latest popular movies from TMDB"
  task popular: :environment do

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


  	puts "----> Contacting TMDB API for popular movies....."
  	movies = tmdb.popularMovies 

  	if movies
  		puts "      Success!! now saving the records!"
      puts "\n"
  		movies.each do |movie|
        if movie["release_date"].to_date.year > 2010 && movie["backdrop_path"] != nil && movie["poster_path"] != nil
    			genres = []
          puts "       -> New movie: #{movie["title"]}..."
    			puts "       -> Fetching trailer for #{movie["title"]}..."
    			trailer = tmdb.movieTrailer(movie["id"])

    			params = movie.select{|key, value| cols.include?(key) }
    			params["genres"].each {|x| genres.push(x["name"])}
    			

    			newMovie = Movie.new( title: params["title"],
  			  					  tmdb_id: params["id"],
  			  					  overview: params["overview"],
  			  					  poster: params["poster_path"],
  			  					  backdrop: params["backdrop_path"],
  			  					  genres: genres,
  			  					  youtube_identifier: trailer,
  			  					  budget: params["budget"],
  			  					  homepage: params["homepage"],
  			  					  release_date: params["release_date"],
  			  					  tag_line: params["tagline"],
  			  					  popular: true
  			  					)

    			if newMovie.save
    				puts "       -> Successfully added #{newMovie.title}"
    				puts "\n"
    			end
        end
  		end
      puts "Regards, always at your service"
  	end
  end

  desc "Fetch upcoming movies from TMDB"
  task upcoming: :environment do
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

    puts "----> Contacting TMDB API for upcoming movies....."
    movies = tmdb.upcomingMovies

    if movies
      movies.each do |movie|
        if movie["release_date"].to_date.year > 2010 && movie["backdrop_path"] != nil && movie["poster_path"] != nil
        genres = []
        puts "       -> New movie: #{movie["title"]}..."
        puts "       -> Fetching trailer for #{movie["title"]}..."
        trailer = tmdb.movieTrailer(movie["id"])

        params = movie.select{|key, value| cols.include?(key) }
        params["genres"].each {|x| genres.push(x["name"])}
        

        newMovie = Movie.new( title: params["title"],
                    tmdb_id: params["id"],
                    overview: params["overview"],
                    poster: params["poster_path"],
                    backdrop: params["backdrop_path"],
                    genres: genres,
                    youtube_identifier: trailer,
                    budget: params["budget"],
                    homepage: params["homepage"],
                    release_date: params["release_date"],
                    tag_line: params["tagline"],
                    upcoming: true
                  )

        if newMovie.save
          puts "       -> Successfully added #{newMovie.title}"
          puts "\n"
        end
      end

    end
  end


desc "Fetch highest rated movies from TMDB"
  task highest_rated: :environment do
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
    
    puts "----> Contacting TMDB API for highest rated movies....."
    movies = tmdb.highest_rated

    if movies
      movies.each do |movie|
        genres = []
        puts "       -> New movie: #{movie["title"]}..."
        puts "       -> Fetching trailer for #{movie["title"]}..."
        trailer = tmdb.movieTrailer(movie["id"])

        params = movie.select{|key, value| cols.include?(key) }
        params["genres"].each {|x| genres.push(x["name"])}
        

        newMovie = Movie.new( title: params["title"],
                    tmdb_id: params["id"],
                    overview: params["overview"],
                    poster: params["poster_path"],
                    backdrop: params["backdrop_path"],
                    genres: genres,
                    youtube_identifier: trailer,
                    budget: params["budget"],
                    homepage: params["homepage"],
                    release_date: params["release_date"],
                    tag_line: params["tagline"],
                    highest_rated: true
                  )

        if newMovie.save
          puts "       -> Successfully added #{newMovie.title}"
          puts "\n"
        end
      end

    end
  end


end
