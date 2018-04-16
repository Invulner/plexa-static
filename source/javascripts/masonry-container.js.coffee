$ ->
  win = $('.right_col')
  wincontent = $('.right_col > div')
  pagefilter = $('.right_col .page-filter')
  grid = $('.grid-posts')
  loadingData = $('#post-load-data')

  requestUrl = ->
    action = loadingData.attr('data-action')
    if action
      return Routes.user_my_feeds_path() if action == 'msm'
      return Routes.user_saved_news_path() if action == 'saved_news'
      return Routes.user_saved_posts_path() if action == 'saved_posts'
      return Routes.user_rejected_news_path() if action == 'rejected_news'
      return Routes.user_rejected_research_path() if action == 'rejected_research'
      return Routes.user_rejected_posts_path() if action == 'rejected_posts'
      Routes.user_social_magnet_path()

  url = requestUrl()

  window.detectBottom = ->
    if win.scrollTop() >= wincontent.height() - win.height() + pagefilter.height()
      if loadingData.attr('data-last') == 'false'
        $('.ag-post-loading').show()
        loadContent()

  loadContent = ->
    page = parseInt loadingData.attr('data-page')
    order = loadingData.attr('data-order')
    filter = loadingData.attr('data-filter')
    win.off 'scroll', detectBottom
    $.ajax
      url: url + "/?page=#{page}&order=#{order}&#{filter}"
      type: 'GET'
      success: (result) ->
        loadingData.attr('data-page', page + 1)

  showGrid = ->
    grid.addClass('visible')

  grid.imagesLoaded ->
    grid.masonry ->
      itemSelector: '.grid-post-item'

    grid.masonry('layout')

    setTimeout ->
      showGrid()
    , 100

  win.scroll detectBottom
