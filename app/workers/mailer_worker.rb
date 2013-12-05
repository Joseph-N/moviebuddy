class MailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, identifier, options = {})
  	user = User.find(user_id)

  	unless options.empty?
  		actor = User.find(options["actor_id"])
  		movie = Movie.find(options["movie_id"]) if options["movie_id"]
  		update = Update.find(options["update_id"]) if options["update_id"]  		
  	end

  	if identifier == "registration"
  		UserMailer.signup_confirmation(user).deliver
  	elsif identifier == "movieComment"
  		comment = Comment.find(options["comment_id"]) if options["comment_id"]
  		UserMailer.comment_notification(user, actor, movie, comment).deliver unless user == actor
  	elsif identifier == "movieLike"
  		UserMailer.like_notification(user, actor, movie).deliver unless user == actor 
  	elsif identifier == "updateComment"
  		comment = UpdateComment.find(options["comment_id"]) if options["comment_id"]
  		UserMailer.update_comment_notification(user, actor, update, comment).deliver unless user == actor	
  	elsif identifier == "userFollow"
  		UserMailer.follow_notification(user, actor).deliver  																		
  	end
  end
end