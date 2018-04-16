$ ->
  toggleFilledClass = ->
    $('.login-form__input').each (i, input) ->
      if $(input).val().trim()
        $(input).closest('div').addClass('login-form__input--filled')
      else
        $(input).closest('div').removeClass('login-form__input--filled')

  toggleFilledClass()

  $(document).on 'blur input', '.login-form__input', ->
    toggleFilledClass()

  $(document).on 'focus', '.login-form__input', (e) ->
    toggleFilledClass()
    $(e.target).closest('div').addClass('login-form__input--filled')
