// Main dropdown menu
$(document).ready(function(){
	$('#menu li ul').css({
		display: 'none',
		width: "250px" // Keeps the with from popping to right on wider menus
		//left: 'auto'
	});
	$('#menu li').hover(function() {
		$(this)
			.find('ul')
			.stop(true, true)
			.slideDown('fast');
	}, function() {
		$(this)
			.find('ul')
			.stop(true, true)
			.fadeOut('fast');
	});
});


