$('.login-form__submit-btn').on 'click', (e) ->
  e.preventDefault()

  login = $('.login-form__input--email').val().trim()
  password = $('.login-form__input--password').val().trim()

  if (login.length && password.length)
    if (login == 'patient@mail.com')
      localStorage.setItem('user_type', 'patient')
    else
      localStorage.setItem('user_type', 'doctor')

    window.location.href = 'feed.html'

$('.logout-link').on 'click', (e) ->
  e.preventDefault()

  localStorage.removeItem('user_type')
  window.location.href = 'sign_in.html'
