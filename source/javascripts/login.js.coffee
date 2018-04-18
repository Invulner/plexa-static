#= require jquery

$('.login-form__submit-btn').on 'click', (e) ->
  e.preventDefault()

  login = $('.login-form__input--email').val().trim()
  password = $('.login-form__input--password').val().trim()

  if (login.length && password.length)
    if (login == 'patient@mail.com')
      window.location.href = 'feed_patient.html'
    else
      window.location.href = 'feed.html'
