jQuery.fn.extend({
	linkToDialog: function() {
		href = this.attr("href");
		dialog_id = "dialog-" + href.replace(/[^A-Za-z0-9\-_\.]/g, "-");
		
		$("<div>").attr("id", dialog_id).load(href, "", function() {
			$(this).appendTo("body").dialog({
				title: 'Edit Plan', modal: true,
				close: function() { $(this).remove(); }
			});
		});
		
		return false;
	}
});