// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.ui.all
//= require jquery.timepicker.js
//= require jquery_ujs
//= require foundation
//= require fullcalendar
//= require home
//= require barcode_listener

$(function() {
	$("#schedule_start").datepicker();
	$("#schedule_end").datepicker();
	$("#schedule_start_time").timepicker({
		'timeFormat' : 'h:i A'
	});
	$("#schedule_end_time").timepicker({
		'timeFormat' : 'h:i A'
	});

});

$(document).ready(function() {
	var chars = [];
	var barcode = "";
	$(window).keypress(function(e) {
		barcode += String.fromCharCode(e.which);
		if (e.which === 13) {
			if ($("#sign_out_tab").attr('class') == "active") {
				if ($("#bc_out_" + barcode).length > 0) {
					$("#bc_out_" + barcode)[0].checked = !$("#bc_out_" + barcode)[0].checked;
				} else {
					alert("Item with barcode " + barcode + " not found for sign out.");
				}
			} else if ($("#sign_in_tab").attr('class') == "active") {
				if ($("#bc_in_" + barcode).length > 0) {
					$("#bc_in_" + barcode)[0].checked = !$("#bc_in_" + barcode)[0].checked;
				} else {
					alert("Item with barcode " + barcode + " not found for sign in.");
				}
			}

			barcode = "";
		}
	});
});

$(document).foundation(); 