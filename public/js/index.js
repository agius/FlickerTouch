$(window).load(function(){
  load_more = function(e){
    e.preventDefault();
    $.get($('#more').attr('href'), function(data) {
      $('#photos').append(data);
    });
  };
  $('#more').click(load_more);
});