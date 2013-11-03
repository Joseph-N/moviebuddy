/* Place all the behaviors and hooks related to the matching controller here.
All this logic will automatically be available in application.js.
You can use CoffeeScript in this file: http://coffeescript.org/ */

$(document).ready(function(){
	$('#movie_search').submit(function(){
		$('#loading').show();
		$.ajax({
			type: "GET",
  			url: $(this).attr('action'),
  			data: $(this).serialize(),
  			dataType: "script",
  			success: function(){
  				$('#loading').hide();
  			}
		});
		return false;
	});

	$('#save-movie').click(function(e){
		e.preventDefault();

		var title = $('#movie_title').val();
		var overview = $('#movie_overview').val();
		var poster= $('#movie_poster').val();
		var comment = $('#movie_comment').val();
		var genres = $('#movie_genres').val().split(",");
		var video_id = $('#movie_youtube_id').val();

		$.ajax({
			type: "POST",
  			url: $('#new_movie').attr('action'),
  			data: {"movie[title]" : title, "movie[overview]": overview, "movie[poster]": poster, "movie[comment]" : comment, "movie[youtube_id]" : video_id,"movie[genres]": genres },
  			success: function(data){
  				 window.location.href = data.url;
  			}
		});


		
	});
});


