class ShareWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(service, resource, user_id, resource_id, options = {})
		user = User.find(user_id)

		# check if user is connected to any social network
		if user.connected_socially?
		  	record =  resource.safe_constantize.find(resource_id)

		  	if service == "facebook" && user.connected_facebook? && user.granted_permission?
		  		graph = user.facebook

		  		# graph.put_connections("me","feed", :message => content, :link => options["url"])  

			  	if resource == "Movie"
			  		if options["activity"] == "movie.like"
			  			graph.put_connections("me","og.likes", :object => options["url"],
			  								  	"fb:explicitly_shared" => true)
			  		elsif options["activity"] == "movie.create"
			  			graph.put_connections("me","themoviebuddy:added", :message => record.comment,
			  									:movie =>  options["url"], "fb:explicitly_shared" => true)
			  		end
			  	elsif resource == "Comment"
			  		if options["activity"] == "movie.comment"
			  			graph.put_connections("me","themoviebuddy:comment_on", :message => record.body,
			  									:movie =>  options["url"], "fb:explicitly_shared" => true)
			  		end
			  	end 	

		  	end

		end

	end

end