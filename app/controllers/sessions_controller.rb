class SessionsController < Devise::SessionsController

  def new
    @recent_movies = Movie.last(5)
    @tmdb = Tmdb.new
    super
  end

end 