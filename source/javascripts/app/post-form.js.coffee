window.currentUserTimezone = "Australia/Sydney"
moment.tz.setDefault(currentUserTimezone)

class window.PostForm
  ERROR_CLASS: 'error'
  VISIBILITY_CLASS: 'visible'
  HIDDEN_CLASS: 'hidden'
  MINUTES_INTERVAL: 30

  constructor: (@modal) ->
    @._init()
    @._addEventListeners()

  _init: ->
    @._initUI()
    @._initData()
    @._initComponents()

  _initUI: ->
    @ui = {}
    @ui.$form = $('#new-post')
    @ui.$postBtn = $('.new-post-modal__btn.submit')
    @ui.$contentBlock = $('.accordion__item--content')
    @ui.$scheduleBlock = $('.accordion__item--schedule')
    @ui.$contentTextarea = $('#new-post-modal__content')
    @ui.$contentCounter = $('#new-post-modal__counter')
    @ui.$accountCheckboxes = @ui.$form.find('.new-post-modal__account-checkbox')
    @ui.$dateInput = $('#new-post-modal__date')
    @ui.$timeInput = $('#new-post-modal__time')
    @ui.$times_list = ''
    @ui.$timeColumn = $('.new-post-modal__schedule-column--time')
    @ui.$validationBlock = $('.new-post-modal__validation-status')
    @ui.$uploadBtn = $('.new-post-modal__upload-btn')
    @ui.$bannerBtn = $('.new-post-modal__banner-btn')
    @ui.$fileUploader = $('#fileupload')
    @ui.$postImg = $('.new-post-modal__img')
    @ui.$removeImgBtn = $('.destroy-image')
    @ui.$editBannerBtn = $('.edit-banner')
    @ui.$gallery = $('.gallery-wrapper')
    @ui.$imageIds = $('.img-ids')
    @ui.$maxFileSize = $('.max-size')
    @ui.twitterIcon = '.new-post-modal__social-icon--twitter'
    @ui.linkWrapper = '#link-wrapper'
    @ui.linkTitle = '#link-wrapper .post-content__title'
    @ui.linkDescription = '#link-wrapper .post-content p:last'
    @ui.linkDelete = '#link-wrapper #delete-link'
    @ui.linkSpinner = '#link-spinner'
    @ui.scheduleWrapper = '#schedule'
    @ui.datePicker = '#datepicker'
    @ui.datePickerWidget = '.bootstrap-datetimepicker-widget'
    @ui.datePickerArea = '#datepicker, #new-post-modal__date'
    @ui.modal = @modal.selector
    @ui.validationMessages =
      $all: $('.new-post-modal__validation-msg')
      $content: $('.new-post-modal__validation-msg--type-message')
      $date: $('.new-post-modal__validation-msg--choose-date')
      $account: $('.new-post-modal__validation-msg--choose-account')
      $image: $('.new-post-modal__validation-msg--image-error')

  _initData: ->
    @data = {}
    @data.isFormSubmitted = false

  _initComponents: ->
    @._initDatepicker()
    @._generateDays()
    @._generateTime()
    @._filterTimeOptions()
    @._onDateUpdate()
    @highlightTextarea = new PostTextArea(@)
    @crawlLink = new OpenGraphCrawler(@)

  _initDatepicker: ->
    $(@ui.scheduleWrapper).one 'shown.bs.collapse', =>
      $(@ui.datePicker).datetimepicker
        format: 'DD/MM/YYYY'
        minDate: moment.tz(currentUserTimezone).startOf('day')

      $(@ui.datePicker).on 'dp.change', (e) =>
        @._onDatePickerUpdate(e)
        @._onDateUpdate()

      $(@ui.datePicker).on 'dp.hide', (e) =>
        text = $(@ui.$dateInput).find('option:selected').text()
        return unless text == 'Other date...'
        date = @._datepicker().date()
        formattedDate = date.format('DD/MM/YYYY')
        $(@ui.$dateInput).val(formattedDate)

      $(@ui.modal).on 'click', (e) =>
        datepicker_visible = $(@ui.datePickerWidget).length > 0
        outside_of_datepicker = $(e.target).closest(@ui.datePickerArea).length == 0
        if datepicker_visible and outside_of_datepicker
          currentDate = @._datepicker().date().format('DD/MM/YYYY')
          @ui.$dateInput.val(currentDate)
          @._hideDatepicker()

  _onDatePickerUpdate: (e)->
    date = e.date.format('DD/MM/YYYY')
    selected = @ui.$dateInput.data('selected') == date
    date_exists = $(@ui.$dateInput).find("option[value='#{date}']").length > 0

    $option = $("<option value=\"#{date}\" selected>#{date}</option>")
    $option.prop('selected', selected)
    @ui.$dateInput.append($option) unless date_exists

    @._sortDates()
    @ui.$dateInput.val(date)

  _sortDates: ->
    selected =  @ui.$dateInput.find('option:selected').val()
    options = @ui.$dateInput.find('option:gt(1)')
    arr = options.map((_, o) ->
      {
        t: $(o).text()
        v: moment.tz(o.value, 'DD/MM/YYYY', currentUserTimezone)
      }
    ).get()

    arr.sort (o1, o2) ->
      return (o1.v).diff(o2.v)

    for x of arr
      if arr[x].t == 'Other date...' then arr.push(arr.splice(x, 1)[0]) else 0

    options.each (i, o) ->
      o.value = arr[i].v.format('DD/MM/YYYY')
      $(o).text arr[i].t

    @ui.$dateInput.val(selected)

  _showDatepicker: ->
    @._datepicker().show()

  _datepicker: ->
    $(@ui.datePicker).data("DateTimePicker")

  _hideDatepicker: ->
    @._datepicker().hide()

  _onCustomDateUpdate: ->
    text = $(@ui.$dateInput).find('option:selected').text()
    if text == 'Other date...'
      @._showDatepicker()
    else
      return unless @._datepicker()
      date = $(@ui.$dateInput).find('option:selected').val()
      val = moment.tz(date, 'DD/MM/YYYY', currentUserTimezone)
      @._datepicker().date(val)

  _addEventListeners: ->
    @ui.$postBtn.on 'click', (event) =>
      event.preventDefault()
      @._submitForm()

    @ui.$contentTextarea.on   'input', =>
      if @data.isFormSubmitted
        @._toggleContentValidation()
        @._toggleValidationErrors()

    @ui.$accountCheckboxes.on 'change', =>
      if @data.isFormSubmitted
        @._toggleAccountValidation()
        @._toggleValidationErrors()

    @ui.$dateInput.on 'change', =>
      @._onCustomDateUpdate()
      @._onDateUpdate()

      if @data.isFormSubmitted
        @._toggleValidationErrors()

    @ui.$uploadBtn.on 'click', (e) =>
      e.preventDefault()
      @ui.$fileUploader.trigger('click')
      @._showRemoveImgBtn()

    @ui.$bannerBtn.on 'click', (e) =>
      e.preventDefault()

      @._openBannerBuilder()
      @._showRemoveImgBtn()

    @ui.$editBannerBtn.on 'click', (e) =>
      e.preventDefault()
      @._openBannerBuilder()

    @ui.$removeImgBtn.on 'click', =>
      @.removeImage()

  _isContentValid: ->
    return true unless @ui.$contentTextarea.hasClass('required')
    @ui.$contentTextarea.val().trim().length > 0

  _isSocialAccountSelected: ->
    @ui.$accountCheckboxes.filter(':checked').length > 0

  _isFormValid: ->
    @._isContentValid() && @._isSocialAccountSelected()

  _toggleAccountValidation: ->
    @ui.validationMessages.$account.toggle(!@._isSocialAccountSelected())
    @ui.$contentBlock.toggleClass(@ERROR_CLASS, !@._isSocialAccountSelected())

  _toggleContentValidation: ->
    @ui.validationMessages.$content.toggle(!@._isContentValid())
    @ui.$contentBlock.toggleClass(@ERROR_CLASS, !@._isContentValid())

  _toggleValidationErrors: ->
    @toggleImageValidation()
    if @._isFormValid() then @._hideValidationErrors() else @._showValidationErrors()

  _hideValidationErrors: ->
    @ui.$validationBlock.removeClass @VISIBILITY_CLASS
    @ui.validationMessages.$all.hide()

  _showValidationErrors: ->
    @ui.$validationBlock.addClass @VISIBILITY_CLASS
    @._toggleAccountValidation()
    @._toggleContentValidation()

  _showRemoveImgBtn: ->
    @ui.$removeImgBtn.removeClass @HIDDEN_CLASS

  toggleImageValidation: (error='') ->
    show = if error.length > 0 then true else false
    @ui.$validationBlock.toggleClass @VISIBILITY_CLASS, show
    @ui.validationMessages.$image.text(error).toggle(show)
    @ui.$contentBlock.toggleClass(@ERROR_CLASS, show)

  _submitForm: ->
    @data.isFormSubmitted = true
    if @._isFormValid()
      @._hideValidationErrors()
      @ui.$form.submit()
      @modal.modal('hide')
    else
      @._showValidationErrors()

  showImage: ->
    file = @ui.$fileUploader[0].files[0]
    return unless file
    fileReader = new FileReader()
    fileReader.onload = (e) =>
      @ui.$postImg.attr 'src', e.target.result
      @ui.$gallery.removeClass @HIDDEN_CLASS
      @ui.$editBannerBtn.addClass @HIDDEN_CLASS
      @.toggleImageSpinner(false)
    fileReader.readAsDataURL(file)

  toggleImageSpinner: (show) ->
    @ui.$uploadBtn.toggleClass 'new-post-modal__upload-btn--loading', show

  removeImage: ->
    @ui.$postImg.attr 'src', ''
    @ui.$gallery.addClass(@HIDDEN_CLASS)
    @ui.$editBannerBtn.removeAttr('data')
    @ui.$imageIds.val('')
    @toggleTextAreaCounter(false)

  setImageId: (id) ->
    @ui.$form.find('.destroy-image').data('id', id)
    @ui.$imageIds.val(id)

  rebindFileUploader: ->
    @ui.$fileUploader = $('#fileupload')

  _onDateUpdate: ->
    chosenDate = @._getChosenDate()
    if @._isScheduledDate()
      @._showScheduleButton()
      @._showTimeColumn()
    else
      @._showPostButton()
      @._hideTimeColumn()

    if @._isTodayDate(chosenDate) && @._isScheduledDate()
      @._filterTimeOptions()
    else
      @._resetTimeOptions()

  _getChosenDate: ->
    moment.tz(@ui.$dateInput.val(), 'DD/MM/YYYY', currentUserTimezone)

  _isScheduledDate: ->
    @ui.$dateInput.prop('selectedIndex') > 0

  _isTodayDate: (chosenDate) ->
    chosenDate.isSame(moment.tz(currentUserTimezone), 'day')

  _showScheduleButton: ->
    @ui.$postBtn.val 'Schedule Post'

  _showPostButton: ->
    @ui.$postBtn.val 'Post Now'

  _generateDays: ->
    @ui.$dateInput.append("<option value='' selected>Now</option>")
    dates = []
    date = moment.tz(currentUserTimezone).subtract(1, 'day')
    for i in [0..6]
      formattedDate = date.add(1, 'day').format('DD/MM/YYYY')
      dates.push(formattedDate)
      @._renderDateOption(formattedDate)
    @._renderCustomDateOption()
    selected = @ui.$dateInput.data('selected')
    if selected? && dates.indexOf(selected) == -1
      @._renderDateOption(selected)
    @._sortDates()

  _generateTime: ->
    selected = moment.tz(@ui.$timeInput.data('selected'), 'hh:mm A', currentUserTimezone)
    currentTime = moment.tz(currentUserTimezone).startOf('day')
    itemsCount = 24 * 60 / @MINUTES_INTERVAL
    for [1..itemsCount]
      @._renderTimeOption(currentTime.format('hh:mm A'))
      nextTime = moment(currentTime).add(@MINUTES_INTERVAL, 'minutes')
      if selected.isBetween(currentTime, nextTime, 'minutes')
        @._renderTimeOption(selected.format('hh:mm A'))
      currentTime.add(@MINUTES_INTERVAL, 'minutes')

    @ui.$times_list = @ui.$timeInput.clone()

  _filterTimeOptions: ->
    currentTime = moment.tz(currentUserTimezone)
    dateVal = @ui.$dateInput.val()
    @ui.$timeInput.find('option').filter( ->
      optionTime = moment.tz("#{dateVal} #{$(@).val()}", 'DD/MM/YYYY hh:mm A', currentUserTimezone)
      optionTime.isBefore(currentTime)
    ).remove()
    @ui.$timeInput.val('')
    @._selectDefaultTime()

  _resetTimeOptions: ->
    @ui.$timeInput.html(@ui.$times_list.html())
    @._selectDefaultTime()

  _selectDefaultTime: ->
    selected = @ui.$timeInput.data('selected')
    if !!selected
      @ui.$timeInput.find("option[value='#{selected}']").prop('selected', true)
    else if @ui.$timeInput.prop('selectedIndex') < 0
      @ui.$timeInput.find('option:not(.hidden)').first().prop 'selected', true

  _renderTimeOption: (time) ->
    @ui.$timeInput.append("<option value='#{time}'>#{time}</option>")

  _renderDateOption: (date) ->
    selected = @ui.$dateInput.data('selected') == date
    today = moment.tz(currentUserTimezone).format('DD/MM/YYYY')
    title = if today == date then 'Today' else date
    $option = $("<option value=\"#{date}\">#{title}</option>")
    $option.prop('selected', selected)
    @ui.$dateInput.append($option)

  _renderCustomDateOption: ->
    $option = $("<option value=\"\">Other date...</option>")
    @ui.$dateInput.append($option)

  _showTimeColumn: ->
    @ui.$timeColumn.show()
    @ui.$timeInput.prop('disabled', false)

  _hideTimeColumn: ->
    @ui.$timeColumn.hide()
    @ui.$timeInput.prop('disabled', true)

  _openBannerBuilder: ->
    @_fillBannerModal()

  _fillBannerModal: ->
    $.ajax(url: '/user/banner_builder').done (data) =>
      $('.banner-modal__body').html(data)

  displayBanner: (url, bannerData) ->
    @ui.$postImg.attr 'src', url
    @ui.$gallery.removeClass @HIDDEN_CLASS
    @ui.$editBannerBtn.removeClass @HIDDEN_CLASS
    @ui.$editBannerBtn.attr 'data', bannerData
    @rebindFileUploader()
    @toggleTextAreaCounter(true)

  hasTwitterPages: ->
    checkbox = ".#{$(@ui.$accountCheckboxes).attr('class')}"
    form = "##{$(this.ui.$form).attr('id')}"
    $("#{form} #{@ui.twitterIcon} ~ label #{checkbox}:checked").length > 0

  toggleTextAreaCounter: (images_exists) ->
    if images_exists
      $(@ui.$contentCounter).addClass('top')
      @ui.$contentCounter.insertBefore(@ui.$gallery)
    else
      $(@ui.$contentCounter).removeClass('top')
      @ui.$contentCounter.insertAfter(@ui.$bannerBtn)

  _linkExists: ->
    !$(@ui.linkWrapper).hasClass('hidden')

class PostTextArea
  constructor: (@form) ->
    @$textarea = @form.ui.$contentTextarea
    @$counter = @form.ui.$contentCounter
    @length = @$counter.data('length')
    @minLength = @$counter.data('min-length')
    @$checkbox = @form.ui.$accountCheckboxes
    @._init()

  _init: ->
    @._onPageChange()
    @$checkbox.trigger('change') if @form.hasTwitterPages()

  _onPageChange: ->
    @$checkbox.on 'change', =>
      if @form.hasTwitterPages() then @._initAll() else @._hide()

  _hide: ->
    highlighter = @$textarea.data('hwt')
    highlighter.destroy() if highlighter
    @$counter.addClass('hidden')

  _initAll: ->
    @._hightlight()
    @._showCounter()
    @$counter.removeClass('hidden')
    @._highlightText @$textarea.val()

  _hightlight: ->
    $('.modal textarea').highlightWithinTextarea (input) =>
      if input.length >= @length then [ [@length, null] ] else []

  _autoHeight: ->
    el = @$textarea[0]
    calcHeight = ->
      el.style.cssText = 'height:auto; padding:0'
      el.style.cssText = 'height:' + el.scrollHeight + 'px'

    setTimeout(->
      calcHeight()
    , 300)

    @$textarea.on 'input', ->
      calcHeight()

  _showCounter: ->
    @$textarea.on 'input', (e) =>
      @._highlightText $(e.currentTarget).val()

  _highlightText: (val) ->
    currentCount = val.length
    counter = @length - currentCount
    @$counter.text(counter)
    isRed = counter <= @minLength
    @._highlightCounter(isRed)

  _highlightCounter: (show) ->
     @$counter.toggleClass('red', show)

class OpenGraphCrawler
  constructor: (@form) ->
    @textarea = @form.ui.$contentTextarea
    @linkWrapper = @form.ui.linkWrapper
    @title = @form.ui.linkTitle
    @description = @form.ui.linkDescription
    @deleteLink = @form.ui.linkDelete
    @spinner = @form.ui.linkSpinner
    @form_ui = @form.ui.$form
    @._init()

  _init: ->
    return unless @._isNewPost()
    val = $(@textarea).val()
    @._crawlUrl(@textarea) if @._urlIsValid(val)

    $(@textarea).on 'input', (e) =>
      clearTimeout(window.fieldTimeout) if window.fieldTimeout?
      window.fieldTimeout = setTimeout(
        => @._crawlUrl($(e.currentTarget))
      , 1000)

    @._onDelete()

  _isNewPost: ->
    $(@form_ui).hasClass('post-form')

  _onDelete: ->
    $(@deleteLink).click =>
      @._clear()

  _crawlUrl: (textarea) ->
    val = $(textarea).val()
    if !val and !$(@linkWrapper).hasClass('hidden')
      @._clear()
    if @._urlIsValid(val)
      url = @._urlFor(val)
      return if $(@textarea).data('url') == url

      @._clear()
      @._toggleSpinner(false)
      data = { url: url  }
      $.get('/user/articles/fetch', data)
        .done((res) =>
          @._fillData(res, url)
        ).always((res) =>
          $(@textarea).data('url', url)
          @._toggleSpinner(true)
        )

  _toggleSpinner: (show) ->
    $(@spinner).toggleClass('hidden', show)

  _urlIsValid: (val) ->
    return false unless val
    val.match(@._urlRegexp())

  _urlFor: (val) ->
    val.match(@._urlRegexp()).pop()

  _urlRegexp: ->
    /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig

  _clear: ->
    @._toggle(true)
    @form.ui.$gallery.addClass @form.HIDDEN_CLASS
    $(@title).text()
    $(@description).text()
    $(@textarea).data('url', null)
    @form.ui.$postImg.attr 'src', null
    @form.toggleTextAreaCounter(false)
    @form.rebindFileUploader()

  _fillData: (data, val) ->
    $(@title).text(data.title)
    $(@description).text(data.description)

    @._displayImage(data)
    @._toggle(false)

  _displayImage: (data) ->
    @form.ui.$removeImgBtn.addClass @form.HIDDEN_CLASS
    @form.ui.$postImg.attr 'src', data.image.url
    @form.ui.$gallery.removeClass @form.HIDDEN_CLASS
    @form.ui.$editBannerBtn.addClass @form.HIDDEN_CLASS
    @form.ui.$editBannerBtn.attr 'data', null
    @form.rebindFileUploader()
    @form.toggleTextAreaCounter(true)

  _toggle: (show) ->
    $(@linkWrapper).toggleClass('hidden', show)
