class ShareWorker
  include Sidekiq::Worker

  def perform(service, resource, user_id, resource_id, options = {})
  	user = User.find(user_id)

  	#check if user is connected to any social network
  	if user.connected_socially?
	  	record =  resource.safe_constantize.find(resource_id)

	  	if resource == "Movie"
	  		unless options["activity"] == nil
	  			content = "Liked a movie on #Moviebuddy"
	  		else
	  			content = record.comment.present? ? "#{record.comment}" : "Added new movie on #MovieBuddy"
	  		end
	  	elsif resource == "Update"
	  		content = "#{record.content} #MovieBuddy"
	  	elsif resource == "Comment"
	  		content = "#{ record.body }"
	  	end

	  	graph = user.facebook
	  	graph.put_connections("me","feed", :message => content, :link => options["url"])  
	end  
  end
end