/* Place all the behaviors and hooks related to the matching controller here.
All this logic will automatically be available in application.js.
You can use CoffeeScript in this file: http://coffeescript.org/ */

var s = jQuery;
s.noConflict();

s(document).ready(function(){
	s('.youtube').fitVids();

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
		s('.loading').show();
    s('h4#movies').remove();

		s.ajax({
			type: "GET",
  			url: s(this).attr('action'),
  			data: s(this).serialize(),
  			dataType: "script",
  			success: function(){
  				s('.loading').hide();

          //set tooltips
          setTooltip();
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

function setTooltip(){
  s('.tip').each(function(){
    var myImage = s(this);
    var url = myImage.attr('data-url');

    myImage.tooltipster({
      maxWidth: 500,
      position: 'bottom-left',
      animation: 'slide',
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
                 origin.tooltipster('update', '<b>' + data.original_title + '</b><br />' + data.overview).data('ajax', 'cached');
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
