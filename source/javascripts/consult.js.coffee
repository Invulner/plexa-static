$chatBlock = $('.consult-chat-block')
$chat = $('.consult-chat')
messageShowDelay = 3200
$textarea = $('.consult-form__textarea')
$currentMessage = null
textMessage = ''

scrollChatToBottom = ->
  $chatBlock.animate({scrollTop: $chat.height()})

startChatAnimation = (delay = messageShowDelay) ->
  $currentMessage = $firstInvisibleMessage = $('.consult-chat__item--invisible').first()
  isUserMessage = !$firstInvisibleMessage.hasClass('consult-chat__item--medbot')
  isPauseStep = $firstInvisibleMessage.hasClass('pause-step')
  isSkipStep = $firstInvisibleMessage.hasClass('skip-step')
  isLastStep = $firstInvisibleMessage.is(':last-child')

  callback = if ((isUserMessage || isPauseStep) && !isSkipStep) then null else startChatAnimation
  setTimeout(() =>
    animateMessage($firstInvisibleMessage, callback)
  , delay)

  if isLastStep
    setTimeout ->
      window.location.href = 'loading.html'
    , 2000


animateMessage = (message, callback) =>
  message.removeClass 'consult-chat__item--invisible'
  setTimeout(() =>
    scrollChatToBottom()
    callback?()
  , 20)

startChatAnimation(0)

$('.user-btn').on 'click', (e) =>
  $(e.target).addClass 'active'
  startChatAnimation(0)

$(".consult-form__btn").on 'click', () =>
  textMessage = $textarea.val()
  $message = $("<li class='consult-chat__item consult-chat__item--invisible skip-step'>
                  <div class='consult-chat__message'>
                    #{textMessage}
                  </div>
                  <span class='consult-chat__author'></span>
                  <span class='consult-chat__time'>18:19 pm</span>
                </li>")

  $message.insertAfter($currentMessage)

  startChatAnimation(0)
  $textarea.val('')
