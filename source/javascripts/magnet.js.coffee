$grid = $('.grid-posts')

showGrid = ->
  $grid.addClass('visible')

$grid.imagesLoaded ->
  $grid.masonry ->
    itemSelector: '.grid-post-item'

  $grid.masonry('layout')

  setTimeout ->
    showGrid()
  , 100
