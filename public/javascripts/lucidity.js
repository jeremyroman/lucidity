Lucidity = {
  init: function() {
    // add tooltips to courses
    $(".course").each(function() { $(this).attr("title", this.innerText); });
    
    $(".term").sortable({
      connectWith:'.term,.trash',
      items:'.course',
      
      // create a new course membership when a course is received
      receive: function(event, ui) {
        me = $(this);
        term_id = $(this).attr("data-id");
        course_id = $(event.toElement).closest(".course").attr("data-id");
        $.ajax({
          type: 'POST',
          url: '/course_memberships.json',
          data: { 'course_membership[term_id]': term_id, 'course_membership[course_id]': course_id },
          success: function(data, status, xhr) {
            console.log([data, status, xhr]);
            Lucidity.processConflicts(data.conflicts);
          },
          error: function(xhr, status, err) { alert("An error has occurred."); }
        });
      },
      
      // destroy a course membership when a course is removed
      remove: function(event, ui) {
        term_id = $(this).attr("data-id");
        course_id = $(event.toElement).closest(".course").attr("data-id");
        console.log(["remove", term_id, course_id, event]);
        $.ajax({
          type: 'POST',
          url: '/course_memberships.json',
          data: { '_method':'DELETE', 'term_id': term_id, 'course_id': course_id },
          success: function(data, status, xhr) {
            console.log([data, status, xhr]);
            Lucidity.processConflicts(data.conflicts);
          },
          error: function(xhr, status, err) { if (xhr.status != 200) alert("An error has occurred. " + xhr.status); }
        });
      }
    }).disableSelection();
    
    // the trash discards things dropped onto it
    $(".trash").sortable({
      items:'.course',
      receive: function(event, ui) {
        $(event.toElement).closest(".course").fadeOut('slow', function() { $(this).remove() });
      }
    });
    
    $(".search form").submit(Lucidity.performSearch);
    //$(".search input").keyup(Lucidity.performSearch);
    
    $(".term .course").dblclick(function() {
      course_id = $(this).attr("data-id");
      term_id = $(this).closest(".term").attr("data-id");
      console.log([course_id, term_id]);
      Lucidity.dialog.show('/course_memberships/edit?course_id=' + course_id + '&term_id=' + term_id);
    });
  },
  
  processConflicts: function(conflicts) {
    noconflict = $(".course:not(.conflict)");
    conflicted = $(".course.conflict");
    $(".course").removeClass("conflict").each(function() { $(this).attr("title", this.innerText); });;
    
    for (i in conflicts) {
      conflict = conflicts[i];
      element = $(".term[data-id=" + conflict.term_id + "] .course[data-id=" + conflict.course_id + "]");
      element.attr("title", element.attr("title") + "\n" + conflict.message)
      element.addClass("conflict");
    }
    
    noconflict.filter(".conflict").effect('highlight', {}, 2000);
    conflicted.filter(":not(.conflict)").stop(false, true);
  },
  
  performSearch: function() {
    query = $(".search form").find("input").val();
    
    if (query == "") {
      $(".search .results").html("");
      return;
    }
    
    $(".search .results").load("/catalogues/1/courses/search?" + $.param({q:query}), undefined,
      function() {
        $(".search .course").draggable({ helper:'clone', connectToSortable:'.term' }).disableSelection();
      });
    return false;
  },
  
  dialog: {
    show: function(path) {
      $.get(path, function(data) {
        $.modal(data, {
          overlayClose: true, minWidth:400, minHeight:300,
          onOpen: function(dialog) {
            dialog.data.find("form").submit(function() {
              $.ajax({
                url: $(this).attr("action"),
                type: $(this).attr("method"),
                data: $(this).serialize(),
                dataType: "json",
                success: function(data) {
                  console.log(data);
                  if (typeof(data.conflicts) == 'object') Lucidity.processConflicts(data.conflicts)
                  Lucidity.dialog.hide();
                }
              });
              return false;
            });
            
            dialog.overlay.fadeIn('fast', function() {
              dialog.container.slideDown('fast', function() { dialog.data.fadeIn('fast'); });
            });
          },
          onClose: function(dialog) {
            dialog.data.fadeOut('fast', function() {
              dialog.container.slideUp('fast', function() {
                dialog.overlay.fadeOut('fast');
                $.modal.close();
              });
            });
          }
        });
      });
    },
    
    hide: function() {
      $.modal.close();
    }
  }
};

$(Lucidity.init);
