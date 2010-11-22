var jQT = new $.jQTouch({
    icon: 'jqtouch.png',
    statusBar: 'black-translucent',
    preloadImages: [
        '/themes/jqt/img/chevron_white.png',
        '/themes/jqt/img/bg_row_select.gif',
        '/themes/jqt/img/back_button_clicked.png',
        '/themes/jqt/img/button_clicked.png'
        ]
});
$(window).load(function(){
  var gallery_page = $('#more').attr('data-page')
  view_img = function(e){
    $('#picture').html('<img src="' + $(e.target).attr('data-photo') + '" />')
    jQT.goTo('#view')
  }
  $('#more_link').click(function(e){
    $.get('/?page=' + (gallery_page + 1), function(data) {
      $(data).each(function(index, elem){ $(elem).click(view_img); $('#photos').append(elem)})
      gallery_page++
    })
  })
  $('.galleryimg').click(view_img)
  $('#search_button').click(function(e){jQT.goTo('#search')})
  
  var search_page = 1
  $('#search_form').submit(function(e){
    e.preventDefault()
    $.get('/search?q=' + $('#search_box').val(), function(data){
      $('#results').empty()
      $(data).each(function(index, elem){ $(elem).click(view_img); $('#results').append(elem)})
    })
  })
  $('#more_results').click(function(e){
    search_page++
    $.get('/search?q=' + $('#search_box').val() + '&page=' + search_page, function(data){
      $(data).each(function(index, elem){ $(elem).click(view_img); $('#results').append(elem)})
    })
  })
});