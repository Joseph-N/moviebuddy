var s = jQuery;
s.noConflict();

s(document).ready(function(){
	if(s('table.recent-activity').size() > 0){

		s('#more-activity').click(function(){
			var id = s('tr:last').attr('data-id');
			var link = s(this);
			s('div.more').html('<img src="/assets/ajax-loader-2.gif">').show();
			link.hide();

			s.ajax({
				type: "GET",
	  			url: window.location.href + '/activity',
	  			data: {"activity_id" : id },
	  			dataType: "script",
	  			success: function(){
	  				s('div.more').hide();
	  				link.show();
	  			}
			});
			return false;
		});
		
	}
});