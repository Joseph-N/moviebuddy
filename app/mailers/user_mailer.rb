class UserMailer < ActionMailer::Base
  default from: ENV["NOTIFICATION_EMAIL"]

  def signup_confirmation(user)
    @user = user

    mail to: user.email, subject: "Welcome to MovieBuddy"
  end

  def review_notification(to_user, from_user, movie, review)
    @to_user = to_user
    @from_user = from_user
    @movie = movie
    @review = review

    mail to: to_user.email, subject: "New Review"
  end

  def like_notification(to_user, from_user, movie)
    @to_user = to_user
    @from_user = from_user
    @movie = movie

    mail to: to_user.email, subject: "New Like"
  end

  def comment_notification(user, actor, update, comment)
    @to_user = user
    @from_user = actor
    @update = update
    @comment = comment
    @movie = Movie.find(update.movie) unless update.movie.equal?(0)

    mail to: user.email, subject: "New Comment"
  end

  def follow_notification(user, actor)
    @user = user
    @follower = actor

    mail to: user.email, subject: "New Follower"
  end
end
