function initializePlan(root) {
	// initialize term stuff
	$(".term-cap", root).addClass("ui-widget-header").disableSelection();
	$(".term-course", root).addClass("ui-widget-content").disableSelection();
	
	$(".term", root).sortable({ items:'.term-course', connectWith:'.term',
	 	update: function(ev, ui) {
			if (console) {
				console.log(this);
				console.log([ev, ui]);
			}
		}
	});
	
	$(".term-course", root).mousedown(function() {
		$(".term-course").removeClass("ui-state-highlight");
		$(this).addClass("ui-state-highlight");
		id = $(this).children("input[name=id]").val();
		$("#portlet-info .portlet-content").load('/courses/' + id);
	});
}

$(function() {
	// Initialize header stuff
	$("#header").addClass("ui-widget ui-widget-header");
	
	// Initialize tabs
	$(".tabs").tabs({
		load: function(ev, ui) {
			initializePlan(ui.panel);
		},
		show: function(ev, ui) {
			console.log([ev, ui]);
			id_match =  ui.tab.href.match(/(\d+)$/);
			if (!id_match) return;
			
			plan_id = id_match[1];
			$("#portlet-endpoints .portlet-content").load("/plans/" + plan_id + "/endpoints");
			$("#portlet-conflicts .portlet-content").load("/plans/" + plan_id + "/conflicts");
		},
		selected: document.cookie
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
	
	// if anything's already been loaded as far as plans go, handle that
	initializePlan(document);
});

//$("#portlet-info .term-course").draggable({ appendTo:'body', helper:'clone', connectToSortable:'.term', zIndex:10 });