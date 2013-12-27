class ReviewsController < ApplicationController
	before_filter :authenticate_user!, :except => [:index]
	def index
		@movie = Movie.friendly.find(params[:movie_id])
		@reviews = Review.where("movie_id = ? and created_at > ?", @movie.id, Time.at(params[:after].to_i + 1))
    end

	def create
		@movie = Movie.friendly.find(params[:movie_id])
		@review = @movie.reviews.build(comment_params)
		@review.user_id = current_user.id
		if @review.save
			ActivityWorker.perform_async("Review", @review.id, current_user.id)	
			ShareWorker.perform_async("facebook", "Review", current_user.id, @review.id, { activity: "movie.review", url: movie_url(@movie)})
			MailerWorker.perform_async(@movie.user.id, "movieReview", { actor_id: current_user.id, movie_id: @movie.id, review_id: @review.id })

			respond_to do |format|
				format.html { redirect_to movie_path(@movie) }
				format.js
			end
		else
			@movie = Movie.friendly.find(params[:movie_id])
			@tmdb = Tmdb.new
			@reviews = @movie.reviews
			@trailer = youtubeVideo(@movie.youtube_id)
			render 'movies/show'
		end
	end

	private
		def comment_params
			params.require(:review).permit(:body)
		end
end
