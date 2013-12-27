/* Place all the behaviors and hooks related to the matching controller here.
All this logic will automatically be available in application.js.
You can use CoffeeScript in this file: http://coffeescript.org/ */

var s = jQuery;
s.noConflict();

s(document).ready(function(){
	s('.youtube').fitVids();

  //when searching if .tips are present add tooltipser
  if(s('.tip').size() > 0){
    setTooltips();
  }

  //change checkbox value
  s('#movie_facebook').click(function(){
     s(this).is(':checked') ? s(this).val("1") : s(this).val("0");
  });

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


    /*
     *----------------- AJAX CALLS ------------------ *
     			                    				  */

	// when a user searches for movies
	s('#movie_search').submit(function(){
    s('h4#movies').text('Searching.....');

		s.ajax({
			type: "GET",
  			url: s(this).attr('action'),
  			data: s(this).serialize(),
  			dataType: "script",
  			success: function(){
  				s('.loading').hide();

          //set tooltips
          setTooltips();
  			}
		});
		return false;
	});


  // when user adds a movie
  s(document).on('click','.add-to-collection', function(e){
    e.preventDefault();

    s.ajax({
      type: "GET",
        url: s(this).attr('data-url'),
        dataType: "JSON",
        success: function(data){
          addMovie(data);
        }
    });

  })


	// when use clicks the voting links
	s(document).on('click', 'a.vote', function(e){
		e.preventDefault();

		s.ajax({
			type: "GET",
  			url: s(this).attr('href'),
  			dataType: "script"
		});	
	});

	// when a review is posted
	s('#new_review').submit(function(e){
		e.preventDefault();
		if(!s.trim(s('#review_body').val())){
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

  // get cast for a movie
  s('a.cast').click(function(){
    var id = s('span#tmdb_id').text();

    if(s('.col-md-2.portfolio-item-wrapper-cast').size() == 0){
      s('.gif-loader').show();

      s.ajax({
        type: "GET",
        url: 'http://api.themoviedb.org/3/movie/' + id +'/credits',
        data: { api_key: "29588c40b1a3ef6254fd1b6c86fbb9a9" },
        dataType: "JSON",
        global: false,
        success: function(data){
          s('.gif-loader').hide();
          showCast(data);
        }
      });
    }
  });

  // get similar movies for a movie
  s('a.similar-movies').click(function(){
    var id = s('span#tmdb_id').text();
    
    if(s('.col-md-2.portfolio-item-wrapper-similar').size() == 0){
      s('.gif-loader').show();

      s.ajax({
        type: "GET",
        url: 'http://api.themoviedb.org/3/movie/' + id +'/similar_movies',
        data: { api_key: "29588c40b1a3ef6254fd1b6c86fbb9a9" },
        dataType: "JSON",
        global: false,
        success: function(data){
          s('.gif-loader').hide();
          similarMovies(data);
        }
      });
    }
  });

  // poll 4 changes
  if (s('ul#reviews').children().size() > 0) {
    setTimeout(updateReviews, 20000);
  }

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
                  max: 6
              }
          },
          prev: '#portfolio-prev',
          next: '#portfolio-next',
          auto: {
              play: false
          }
      });
  };

  var caroufredselhome = function () {
      s('#caroufredsel-portfolio-container-home').carouFredSel({
          responsive: true,
          scroll : {
            items           : 1,
            easing          : "elastic",
            duration        : 1000,                         
            pauseOnHover    : true
          },
          circular: true,
          infinite: true,
          items: {
              visible: {
                  min: 3,
                  max: 6
              }
          },
          prev: '#portfolio-prev',
          next: '#portfolio-next',
          auto: {
              play: true
          }
      });
  };

  if(s('#caroufredsel-portfolio-container').size() > 0 || s('#caroufredsel-portfolio-container-home').size() > 0 ){
    s(window).load(function () {
      caroufredsel();
      caroufredselhome();
    });
    s(window).resize(function () {
      caroufredsel();
      caroufredselhome();
    }); 
  } 

});


function updateReviews() {
  var after = s('.media:last').attr('data-time');
  s.ajax({
    type: "GET",
    global: false,
    url: s('#reviews-path').text() + '.js',
    data: {"after" : after },
    dataType: "script",
  });
  setTimeout(updateReviews, 20000);
}

function setTooltips(){
  s('.tip').each(function(){
    var myImage = s(this);
    var url = myImage.attr('data-url');

    myImage.tooltipster({
      maxWidth: 500,
      interactive: false,
      position: 'right',
      animation: 'slide',
      trigger: 'hover',
      content: 'Loading....',
      functionBefore: function(origin, continueTooltip) {

        // we'll make this function asynchronous and allow the tooltip to go ahead and show the loading notification while fetching our data
        continueTooltip();
          
        // next, we want to check if our data has already been cached
        if (origin.data('ajax') !== 'cached') {
           s.ajax({
              type: 'GET',
              global: false,
              url: url,
              success: function(data) {
                 // update our tooltip content with our returned data and cache it
                 origin.tooltipster('update', '<p class="tooltipser-title">' + data.title + '</p><p>' + data.overview + 
                                    '</p><p>Rated: '+ data.vote_average +' / 10</p>').data('ajax', 'cached');
              }
           });
        }
      }

    })
  })
}

function addMovie(data){
  var genres = []
  data.genres.forEach(function(genre){ genres.push(genre.name)});

  var title = data.original_title;
  var tmdb_id = data.id;
  var overview = data.overview;
  var poster = data.poster_path;
  var video_id = data.trailers.youtube[0] == undefined ? null : data.trailers.youtube[0].source;
  var budget = data.budget;
  var homepage = data.homepage;
  var r_date = data.release_date;
  var tagline = data.tagline;
  var backdrop = data.backdrop;

  s.ajax({
    type: "POST",
      url: '/movies',
      data: {"movie[tmdb_id]" : tmdb_id, "movie[title]" : title, "movie[overview]": overview, "movie[poster]": poster,
        "movie[youtube_identifier]" : video_id,"movie[genres]": genres,
        "movie[budget]" : budget, "movie[homepage]" : homepage, "movie[release_date]" : r_date,
        "movie[tag_line]" : tagline, "movie[backdrop]" : backdrop
      }
  }); 

}


function showCast(data){
  var div = s('div#cast');
  var count = 0

  data.cast.forEach(function(cast){
      var profile_pic =  cast.profile_path;
      var name = cast.name;
      var character = cast.character;

      if(profile_pic != undefined){
        count += 1;

        div.append('<div class="col-md-2 col-sm-4 col-xs-6 portfolio-item-wrapper-cast">' + 
                    '<div class="portfolio-item">' +
                        '<div class="thumbnail">' +
                          '<img src="http://image.tmdb.org/t/p/w154/' + profile_pic + '" />' +
                          '<div class="caption">' +
                            '<b>' + name + '</b>' +
                            '<span style="display: block">' + character + '</span>' +
                        '</div>' +
                      '</div>' +
                    '</div>' +
                  '</div>');
        if(count % 6 == 0){
          div.append('<div class="clearfix" style="margin-bottom: 10px;"></div>');
        }

      }
  });
  div.append('<div class="clearfix"></div>');
}

function similarMovies(data){
  var div = s('div#similar');
  var count = 0

  data.results.forEach(function(result){
      var poster =  result.poster_path;
      var title = result.title;
      var year = result.release_date;
      var id = result.id;

      if(poster != undefined){
        count += 1;

        div.append('<div class="col-md-2 col-sm-4 col-xs-6 portfolio-item-wrapper-similar" id="' + id +'">' + 
                    '<div class="portfolio-item">' +
                        '<div class="thumbnail">' +
                          '<a href="#"><img src="http://image.tmdb.org/t/p/w154/' + poster + '" id="image-'+ id +'" class="tip" title="'+ title +'" data-url="http://api.themoviedb.org/3/movie/'+ id +'?api_key=29588c40b1a3ef6254fd1b6c86fbb9a9&append_to_response=trailers" /></a>' +
                          '<div class="caption">' +
                            '<b>' + truncateString(title, 12) + '</b>' +
                            '<span style="display: block" id="release-year-' + id +'">' +year + '</span>' +
                            '<hr /><a href="#" class="add-to-collection btn btn-info btn-default btn-xs btn-block" data-url="http://api.themoviedb.org/3/movie/'+ id +'?api_key=29588c40b1a3ef6254fd1b6c86fbb9a9&append_to_response=trailers" id="add-'+ id +'">Add</a>' +
                        '</div>' +
                      '</div>' +
                    '</div>' +
                  '</div>');
        if(count % 6 == 0){
          div.append('<div class="clearfix" style="margin-bottom: 10px;"></div>');
        }

      }
  });
  div.append('<div class="clearfix"></div>');
  setTooltips();
} 

//function to truncate strings
function truncateString(str, length) {
   return str.length > length ? str.substring(0, length - 3) + '...' : str
}