$(document).ready(function(){
  $('.parsley-validate').parsley();
  //-initialize the javascript
  App.init();
  App.pageCalendar();

  $('#calendar').fullCalendar('option', 'contentHeight', 450);

  $("#show").click(function(){
    $(".fc-view-container").toggle("slow");
  });
  $('.dropdown-menu').click(function(e) {
      e.stopPropagation();
  });
});
