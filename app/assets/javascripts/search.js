$(function() {

	var $searchInputs = $('input.search');
	var $target;

	$searchInputs.focus(function() {
		console.log($(this).attr('data-target'));
		$target = $($(this).attr('data-target'));
	});

	$searchInputs.keyup(function() {
		var query = $(this).val().toLowerCase();

		$target.each(function() {
			if ($(this).find('.name').text().toLowerCase().indexOf(query) == -1) $(this).hide();
			else $(this).show();
		});
		if (query != '') $(this).addClass('active');
		else $(this).removeClass('active');
	});

	$('.search .icon-remove').click(function() {
		$(this).siblings('input').val('').removeClass('active').keyup();
	});

});