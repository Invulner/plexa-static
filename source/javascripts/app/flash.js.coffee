#= require app/notify-metro
#= require app/notify-alert

class window.Flash
  constructor: ->
    @selector = '.flash-message'
    @$wrapper = $(@selector)
    @notifyWrapper = '.notifyjs-wrapper'

  call: ->
    return if @$wrapper.length == 0
    message = @$wrapper.data('message')
    return unless message
    type = @$wrapper.data('type')
    @show(type, message)

  show: (type, message, element=null) ->
    options = { }
    options.type = @typeFor(type)
    options.position = @position()
    options.message = message
    options.element = @element()
    options.autoHideDelay = @autoHideDelay(options)
    library = new NotifyAlert(options)
    library.call()

  removeAndShow: (type, message) ->
    @destroy()
    @show(type, message)

  destroy: ->
    $(@notifyWrapper).trigger 'click'

  typeFor: (val) ->
    switch val
      when 'notice'
        'success'
      when 'alert'
        'warning'
      else
        val

  signedIn: ->
    $('.top_nav .nav_menu').length > 0

  element: ->
    if @signedIn() then $('.top_nav .nav_menu') else null

  position: ->
    'bottom right'

  autoHideDelay: (options) ->
    if options.type == 'success' then 5000 else 10000

$ ->
  window.flashMessage = new Flash()
  flashMessage.call()
