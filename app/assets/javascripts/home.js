/* Place all the behaviors and hooks related to the matching controller here.
 All this logic will automatically be available in application.js.
You can use CoffeeScript in this file: http://coffeescript.org/ */

var s = jQuery;
s.noConflict();

s(document).ready(function(){
	// hide loading div
	s('div#dvLoading').hide()

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
		  s.ajax({
		    type: "POST",
		      url: s(this).attr('action'),
		      data: s(this).serialize(),
		      dataType: "script"
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
	if (s('ul.media-list').children('li').size() > 0) {
	    setTimeout(fetchUpdates, 20000);
	}

});

function fetchUpdates() {
  	var after = s('.media-list').children('li:first').attr('data-time');
  	s.getScript('updates.js?after=' + after);
  	setTimeout(fetchUpdates, 20000);
}

