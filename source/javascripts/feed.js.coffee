$options = $('.compose__options')
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

$(document).on 'click', '.feed-item__dropdown-trigger', dropdownToggle

$(document).on 'click', (e) ->
  if !$(e.target).hasClass('feed-item__dropdown-trigger')
    hideDropdown()


# Likes
$(document).on 'click', '.feed-item__likes', ->
  $likeCounter = $(@).find('.feed-item__like-counter')
  likesCount = +$likeCounter.text()

  if $(@).hasClass('feed-item__likes--active')
    $likeCounter.text(--likesCount)
  else
    $likeCounter.text(++likesCount)

  $(@).toggleClass('feed-item__likes--active')


# Filter topic selection
$('.feed-filter .filter-checkbox').on 'change', (e) ->
  id = $(e.target).attr('id')
  checked = $(e.target).is(':checked')
  filters = if localStorage.getItem('filters') then JSON.parse(localStorage.getItem('filters')) else []

  if id != 'allspec'
    $('#allspec').prop 'checked', false
    index = filters.indexOf('allspec')

    if (index > -1)
      filters.splice(index, 1)

    if checked
      filters.push(id)
    else
      index = filters.indexOf(id)

      if (index > -1)
        filters.splice(index, 1)

  else
    $('.feed-filter__list .filter-checkbox').prop 'checked', false

    if checked
      filters = [id]
    else
      filters = []

  localStorage.setItem 'filters', JSON.stringify(filters)

filters = JSON.parse(localStorage.getItem('filters'))

if filters?.length
  $('.feed-filter .filter-checkbox').prop 'checked', false

  filters.map (filter, i) ->
    $(".feed-filter ##{filter}").prop 'checked', true


# Compose tabs
$('.compose__tab').on 'click', () ->
  tab = $(@).attr('data-tab')

  $('.compose__tab').removeClass 'compose__tab--active'
  $(@).addClass 'compose__tab--active'

  $('.compose-tab-content').addClass 'compose-tab-hidden'
  $(".compose__#{tab}").removeClass 'compose-tab-hidden'

$('.compose__section li').on 'click', () ->
  $list = $(@).parents('ul')

  $list.find('li').removeClass 'list-item--active'
  $(@).toggleClass 'list-item--active'


# Go to group feed
$('.feed-filter__list.nav__groups li').on 'click', () ->
  window.location.href = 'group-feed.html'
