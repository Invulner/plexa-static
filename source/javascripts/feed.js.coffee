$options = $('.compose__options')
$dropdown = $('.feed-item__dropdown')
if window.location.href.indexOf('/feed.html') > 0
  activeGroup = composeActiveGroup = localStorage.setItem('group', '')
else
  activeGroup = composeActiveGroup = localStorage.getItem('group')

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

  if $list.hasClass 'compose__groups-list'
    composeActiveGroup = $(@).text()


# Go to group feed
$('.feed-filter__list.nav__groups li').on 'click', () ->
  localStorage.setItem('group', $(@).text())
  window.location.href = 'group-feed.html'


# Highlight selected group in compose and sidebar
if activeGroup
  $('.compose__groups-list li').removeClass 'list-item--active'
  $('.feed-filter__list.nav__groups li').removeClass 'list-item--active'

  activeComposeGroupItem = $('.compose__groups-list li').filter (i, item) ->
    $(item).text() == activeGroup
  activeComposeGroupItem.addClass 'list-item--active'

  activeSidebarGroupItem = $('.feed-filter__list.nav__groups li').filter (i, item) ->
    $(item).text() == activeGroup
  activeSidebarGroupItem.addClass 'list-item--active'

  $('.group-strip__title').text activeGroup


# Create post
$postBtn = $('.compose__post-btn')
$postTextarea = $('.compose__textarea')

$postTextarea.on 'input', (e) ->
  val = $(@).val()

  if val.trim().length
    $postBtn.removeAttr 'disabled'
  else
    $postBtn.prop 'disabled', 'disabled'

$postBtn.on 'click', (e) ->
  e.preventDefault()

  message = $postTextarea.val()
  $postTextarea.val('')

  template = "<div class='feed-item feed-item--custom'><div class='feed-item__header'>
                <a class='feed-item__avatar-block' href='/profile.html'>
                </a>
                <div class='feed-item__header-main'>
                  <div class='feed-item__header-row'>
                    <a class='feed-item__author' href='/profile.html'>
                      Plexa Test
                    </a>
                    <a class='feed-item__story-link' href='javascript:void(0)'>
                      <time class='feed-item__time time timeago'>1 min ago</time>
                    </a>
                  </div>
                  <div class='feed-item__header-aux' style='width: calc(100% - 143px);'>
                    <span class='feed-item__label feed-item__label--group'>
                      #{composeActiveGroup}
                    </span>
                    <div class='feed-item__dropdown-wrapper'>
                      <a class='feed-item__dropdown-trigger feed-item__triangle-trigger' href='javascript: void(0)'></a>
                      <div class='feed-item__dropdown feed-item__dropdown--arrow-trigger'>
                        <div class='feed-item__dropdown-section'><a href='javascript:void(0)' class='feed-item__dropdown-link feed-item__edit'><i class='feed-item__dropdown-item-icon glyphicon glyphicon-pencil'></i>
              Edit</a><a href='javascript:void(0)' class='feed-item__dropdown-link feed-item__delete'><i class='feed-item__dropdown-item-icon glyphicon glyphicon-remove-circle'></i>
              Delete</a></div>
                      </div>
                    </div>
                  </div>
                  <span class='feed-item__label feed-item__label--position'>
                    Doctor
                  </span>
                </div>
              </div>
              <div class='feed-item__body'>
                <p class='feed-item__text'>#{message}</p>
              </div>
              <div class='feed-item__comments-region'></div>
              <div class='feed-item__footer share-data'>
                <div class='feed-item__stats'><span class='feed-item__likes icon-like'>
                <span class='feed-item__like'>Like</span>
                <svg>
                  <use xlink:href='#like-icon' xmlns:xlink='http://www.w3.org/1999/xlink'></use>
                </svg>
                <span class='feed-item__like-counter'>0</span>
              </span></div>
                <form class='feed-item__reply-form'><textarea class='feed-item__reply-input' rows='1' placeholder='Type your reply' style='height: 36px;'></textarea>
              <button class='feed-item__reply-btn' type='submit' disabled='disabled'></button></form>
              </div></div>"

  $('.feed-items').prepend template
