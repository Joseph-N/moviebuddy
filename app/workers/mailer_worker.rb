class MailerWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, identifier, options = {})
  	user = User.find(user_id)

    actor = User.find(options["actor_id"]) if options["actor_id"]
    movie = Movie.find(options["movie_id"]) if options["movie_id"]
    update = Update.find(options["update_id"]) if options["update_id"]  

  	if identifier == "registration"
  		UserMailer.signup_confirmation(user).deliver
  	elsif identifier == "movieReview"
  		review = Review.find(options["review_id"]) if options["review_id"]
  		UserMailer.review_notification(user, actor, movie, review).deliver unless user == actor
  	elsif identifier == "movieLike"
  		UserMailer.like_notification(user, actor, movie).deliver unless user == actor 
  	elsif identifier == "Comment"
  		comment = Comment.find(options["comment_id"]) if options["comment_id"]
  		UserMailer.comment_notification(user, actor, update, comment).deliver unless user == actor	
  	elsif identifier == "userFollow"
  		UserMailer.follow_notification(user, actor).deliver  																		
  	end
  end
end