$(function() {
  $(".course").each(function() { $(this).attr("title", this.innerText); });
  $(".term").sortable({
    connectWith:'.term',
    items:'.course',
    receive: function(event, ui) {
      console.log([$(this).attr("data-id"), event]);
    },
    remove: function(event, ui) { console.log(["remove", event, ui]); }
  }).disableSelection();
  $(".search .course").draggable({ helper:'clone', connectToSortable:'.term' }).disableSelection();
});