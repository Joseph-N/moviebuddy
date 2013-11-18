var s = jQuery;
s.noConflict();

s('tr:last').after('<%= escape_javascript(render(:partial => "activities",  locals: { activities: @activities })) %>');