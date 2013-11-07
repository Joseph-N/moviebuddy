/* Place all the behaviors and hooks related to the matching controller here.
All this logic will automatically be available in application.js.
You can use CoffeeScript in this file: http://coffeescript.org/ */

var s = jQuery;
s.noConflict();

s(document).ready(function(){
	s('.youtube').fitVids();

	// Isotope Portfolio
    var container = s('#isotope-portfolio-container');
    var filter = s('.portfolio-filter');
    s(window).load(function () {
        // Initialize Isotope
        container.isotope({
            itemSelector: '.portfolio-item-wrapper'
        });
        s('.portfolio-filter a').click(function () {
            var selector = s(this).attr('data-filter');
            container.isotope({ filter: selector });
            return false;
        });
        filter.find('a').click(function () {
            var selector = s(this).attr('data-filter');
            filter.find('a').parent().removeClass('active');
            s(this).parent().addClass('active');
        });
    });
    s(window).smartresize(function () {
        container.isotope('reLayout');
    });   

	// when a user searches for movies
	s('#movie_search').submit(function(){
		s('#loading').show();
		s.ajax({
			type: "GET",
  			url: s(this).attr('action'),
  			data: s(this).serialize(),
  			dataType: "script",
  			success: function(){
  				s('#loading').hide();
  			}
		});
		return false;
	});

	// when user wants to save a movie
	s('#save-movie').click(function(e){
		e.preventDefault();

		var title = s('#movie_title').val();
		var overview = s('#movie_overview').val();
		var poster= s('#movie_poster').val();
		var comment = s('#movie_comment').val();
		var genres = s('#movie_genres').val().split(",");
		var video_id = s('#movie_youtube_id').val();
		var budget = s('#movie_budget').val();
		var homepage = s('#movie_homepage').val();
		var r_date = s('#movie_release_date').val();
		var tagline = s('#movie_tag_line').val();
		var backdrop = s('#movie_backdrop').val();

		s.ajax({
			type: "POST",
  			url: s('#new_movie').attr('action'),
  			data: {"movie[title]" : title, "movie[overview]": overview, "movie[poster]": poster,
  				"movie[comment]" : comment, "movie[youtube_id]" : video_id,"movie[genres]": genres,
  				"movie[budget]" : budget, "movie[homepage]" : homepage, "movie[release_date]" : r_date,
  				"movie[tag_line]" : tagline, "movie[backdrop]" : backdrop
  			},
  			success: function(data){
  				 window.location.href = data.url;
  			}
		});		
	});

	// when use clicks the voting links
	s(document).on('click', 'a.vote', function(e){
		e.preventDefault();

		s.ajax({
			type: "GET",
  			url: s(this).attr('href'),
  			dataType: "script"
		});	
	});

	// when a comment is posted
	s('#new_comment').submit(function(e){
		e.preventDefault();
		if(!s.trim(s('#comment_body').val())){
			alert("Please fill some content")
		}
		else{
			s.ajax({
				type: "POST",
	  			url: s(this).attr('action'),
	  			data: s(this).serialize(),
	  			dataType: "script"
			});
		}
	})
});
