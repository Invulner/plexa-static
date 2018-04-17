$ ->
  # Show particles on home page
  $('#landing').particleground
    dotColor: '#d2cebb'
    lineColor: '#d2cebb'
    particleRadius: '2'
    density: '7000'
  # mobile menu toggle
  $('.header__mob-toggle').click (e) ->
    flag = $(@).hasClass('active')
    $('.header__nav').toggleClass 'active', !flag
    $(@).toggleClass 'active', !flag
  $('.dropdown-toggle').dropdown()
  # Show menu after header
  menu = $('#main__nav')
  $(window).scroll (e) ->
  #more then or equals to
    if $(window).scrollTop() >= 200
      menu.addClass 'fixie'
  #less then 200px from top
    else
      menu.removeClass 'fixie'

  $(document).ready ->
    grid = $('.grid-posts')
    grid.imagesLoaded ->
      grid.masonry ->
        { itemSelector: '.grid-post-item' }
    hash = window.location.hash
    if hash
      slicedhash = hash.slice(0, hash.indexOf('-'))
      $('ul.nav a[href="' + slicedhash + '"]').tab 'show'
    $('.nav-tabs a').click (e) ->
      window.location.hash = @hash + '-tab'

  $(window).load ->
    $('.group__desc').show()

  currentPage = window.location.pathname
  $('#menu-main-navigation li').each (i, el) ->
    if $(el).find('a').attr('href') == currentPage
      $(el).addClass('active')
  headerHeight = $('header').height()

  $(document).on 'click', '.hero__nav-link', (e) ->
    e.preventDefault()

    $('.hero__nav-link').removeClass('hero__nav-link--active')
    $(e.target).addClass('hero__nav-link--active')

    targetId = $(e.target).attr('href')
    $targetSection = $(targetId)
    $targetTopOffset = $targetSection.offset().top

    console.log(targetId)
    console.log($targetTopOffset)
    console.log(headerHeight)

    $('html, body').animate(
      scrollTop: $targetTopOffset - headerHeight
    , 400);

  $(window).on 'scroll', (e) ->
    winScrollTop = $(window).scrollTop()
    navHeight = $('.hero__nav').height()
    navOffsetTop = $('#landing').height() - navHeight

    if winScrollTop  > navOffsetTop
      $('.hero__nav').addClass('hero__nav--fixed')
    else
      $('.hero__nav').removeClass('hero__nav--fixed')
