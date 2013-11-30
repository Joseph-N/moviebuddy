class ShareWorker
  include Sidekiq::Worker

  def perform(service, resource, user_id, resource_id, options = {})
  	user = User.find(user_id)

  	#check if user is connected to any social network
  	if user.connected_socially?
	  	record =  resource.safe_constantize.find(resource_id)

	  	if resource == "Movie"
	  		unless options["activity"] == nil
	  			content = "Liked #{ record.title } movie on #MovieBuddy #{ options['url'] }"
	  		else
	  			content = record.comment.present? ? "#{record.comment}  #{ options['url'] }" : "Added new movie on MovieBuddy'#{record.title}' #{ options['url'] }"
	  		end
	  	elsif resource == "Update"
	  		content = "#{record.content} #MovieBuddy"
	  	elsif resource == "Comment"
	  		content = "#{ record.body } #{ options['url'] }"
	  	end

	  	graph = user.facebook
	  	graph.put_connections("me","feed", :message => content)  
	end  
  end
end