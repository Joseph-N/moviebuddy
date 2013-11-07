module MoviesHelper
	def percent_of(votes, total_votes)
		((votes.to_f / total_votes.to_f) * 100).round(1)
	end

	def format_time(time)
    	time.strftime("%B %d at %I:%M %p")
  	end
end