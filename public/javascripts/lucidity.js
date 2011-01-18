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
        term_id = $(this).attr("data-term-id");
        cm_element = $(event.toElement).closest(".course");
        course_id = cm_element.attr("data-course-id");
        new_elem = $(this).find(".course[data-course-id='"+course_id+"']:not([data-cm-id])");
        if (new_elem.length == 0) new_elem = cm_element;
        console.log(new_elem);
        console.log({ 'course_membership[course_id]': course_id });
        $.ajax({
          type: 'POST',
          url: '/terms/' + term_id + '/course_memberships.json',
          data: { 'course_membership[term_id]': term_id, 'course_membership[course_id]': course_id },
          success: function(data, status, xhr) {
            if (new_elem.length > 0)
              
            new_elem.attr("data-cm-id", data.course_membership.course_membership.id);
            console.log("CM ID: " + new_elem.attr("data-cm-id"));
            console.log(event, ui);
            Lucidity.processConflicts(data.conflicts);
          },
          error: function(xhr, status, err) { alert("An error has occurred."); }
        });
      },
      
      // destroy a course membership when a course is removed
      remove: function(event, ui) {
        cm_id = $(event.toElement).closest(".course").attr("data-cm-id");
        if(cm_id === undefined) return;
        term_id = $(this).attr("data-term-id");
        
        $.ajax({
          type: 'POST',
          url: '/terms/' + term_id + '/course_memberships/' + cm_id + '.json',
          data: { '_method':'DELETE' },
          success: function(data, status, xhr) {
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
    
    $(".term .course").live("dblclick", function() {
      cm_id = $(this).attr("data-cm-id");
      term_id = $(this).closest(".term").attr("data-term-id");
      Lucidity.dialog.show('/terms/' + term_id + '/course_memberships/' + cm_id + '/edit');
    });
    
    var clearCourseInfoTimeout;
    $(".course").live("mouseover", function() {
      clearTimeout(clearCourseInfoTimeout);
      course_id = $(this).attr("data-course-id");
      $(".courseinfo div").load('/courses/' + course_id, function() { $(this).slideDown(200); });
    }).live("mouseout", function() {
      clearCourseInfoTimeout = setTimeout(function() { $(".courseinfo div").slideUp(200); }, 300);
    });
    $(".courseinfo div").slideUp();
  },
  
  processConflicts: function(conflicts) {
    noconflict = $(".course:not(.conflict)");
    conflicted = $(".course.conflict");
    $(".course").removeClass("conflict");
    
    for (i in conflicts) {
      conflict = conflicts[i];
      element = $(".term[data-term-id=" + conflict.term_id + "] .course[data-course-id=" + conflict.course_id + "]");
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
        $(".search .course").draggable({ helper:'clone', connectToSortable:'.term' })
                            .disableSelection()
                            .each(function() { $(this).attr("title", this.innerText); });
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
