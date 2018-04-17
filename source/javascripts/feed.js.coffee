$options = $('.compose__options')
$dropdownTrigger = $('.feed-item__dropdown-trigger')
$dropdown = $('.feed-item__dropdown')

# Compose textarea
$('.compose__textarea').on 'focus', (event) ->
  event.stopPropagation()
  $options.slideDown()

$(document).on 'click', (event) ->
  return if $(event.target).hasClass('compose__textarea')
  return if $(event.target).parents('.compose__options').length

  event.stopPropagation()
  $options.slideUp()


# Dropdown
dropdownToggle = (e) ->
  e.stopPropagation()
  $(e.target).next().toggleClass('feed-item__dropdown--visible')

hideDropdown = ->
  $dropdown.removeClass 'feed-item__dropdown--visible'

$(document).on 'click', $dropdownTrigger, dropdownToggle

$(document).on 'click', (e) ->
  if !$(e.target).hasClass('feed-item__dropdown-trigger')
    hideDropdown()
