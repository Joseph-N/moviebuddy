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

        // PrettyPhoto
    s("a[rel^='prettyPhoto']").prettyPhoto({
        theme: 'facebook',
        social_tools: false
    });

    // jQuery UItoTop
    s().UItoTop({ easingType: 'easeOutQuart' });

	// Skin Chooser
	s(".color-skin").click(function () {
	    var cls = this.id;
	    s(".color-skin").removeClass("active");
	    s(this).addClass("active");
	    s("#main-wrapper").removeClass();
	    s("#main-wrapper").addClass(cls);
	});

    // jQuery CarouFredSel
    var caroufredsel = function () {
        s('#caroufredsel-portfolio-container').carouFredSel({
            responsive: true,
            scroll: 1,
            circular: false,
            infinite: false,
            items: {
                visible: {
                    min: 1,
                    max: 3
                }
            },
            prev: '#portfolio-prev',
            next: '#portfolio-next',
            auto: {
                play: false
            }
        });
        s('#caroufredsel-clients-container').carouFredSel({
            responsive: true,
            scroll: 1,
            circular: false,
            infinite: false,
            items: {
                visible: {
                    min: 1,
                    max: 4
                }
            },
            prev: '#client-prev',
            next: '#client-next',
            auto: {
                play: false
            }
        });
    };
    s(window).load(function () {
        caroufredsel();
    });
    s(window).resize(function () {
        caroufredsel();
    });  


    /*
     *----------------- AJAX CALLS ------------------ *
     			                    				  */

	// when a user searches for movies
	s('#movie_search').submit(function(){
		s('.loading').show();
    s('h4#movies').remove();

		s.ajax({
			type: "GET",
  			url: s(this).attr('action'),
  			data: s(this).serialize(),
  			dataType: "script",
  			success: function(){
  				s('.loading').hide();
  			}
		});
		return false;
	});

	// when user wants to save a movie
	s('#save-movie').click(function(e){
		e.preventDefault();

		var title = s('#movie_title').val();
    var tmdb_id = s('#movie_tmdb_id').val();
		var overview = s('#movie_overview').val();
		var poster= s('#movie_poster').val();
		var comment = s('#movie_comment').val();
		var genres = s('#movie_genres').val().split(",");
		var video_id = s('#movie_youtube_identifier').val();
		var budget = s('#movie_budget').val();
		var homepage = s('#movie_homepage').val();
		var r_date = s('#movie_release_date').val();
		var tagline = s('#movie_tag_line').val();
		var backdrop = s('#movie_backdrop').val();

		s.ajax({
			type: "POST",
  			url: s('#new_movie').attr('action'),
  			data: {"movie[tmdb_id]" : tmdb_id, "movie[title]" : title, "movie[overview]": overview, "movie[poster]": poster,
  				"movie[comment]" : comment, "movie[youtube_identifier]" : video_id,"movie[genres]": genres,
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
			s('#modal').modal();
		}
		else{
			s.ajax({
				type: "POST",
	  			url: s(this).attr('action'),
	  			data: s(this).serialize(),
	  			dataType: "script"
			});
		}
	});

  // poll 4 changes
  if (s('ul#comments').children().size() > 0) {
    setTimeout(updateComments, 20000);
  }

});


function updateComments() {
  var after = s('.media:last').attr('data-time');
  s.ajax({
    type: "GET",
    global: false,
    url: s('#comments-path').text() + '.js',
    data: {"after" : after },
    dataType: "script",
  });
  setTimeout(updateComments, 20000);
}
