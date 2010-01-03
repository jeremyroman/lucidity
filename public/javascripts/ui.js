Waterloonatic = {
	defaultInitializers: ['header','tabs','portlets','search','plan','actions','misc_ui'],
	
	init: function(what, param) {
		if (typeof(what) == 'undefined') what = Waterloonatic.defaultInitializers;
		if (typeof(what) == 'string') what = [what];
		what.forEach(function(modu) { Waterloonatic.initializers[modu].call(param); });
	},
	
	initializers: {
		header: function() {
			$("#header").addClass("ui-widget ui-widget-header");
		},
		
		tabs: function() {
			$(".tabs").tabs({ cookie: { expires: 7 }, cache: true,
				load: function(ev, ui) {
					Waterloonatic.init('plan', ui.panel);
					
					// try to make the same course selected
					sel_id = Waterloonatic.selection;
					if(!sel_id) return;
					$(".term-course").removeClass("ui-state-highlight");
					$("input[name*=mid][value="+sel_id+"]", ui.panel).parent(".term-course").addClass("ui-state-highlight");
				},
				
				show: function(ev, ui) {
					id_match =  ui.tab.href.match(/(\d+)$/);
					if (!id_match) return;

					plan_id = id_match[1];
					$("#portlet-endpoints .portlet-content").load("/plans/" + plan_id + "/endpoints");
					$("#portlet-conflicts .portlet-content").load("/plans/" + plan_id + "/conflicts");
				}
			}).sortable({ items: 'li:not(.tab-newplan)', axis:'x', containment:'parent' }).css("background","none");
		},
		
		portlets: function() {
			$(".portlet-bar").sortable({ axis:'y', handle:'.portlet-header' });

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
		},
		
		search: function() {
			$("#portlet-search form").submit(function() {
				$.post("/courses/search", $(this).serialize(), function(data, status) {
					$("#search_results").html(data);
					$("#search_results .term-course").draggable({ appendTo:'body', helper:'clone', connectToSortable:'.term', zIndex:10 })
						.addClass("ui-widget-content").disableSelection().mousedown(Waterloonatic.course_select);
				});
				return false;
			});
			
			$("#portlet-search .search_clear").click(function() {
				$("#portlet-search :text").val("");
				$("#search_results").html("");
			});
		},
		
		plan: function(root) {
			if (typeof(root) == 'undefined') root = document;

			$(".term-cap", root).addClass("ui-widget-header").disableSelection();
			$(".term-course", root).addClass("ui-widget-content").disableSelection().mousedown(Waterloonatic.course_select);
			$(".term", root).sortable({ items:'.term-course', connectWith:'.term', update: Waterloonatic.update });
		},
		
		actions: function() {
			$("#portlet-actions .action").hover(
				function() { $(this).addClass("ui-state-highlight"); },
				function() {
					if(! $(this).hasClass("ui-state-highlight-persistent"))
						$(this).removeClass("ui-state-highlight");
				}
			).addClass("ui-widget-content").disableSelection();
			
			$(".action-trash").click(function() {
				mid = $(".ui-tabs-panel:not(.ui-tabs-hide) .term-course.ui-state-highlight input[name*=mid]").val();
				$.post("/course_memberships/"+mid, { _method: 'delete' }, Waterloonatic.reload);
			});
			
			$(".action-override").click(function() {
				mid = $(".ui-tabs-panel:not(.ui-tabs-hide) .term-course.ui-state-highlight input[name*=mid]").val();
				$(this).toggleClass("ui-state-highlight-persistent");
				new_override = $(this).hasClass("ui-state-highlight-persistent") ? "true" : "false" ;
				$.post("/course_memberships/"+mid, { _method: 'put', 'course_membership[override]': new_override }, Waterloonatic.reload);
			});
		},
		
		misc_ui: function() {
			$(".ui-state-highlight-persistent").addClass("ui-state-highlight");
		}
	},
	
	reload: function() {
		$(".tabs").tabs('load', $(".tabs").tabs('option', 'selected'));
		$("#portlet-endpoints .portlet-content").load("/plans/" + plan_id + "/endpoints");
		$("#portlet-conflicts .portlet-content").load("/plans/" + plan_id + "/conflicts");
	},
	
	update: function() {
		id_match = $(this).closest("div.ui-tabs-panel").attr("id").match(/(\d+)$/);
		if (!id_match) return;
		plan_id = id_match[1];

		// pushes updated order to the server and asks for update
		// (timeout used since multiple events may be triggered)
		$.doTimeout('push-and-reload-plan-'+plan_id, 50, function() {
			serialized = $(".ui-tabs-panel:not(.ui-tabs-hide) input[name^=terms]").serialize();
			$.post("/plans/"+plan_id+"/course_memberships/reorder", serialized, Waterloonatic.reload);
		});
	},
	
	course_select: function() {
		// highlight
		$(".term-course").removeClass("ui-state-highlight");
		$(this).addClass("ui-state-highlight");
		
		// show course info
		id = $(this).children("input[name*=cid]").val();
		$("#portlet-info .portlet-content").load('/courses/' + id);
		
		// store the ID
		Waterloonatic.selection = $(this).children("input[name*=mid]").val();
		
		// update actions portlet
		override_field = $(this).children("input[name*=override]");
		if (override_field.size() < 1 || override_field.val() == "false") {
			$("#portlet-actions .action-override").removeClass("ui-state-highlight ui-state-highlight-persistent");
		} else {
			$("#portlet-actions .action-override").addClass("ui-state-highlight ui-state-highlight-persistent");
		}
	}
}

// when loaded, do initial setup
$(function() { Waterloonatic.init(); });