# Masonry
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


# share modal
shareType = localStorage.getItem('magnet-type')
$('.share-modal').addClass('share-modal--' + shareType)

$('.new-post-modal__btn').on 'click', (event) ->
  event.preventDefault()
  event.stopPropagation()

  flashMessage.show('success', "Post 'Title' successfully posted to Twitter/Facebook/Linkedin.")
