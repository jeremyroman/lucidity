$(function() {
	// Initialize header stuff
	$("#header").addClass("ui-widget ui-widget-header");
	
	// Initialize tabs
	$(".tabs").tabs({
		show: function(ev, ui) {
			$("#portlet-endpoints .portlet-content").load("/endpoints","plan_id=2")
		}
	});
	$(".tabs").css("background","none");
	
	// Initialize portlet stuff
	$(".portlet-bar").sortable({axis:'y', handle:'.portlet-header'});
	
	$(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
		.find(".portlet-header")
			.addClass("ui-widget-header ui-corner-all")
			.prepend('<span class="ui-icon ui-icon-triangle-1-n"></span>')
			.end()
		.find(".portlet-content");
		
	$(".portlet-header .ui-icon").click(function() {
		$(this).toggleClass("ui-icon-triangle-1-s");
		$(this).parents(".portlet:first").find(".portlet-content").toggle();
	});
	
	$(".portlet-header").disableSelection();
	
	// initialize term stuff
	$(".term-cap").addClass("ui-widget-header");
	$(".term-course").addClass("ui-widget-content");
	$(".term").sortable({ items:'.term-course', connectWith:'.term',
	 	update: function(ev, ui) {
			if (console) {
				console.log(this);
				console.log([ev, ui]);
			}
		}
	});
	$("#portlet-info .term-course").draggable({ appendTo:'body', helper:'clone', connectToSortable:'.term', zIndex:10 });
	$(".term-course").mousedown(function() {
		$(".term-course").removeClass("ui-state-highlight");
		$(this).addClass("ui-state-highlight");
		id = $(this).children("input[name=id]").val();
		$("#portlet-info .portlet-content").load('/courses/' + id);
	});
});