class window.NotifyAlert
  constructor: (options) ->
    @options = options

  call: ->
    @show(@options)

  show: (options) ->
    elData = {
      text: options.message,
      image: '<i class=\'' + @iconFor(options.type) + '\'></i>'
    }

    defaultOpts = {
      style: 'metro',
      className: options.type,
      globalPosition: options.position,
      showAnimation: 'show',
      showDuration: 0,
      hideDuration: 0,
      autoHide: true,
      clickToHide: true,
      arrowShow: false,
      autoHideDelay: options.autoHideDelay
    }

    opts = $.extend({}, defaultOpts, options)
    $.notify elData, opts
    $('.notifyjs-corner').show()

  iconFor: (type) ->
    switch type
      when 'error'
        icon = 'fa fa-exclamation'
      when 'warning'
        icon = 'fa fa-warning'
      when 'success'
        icon = 'fa fa-check'
      when 'info'
        icon = 'fa fa-question'
      else
        icon = 'fa fa-adjust'
    icon
