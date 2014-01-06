class ShareWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(service, resource, user_id, resource_id, options = {})
		user = User.find(user_id)

		  	record =  resource.safe_constantize.find(resource_id)

		  	if service == "facebook" && user.connected_facebook? && user.granted_permission? && options["facebook"] == true
		  		graph = user.facebook

		  		# graph.put_connections("me","themoviebuddy:review", :message => record.body,
		  		#	                    :movie =>  options["url"], "fb:explicitly_shared" => true) 

			  	if resource == "Movie"
			  		if options["activity"] == "movie.like"
			  			graph.put_connections("me","og.likes", :object => options["url"])
			  		elsif options["activity"] == "movie.create"
			  			graph.put_connections("me","themoviebuddy:added", :movie =>  options["url"])
			  		end
			  	elsif resource == "Review"
			  		if options["activity"] == "movie.review"
			  			graph.put_connections("me","themoviebuddy:review", :message => record.body,
			  									:movie =>  options["url"], "fb:explicitly_shared" => true)
			  		end
			  	end 	

		  	end

	end

end