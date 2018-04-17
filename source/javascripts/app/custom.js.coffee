# Sidebar
$(document).ready ->
  CURRENT_URL = window.location.href.split('#')[0].split('?')[0]
  $BODY = $('body')
  $MENU_TOGGLE = $('#menu-toggle')
  $SIDEBAR_MENU = $('#sidebar-menu')
  $SIDEBAR_FOOTER = $('.sidebar-footer')
  $LEFT_COL = $('.left_col')
  $RIGHT_COL = $('.right_col')
  $NAV_MENU = $('.nav_menu')
  $FOOTER = $('footer')
  # TODO: This is some kind of easy fix, maybe we can improve this

  $('.nav-sm .side-menu > .active').addClass('current-item').removeClass('active').find('ul').hide()

  $SIDEBAR_MENU.find('a').on 'click', (ev) ->
    $link = $(@)
    return if $link.hasClass('new-post')
    $li = $link.parent()
    if $li.is('.active')
      $li.removeClass 'active active-sm'
    else
      if $('.side-menu > .active').length && $('.nav-sm').length
        $('.side-menu > .active').removeClass 'active active-sm'

  # toggle small or large menu
  $('#menu-toggle').on 'click', ->
    if $BODY.hasClass('nav-md')
      $('.side-menu > .active').each ->
        if $(@).children('a').attr('href')
          $(@).addClass('current-item')
        else
          $('.side-menu li .active').closest('.side-menu > li').addClass('current-item')

      $SIDEBAR_MENU.find('li.active ul').hide()
      $('.side-menu > .active').removeClass('active')
      localStorage.setItem('small_menu', true)
    else
      $SIDEBAR_MENU.find('li.active-sm ul').show()
      $('.current-item').addClass('active').removeClass('current-item').find('ul').show()
      $SIDEBAR_MENU.find('li.active-sm').addClass('active').removeClass 'active-sm'
      localStorage.setItem('small_menu', false)

    $BODY.toggleClass 'nav-md nav-sm'
    $('.grid-posts').masonry()

  # fixed sidebar
  if $.fn.mCustomScrollbar
    $('.menu_fixed').mCustomScrollbar
      autoHideScrollbar: true
      theme: 'minimal'
      mouseWheel: preventDefault: true
