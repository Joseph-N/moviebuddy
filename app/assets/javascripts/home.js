/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
You can use CoffeeScript in this file: http://coffeescript.org/ */

var s = jQuery;
s.noConflict();

s(document).ready(function(){

    // Revolution Slider
    if (s.fn.cssOriginal != undefined)
        s.fn.css = s.fn.cssOriginal;
    s('.fullwidthbanner').revolution({
        delay: 9000,
        startwidth: 1200,
        startheight: 400,

        onHoverStop: "on",

        thumbWidth: 100,
        thumbHeight: 50,
        thumbAmount: 3,

        hideThumbs: 0,

        navigationType: "none",
        navigationArrows: "solo",
        navigationStyle: "round",
        navigationHAlign: "left",
        navigationVAlign: "bottom",
        navigationHOffset: 30,
        navigationVOffset: 30,

        soloArrowLeftHalign: "left",
        soloArrowLeftValign: "center",
        soloArrowLeftHOffset: 20,
        soloArrowLeftVOffset: 0,

        soloArrowRightHalign: "right",
        soloArrowRightValign: "center",
        soloArrowRightHOffset: 20,
        soloArrowRightVOffset: 0,

        stopAtSlide: -1,
        stopAfterLoops: -1,
        hideCaptionAtLimit: 0,
        hideAllCaptionAtLilmit: 0,
        hideSliderAtLimit: 0,

        fullWidth: "on",
        fullScreen: "off",
        fullScreenOffsetContainer: "#topheader-to-offset",

        shadow: 0
    });

	//apply backdrop
	s('.section.colored-wrapper.b').addClass('backdrop');

	//hide comment forms
	s('.media.update-comment-form').hide();

	//show comment form when comment link is clicked
	s(document).on('click', '.home.com', function(e){
		e.preventDefault();

		var id = s(this).attr('id').replace(/[^0-9\.]/g, '');
		s('#form-' + id).toggle('slow');
	});

	// when a comment is posted
	s(document).on('submit', '#new_update', function(e){
		e.preventDefault();

		if(!s.trim(s('#update_content').val())){
			s('#modal').modal();
		}
		else{
			s('.ajax-loading-gif').show();
			s('#post-update').addClass('disabled');

			s.ajax({
			type: "POST",
			  url: s(this).attr('action'),
			  data: s(this).serialize(),
			  dataType: "script",
			  success: function(){
			  	s('.ajax-loading-gif').hide();
			  	s('#post-update').removeClass('disabled');

			  }
			});
		}
	});

	// when a new update comment is posted
	s(document).on('click', '.update-comment', function(e){
		e.preventDefault();

		var id = s(this).attr('id');
		var form = s('#cupdate_' + id);

		if(!s.trim(form.val())){
			s('#modal').modal();
		}
		else{
		  s.ajax({
		    type: "POST",
		      url: s('#update_' + id).attr('action'),
		      data: s('#update_' + id).serialize(),
		      dataType: "script"
		  });
		}
	});

	// when user clicks the like/dislike link
	s(document).on('click', 'a.home.like-dislike', function(e){
		e.preventDefault();

		s.ajax({
			type: "GET",
  			url: s(this).attr('href'),
  			dataType: "script"
		});	
	});

	// poll 4 changes
	if (s('ul#home-updates').children('li').size() > 0) {
	    setTimeout(fetchUpdates, 20000);
	}

	// manually poll for past updates
	if(s('li.media').size() > 0){

		s('#more-updates').click(function(){
			var after = s('li.media:last').attr('data-time');
			var link = s(this);
			s('div.more').show();
			link.hide();

			s.ajax({
				type: "GET",
	  			url: '/updates/more',
	  			data: {"after" : after },
	  			dataType: "script",
	  			success: function(){
	  				s('div.more').hide();
	  				link.show();
	  			}
			});
			return false;
		});
		
	} 

	//show overlay for any ajax request
	s('body').ajaxStart(function() {
		ajaxOverlay();
	}).ajaxStop(function(){
		s('#overlay').hide();

	});


});



function fetchUpdates() {
  	var after = s('.media-list').children('li:first').attr('data-time');
	s.ajax({
		type: "GET",
		global: false,
		url: '/updates.js',
		data: {"after" : after },
		dataType: "script",
	});
	setTimeout(fetchUpdates, 20000);            
}

function ajaxOverlay(){
	var docHeight = s(document).height();

   	s("body").append("<div id='overlay'></div>");

   	s("#overlay").show();
}


