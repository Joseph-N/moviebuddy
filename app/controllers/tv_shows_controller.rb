class TvShowsController < ApplicationController
	before_action :init_tmdb, only: [:index, :show]

	def index
		if params[:q]
			@tv_shows = @tmdb.searchTv(params[:q])	
		else
			@tv_shows = current_user.tv_shows.page(params[:page]).per(12)
		end
		respond_to do |format|
			format.html
			format.js
		end
	end

	def show
		@tv_show = TvShow.friendly.find(params[:id])
	end

	def create
		@tv_show = current_user.tv_shows.build(tv_show_params)
		unless current_user.tv_shows.where(:tmdbid => @tv_show.tmdbid).any?
			if @tv_show.save
				respond_to do |format|
					format.js
					format.html { redirect_to tv_shows_path }					
				end
			end
		end
	end


	private
		def init_tmdb
			@tmdb = Tmdb.new
		end

		def tv_show_params
			params.require(:tv_show).permit(:tmdbid, :name, :poster)
		end
end
