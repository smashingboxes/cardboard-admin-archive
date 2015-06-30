(($) ->
  if typeof $.fn.each2 == 'undefined'
    $.extend $.fn, each2: (c) ->
      j = $([ 0 ])
      i = -1
      l = @length
      while ++i < l and (j.context = j[0] = @[i]) and c.call(j[0], i, j) != false
              this
  return
) jQuery
(($) ->

  reinsertElement = (element) ->
    placeholder = $(document.createTextNode(''))
    element.before placeholder
    placeholder.before element
    placeholder.remove()
    return

  stripDiacritics = (str) ->
    # Used 'uni range + named function' from http://jsperf.com/diacritics/18

    match = (a) ->
      DIACRITICS[a] or a

    str.replace /[^\u0000-\u007E]/g, match

  indexOf = (value, array) ->
    i = 0
    l = array.length
    while i < l
      if equal(value, array[i])
        return i
      i = i + 1
    -1

  measureScrollbar = ->
    $template = $(MEASURE_SCROLLBAR_TEMPLATE)
    $template.appendTo document.body
    dim = 
      width: $template.width() - ($template[0].clientWidth)
      height: $template.height() - ($template[0].clientHeight)
    $template.remove()
    dim

  ###*
  # Compares equality of a and b
  # @param a
  # @param b
  ###

  equal = (a, b) ->
    if a == b
      return true
    if a == undefined or b == undefined
      return false
    if a == null or b == null
      return false
    # Check whether 'a' or 'b' is a string (primitive or object).
    # The concatenation of an empty string (+'') converts its argument to a string's primitive.
    if a.constructor == String
      return a + '' == b + ''
    # a+'' - in case 'a' is a String object
    if b.constructor == String
      return b + '' == a + ''
    # b+'' - in case 'b' is a String object
    false

  ###*
  # Splits the string into an array of values, transforming each value. An empty array is returned for nulls or empty
  # strings
  # @param string
  # @param separator
  ###

  splitVal = (string, separator, transform) ->
    val = undefined
    i = undefined
    l = undefined
    if string == null or string.length < 1
      return []
    val = string.split(separator)
    i = 0
    l = val.length
    while i < l
      val[i] = transform(val[i])
      i = i + 1
    val

  getSideBorderPadding = (element) ->
    element.outerWidth(false) - element.width()

  installKeyUpChangeEvent = (element) ->
    key = 'keyup-change-value'
    element.on 'keydown', ->
      if $.data(element, key) == undefined
        $.data element, key, element.val()
      return
    element.on 'keyup', ->
      val = $.data(element, key)
      if val != undefined and element.val() != val
        $.removeData element, key
        element.trigger 'keyup-change'
      return
    return

  ###*
  # filters mouse events so an event is fired only if the mouse moved.
  #
  # filters out mouse events that occur when mouse is stationary but
  # the elements under the pointer are scrolled.
  ###

  installFilteredMouseMove = (element) ->
    element.on 'mousemove', (e) ->
      lastpos = lastMousePosition
      if lastpos == undefined or lastpos.x != e.pageX or lastpos.y != e.pageY
        $(e.target).trigger 'mousemove-filtered', e
      return
    return

  ###*
  # Debounces a function. Returns a function that calls the original fn function only if no invocations have been made
  # within the last quietMillis milliseconds.
  #
  # @param quietMillis number of milliseconds to wait before invoking fn
  # @param fn function to be debounced
  # @param ctx object to be used as this reference within fn
  # @return debounced version of fn
  ###

  debounce = (quietMillis, fn, ctx) ->
    ctx = ctx or undefined
    timeout = undefined
    ->
      args = arguments
      window.clearTimeout timeout
      timeout = window.setTimeout((->
        fn.apply ctx, args
        return
      ), quietMillis)
      return

  installDebouncedScroll = (threshold, element) ->
    notify = debounce(threshold, (e) ->
      element.trigger 'scroll-debounced', e
      return
    )
    element.on 'scroll', (e) ->
      if indexOf(e.target, element.get()) >= 0
        notify e
      return
    return

  focus = ($el) ->
    if $el[0] == document.activeElement
      return

    ### set the focus in a 0 timeout - that way the focus is set after the processing
        of the current event has finished - which seems like the only reliable way
        to set focus 
    ###

    window.setTimeout (->
      el = $el[0]
      pos = $el.val().length
      range = undefined
      $el.focus()

      ### make sure el received focus so we do not error out when trying to manipulate the caret.
          sometimes modals or others listeners may steal it after its set 
      ###

      isVisible = el.offsetWidth > 0 or el.offsetHeight > 0
      if isVisible and el == document.activeElement

        ### after the focus is set move the caret to the end, necessary when we val()
            just before setting focus 
        ###

        if el.setSelectionRange
          el.setSelectionRange pos, pos
        else if el.createTextRange
          range = el.createTextRange()
          range.collapse false
          range.select()
      return
    ), 0
    return

  getCursorInfo = (el) ->
    el = $(el)[0]
    offset = 0
    length = 0
    if 'selectionStart' of el
      offset = el.selectionStart
      length = el.selectionEnd - offset
    else if 'selection' of document
      el.focus()
      sel = document.selection.createRange()
      length = document.selection.createRange().text.length
      sel.moveStart 'character', -el.value.length
      offset = sel.text.length - length
    {
      offset: offset
      length: length
    }

  killEvent = (event) ->
    event.preventDefault()
    event.stopPropagation()
    return

  killEventImmediately = (event) ->
    event.preventDefault()
    event.stopImmediatePropagation()
    return

  measureTextWidth = (e) ->
    if !sizer
      style = e[0].currentStyle or window.getComputedStyle(e[0], null)
      sizer = $(document.createElement('div')).css(
        position: 'absolute'
        left: '-10000px'
        top: '-10000px'
        display: 'none'
        fontSize: style.fontSize
        fontFamily: style.fontFamily
        fontStyle: style.fontStyle
        fontWeight: style.fontWeight
        letterSpacing: style.letterSpacing
        textTransform: style.textTransform
        whiteSpace: 'nowrap')
      sizer.attr 'class', 'select2-sizer'
      $(document.body).append sizer
    sizer.text e.val()
    sizer.width()

  syncCssClasses = (dest, src, adapter) ->
    classes = undefined
    replacements = []
    adapted = undefined
    classes = $.trim(dest.attr('class'))
    if classes
      classes = '' + classes
      # for IE which returns object
      $(classes.split(/\s+/)).each2 ->
        if @indexOf('select2-') == 0
          replacements.push this
        return
    classes = $.trim(src.attr('class'))
    if classes
      classes = '' + classes
      # for IE which returns object
      $(classes.split(/\s+/)).each2 ->
        if @indexOf('select2-') != 0
          adapted = adapter(this)
          if adapted
            replacements.push adapted
        return
    dest.attr 'class', replacements.join(' ')
    return

  markMatch = (text, term, markup, escapeMarkup) ->
    match = stripDiacritics(text.toUpperCase()).indexOf(stripDiacritics(term.toUpperCase()))
    tl = term.length
    if match < 0
      markup.push escapeMarkup(text)
      return
    markup.push escapeMarkup(text.substring(0, match))
    markup.push '<span class=\'select2-match\'>'
    markup.push escapeMarkup(text.substring(match, match + tl))
    markup.push '</span>'
    markup.push escapeMarkup(text.substring(match + tl, text.length))
    return

  defaultEscapeMarkup = (markup) ->
    replace_map = 
      '\\': '&#92;'
      '&': '&amp;'
      '<': '&lt;'
      '>': '&gt;'
      '"': '&quot;'
      '\'': '&#39;'
      '/': '&#47;'
    String(markup).replace /[&<>"'\/\\]/g, (match) ->
      replace_map[match]

  ###*
  # Produces an ajax-based query function
  #
  # @param options object containing configuration parameters
  # @param options.params parameter map for the transport ajax call, can contain such options as cache, jsonpCallback, etc. see $.ajax
  # @param options.transport function that will be used to execute the ajax request. must be compatible with parameters supported by $.ajax
  # @param options.url url for the data
  # @param options.data a function(searchTerm, pageNumber, context) that should return an object containing query string parameters for the above url.
  # @param options.dataType request data type: ajax, jsonp, other datatypes supported by jQuery's $.ajax function or the transport function if specified
  # @param options.quietMillis (optional) milliseconds to wait before making the ajaxRequest, helps debounce the ajax function if invoked too often
  # @param options.results a function(remoteData, pageNumber, query) that converts data returned form the remote request to the format expected by Select2.
  #      The expected format is an object containing the following keys:
  #      results array of objects that will be used as choices
  #      more (optional) boolean indicating whether there are more results available
  #      Example: {results:[{id:1, text:'Red'},{id:2, text:'Blue'}], more:true}
  ###

  ajax = (options) ->
    timeout = undefined
    handler = null
    quietMillis = options.quietMillis or 100
    ajaxUrl = options.url
    self = this
    (query) ->
      window.clearTimeout timeout
      timeout = window.setTimeout((->
        data = options.data
        url = ajaxUrl
        transport = options.transport or $.fn.select2.ajaxDefaults.transport
        deprecated = 
          type: options.type or 'GET'
          cache: options.cache or false
          jsonpCallback: options.jsonpCallback or undefined
          dataType: options.dataType or 'json'
        params = $.extend({}, $.fn.select2.ajaxDefaults.params, deprecated)
        data = if data then data.call(self, query.term, query.page, query.context) else null
        url = if typeof url == 'function' then url.call(self, query.term, query.page, query.context) else url
        if handler and typeof handler.abort == 'function'
          handler.abort()
        if options.params
          if $.isFunction(options.params)
            $.extend params, options.params.call(self)
          else
            $.extend params, options.params
        $.extend params,
          url: url
          dataType: options.dataType
          data: data
          success: (data) ->
            # TODO - replace query.page with query so users have access to term, page, etc.
            # added query as third paramter to keep backwards compatibility
            results = options.results(data, query.page, query)
            query.callback results
            return
          error: (jqXHR, textStatus, errorThrown) ->
            results = 
              hasError: true
              jqXHR: jqXHR
              textStatus: textStatus
              errorThrown: errorThrown
            query.callback results
            return
        handler = transport.call(self, params)
        return
      ), quietMillis)
      return

  ###*
  # Produces a query function that works with a local array
  #
  # @param options object containing configuration parameters. The options parameter can either be an array or an
  # object.
  #
  # If the array form is used it is assumed that it contains objects with 'id' and 'text' keys.
  #
  # If the object form is used it is assumed that it contains 'data' and 'text' keys. The 'data' key should contain
  # an array of objects that will be used as choices. These objects must contain at least an 'id' key. The 'text'
  # key can either be a String in which case it is expected that each element in the 'data' array has a key with the
  # value of 'text' which will be used to match choices. Alternatively, text can be a function(item) that can extract
  # the text.
  ###

  local = (options) ->
    data = options
    dataText = undefined
    tmp = undefined

    text = (item) ->
      '' + item.text

    # function used to retrieve the text portion of a data item that is matched against the search
    if $.isArray(data)
      tmp = data
      data = results: tmp
    if $.isFunction(data) == false
      tmp = data

      data = ->
        tmp

    dataItem = data()
    if dataItem.text
      text = dataItem.text
      # if text is not a function we assume it to be a key name
      if !$.isFunction(text)
        dataText = dataItem.text
        # we need to store this in a separate variable because in the next step data gets reset and data.text is no longer available

        text = (item) ->
          item[dataText]

    (query) ->
      t = query.term
      filtered = results: []
      process = undefined
      if t == ''
        query.callback data()
        return

      process = (datum, collection) ->
        group = undefined
        attr = undefined
        datum = datum[0]
        if datum.children
          group = {}
          for attr of datum
            `attr = attr`
            if datum.hasOwnProperty(attr)
              group[attr] = datum[attr]
          group.children = []
          $(datum.children).each2 (i, childDatum) ->
            process childDatum, group.children
            return
          if group.children.length or query.matcher(t, text(group), datum)
            collection.push group
        else
          if query.matcher(t, text(datum), datum)
            collection.push datum
        return

      $(data().results).each2 (i, datum) ->
        process datum, filtered.results
        return
      query.callback filtered
      return

  # TODO javadoc

  tags = (data) ->
    isFunc = $.isFunction(data)
    (query) ->
      t = query.term
      filtered = results: []
      result = if isFunc then data(query) else data
      if $.isArray(result)
        $(result).each ->
          isObject = @text != undefined
          text = if isObject then @text else this
          if t == '' or query.matcher(t, text)
            filtered.results.push if isObject then this else
              id: this
              text: this
          return
        query.callback filtered
      return

  ###*
  # Checks if the formatter function should be used.
  #
  # Throws an error if it is not a function. Returns true if it should be used,
  # false if no formatting should be performed.
  #
  # @param formatter
  ###

  checkFormatter = (formatter, formatterName) ->
    if $.isFunction(formatter)
      return true
    if !formatter
      return false
    if typeof formatter == 'string'
      return true
    throw new Error(formatterName + ' must be a string, function, or falsy value')
    return

  ###*
  # Returns a given value
  # If given a function, returns its output
  #
  # @param val string|function
  # @param context value of "this" to be passed to function
  # @returns {*}
  ###

  evaluate = (val, context) ->
    if $.isFunction(val)
      args = Array::slice.call(arguments, 2)
      return val.apply(context, args)
    val

  countResults = (results) ->
    count = 0
    $.each results, (i, item) ->
      if item.children
        count += countResults(item.children)
      else
        count++
      return
    count

  ###*
  # Default tokenizer. This function uses breaks the input on substring match of any string from the
  # opts.tokenSeparators array and uses opts.createSearchChoice to create the choice object. Both of those
  # two options have to be defined in order for the tokenizer to work.
  #
  # @param input text user has typed so far or pasted into the search field
  # @param selection currently selected choices
  # @param selectCallback function(choice) callback tho add the choice to selection
  # @param opts select2's opts
  # @return undefined/null to leave the current input unchanged, or a string to change the input to the returned value
  ###

  defaultTokenizer = (input, selection, selectCallback, opts) ->
    original = input
    dupe = false
    token = undefined
    index = undefined
    i = undefined
    l = undefined
    separator = undefined
    # the matched separator
    if !opts.createSearchChoice or !opts.tokenSeparators or opts.tokenSeparators.length < 1
      return undefined
    loop
      index = -1
      i = 0
      l = opts.tokenSeparators.length
      while i < l
        separator = opts.tokenSeparators[i]
        index = input.indexOf(separator)
        if index >= 0
          break
        i++
      if index < 0
        break
      # did not find any token separator in the input string, bail
      token = input.substring(0, index)
      input = input.substring(index + separator.length)
      if token.length > 0
        token = opts.createSearchChoice.call(this, token, selection)
        if token != undefined and token != null and opts.id(token) != undefined and opts.id(token) != null
          dupe = false
          i = 0
          l = selection.length
          while i < l
            if equal(opts.id(token), opts.id(selection[i]))
              dupe = true
              break
            i++
          if !dupe
            selectCallback token
    if original != input
      return input
    return

  cleanupJQueryElements = ->
    self = this
    $.each arguments, (i, element) ->
      self[element].remove()
      self[element] = null
      return
    return

  ###*
  # Creates a new class
  #
  # @param superClass
  # @param methods
  ###

  clazz = (SuperClass, methods) ->

    constructor = ->

    constructor.prototype = new SuperClass
    constructor::constructor = constructor
    constructor::parent = SuperClass.prototype
    constructor.prototype = $.extend(constructor.prototype, methods)
    constructor

  'use strict'

  ###global document, window, jQuery, console ###

  if window.Select2 != undefined
    return
  AbstractSelect2 = undefined
  SingleSelect2 = undefined
  MultiSelect2 = undefined
  nextUid = undefined
  sizer = undefined
  lastMousePosition = 
    x: 0
    y: 0
  $document = undefined
  scrollBarDimensions = undefined
  KEY = 
    TAB: 9
    ENTER: 13
    ESC: 27
    SPACE: 32
    LEFT: 37
    UP: 38
    RIGHT: 39
    DOWN: 40
    SHIFT: 16
    CTRL: 17
    ALT: 18
    PAGE_UP: 33
    PAGE_DOWN: 34
    HOME: 36
    END: 35
    BACKSPACE: 8
    DELETE: 46
    isArrow: (k) ->
      k = if k.which then k.which else k
      switch k
        when KEY.LEFT, KEY.RIGHT, KEY.UP, KEY.DOWN
          return true
      false
    isControl: (e) ->
      k = e.which
      switch k
        when KEY.SHIFT, KEY.CTRL, KEY.ALT
          return true
      if e.metaKey
        return true
      false
    isFunctionKey: (k) ->
      k = if k.which then k.which else k
      k >= 112 and k <= 123
  MEASURE_SCROLLBAR_TEMPLATE = '<div class=\'select2-measure-scrollbar\'></div>'
  DIACRITICS = 
    'Ⓐ': 'A'
    'Ａ': 'A'
    'À': 'A'
    'Á': 'A'
    'Â': 'A'
    'Ầ': 'A'
    'Ấ': 'A'
    'Ẫ': 'A'
    'Ẩ': 'A'
    'Ã': 'A'
    'Ā': 'A'
    'Ă': 'A'
    'Ằ': 'A'
    'Ắ': 'A'
    'Ẵ': 'A'
    'Ẳ': 'A'
    'Ȧ': 'A'
    'Ǡ': 'A'
    'Ä': 'A'
    'Ǟ': 'A'
    'Ả': 'A'
    'Å': 'A'
    'Ǻ': 'A'
    'Ǎ': 'A'
    'Ȁ': 'A'
    'Ȃ': 'A'
    'Ạ': 'A'
    'Ậ': 'A'
    'Ặ': 'A'
    'Ḁ': 'A'
    'Ą': 'A'
    'Ⱥ': 'A'
    'Ɐ': 'A'
    'Ꜳ': 'AA'
    'Æ': 'AE'
    'Ǽ': 'AE'
    'Ǣ': 'AE'
    'Ꜵ': 'AO'
    'Ꜷ': 'AU'
    'Ꜹ': 'AV'
    'Ꜻ': 'AV'
    'Ꜽ': 'AY'
    'Ⓑ': 'B'
    'Ｂ': 'B'
    'Ḃ': 'B'
    'Ḅ': 'B'
    'Ḇ': 'B'
    'Ƀ': 'B'
    'Ƃ': 'B'
    'Ɓ': 'B'
    'Ⓒ': 'C'
    'Ｃ': 'C'
    'Ć': 'C'
    'Ĉ': 'C'
    'Ċ': 'C'
    'Č': 'C'
    'Ç': 'C'
    'Ḉ': 'C'
    'Ƈ': 'C'
    'Ȼ': 'C'
    'Ꜿ': 'C'
    'Ⓓ': 'D'
    'Ｄ': 'D'
    'Ḋ': 'D'
    'Ď': 'D'
    'Ḍ': 'D'
    'Ḑ': 'D'
    'Ḓ': 'D'
    'Ḏ': 'D'
    'Đ': 'D'
    'Ƌ': 'D'
    'Ɗ': 'D'
    'Ɖ': 'D'
    'Ꝺ': 'D'
    'Ǳ': 'DZ'
    'Ǆ': 'DZ'
    'ǲ': 'Dz'
    'ǅ': 'Dz'
    'Ⓔ': 'E'
    'Ｅ': 'E'
    'È': 'E'
    'É': 'E'
    'Ê': 'E'
    'Ề': 'E'
    'Ế': 'E'
    'Ễ': 'E'
    'Ể': 'E'
    'Ẽ': 'E'
    'Ē': 'E'
    'Ḕ': 'E'
    'Ḗ': 'E'
    'Ĕ': 'E'
    'Ė': 'E'
    'Ë': 'E'
    'Ẻ': 'E'
    'Ě': 'E'
    'Ȅ': 'E'
    'Ȇ': 'E'
    'Ẹ': 'E'
    'Ệ': 'E'
    'Ȩ': 'E'
    'Ḝ': 'E'
    'Ę': 'E'
    'Ḙ': 'E'
    'Ḛ': 'E'
    'Ɛ': 'E'
    'Ǝ': 'E'
    'Ⓕ': 'F'
    'Ｆ': 'F'
    'Ḟ': 'F'
    'Ƒ': 'F'
    'Ꝼ': 'F'
    'Ⓖ': 'G'
    'Ｇ': 'G'
    'Ǵ': 'G'
    'Ĝ': 'G'
    'Ḡ': 'G'
    'Ğ': 'G'
    'Ġ': 'G'
    'Ǧ': 'G'
    'Ģ': 'G'
    'Ǥ': 'G'
    'Ɠ': 'G'
    'Ꞡ': 'G'
    'Ᵹ': 'G'
    'Ꝿ': 'G'
    'Ⓗ': 'H'
    'Ｈ': 'H'
    'Ĥ': 'H'
    'Ḣ': 'H'
    'Ḧ': 'H'
    'Ȟ': 'H'
    'Ḥ': 'H'
    'Ḩ': 'H'
    'Ḫ': 'H'
    'Ħ': 'H'
    'Ⱨ': 'H'
    'Ⱶ': 'H'
    'Ɥ': 'H'
    'Ⓘ': 'I'
    'Ｉ': 'I'
    'Ì': 'I'
    'Í': 'I'
    'Î': 'I'
    'Ĩ': 'I'
    'Ī': 'I'
    'Ĭ': 'I'
    'İ': 'I'
    'Ï': 'I'
    'Ḯ': 'I'
    'Ỉ': 'I'
    'Ǐ': 'I'
    'Ȉ': 'I'
    'Ȋ': 'I'
    'Ị': 'I'
    'Į': 'I'
    'Ḭ': 'I'
    'Ɨ': 'I'
    'Ⓙ': 'J'
    'Ｊ': 'J'
    'Ĵ': 'J'
    'Ɉ': 'J'
    'Ⓚ': 'K'
    'Ｋ': 'K'
    'Ḱ': 'K'
    'Ǩ': 'K'
    'Ḳ': 'K'
    'Ķ': 'K'
    'Ḵ': 'K'
    'Ƙ': 'K'
    'Ⱪ': 'K'
    'Ꝁ': 'K'
    'Ꝃ': 'K'
    'Ꝅ': 'K'
    'Ꞣ': 'K'
    'Ⓛ': 'L'
    'Ｌ': 'L'
    'Ŀ': 'L'
    'Ĺ': 'L'
    'Ľ': 'L'
    'Ḷ': 'L'
    'Ḹ': 'L'
    'Ļ': 'L'
    'Ḽ': 'L'
    'Ḻ': 'L'
    'Ł': 'L'
    'Ƚ': 'L'
    'Ɫ': 'L'
    'Ⱡ': 'L'
    'Ꝉ': 'L'
    'Ꝇ': 'L'
    'Ꞁ': 'L'
    'Ǉ': 'LJ'
    'ǈ': 'Lj'
    'Ⓜ': 'M'
    'Ｍ': 'M'
    'Ḿ': 'M'
    'Ṁ': 'M'
    'Ṃ': 'M'
    'Ɱ': 'M'
    'Ɯ': 'M'
    'Ⓝ': 'N'
    'Ｎ': 'N'
    'Ǹ': 'N'
    'Ń': 'N'
    'Ñ': 'N'
    'Ṅ': 'N'
    'Ň': 'N'
    'Ṇ': 'N'
    'Ņ': 'N'
    'Ṋ': 'N'
    'Ṉ': 'N'
    'Ƞ': 'N'
    'Ɲ': 'N'
    'Ꞑ': 'N'
    'Ꞥ': 'N'
    'Ǌ': 'NJ'
    'ǋ': 'Nj'
    'Ⓞ': 'O'
    'Ｏ': 'O'
    'Ò': 'O'
    'Ó': 'O'
    'Ô': 'O'
    'Ồ': 'O'
    'Ố': 'O'
    'Ỗ': 'O'
    'Ổ': 'O'
    'Õ': 'O'
    'Ṍ': 'O'
    'Ȭ': 'O'
    'Ṏ': 'O'
    'Ō': 'O'
    'Ṑ': 'O'
    'Ṓ': 'O'
    'Ŏ': 'O'
    'Ȯ': 'O'
    'Ȱ': 'O'
    'Ö': 'O'
    'Ȫ': 'O'
    'Ỏ': 'O'
    'Ő': 'O'
    'Ǒ': 'O'
    'Ȍ': 'O'
    'Ȏ': 'O'
    'Ơ': 'O'
    'Ờ': 'O'
    'Ớ': 'O'
    'Ỡ': 'O'
    'Ở': 'O'
    'Ợ': 'O'
    'Ọ': 'O'
    'Ộ': 'O'
    'Ǫ': 'O'
    'Ǭ': 'O'
    'Ø': 'O'
    'Ǿ': 'O'
    'Ɔ': 'O'
    'Ɵ': 'O'
    'Ꝋ': 'O'
    'Ꝍ': 'O'
    'Ƣ': 'OI'
    'Ꝏ': 'OO'
    'Ȣ': 'OU'
    'Ⓟ': 'P'
    'Ｐ': 'P'
    'Ṕ': 'P'
    'Ṗ': 'P'
    'Ƥ': 'P'
    'Ᵽ': 'P'
    'Ꝑ': 'P'
    'Ꝓ': 'P'
    'Ꝕ': 'P'
    'Ⓠ': 'Q'
    'Ｑ': 'Q'
    'Ꝗ': 'Q'
    'Ꝙ': 'Q'
    'Ɋ': 'Q'
    'Ⓡ': 'R'
    'Ｒ': 'R'
    'Ŕ': 'R'
    'Ṙ': 'R'
    'Ř': 'R'
    'Ȑ': 'R'
    'Ȓ': 'R'
    'Ṛ': 'R'
    'Ṝ': 'R'
    'Ŗ': 'R'
    'Ṟ': 'R'
    'Ɍ': 'R'
    'Ɽ': 'R'
    'Ꝛ': 'R'
    'Ꞧ': 'R'
    'Ꞃ': 'R'
    'Ⓢ': 'S'
    'Ｓ': 'S'
    'ẞ': 'S'
    'Ś': 'S'
    'Ṥ': 'S'
    'Ŝ': 'S'
    'Ṡ': 'S'
    'Š': 'S'
    'Ṧ': 'S'
    'Ṣ': 'S'
    'Ṩ': 'S'
    'Ș': 'S'
    'Ş': 'S'
    'Ȿ': 'S'
    'Ꞩ': 'S'
    'Ꞅ': 'S'
    'Ⓣ': 'T'
    'Ｔ': 'T'
    'Ṫ': 'T'
    'Ť': 'T'
    'Ṭ': 'T'
    'Ț': 'T'
    'Ţ': 'T'
    'Ṱ': 'T'
    'Ṯ': 'T'
    'Ŧ': 'T'
    'Ƭ': 'T'
    'Ʈ': 'T'
    'Ⱦ': 'T'
    'Ꞇ': 'T'
    'Ꜩ': 'TZ'
    'Ⓤ': 'U'
    'Ｕ': 'U'
    'Ù': 'U'
    'Ú': 'U'
    'Û': 'U'
    'Ũ': 'U'
    'Ṹ': 'U'
    'Ū': 'U'
    'Ṻ': 'U'
    'Ŭ': 'U'
    'Ü': 'U'
    'Ǜ': 'U'
    'Ǘ': 'U'
    'Ǖ': 'U'
    'Ǚ': 'U'
    'Ủ': 'U'
    'Ů': 'U'
    'Ű': 'U'
    'Ǔ': 'U'
    'Ȕ': 'U'
    'Ȗ': 'U'
    'Ư': 'U'
    'Ừ': 'U'
    'Ứ': 'U'
    'Ữ': 'U'
    'Ử': 'U'
    'Ự': 'U'
    'Ụ': 'U'
    'Ṳ': 'U'
    'Ų': 'U'
    'Ṷ': 'U'
    'Ṵ': 'U'
    'Ʉ': 'U'
    'Ⓥ': 'V'
    'Ｖ': 'V'
    'Ṽ': 'V'
    'Ṿ': 'V'
    'Ʋ': 'V'
    'Ꝟ': 'V'
    'Ʌ': 'V'
    'Ꝡ': 'VY'
    'Ⓦ': 'W'
    'Ｗ': 'W'
    'Ẁ': 'W'
    'Ẃ': 'W'
    'Ŵ': 'W'
    'Ẇ': 'W'
    'Ẅ': 'W'
    'Ẉ': 'W'
    'Ⱳ': 'W'
    'Ⓧ': 'X'
    'Ｘ': 'X'
    'Ẋ': 'X'
    'Ẍ': 'X'
    'Ⓨ': 'Y'
    'Ｙ': 'Y'
    'Ỳ': 'Y'
    'Ý': 'Y'
    'Ŷ': 'Y'
    'Ỹ': 'Y'
    'Ȳ': 'Y'
    'Ẏ': 'Y'
    'Ÿ': 'Y'
    'Ỷ': 'Y'
    'Ỵ': 'Y'
    'Ƴ': 'Y'
    'Ɏ': 'Y'
    'Ỿ': 'Y'
    'Ⓩ': 'Z'
    'Ｚ': 'Z'
    'Ź': 'Z'
    'Ẑ': 'Z'
    'Ż': 'Z'
    'Ž': 'Z'
    'Ẓ': 'Z'
    'Ẕ': 'Z'
    'Ƶ': 'Z'
    'Ȥ': 'Z'
    'Ɀ': 'Z'
    'Ⱬ': 'Z'
    'Ꝣ': 'Z'
    'ⓐ': 'a'
    'ａ': 'a'
    'ẚ': 'a'
    'à': 'a'
    'á': 'a'
    'â': 'a'
    'ầ': 'a'
    'ấ': 'a'
    'ẫ': 'a'
    'ẩ': 'a'
    'ã': 'a'
    'ā': 'a'
    'ă': 'a'
    'ằ': 'a'
    'ắ': 'a'
    'ẵ': 'a'
    'ẳ': 'a'
    'ȧ': 'a'
    'ǡ': 'a'
    'ä': 'a'
    'ǟ': 'a'
    'ả': 'a'
    'å': 'a'
    'ǻ': 'a'
    'ǎ': 'a'
    'ȁ': 'a'
    'ȃ': 'a'
    'ạ': 'a'
    'ậ': 'a'
    'ặ': 'a'
    'ḁ': 'a'
    'ą': 'a'
    'ⱥ': 'a'
    'ɐ': 'a'
    'ꜳ': 'aa'
    'æ': 'ae'
    'ǽ': 'ae'
    'ǣ': 'ae'
    'ꜵ': 'ao'
    'ꜷ': 'au'
    'ꜹ': 'av'
    'ꜻ': 'av'
    'ꜽ': 'ay'
    'ⓑ': 'b'
    'ｂ': 'b'
    'ḃ': 'b'
    'ḅ': 'b'
    'ḇ': 'b'
    'ƀ': 'b'
    'ƃ': 'b'
    'ɓ': 'b'
    'ⓒ': 'c'
    'ｃ': 'c'
    'ć': 'c'
    'ĉ': 'c'
    'ċ': 'c'
    'č': 'c'
    'ç': 'c'
    'ḉ': 'c'
    'ƈ': 'c'
    'ȼ': 'c'
    'ꜿ': 'c'
    'ↄ': 'c'
    'ⓓ': 'd'
    'ｄ': 'd'
    'ḋ': 'd'
    'ď': 'd'
    'ḍ': 'd'
    'ḑ': 'd'
    'ḓ': 'd'
    'ḏ': 'd'
    'đ': 'd'
    'ƌ': 'd'
    'ɖ': 'd'
    'ɗ': 'd'
    'ꝺ': 'd'
    'ǳ': 'dz'
    'ǆ': 'dz'
    'ⓔ': 'e'
    'ｅ': 'e'
    'è': 'e'
    'é': 'e'
    'ê': 'e'
    'ề': 'e'
    'ế': 'e'
    'ễ': 'e'
    'ể': 'e'
    'ẽ': 'e'
    'ē': 'e'
    'ḕ': 'e'
    'ḗ': 'e'
    'ĕ': 'e'
    'ė': 'e'
    'ë': 'e'
    'ẻ': 'e'
    'ě': 'e'
    'ȅ': 'e'
    'ȇ': 'e'
    'ẹ': 'e'
    'ệ': 'e'
    'ȩ': 'e'
    'ḝ': 'e'
    'ę': 'e'
    'ḙ': 'e'
    'ḛ': 'e'
    'ɇ': 'e'
    'ɛ': 'e'
    'ǝ': 'e'
    'ⓕ': 'f'
    'ｆ': 'f'
    'ḟ': 'f'
    'ƒ': 'f'
    'ꝼ': 'f'
    'ⓖ': 'g'
    'ｇ': 'g'
    'ǵ': 'g'
    'ĝ': 'g'
    'ḡ': 'g'
    'ğ': 'g'
    'ġ': 'g'
    'ǧ': 'g'
    'ģ': 'g'
    'ǥ': 'g'
    'ɠ': 'g'
    'ꞡ': 'g'
    'ᵹ': 'g'
    'ꝿ': 'g'
    'ⓗ': 'h'
    'ｈ': 'h'
    'ĥ': 'h'
    'ḣ': 'h'
    'ḧ': 'h'
    'ȟ': 'h'
    'ḥ': 'h'
    'ḩ': 'h'
    'ḫ': 'h'
    'ẖ': 'h'
    'ħ': 'h'
    'ⱨ': 'h'
    'ⱶ': 'h'
    'ɥ': 'h'
    'ƕ': 'hv'
    'ⓘ': 'i'
    'ｉ': 'i'
    'ì': 'i'
    'í': 'i'
    'î': 'i'
    'ĩ': 'i'
    'ī': 'i'
    'ĭ': 'i'
    'ï': 'i'
    'ḯ': 'i'
    'ỉ': 'i'
    'ǐ': 'i'
    'ȉ': 'i'
    'ȋ': 'i'
    'ị': 'i'
    'į': 'i'
    'ḭ': 'i'
    'ɨ': 'i'
    'ı': 'i'
    'ⓙ': 'j'
    'ｊ': 'j'
    'ĵ': 'j'
    'ǰ': 'j'
    'ɉ': 'j'
    'ⓚ': 'k'
    'ｋ': 'k'
    'ḱ': 'k'
    'ǩ': 'k'
    'ḳ': 'k'
    'ķ': 'k'
    'ḵ': 'k'
    'ƙ': 'k'
    'ⱪ': 'k'
    'ꝁ': 'k'
    'ꝃ': 'k'
    'ꝅ': 'k'
    'ꞣ': 'k'
    'ⓛ': 'l'
    'ｌ': 'l'
    'ŀ': 'l'
    'ĺ': 'l'
    'ľ': 'l'
    'ḷ': 'l'
    'ḹ': 'l'
    'ļ': 'l'
    'ḽ': 'l'
    'ḻ': 'l'
    'ſ': 'l'
    'ł': 'l'
    'ƚ': 'l'
    'ɫ': 'l'
    'ⱡ': 'l'
    'ꝉ': 'l'
    'ꞁ': 'l'
    'ꝇ': 'l'
    'ǉ': 'lj'
    'ⓜ': 'm'
    'ｍ': 'm'
    'ḿ': 'm'
    'ṁ': 'm'
    'ṃ': 'm'
    'ɱ': 'm'
    'ɯ': 'm'
    'ⓝ': 'n'
    'ｎ': 'n'
    'ǹ': 'n'
    'ń': 'n'
    'ñ': 'n'
    'ṅ': 'n'
    'ň': 'n'
    'ṇ': 'n'
    'ņ': 'n'
    'ṋ': 'n'
    'ṉ': 'n'
    'ƞ': 'n'
    'ɲ': 'n'
    'ŉ': 'n'
    'ꞑ': 'n'
    'ꞥ': 'n'
    'ǌ': 'nj'
    'ⓞ': 'o'
    'ｏ': 'o'
    'ò': 'o'
    'ó': 'o'
    'ô': 'o'
    'ồ': 'o'
    'ố': 'o'
    'ỗ': 'o'
    'ổ': 'o'
    'õ': 'o'
    'ṍ': 'o'
    'ȭ': 'o'
    'ṏ': 'o'
    'ō': 'o'
    'ṑ': 'o'
    'ṓ': 'o'
    'ŏ': 'o'
    'ȯ': 'o'
    'ȱ': 'o'
    'ö': 'o'
    'ȫ': 'o'
    'ỏ': 'o'
    'ő': 'o'
    'ǒ': 'o'
    'ȍ': 'o'
    'ȏ': 'o'
    'ơ': 'o'
    'ờ': 'o'
    'ớ': 'o'
    'ỡ': 'o'
    'ở': 'o'
    'ợ': 'o'
    'ọ': 'o'
    'ộ': 'o'
    'ǫ': 'o'
    'ǭ': 'o'
    'ø': 'o'
    'ǿ': 'o'
    'ɔ': 'o'
    'ꝋ': 'o'
    'ꝍ': 'o'
    'ɵ': 'o'
    'ƣ': 'oi'
    'ȣ': 'ou'
    'ꝏ': 'oo'
    'ⓟ': 'p'
    'ｐ': 'p'
    'ṕ': 'p'
    'ṗ': 'p'
    'ƥ': 'p'
    'ᵽ': 'p'
    'ꝑ': 'p'
    'ꝓ': 'p'
    'ꝕ': 'p'
    'ⓠ': 'q'
    'ｑ': 'q'
    'ɋ': 'q'
    'ꝗ': 'q'
    'ꝙ': 'q'
    'ⓡ': 'r'
    'ｒ': 'r'
    'ŕ': 'r'
    'ṙ': 'r'
    'ř': 'r'
    'ȑ': 'r'
    'ȓ': 'r'
    'ṛ': 'r'
    'ṝ': 'r'
    'ŗ': 'r'
    'ṟ': 'r'
    'ɍ': 'r'
    'ɽ': 'r'
    'ꝛ': 'r'
    'ꞧ': 'r'
    'ꞃ': 'r'
    'ⓢ': 's'
    'ｓ': 's'
    'ß': 's'
    'ś': 's'
    'ṥ': 's'
    'ŝ': 's'
    'ṡ': 's'
    'š': 's'
    'ṧ': 's'
    'ṣ': 's'
    'ṩ': 's'
    'ș': 's'
    'ş': 's'
    'ȿ': 's'
    'ꞩ': 's'
    'ꞅ': 's'
    'ẛ': 's'
    'ⓣ': 't'
    'ｔ': 't'
    'ṫ': 't'
    'ẗ': 't'
    'ť': 't'
    'ṭ': 't'
    'ț': 't'
    'ţ': 't'
    'ṱ': 't'
    'ṯ': 't'
    'ŧ': 't'
    'ƭ': 't'
    'ʈ': 't'
    'ⱦ': 't'
    'ꞇ': 't'
    'ꜩ': 'tz'
    'ⓤ': 'u'
    'ｕ': 'u'
    'ù': 'u'
    'ú': 'u'
    'û': 'u'
    'ũ': 'u'
    'ṹ': 'u'
    'ū': 'u'
    'ṻ': 'u'
    'ŭ': 'u'
    'ü': 'u'
    'ǜ': 'u'
    'ǘ': 'u'
    'ǖ': 'u'
    'ǚ': 'u'
    'ủ': 'u'
    'ů': 'u'
    'ű': 'u'
    'ǔ': 'u'
    'ȕ': 'u'
    'ȗ': 'u'
    'ư': 'u'
    'ừ': 'u'
    'ứ': 'u'
    'ữ': 'u'
    'ử': 'u'
    'ự': 'u'
    'ụ': 'u'
    'ṳ': 'u'
    'ų': 'u'
    'ṷ': 'u'
    'ṵ': 'u'
    'ʉ': 'u'
    'ⓥ': 'v'
    'ｖ': 'v'
    'ṽ': 'v'
    'ṿ': 'v'
    'ʋ': 'v'
    'ꝟ': 'v'
    'ʌ': 'v'
    'ꝡ': 'vy'
    'ⓦ': 'w'
    'ｗ': 'w'
    'ẁ': 'w'
    'ẃ': 'w'
    'ŵ': 'w'
    'ẇ': 'w'
    'ẅ': 'w'
    'ẘ': 'w'
    'ẉ': 'w'
    'ⱳ': 'w'
    'ⓧ': 'x'
    'ｘ': 'x'
    'ẋ': 'x'
    'ẍ': 'x'
    'ⓨ': 'y'
    'ｙ': 'y'
    'ỳ': 'y'
    'ý': 'y'
    'ŷ': 'y'
    'ỹ': 'y'
    'ȳ': 'y'
    'ẏ': 'y'
    'ÿ': 'y'
    'ỷ': 'y'
    'ẙ': 'y'
    'ỵ': 'y'
    'ƴ': 'y'
    'ɏ': 'y'
    'ỿ': 'y'
    'ⓩ': 'z'
    'ｚ': 'z'
    'ź': 'z'
    'ẑ': 'z'
    'ż': 'z'
    'ž': 'z'
    'ẓ': 'z'
    'ẕ': 'z'
    'ƶ': 'z'
    'ȥ': 'z'
    'ɀ': 'z'
    'ⱬ': 'z'
    'ꝣ': 'z'
    'Ά': 'Α'
    'Έ': 'Ε'
    'Ή': 'Η'
    'Ί': 'Ι'
    'Ϊ': 'Ι'
    'Ό': 'Ο'
    'Ύ': 'Υ'
    'Ϋ': 'Υ'
    'Ώ': 'Ω'
    'ά': 'α'
    'έ': 'ε'
    'ή': 'η'
    'ί': 'ι'
    'ϊ': 'ι'
    'ΐ': 'ι'
    'ό': 'ο'
    'ύ': 'υ'
    'ϋ': 'υ'
    'ΰ': 'υ'
    'ω': 'ω'
    'ς': 'σ'
  $document = $(document)
  nextUid = do ->
    counter = 1
    ->
      counter++
  AbstractSelect2 = clazz(Object,
    bind: (func) ->
      self = this
      ->
        func.apply self, arguments
        return
    init: (opts) ->
      results = undefined
      search = undefined
      resultsSelector = '.select2-results'
      # prepare options
      @opts = opts = @prepareOpts(opts)
      @id = opts.id
      # destroy if called on an existing component
      if opts.element.data('select2') != undefined and opts.element.data('select2') != null
        opts.element.data('select2').destroy()
      @container = @createContainer()
      @liveRegion = $('.select2-hidden-accessible')
      if @liveRegion.length == 0
        @liveRegion = $('<span>',
          role: 'status'
          'aria-live': 'polite').addClass('select2-hidden-accessible').appendTo(document.body)
      @containerId = 's2id_' + (opts.element.attr('id') or 'autogen' + nextUid())
      @containerEventName = @containerId.replace(/([.])/g, '_').replace(/([;&,\-\.\+\*\~':"\!\^#$%@\[\]\(\)=>\|])/g, '\\$1')
      @container.attr 'id', @containerId
      @container.attr 'title', opts.element.attr('title')
      @body = $(document.body)
      syncCssClasses @container, @opts.element, @opts.adaptContainerCssClass
      @container.attr 'style', opts.element.attr('style')
      @container.css evaluate(opts.containerCss, @opts.element)
      @container.addClass evaluate(opts.containerCssClass, @opts.element)
      @elementTabIndex = @opts.element.attr('tabindex')
      # swap container for the element
      @opts.element.data('select2', this).attr('tabindex', '-1').before(@container).on 'click.select2', killEvent
      # do not leak click events
      @container.data 'select2', this
      @dropdown = @container.find('.select2-drop')
      syncCssClasses @dropdown, @opts.element, @opts.adaptDropdownCssClass
      @dropdown.addClass evaluate(opts.dropdownCssClass, @opts.element)
      @dropdown.data 'select2', this
      @dropdown.on 'click', killEvent
      @results = results = @container.find(resultsSelector)
      @search = search = @container.find('input.select2-input')
      @queryCount = 0
      @resultsPage = 0
      @context = null
      # initialize the container
      @initContainer()
      @container.on 'click', killEvent
      installFilteredMouseMove @results
      @dropdown.on 'mousemove-filtered', resultsSelector, @bind(@highlightUnderEvent)
      @dropdown.on 'touchstart touchmove touchend', resultsSelector, @bind((event) ->
        @_touchEvent = true
        @highlightUnderEvent event
        return
      )
      @dropdown.on 'touchmove', resultsSelector, @bind(@touchMoved)
      @dropdown.on 'touchstart touchend', resultsSelector, @bind(@clearTouchMoved)
      # Waiting for a click event on touch devices to select option and hide dropdown
      # otherwise click will be triggered on an underlying element
      @dropdown.on 'click', @bind((event) ->
        if @_touchEvent
          @_touchEvent = false
          @selectHighlighted()
        return
      )
      installDebouncedScroll 80, @results
      @dropdown.on 'scroll-debounced', resultsSelector, @bind(@loadMoreIfNeeded)
      # do not propagate change event from the search field out of the component
      $(@container).on 'change', '.select2-input', (e) ->
        e.stopPropagation()
        return
      $(@dropdown).on 'change', '.select2-input', (e) ->
        e.stopPropagation()
        return
      # if jquery.mousewheel plugin is installed we can prevent out-of-bounds scrolling of results via mousewheel
      if $.fn.mousewheel
        results.mousewheel (e, delta, deltaX, deltaY) ->
          top = results.scrollTop()
          if deltaY > 0 and top - deltaY <= 0
            results.scrollTop 0
            killEvent e
          else if deltaY < 0 and results.get(0).scrollHeight - results.scrollTop() + deltaY <= results.height()
            results.scrollTop results.get(0).scrollHeight - results.height()
            killEvent e
          return
      installKeyUpChangeEvent search
      search.on 'keyup-change input paste', @bind(@updateResults)
      search.on 'focus', ->
        search.addClass 'select2-focused'
        return
      search.on 'blur', ->
        search.removeClass 'select2-focused'
        return
      @dropdown.on 'mouseup', resultsSelector, @bind((e) ->
        if $(e.target).closest('.select2-result-selectable').length > 0
          @highlightUnderEvent e
          @selectHighlighted e
        return
      )
      # trap all mouse events from leaving the dropdown. sometimes there may be a modal that is listening
      # for mouse events outside of itself so it can close itself. since the dropdown is now outside the select2's
      # dom it will trigger the popup close, which is not what we want
      # focusin can cause focus wars between modals and select2 since the dropdown is outside the modal.
      @dropdown.on 'click mouseup mousedown touchstart touchend focusin', (e) ->
        e.stopPropagation()
        return
      @nextSearchTerm = undefined
      if $.isFunction(@opts.initSelection)
        # initialize selection based on the current value of the source element
        @initSelection()
        # if the user has provided a function that can set selection based on the value of the source element
        # we monitor the change event on the element and trigger it, allowing for two way synchronization
        @monitorSource()
      if opts.maximumInputLength != null
        @search.attr 'maxlength', opts.maximumInputLength
      disabled = opts.element.prop('disabled')
      if disabled == undefined
        disabled = false
      @enable !disabled
      readonly = opts.element.prop('readonly')
      if readonly == undefined
        readonly = false
      @readonly readonly
      # Calculate size of scrollbar
      scrollBarDimensions = scrollBarDimensions or measureScrollbar()
      @autofocus = opts.element.prop('autofocus')
      opts.element.prop 'autofocus', false
      if @autofocus
        @focus()
      @search.attr 'placeholder', opts.searchInputPlaceholder
      return
    destroy: ->
      element = @opts.element
      select2 = element.data('select2')
      self = this
      @close()
      if element.length and element[0].detachEvent and self._sync
        element.each ->
          if self._sync
            @detachEvent 'onpropertychange', self._sync
          return
      if @propertyObserver
        @propertyObserver.disconnect()
        @propertyObserver = null
      @_sync = null
      if select2 != undefined
        select2.container.remove()
        select2.liveRegion.remove()
        select2.dropdown.remove()
        element.show().removeData('select2').off('.select2').prop 'autofocus', @autofocus or false
        if @elementTabIndex
          element.attr tabindex: @elementTabIndex
        else
          element.removeAttr 'tabindex'
        element.show()
      cleanupJQueryElements.call this, 'container', 'liveRegion', 'dropdown', 'results', 'search'
      return
    optionToData: (element) ->
      if element.is('option')
        return {
          id: element.prop('value')
          text: element.text()
          element: element.get()
          css: element.attr('class')
          disabled: element.prop('disabled')
          locked: equal(element.attr('locked'), 'locked') or equal(element.data('locked'), true)
        }
      else if element.is('optgroup')
        return {
          text: element.attr('label')
          children: []
          element: element.get()
          css: element.attr('class')
        }
      return
    prepareOpts: (opts) ->
      element = undefined
      select = undefined
      idKey = undefined
      ajaxUrl = undefined
      self = this
      element = opts.element
      if element.get(0).tagName.toLowerCase() == 'select'
        @select = select = opts.element
      if select
        # these options are not allowed when attached to a select because they are picked up off the element itself
        $.each [
          'id'
          'multiple'
          'ajax'
          'query'
          'createSearchChoice'
          'initSelection'
          'data'
          'tags'
        ], ->
          if this of opts
            throw new Error('Option \'' + this + '\' is not allowed for Select2 when attached to a <select> element.')
          return
      opts = $.extend({}, { populateResults: (container, results, query) ->
        populate = undefined
        id = @opts.id
        liveRegion = @liveRegion

        populate = (results, container, depth) ->
          i = undefined
          l = undefined
          result = undefined
          selectable = undefined
          disabled = undefined
          compound = undefined
          node = undefined
          label = undefined
          innerContainer = undefined
          formatted = undefined
          results = opts.sortResults(results, container, query)
          # collect the created nodes for bulk append
          nodes = []
          i = 0
          l = results.length
          while i < l
            result = results[i]
            disabled = result.disabled == true
            selectable = !disabled and id(result) != undefined
            compound = result.children and result.children.length > 0
            node = $('<li></li>')
            node.addClass 'select2-results-dept-' + depth
            node.addClass 'select2-result'
            node.addClass if selectable then 'select2-result-selectable' else 'select2-result-unselectable'
            if disabled
              node.addClass 'select2-disabled'
            if compound
              node.addClass 'select2-result-with-children'
            node.addClass self.opts.formatResultCssClass(result)
            node.attr 'role', 'presentation'
            label = $(document.createElement('div'))
            label.addClass 'select2-result-label'
            label.attr 'id', 'select2-result-label-' + nextUid()
            label.attr 'role', 'option'
            formatted = opts.formatResult(result, label, query, self.opts.escapeMarkup)
            if formatted != undefined
              label.html formatted
              node.append label
            if compound
              innerContainer = $('<ul></ul>')
              innerContainer.addClass 'select2-result-sub'
              populate result.children, innerContainer, depth + 1
              node.append innerContainer
            node.data 'select2-data', result
            nodes.push node[0]
            i = i + 1
          # bulk append the created nodes
          container.append nodes
          liveRegion.text opts.formatMatches(results.length)
          return

        populate results, container, 0
        return
 }, $.fn.select2.defaults, opts)
      if typeof opts.id != 'function'
        idKey = opts.id

        opts.id = (e) ->
          e[idKey]

      if $.isArray(opts.element.data('select2Tags'))
        if 'tags' of opts
          throw 'tags specified as both an attribute \'data-select2-tags\' and in options of Select2 ' + opts.element.attr('id')
        opts.tags = opts.element.data('select2Tags')
      if select
        opts.query = @bind((query) ->
          data = 
            results: []
            more: false
          term = query.term
          children = undefined
          placeholderOption = undefined
          process = undefined

          process = (element, collection) ->
            group = undefined
            if element.is('option')
              if query.matcher(term, element.text(), element)
                collection.push self.optionToData(element)
            else if element.is('optgroup')
              group = self.optionToData(element)
              element.children().each2 (i, elm) ->
                process elm, group.children
                return
              if group.children.length > 0
                collection.push group
            return

          children = element.children()
          # ignore the placeholder option if there is one
          if @getPlaceholder() != undefined and children.length > 0
            placeholderOption = @getPlaceholderOption()
            if placeholderOption
              children = children.not(placeholderOption)
          children.each2 (i, elm) ->
            process elm, data.results
            return
          query.callback data
          return
        )
        # this is needed because inside val() we construct choices from options and their id is hardcoded

        opts.id = (e) ->
          e.id

      else
        if !('query' of opts)
          if 'ajax' of opts
            ajaxUrl = opts.element.data('ajax-url')
            if ajaxUrl and ajaxUrl.length > 0
              opts.ajax.url = ajaxUrl
            opts.query = ajax.call(opts.element, opts.ajax)
          else if 'data' of opts
            opts.query = local(opts.data)
          else if 'tags' of opts
            opts.query = tags(opts.tags)
            if opts.createSearchChoice == undefined

              opts.createSearchChoice = (term) ->
                {
                  id: $.trim(term)
                  text: $.trim(term)
                }

            if opts.initSelection == undefined

              opts.initSelection = (element, callback) ->
                data = []
                $(splitVal(element.val(), opts.separator, opts.transformVal)).each ->
                  `var tags`
                  obj = 
                    id: this
                    text: this
                  tags = opts.tags
                  if $.isFunction(tags)
                    tags = tags()
                  $(tags).each ->
                    if equal(@id, obj.id)
                      obj = this
                      return false
                    return
                  data.push obj
                  return
                callback data
                return

      if typeof opts.query != 'function'
        throw 'query function not defined for Select2 ' + opts.element.attr('id')
      if opts.createSearchChoicePosition == 'top'

        opts.createSearchChoicePosition = (list, item) ->
          list.unshift item
          return

      else if opts.createSearchChoicePosition == 'bottom'

        opts.createSearchChoicePosition = (list, item) ->
          list.push item
          return

      else if typeof opts.createSearchChoicePosition != 'function'
        throw 'invalid createSearchChoicePosition option must be \'top\', \'bottom\' or a custom function'
      opts
    monitorSource: ->
      el = @opts.element
      observer = undefined
      self = this
      el.on 'change.select2', @bind((e) ->
        if @opts.element.data('select2-change-triggered') != true
          @initSelection()
        return
      )
      @_sync = @bind(->
        # sync enabled state
        disabled = el.prop('disabled')
        if disabled == undefined
          disabled = false
        @enable !disabled
        readonly = el.prop('readonly')
        if readonly == undefined
          readonly = false
        @readonly readonly
        if @container
          syncCssClasses @container, @opts.element, @opts.adaptContainerCssClass
          @container.addClass evaluate(@opts.containerCssClass, @opts.element)
        if @dropdown
          syncCssClasses @dropdown, @opts.element, @opts.adaptDropdownCssClass
          @dropdown.addClass evaluate(@opts.dropdownCssClass, @opts.element)
        return
      )
      # IE8-10 (IE9/10 won't fire propertyChange via attachEventListener)
      if el.length and el[0].attachEvent
        el.each ->
          @attachEvent 'onpropertychange', self._sync
          return
      # safari, chrome, firefox, IE11
      observer = window.MutationObserver or window.WebKitMutationObserver or window.MozMutationObserver
      if observer != undefined
        if @propertyObserver
          delete @propertyObserver
          @propertyObserver = null
        @propertyObserver = new observer((mutations) ->
          $.each mutations, self._sync
          return
)
        @propertyObserver.observe el.get(0),
          attributes: true
          subtree: false
      return
    triggerSelect: (data) ->
      evt = $.Event('select2-selecting',
        val: @id(data)
        object: data
        choice: data)
      @opts.element.trigger evt
      !evt.isDefaultPrevented()
    triggerChange: (details) ->
      details = details or {}
      details = $.extend({}, details,
        type: 'change'
        val: @val())
      # prevents recursive triggering
      @opts.element.data 'select2-change-triggered', true
      @opts.element.trigger details
      @opts.element.data 'select2-change-triggered', false
      # some validation frameworks ignore the change event and listen instead to keyup, click for selects
      # so here we trigger the click event manually
      @opts.element.click()
      # ValidationEngine ignores the change event and listens instead to blur
      # so here we trigger the blur event manually if so desired
      if @opts.blurOnChange
        @opts.element.blur()
      return
    isInterfaceEnabled: ->
      @enabledInterface == true
    enableInterface: ->
      enabled = @_enabled and !@_readonly
      disabled = !enabled
      if enabled == @enabledInterface
        return false
      @container.toggleClass 'select2-container-disabled', disabled
      @close()
      @enabledInterface = enabled
      true
    enable: (enabled) ->
      if enabled == undefined
        enabled = true
      if @_enabled == enabled
        return
      @_enabled = enabled
      @opts.element.prop 'disabled', !enabled
      @enableInterface()
      return
    disable: ->
      @enable false
      return
    readonly: (enabled) ->
      if enabled == undefined
        enabled = false
      if @_readonly == enabled
        return
      @_readonly = enabled
      @opts.element.prop 'readonly', enabled
      @enableInterface()
      return
    opened: ->
      if @container then @container.hasClass('select2-dropdown-open') else false
    positionDropdown: ->
      $dropdown = @dropdown
      container = @container
      offset = { top: this.container[0].offsetTop, left: this.container.offset().left}
      height = container.outerHeight(false)
      width = container.outerWidth(false)
      dropHeight = $dropdown.outerHeight(false)
      $window = $(window)
      windowWidth = $window.width()
      windowHeight = $window.height()
      viewPortRight = $window.scrollLeft() + windowWidth
      viewportBottom = $window.scrollTop() + windowHeight
      dropTop = offset.top + height
      dropLeft = offset.left
      enoughRoomBelow = dropTop + dropHeight <= viewportBottom
      enoughRoomAbove = offset.top - dropHeight >= $window.scrollTop()
      dropWidth = $dropdown.outerWidth(false)

      enoughRoomOnRight = ->
        dropLeft + dropWidth <= viewPortRight

      enoughRoomOnLeft = ->
        offset.left + viewPortRight + container.outerWidth(false) > dropWidth

      aboveNow = $dropdown.hasClass('select2-drop-above')
      bodyOffset = undefined
      above = undefined
      changeDirection = undefined
      css = undefined
      resultsListNode = undefined
      # always prefer the current above/below alignment, unless there is not enough room
      if aboveNow
        above = true
        if !enoughRoomAbove and enoughRoomBelow
          changeDirection = true
          above = false
      else
        above = false
        if !enoughRoomBelow and enoughRoomAbove
          changeDirection = true
          above = true
      #if we are changing direction we need to get positions when dropdown is hidden;
      if changeDirection
        $dropdown.hide()
        offset = @container.offset()
        height = @container.outerHeight(false)
        width = @container.outerWidth(false)
        dropHeight = $dropdown.outerHeight(false)
        viewPortRight = $window.scrollLeft() + windowWidth
        viewportBottom = $window.scrollTop() + windowHeight
        dropTop = offset.top + height
        dropLeft = offset.left
        dropWidth = $dropdown.outerWidth(false)
        $dropdown.show()
        # fix so the cursor does not move to the left within the search-textbox in IE
        @focusSearch()
      if @opts.dropdownAutoWidth
        resultsListNode = $('.select2-results', $dropdown)[0]
        $dropdown.addClass 'select2-drop-auto-width'
        $dropdown.css 'width', ''
        # Add scrollbar width to dropdown if vertical scrollbar is present
        dropWidth = $dropdown.outerWidth(false) + (if resultsListNode.scrollHeight == resultsListNode.clientHeight then 0 else scrollBarDimensions.width)
        if dropWidth > width then (width = dropWidth) else (dropWidth = width)
        dropHeight = $dropdown.outerHeight(false)
      else
        @container.removeClass 'select2-drop-auto-width'
      #console.log("below/ droptop:", dropTop, "dropHeight", dropHeight, "sum", (dropTop+dropHeight)+" viewport bottom", viewportBottom, "enough?", enoughRoomBelow);
      #console.log("above/ offset.top", offset.top, "dropHeight", dropHeight, "top", (offset.top-dropHeight), "scrollTop", this.body.scrollTop(), "enough?", enoughRoomAbove);
      # fix positioning when body has an offset and is not position: static
      if @body.css('position') != 'static'
        bodyOffset = @body.offset()
        dropTop -= bodyOffset.top
        dropLeft -= bodyOffset.left
      if !enoughRoomOnRight() and enoughRoomOnLeft()
        dropLeft = offset.left + @container.outerWidth(false) - dropWidth
      css =
        left: dropLeft
        width: width
      if above
        css.top = offset.top - dropHeight
        css.bottom = 'auto'
        @container.addClass 'select2-drop-above'
        $dropdown.addClass 'select2-drop-above'
      else
        css.top = dropTop
        css.bottom = 'auto'
        @container.removeClass 'select2-drop-above'
        $dropdown.removeClass 'select2-drop-above'
      css = $.extend(css, evaluate(@opts.dropdownCss, @opts.element))
      $dropdown.css css
      return
    shouldOpen: ->
      event = undefined
      if @opened()
        return false
      if @_enabled == false or @_readonly == true
        return false
      event = $.Event('select2-opening')
      @opts.element.trigger event
      !event.isDefaultPrevented()
    clearDropdownAlignmentPreference: ->
      # clear the classes used to figure out the preference of where the dropdown should be opened
      @container.removeClass 'select2-drop-above'
      @dropdown.removeClass 'select2-drop-above'
      return
    open: ->
      if !@shouldOpen()
        return false
      @opening()
      # Only bind the document mousemove when the dropdown is visible
      $document.on 'mousemove.select2Event', (e) ->
        lastMousePosition.x = e.pageX
        lastMousePosition.y = e.pageY
        return
      true
    opening: ->
      cid = @containerEventName
      scroll = 'scroll.' + cid
      resize = 'resize.' + cid
      orient = 'orientationchange.' + cid
      mask = undefined
      @container.addClass('select2-dropdown-open').addClass 'select2-container-active'
      @clearDropdownAlignmentPreference()
      if @dropdown[0] != @body.children().last()[0]
        @dropdown.detach().appendTo @body
      # create the dropdown mask if doesn't already exist
      mask = $('#select2-drop-mask')
      if mask.length == 0
        mask = $(document.createElement('div'))
        mask.attr('id', 'select2-drop-mask').attr 'class', 'select2-drop-mask'
        mask.hide()
        mask.appendTo @body
        mask.on 'mousedown touchstart click', (e) ->
          # Prevent IE from generating a click event on the body
          reinsertElement mask
          dropdown = $('#select2-drop')
          self = undefined
          if dropdown.length > 0
            self = dropdown.data('select2')
            if self.opts.selectOnBlur
              self.selectHighlighted noFocus: true
            self.close()
            e.preventDefault()
            e.stopPropagation()
          return
      # ensure the mask is always right before the dropdown
      if @dropdown.prev()[0] != mask[0]
        @dropdown.before mask
      # move the global id to the correct dropdown
      $('#select2-drop').removeAttr 'id'
      @dropdown.attr 'id', 'select2-drop'
      # show the elements
      mask.show()
      @positionDropdown()
      @dropdown.show()
      @positionDropdown()
      @dropdown.addClass 'select2-drop-active'
      # attach listeners to events that can change the position of the container and thus require
      # the position of the dropdown to be updated as well so it does not come unglued from the container
      that = this
      @container.parents().add(window).each ->
        $(this).on resize + ' ' + scroll + ' ' + orient, (e) ->
          if that.opened()
            that.positionDropdown()
          return
        return
      return
    close: ->
      if !@opened()
        return
      cid = @containerEventName
      scroll = 'scroll.' + cid
      resize = 'resize.' + cid
      orient = 'orientationchange.' + cid
      # unbind event listeners
      @container.parents().add(window).each ->
        $(this).off(scroll).off(resize).off orient
        return
      @clearDropdownAlignmentPreference()
      $('#select2-drop-mask').hide()
      @dropdown.removeAttr 'id'
      # only the active dropdown has the select2-drop id
      @dropdown.hide()
      @container.removeClass('select2-dropdown-open').removeClass 'select2-container-active'
      @results.empty()
      # Now that the dropdown is closed, unbind the global document mousemove event
      $document.off 'mousemove.select2Event'
      @clearSearch()
      @search.removeClass 'select2-active'
      @opts.element.trigger $.Event('select2-close')
      return
    externalSearch: (term) ->
      @open()
      @search.val term
      @updateResults false
      return
    clearSearch: ->
    getMaximumSelectionSize: ->
      evaluate @opts.maximumSelectionSize, @opts.element
    ensureHighlightVisible: ->
      results = @results
      children = undefined
      index = undefined
      child = undefined
      hb = undefined
      rb = undefined
      y = undefined
      more = undefined
      topOffset = undefined
      index = @highlight()
      if index < 0
        return
      if index == 0
        # if the first element is highlighted scroll all the way to the top,
        # that way any unselectable headers above it will also be scrolled
        # into view
        results.scrollTop 0
        return
      children = @findHighlightableChoices().find('.select2-result-label')
      child = $(children[index])
      topOffset = (child.offset() or {}).top or 0
      hb = topOffset + child.outerHeight(true)
      # if this is the last child lets also make sure select2-more-results is visible
      if index == children.length - 1
        more = results.find('li.select2-more-results')
        if more.length > 0
          hb = more.offset().top + more.outerHeight(true)
      rb = results.offset().top + results.outerHeight(false)
      if hb > rb
        results.scrollTop results.scrollTop() + hb - rb
      y = topOffset - (results.offset().top)
      # make sure the top of the element is visible
      if y < 0 and child.css('display') != 'none'
        results.scrollTop results.scrollTop() + y
        # y is negative
      return
    findHighlightableChoices: ->
      @results.find '.select2-result-selectable:not(.select2-disabled):not(.select2-selected)'
    moveHighlight: (delta) ->
      choices = @findHighlightableChoices()
      index = @highlight()
      while index > -1 and index < choices.length
        index += delta
        choice = $(choices[index])
        if choice.hasClass('select2-result-selectable') and !choice.hasClass('select2-disabled') and !choice.hasClass('select2-selected')
          @highlight index
          break
      return
    highlight: (index) ->
      choices = @findHighlightableChoices()
      choice = undefined
      data = undefined
      if arguments.length == 0
        return indexOf(choices.filter('.select2-highlighted')[0], choices.get())
      if index >= choices.length
        index = choices.length - 1
      if index < 0
        index = 0
      @removeHighlight()
      choice = $(choices[index])
      choice.addClass 'select2-highlighted'
      # ensure assistive technology can determine the active choice
      @search.attr 'aria-activedescendant', choice.find('.select2-result-label').attr('id')
      @ensureHighlightVisible()
      @liveRegion.text choice.text()
      data = choice.data('select2-data')
      if data
        @opts.element.trigger
          type: 'select2-highlight'
          val: @id(data)
          choice: data
      return
    removeHighlight: ->
      @results.find('.select2-highlighted').removeClass 'select2-highlighted'
      return
    touchMoved: ->
      @_touchMoved = true
      return
    clearTouchMoved: ->
      @_touchMoved = false
      return
    countSelectableResults: ->
      @findHighlightableChoices().length
    highlightUnderEvent: (event) ->
      el = $(event.target).closest('.select2-result-selectable')
      if el.length > 0 and !el.is('.select2-highlighted')
        choices = @findHighlightableChoices()
        @highlight choices.index(el)
      else if el.length == 0
        # if we are over an unselectable item remove all highlights
        @removeHighlight()
      return
    loadMoreIfNeeded: ->
      results = @results
      more = results.find('li.select2-more-results')
      below = undefined
      page = @resultsPage + 1
      self = this
      term = @search.val()
      context = @context
      if more.length == 0
        return
      below = more.offset().top - (results.offset().top) - results.height()
      if below <= @opts.loadMorePadding
        more.addClass 'select2-active'
        @opts.query
          element: @opts.element
          term: term
          page: page
          context: context
          matcher: @opts.matcher
          callback: @bind((data) ->
            # ignore a response if the select2 has been closed before it was received
            if !self.opened()
              return
            self.opts.populateResults.call this, results, data.results,
              term: term
              page: page
              context: context
            self.postprocessResults data, false, false
            if data.more == true
              more.detach().appendTo(results).html self.opts.escapeMarkup(evaluate(self.opts.formatLoadMore, self.opts.element, page + 1))
              window.setTimeout (->
                self.loadMoreIfNeeded()
                return
              ), 10
            else
              more.remove()
            self.positionDropdown()
            self.resultsPage = page
            self.context = data.context
            @opts.element.trigger
              type: 'select2-loaded'
              items: data
            return
          )
      return
    tokenize: ->
    updateResults: (initial) ->
      search = @search
      results = @results
      opts = @opts
      data = undefined
      self = this
      input = undefined
      term = search.val()
      lastTerm = $.data(@container, 'select2-last-term')
      queryNumber = undefined
      # prevent duplicate queries against the same term

      postRender = ->
        search.removeClass 'select2-active'
        self.positionDropdown()
        if results.find('.select2-no-results,.select2-selection-limit,.select2-searching').length
          self.liveRegion.text results.text()
        else
          self.liveRegion.text self.opts.formatMatches(results.find('.select2-result-selectable:not(".select2-selected")').length)
        return

      render = (html) ->
        results.html html
        postRender()
        return

      if initial != true and lastTerm and equal(term, lastTerm)
        return
      $.data @container, 'select2-last-term', term
      # if the search is currently hidden we do not alter the results
      if initial != true and (@showSearchInput == false or !@opened())
        return
      queryNumber = ++@queryCount
      maxSelSize = @getMaximumSelectionSize()
      if maxSelSize >= 1
        data = @data()
        if $.isArray(data) and data.length >= maxSelSize and checkFormatter(opts.formatSelectionTooBig, 'formatSelectionTooBig')
          render '<li class=\'select2-selection-limit\'>' + evaluate(opts.formatSelectionTooBig, opts.element, maxSelSize) + '</li>'
          return
      if search.val().length < opts.minimumInputLength
        if checkFormatter(opts.formatInputTooShort, 'formatInputTooShort')
          render '<li class=\'select2-no-results\'>' + evaluate(opts.formatInputTooShort, opts.element, search.val(), opts.minimumInputLength) + '</li>'
        else
          render ''
        if initial and @showSearch
          @showSearch true
        return
      if opts.maximumInputLength and search.val().length > opts.maximumInputLength
        if checkFormatter(opts.formatInputTooLong, 'formatInputTooLong')
          render '<li class=\'select2-no-results\'>' + evaluate(opts.formatInputTooLong, opts.element, search.val(), opts.maximumInputLength) + '</li>'
        else
          render ''
        return
      if opts.formatSearching and @findHighlightableChoices().length == 0
        render '<li class=\'select2-searching\'>' + evaluate(opts.formatSearching, opts.element) + '</li>'
      search.addClass 'select2-active'
      @removeHighlight()
      # give the tokenizer a chance to pre-process the input
      input = @tokenize()
      if input != undefined and input != null
        search.val input
      @resultsPage = 1
      opts.query
        element: opts.element
        term: search.val()
        page: @resultsPage
        context: null
        matcher: opts.matcher
        callback: @bind((data) ->
          def = undefined
          # default choice
          # ignore old responses
          if queryNumber != @queryCount
            return
          # ignore a response if the select2 has been closed before it was received
          if !@opened()
            @search.removeClass 'select2-active'
            return
          # handle ajax error
          if data.hasError != undefined and checkFormatter(opts.formatAjaxError, 'formatAjaxError')
            render '<li class=\'select2-ajax-error\'>' + evaluate(opts.formatAjaxError, opts.element, data.jqXHR, data.textStatus, data.errorThrown) + '</li>'
            return
          # save context, if any
          @context = if data.context == undefined then null else data.context
          # create a default choice and prepend it to the list
          if @opts.createSearchChoice and search.val() != ''
            def = @opts.createSearchChoice.call(self, search.val(), data.results)
            if def != undefined and def != null and self.id(def) != undefined and self.id(def) != null
              if $(data.results).filter((->
                  equal self.id(this), self.id(def)
                )).length == 0
                @opts.createSearchChoicePosition data.results, def
          if data.results.length == 0 and checkFormatter(opts.formatNoMatches, 'formatNoMatches')
            render '<li class=\'select2-no-results\'>' + evaluate(opts.formatNoMatches, opts.element, search.val()) + '</li>'
            return
          results.empty()
          self.opts.populateResults.call this, results, data.results,
            term: search.val()
            page: @resultsPage
            context: null
          if data.more == true and checkFormatter(opts.formatLoadMore, 'formatLoadMore')
            results.append '<li class=\'select2-more-results\'>' + opts.escapeMarkup(evaluate(opts.formatLoadMore, opts.element, @resultsPage)) + '</li>'
            window.setTimeout (->
              self.loadMoreIfNeeded()
              return
            ), 10
          @postprocessResults data, initial
          postRender()
          @opts.element.trigger
            type: 'select2-loaded'
            items: data
          return
        )
      return
    cancel: ->
      @close()
      return
    blur: ->
      # if selectOnBlur == true, select the currently highlighted option
      if @opts.selectOnBlur
        @selectHighlighted noFocus: true
      @close()
      @container.removeClass 'select2-container-active'
      # synonymous to .is(':focus'), which is available in jquery >= 1.6
      if @search[0] == document.activeElement
        @search.blur()
      @clearSearch()
      @selection.find('.select2-search-choice-focus').removeClass 'select2-search-choice-focus'
      return
    focusSearch: ->
      focus @search
      return
    selectHighlighted: (options) ->
      if @_touchMoved
        @clearTouchMoved()
        return
      index = @highlight()
      highlighted = @results.find('.select2-highlighted')
      data = highlighted.closest('.select2-result').data('select2-data')
      if data
        @highlight index
        @onSelect data, options
      else if options and options.noFocus
        @close()
      return
    getPlaceholder: ->
      placeholderOption = undefined
      @opts.element.attr('placeholder') or @opts.element.attr('data-placeholder') or @opts.element.data('placeholder') or @opts.placeholder or (if (placeholderOption = @getPlaceholderOption()) != undefined then placeholderOption.text() else undefined)
    getPlaceholderOption: ->
      if @select
        firstOption = @select.children('option').first()
        if @opts.placeholderOption != undefined
          #Determine the placeholder option based on the specified placeholderOption setting
          return @opts.placeholderOption == 'first' and firstOption or typeof @opts.placeholderOption == 'function' and @opts.placeholderOption(@select)
        else if $.trim(firstOption.text()) == '' and firstOption.val() == ''
          #No explicit placeholder option specified, use the first if it's blank
          return firstOption
      return
    initContainerWidth: ->

      resolveContainerWidth = ->
        style = undefined
        attrs = undefined
        matches = undefined
        i = undefined
        l = undefined
        attr = undefined
        if @opts.width == 'off'
          null
        else if @opts.width == 'element'
          if @opts.element.outerWidth(false) == 0 then 'auto' else @opts.element.outerWidth(false) + 'px'
        else if @opts.width == 'copy' or @opts.width == 'resolve'
          # check if there is inline style on the element that contains width
          style = @opts.element.attr('style')
          if style != undefined
            attrs = style.split(';')
            i = 0
            l = attrs.length
            while i < l
              attr = attrs[i].replace(/\s/g, '')
              matches = attr.match(/^width:(([-+]?([0-9]*\.)?[0-9]+)(px|em|ex|%|in|cm|mm|pt|pc))/i)
              if matches != null and matches.length >= 1
                return matches[1]
              i = i + 1
          if @opts.width == 'resolve'
            # next check if css('width') can resolve a width that is percent based, this is sometimes possible
            # when attached to input type=hidden or elements hidden via css
            style = @opts.element.css('width')
            if style.indexOf('%') > 0
              return style
            # finally, fallback on the calculated width of the element
            return if @opts.element.outerWidth(false) == 0 then 'auto' else @opts.element.outerWidth(false) + 'px'
          null
        else if $.isFunction(@opts.width)
          @opts.width()
        else
          @opts.width

      width = resolveContainerWidth.call(this)
      if width != null
        @container.css 'width', width
      return
  )
  SingleSelect2 = clazz(AbstractSelect2,
    createContainer: ->
      container = $(document.createElement('div')).attr('class': 'select2-container').html([
        '<a href=\'javascript:void(0)\' class=\'select2-choice\' tabindex=\'-1\'>'
        '   <span class=\'select2-chosen\'>&#160;</span><abbr class=\'select2-search-choice-close\'></abbr>'
        '   <span class=\'select2-arrow\' role=\'presentation\'><b role=\'presentation\'></b></span>'
        '</a>'
        '<label for=\'\' class=\'select2-offscreen\'></label>'
        '<input class=\'select2-focusser select2-offscreen\' type=\'text\' aria-haspopup=\'true\' role=\'button\' />'
        '<div class=\'select2-drop select2-display-none\'>'
        '   <div class=\'select2-search\'>'
        '       <label for=\'\' class=\'select2-offscreen\'></label>'
        '       <input type=\'text\' autocomplete=\'off\' autocorrect=\'off\' autocapitalize=\'off\' spellcheck=\'false\' class=\'select2-input\' role=\'combobox\' aria-expanded=\'true\''
        '       aria-autocomplete=\'list\' />'
        '   </div>'
        '   <ul class=\'select2-results\' role=\'listbox\'>'
        '   </ul>'
        '</div>'
      ].join(''))
      container
    enableInterface: ->
      if @parent.enableInterface.apply(this, arguments)
        @focusser.prop 'disabled', !@isInterfaceEnabled()
      return
    opening: ->
      el = undefined
      range = undefined
      len = undefined
      if @opts.minimumResultsForSearch >= 0
        @showSearch true
      @parent.opening.apply this, arguments
      if @showSearchInput != false
        # IE appends focusser.val() at the end of field :/ so we manually insert it at the beginning using a range
        # all other browsers handle this just fine
        @search.val @focusser.val()
      if @opts.shouldFocusInput(this)
        @search.focus()
        # move the cursor to the end after focussing, otherwise it will be at the beginning and
        # new text will appear *before* focusser.val()
        el = @search.get(0)
        if el.createTextRange
          range = el.createTextRange()
          range.collapse false
          range.select()
        else if el.setSelectionRange
          len = @search.val().length
          el.setSelectionRange len, len
      # initializes search's value with nextSearchTerm (if defined by user)
      # ignore nextSearchTerm if the dropdown is opened by the user pressing a letter
      if @search.val() == ''
        if @nextSearchTerm != undefined
          @search.val @nextSearchTerm
          @search.select()
      @focusser.prop('disabled', true).val ''
      @updateResults true
      @opts.element.trigger $.Event('select2-open')
      return
    close: ->
      if !@opened()
        return
      @parent.close.apply this, arguments
      @focusser.prop 'disabled', false
      if @opts.shouldFocusInput(this)
        @focusser.focus()
      return
    focus: ->
      if @opened()
        @close()
      else
        @focusser.prop 'disabled', false
        if @opts.shouldFocusInput(this)
          @focusser.focus()
      return
    isFocused: ->
      @container.hasClass 'select2-container-active'
    cancel: ->
      @parent.cancel.apply this, arguments
      @focusser.prop 'disabled', false
      if @opts.shouldFocusInput(this)
        @focusser.focus()
      return
    destroy: ->
      $('label[for=\'' + @focusser.attr('id') + '\']').attr 'for', @opts.element.attr('id')
      @parent.destroy.apply this, arguments
      cleanupJQueryElements.call this, 'selection', 'focusser'
      return
    initContainer: ->
      selection = undefined
      container = @container
      dropdown = @dropdown
      idSuffix = nextUid()
      elementLabel = undefined
      if @opts.minimumResultsForSearch < 0
        @showSearch false
      else
        @showSearch true
      @selection = selection = container.find('.select2-choice')
      @focusser = container.find('.select2-focusser')
      # add aria associations
      selection.find('.select2-chosen').attr 'id', 'select2-chosen-' + idSuffix
      @focusser.attr 'aria-labelledby', 'select2-chosen-' + idSuffix
      @results.attr 'id', 'select2-results-' + idSuffix
      @search.attr 'aria-owns', 'select2-results-' + idSuffix
      # rewrite labels from original element to focusser
      @focusser.attr 'id', 's2id_autogen' + idSuffix
      elementLabel = $('label[for=\'' + @opts.element.attr('id') + '\']')
      @opts.element.focus @bind(->
        @focus()
        return
      )
      @focusser.prev().text(elementLabel.text()).attr 'for', @focusser.attr('id')
      # Ensure the original element retains an accessible name
      originalTitle = @opts.element.attr('title')
      @opts.element.attr 'title', originalTitle or elementLabel.text()
      @focusser.attr 'tabindex', @elementTabIndex
      # write label for search field using the label from the focusser element
      @search.attr 'id', @focusser.attr('id') + '_search'
      @search.prev().text($('label[for=\'' + @focusser.attr('id') + '\']').text()).attr 'for', @search.attr('id')
      @search.on 'keydown', @bind((e) ->
        if !@isInterfaceEnabled()
          return
        # filter 229 keyCodes (input method editor is processing key input)
        if 229 == e.keyCode
          return
        if e.which == KEY.PAGE_UP or e.which == KEY.PAGE_DOWN
          # prevent the page from scrolling
          killEvent e
          return
        switch e.which
          when KEY.UP, KEY.DOWN
            @moveHighlight if e.which == KEY.UP then -1 else 1
            killEvent e
            return
          when KEY.ENTER
            @selectHighlighted()
            killEvent e
            return
          when KEY.TAB
            @selectHighlighted noFocus: true
            return
          when KEY.ESC
            @cancel e
            killEvent e
            return
        return
      )
      @search.on 'blur', @bind((e) ->
        # a workaround for chrome to keep the search field focussed when the scroll bar is used to scroll the dropdown.
        # without this the search field loses focus which is annoying
        if document.activeElement == @body.get(0)
          window.setTimeout @bind(->
            if @opened()
              @search.focus()
            return
          ), 0
        return
      )
      @focusser.on 'keydown', @bind((e) ->
        if !@isInterfaceEnabled()
          return
        if e.which == KEY.TAB or KEY.isControl(e) or KEY.isFunctionKey(e) or e.which == KEY.ESC
          return
        if @opts.openOnEnter == false and e.which == KEY.ENTER
          killEvent e
          return
        if e.which == KEY.DOWN or e.which == KEY.UP or e.which == KEY.ENTER and @opts.openOnEnter
          if e.altKey or e.ctrlKey or e.shiftKey or e.metaKey
            return
          @open()
          killEvent e
          return
        if e.which == KEY.DELETE or e.which == KEY.BACKSPACE
          if @opts.allowClear
            @clear()
          killEvent e
          return
        return
      )
      installKeyUpChangeEvent @focusser
      @focusser.on 'keyup-change input', @bind((e) ->
        if @opts.minimumResultsForSearch >= 0
          e.stopPropagation()
          if @opened()
            return
          @open()
        return
      )
      selection.on 'mousedown touchstart', 'abbr', @bind((e) ->
        if !@isInterfaceEnabled()
          return
        @clear()
        killEventImmediately e
        @close()
        if @selection
          @selection.focus()
        return
      )
      selection.on 'mousedown touchstart', @bind((e) ->
        # Prevent IE from generating a click event on the body
        reinsertElement selection
        if !@container.hasClass('select2-container-active')
          @opts.element.trigger $.Event('select2-focus')
        if @opened()
          @close()
        else if @isInterfaceEnabled()
          @open()
        killEvent e
        return
      )
      dropdown.on 'mousedown touchstart', @bind(->
        if @opts.shouldFocusInput(this)
          @search.focus()
        return
      )
      selection.on 'focus', @bind((e) ->
        killEvent e
        return
      )
      @focusser.on('focus', @bind(->
        if !@container.hasClass('select2-container-active')
          @opts.element.trigger $.Event('select2-focus')
        @container.addClass 'select2-container-active'
        return
      )).on 'blur', @bind(->
        if !@opened()
          @container.removeClass 'select2-container-active'
          @opts.element.trigger $.Event('select2-blur')
        return
      )
      @search.on 'focus', @bind(->
        if !@container.hasClass('select2-container-active')
          @opts.element.trigger $.Event('select2-focus')
        @container.addClass 'select2-container-active'
        return
      )
      @initContainerWidth()
      @opts.element.hide()
      @setPlaceholder()
      return
    clear: (triggerChange) ->
      data = @selection.data('select2-data')
      if data
        # guard against queued quick consecutive clicks
        evt = $.Event('select2-clearing')
        @opts.element.trigger evt
        if evt.isDefaultPrevented()
          return
        placeholderOption = @getPlaceholderOption()
        @opts.element.val if placeholderOption then placeholderOption.val() else ''
        @selection.find('.select2-chosen').empty()
        @selection.removeData 'select2-data'
        @setPlaceholder()
        if triggerChange != false
          @opts.element.trigger
            type: 'select2-removed'
            val: @id(data)
            choice: data
          @triggerChange removed: data
      return
    initSelection: ->
      selected = undefined
      if @isPlaceholderOptionSelected()
        @updateSelection null
        @close()
        @setPlaceholder()
      else
        self = this
        @opts.initSelection.call null, @opts.element, (selected) ->
          if selected != undefined and selected != null
            self.updateSelection selected
            self.close()
            self.setPlaceholder()
            self.nextSearchTerm = self.opts.nextSearchTerm(selected, self.search.val())
          return
      return
    isPlaceholderOptionSelected: ->
      placeholderOption = undefined
      if @getPlaceholder() == undefined
        return false
      # no placeholder specified so no option should be considered
      (placeholderOption = @getPlaceholderOption()) != undefined and placeholderOption.prop('selected') or @opts.element.val() == '' or @opts.element.val() == undefined or @opts.element.val() == null
    prepareOpts: ->
      opts = @parent.prepareOpts.apply(this, arguments)
      self = this
      if opts.element.get(0).tagName.toLowerCase() == 'select'
        # install the selection initializer

        opts.initSelection = (element, callback) ->
          selected = element.find('option').filter(->
            @selected and !@disabled
          )
          # a single select box always has a value, no need to null check 'selected'
          callback self.optionToData(selected)
          return

      else if 'data' of opts
        # install default initSelection when applied to hidden input and data is local
        opts.initSelection = opts.initSelection or (element, callback) ->
          id = element.val()
          #search in data by id, storing the actual matching item
          match = null
          opts.query
            matcher: (term, text, el) ->
              is_match = equal(id, opts.id(el))
              if is_match
                match = el
              is_match
            callback: if !$.isFunction(callback) then $.noop else (->
              callback match
              return
            )
          return
      opts
    getPlaceholder: ->
      # if a placeholder is specified on a single select without a valid placeholder option ignore it
      if @select
        if @getPlaceholderOption() == undefined
          return undefined
      @parent.getPlaceholder.apply this, arguments
    setPlaceholder: ->
      placeholder = @getPlaceholder()
      if @isPlaceholderOptionSelected() and placeholder != undefined
        # check for a placeholder option if attached to a select
        if @select and @getPlaceholderOption() == undefined
          return
        @selection.find('.select2-chosen').html @opts.escapeMarkup(placeholder)
        @selection.addClass 'select2-default'
        @container.removeClass 'select2-allowclear'
      return
    postprocessResults: (data, initial, noHighlightUpdate) ->
      selected = 0
      self = this
      showSearchInput = true
      # find the selected element in the result list
      @findHighlightableChoices().each2 (i, elm) ->
        if equal(self.id(elm.data('select2-data')), self.opts.element.val())
          selected = i
          return false
        return
      # and highlight it
      if noHighlightUpdate != false
        if initial == true and selected >= 0
          @highlight selected
        else
          @highlight 0
      # hide the search box if this is the first we got the results and there are enough of them for search
      if initial == true
        min = @opts.minimumResultsForSearch
        if min >= 0
          @showSearch countResults(data.results) >= min
      return
    showSearch: (showSearchInput) ->
      if @showSearchInput == showSearchInput
        return
      @showSearchInput = showSearchInput
      @dropdown.find('.select2-search').toggleClass 'select2-search-hidden', !showSearchInput
      @dropdown.find('.select2-search').toggleClass 'select2-offscreen', !showSearchInput
      #add "select2-with-searchbox" to the container if search box is shown
      $(@dropdown, @container).toggleClass 'select2-with-searchbox', showSearchInput
      return
    onSelect: (data, options) ->
      if !@triggerSelect(data)
        return
      old = @opts.element.val()
      oldData = @data()
      @opts.element.val @id(data)
      @updateSelection data
      @opts.element.trigger
        type: 'select2-selected'
        val: @id(data)
        choice: data
      @nextSearchTerm = @opts.nextSearchTerm(data, @search.val())
      @close()
      if (!options or !options.noFocus) and @opts.shouldFocusInput(this)
        @focusser.focus()
      if !equal(old, @id(data))
        @triggerChange
          added: data
          removed: oldData
      return
    updateSelection: (data) ->
      container = @selection.find('.select2-chosen')
      formatted = undefined
      cssClass = undefined
      @selection.data 'select2-data', data
      container.empty()
      if data != null
        formatted = @opts.formatSelection(data, container, @opts.escapeMarkup)
      if formatted != undefined
        container.append formatted
      cssClass = @opts.formatSelectionCssClass(data, container)
      if cssClass != undefined
        container.addClass cssClass
      @selection.removeClass 'select2-default'
      if @opts.allowClear and @getPlaceholder() != undefined
        @container.addClass 'select2-allowclear'
      return
    val: ->
      val = undefined
      triggerChange = false
      data = null
      self = this
      oldData = @data()
      if arguments.length == 0
        return @opts.element.val()
      val = arguments[0]
      if arguments.length > 1
        triggerChange = arguments[1]
      if @select
        @select.val(val).find('option').filter(->
          @selected
        ).each2 (i, elm) ->
          data = self.optionToData(elm)
          false
        @updateSelection data
        @setPlaceholder()
        if triggerChange
          @triggerChange
            added: data
            removed: oldData
      else
        # val is an id. !val is true for [undefined,null,'',0] - 0 is legal
        if !val and val != 0
          @clear triggerChange
          return
        if @opts.initSelection == undefined
          throw new Error('cannot call val() if initSelection() is not defined')
        @opts.element.val val
        @opts.initSelection @opts.element, (data) ->
          self.opts.element.val if !data then '' else self.id(data)
          self.updateSelection data
          self.setPlaceholder()
          if triggerChange
            self.triggerChange
              added: data
              removed: oldData
          return
      return
    clearSearch: ->
      @search.val ''
      @focusser.val ''
      return
    data: (value) ->
      data = undefined
      triggerChange = false
      if arguments.length == 0
        data = @selection.data('select2-data')
        if data == undefined
          data = null
        return data
      else
        if arguments.length > 1
          triggerChange = arguments[1]
        if !value
          @clear triggerChange
        else
          data = @data()
          @opts.element.val if !value then '' else @id(value)
          @updateSelection value
          if triggerChange
            @triggerChange
              added: value
              removed: data
      return
  )
  MultiSelect2 = clazz(AbstractSelect2,
    createContainer: ->
      container = $(document.createElement('div')).attr('class': 'select2-container select2-container-multi').html([
        '<ul class=\'select2-choices\'>'
        '  <li class=\'select2-search-field\'>'
        '    <label for=\'\' class=\'select2-offscreen\'></label>'
        '    <input type=\'text\' autocomplete=\'off\' autocorrect=\'off\' autocapitalize=\'off\' spellcheck=\'false\' class=\'select2-input\'>'
        '  </li>'
        '</ul>'
        '<div class=\'select2-drop select2-drop-multi select2-display-none\'>'
        '   <ul class=\'select2-results\'>'
        '   </ul>'
        '</div>'
      ].join(''))
      container
    prepareOpts: ->
      opts = @parent.prepareOpts.apply(this, arguments)
      self = this
      # TODO validate placeholder is a string if specified
      if opts.element.get(0).tagName.toLowerCase() == 'select'
        # install the selection initializer

        opts.initSelection = (element, callback) ->
          data = []
          element.find('option').filter(->
            @selected and !@disabled
          ).each2 (i, elm) ->
            data.push self.optionToData(elm)
            return
          callback data
          return

      else if 'data' of opts
        # install default initSelection when applied to hidden input and data is local
        opts.initSelection = opts.initSelection or (element, callback) ->
          ids = splitVal(element.val(), opts.separator, opts.transformVal)
          #search in data by array of ids, storing matching items in a list
          matches = []
          opts.query
            matcher: (term, text, el) ->
              is_match = $.grep(ids, (id) ->
                equal id, opts.id(el)
              ).length
              if is_match
                matches.push el
              is_match
            callback: if !$.isFunction(callback) then $.noop else (->
              # reorder matches based on the order they appear in the ids array because right now
              # they are in the order in which they appear in data array
              ordered = []
              i = 0
              while i < ids.length
                id = ids[i]
                j = 0
                while j < matches.length
                  match = matches[j]
                  if equal(id, opts.id(match))
                    ordered.push match
                    matches.splice j, 1
                    break
                  j++
                i++
              callback ordered
              return
            )
          return
      opts
    selectChoice: (choice) ->
      selected = @container.find('.select2-search-choice-focus')
      if selected.length and choice and choice[0] == selected[0]
      else
        if selected.length
          @opts.element.trigger 'choice-deselected', selected
        selected.removeClass 'select2-search-choice-focus'
        if choice and choice.length
          @close()
          choice.addClass 'select2-search-choice-focus'
          @opts.element.trigger 'choice-selected', choice
      return
    destroy: ->
      $('label[for=\'' + @search.attr('id') + '\']').attr 'for', @opts.element.attr('id')
      @parent.destroy.apply this, arguments
      cleanupJQueryElements.call this, 'searchContainer', 'selection'
      return
    initContainer: ->
      selector = '.select2-choices'
      selection = undefined
      @searchContainer = @container.find('.select2-search-field')
      @selection = selection = @container.find(selector)
      _this = this
      @selection.on 'click', '.select2-container:not(.select2-container-disabled) .select2-search-choice:not(.select2-locked)', (e) ->
        _this.search[0].focus()
        _this.selectChoice $(this)
        return
      # rewrite labels from original element to focusser
      @search.attr 'id', 's2id_autogen' + nextUid()
      @search.prev().text($('label[for=\'' + @opts.element.attr('id') + '\']').text()).attr 'for', @search.attr('id')
      @opts.element.focus @bind(->
        @focus()
        return
      )
      @search.on 'input paste', @bind(->
        if @search.attr('placeholder') and @search.val().length == 0
          return
        if !@isInterfaceEnabled()
          return
        if !@opened()
          @open()
        return
      )
      @search.attr 'tabindex', @elementTabIndex
      @keydowns = 0
      @search.on 'keydown', @bind((e) ->
        if !@isInterfaceEnabled()
          return
        ++@keydowns
        selected = selection.find('.select2-search-choice-focus')
        prev = selected.prev('.select2-search-choice:not(.select2-locked)')
        next = selected.next('.select2-search-choice:not(.select2-locked)')
        pos = getCursorInfo(@search)
        if selected.length and (e.which == KEY.LEFT or e.which == KEY.RIGHT or e.which == KEY.BACKSPACE or e.which == KEY.DELETE or e.which == KEY.ENTER)
          selectedChoice = selected
          if e.which == KEY.LEFT and prev.length
            selectedChoice = prev
          else if e.which == KEY.RIGHT
            selectedChoice = if next.length then next else null
          else if e.which == KEY.BACKSPACE
            if @unselect(selected.first())
              @search.width 10
              selectedChoice = if prev.length then prev else next
          else if e.which == KEY.DELETE
            if @unselect(selected.first())
              @search.width 10
              selectedChoice = if next.length then next else null
          else if e.which == KEY.ENTER
            selectedChoice = null
          @selectChoice selectedChoice
          killEvent e
          if !selectedChoice or !selectedChoice.length
            @open()
          return
        else if (e.which == KEY.BACKSPACE and @keydowns == 1 or e.which == KEY.LEFT) and pos.offset == 0 and !pos.length
          @selectChoice selection.find('.select2-search-choice:not(.select2-locked)').last()
          killEvent e
          return
        else
          @selectChoice null
        if @opened()
          switch e.which
            when KEY.UP, KEY.DOWN
              @moveHighlight if e.which == KEY.UP then -1 else 1
              killEvent e
              return
            when KEY.ENTER
              @selectHighlighted()
              killEvent e
              return
            when KEY.TAB
              @selectHighlighted noFocus: true
              @close()
              return
            when KEY.ESC
              @cancel e
              killEvent e
              return
        if e.which == KEY.TAB or KEY.isControl(e) or KEY.isFunctionKey(e) or e.which == KEY.BACKSPACE or e.which == KEY.ESC
          return
        if e.which == KEY.ENTER
          if @opts.openOnEnter == false
            return
          else if e.altKey or e.ctrlKey or e.shiftKey or e.metaKey
            return
        @open()
        if e.which == KEY.PAGE_UP or e.which == KEY.PAGE_DOWN
          # prevent the page from scrolling
          killEvent e
        if e.which == KEY.ENTER
          # prevent form from being submitted
          killEvent e
        return
      )
      @search.on 'keyup', @bind((e) ->
        @keydowns = 0
        @resizeSearch()
        return
      )
      @search.on 'blur', @bind((e) ->
        @container.removeClass 'select2-container-active'
        @search.removeClass 'select2-focused'
        @selectChoice null
        if !@opened()
          @clearSearch()
        e.stopImmediatePropagation()
        @opts.element.trigger $.Event('select2-blur')
        return
      )
      @container.on 'click', selector, @bind((e) ->
        if !@isInterfaceEnabled()
          return
        if $(e.target).closest('.select2-search-choice').length > 0
          # clicked inside a select2 search choice, do not open
          return
        @selectChoice null
        @clearPlaceholder()
        if !@container.hasClass('select2-container-active')
          @opts.element.trigger $.Event('select2-focus')
        @open()
        @focusSearch()
        e.preventDefault()
        return
      )
      @container.on 'focus', selector, @bind(->
        if !@isInterfaceEnabled()
          return
        if !@container.hasClass('select2-container-active')
          @opts.element.trigger $.Event('select2-focus')
        @container.addClass 'select2-container-active'
        @dropdown.addClass 'select2-drop-active'
        @clearPlaceholder()
        return
      )
      @initContainerWidth()
      @opts.element.hide()
      # set the placeholder if necessary
      @clearSearch()
      return
    enableInterface: ->
      if @parent.enableInterface.apply(this, arguments)
        @search.prop 'disabled', !@isInterfaceEnabled()
      return
    initSelection: ->
      data = undefined
      if @opts.element.val() == '' and @opts.element.text() == ''
        @updateSelection []
        @close()
        # set the placeholder if necessary
        @clearSearch()
      if @select or @opts.element.val() != ''
        self = this
        @opts.initSelection.call null, @opts.element, (data) ->
          if data != undefined and data != null
            self.updateSelection data
            self.close()
            # set the placeholder if necessary
            self.clearSearch()
          return
      return
    clearSearch: ->
      placeholder = @getPlaceholder()
      maxWidth = @getMaxSearchWidth()
      if placeholder != undefined and @getVal().length == 0 and @search.hasClass('select2-focused') == false
        @search.val(placeholder).addClass 'select2-default'
        # stretch the search box to full width of the container so as much of the placeholder is visible as possible
        # we could call this.resizeSearch(), but we do not because that requires a sizer and we do not want to create one so early because of a firefox bug, see #944
        @search.width if maxWidth > 0 then maxWidth else @container.css('width')
      else
        @search.val('').width 10
      return
    clearPlaceholder: ->
      if @search.hasClass('select2-default')
        @search.val('').removeClass 'select2-default'
      return
    opening: ->
      @clearPlaceholder()
      # should be done before super so placeholder is not used to search
      @resizeSearch()
      @parent.opening.apply this, arguments
      @focusSearch()
      # initializes search's value with nextSearchTerm (if defined by user)
      # ignore nextSearchTerm if the dropdown is opened by the user pressing a letter
      if @search.val() == ''
        if @nextSearchTerm != undefined
          @search.val @nextSearchTerm
          @search.select()
      @updateResults true
      if @opts.shouldFocusInput(this)
        @search.focus()
      @opts.element.trigger $.Event('select2-open')
      return
    close: ->
      if !@opened()
        return
      @parent.close.apply this, arguments
      return
    focus: ->
      @close()
      @search.focus()
      return
    isFocused: ->
      @search.hasClass 'select2-focused'
    updateSelection: (data) ->
      ids = []
      filtered = []
      self = this
      # filter out duplicates
      $(data).each ->
        if indexOf(self.id(this), ids) < 0
          ids.push self.id(this)
          filtered.push this
        return
      data = filtered
      @selection.find('.select2-search-choice').remove()
      $(data).each ->
        self.addSelectedChoice this
        return
      self.postprocessResults()
      return
    tokenize: ->
      input = @search.val()
      input = @opts.tokenizer.call(this, input, @data(), @bind(@onSelect), @opts)
      if input != null and input != undefined
        @search.val input
        if input.length > 0
          @open()
      return
    onSelect: (data, options) ->
      if !@triggerSelect(data) or data.text == ''
        return
      @addSelectedChoice data
      @opts.element.trigger
        type: 'selected'
        val: @id(data)
        choice: data
      # keep track of the search's value before it gets cleared
      @nextSearchTerm = @opts.nextSearchTerm(data, @search.val())
      @clearSearch()
      @updateResults()
      if @select or !@opts.closeOnSelect
        @postprocessResults data, false, @opts.closeOnSelect == true
      if @opts.closeOnSelect
        @close()
        @search.width 10
      else
        if @countSelectableResults() > 0
          @search.width 10
          @resizeSearch()
          if @getMaximumSelectionSize() > 0 and @val().length >= @getMaximumSelectionSize()
            # if we reached max selection size repaint the results so choices
            # are replaced with the max selection reached message
            @updateResults true
          else
            # initializes search's value with nextSearchTerm and update search result
            if @nextSearchTerm != undefined
              @search.val @nextSearchTerm
              @updateResults()
              @search.select()
          @positionDropdown()
        else
          # if nothing left to select close
          @close()
          @search.width 10
      # since its not possible to select an element that has already been
      # added we do not need to check if this is a new element before firing change
      @triggerChange added: data
      if !options or !options.noFocus
        @focusSearch()
      return
    cancel: ->
      @close()
      @focusSearch()
      return
    addSelectedChoice: (data) ->
      enableChoice = !data.locked
      enabledItem = $('<li class=\'select2-search-choice\'>' + '    <div></div>' + '    <a href=\'#\' class=\'select2-search-choice-close\' tabindex=\'-1\'></a>' + '</li>')
      disabledItem = $('<li class=\'select2-search-choice select2-locked\'>' + '<div></div>' + '</li>')
      choice = if enableChoice then enabledItem else disabledItem
      id = @id(data)
      val = @getVal()
      formatted = undefined
      cssClass = undefined
      formatted = @opts.formatSelection(data, choice.find('div'), @opts.escapeMarkup)
      if formatted != undefined
        choice.find('div').replaceWith $('<div></div>').html(formatted)
      cssClass = @opts.formatSelectionCssClass(data, choice.find('div'))
      if cssClass != undefined
        choice.addClass cssClass
      if enableChoice
        choice.find('.select2-search-choice-close').on('mousedown', killEvent).on('click dblclick', @bind((e) ->
          if !@isInterfaceEnabled()
            return
          @unselect $(e.target)
          @selection.find('.select2-search-choice-focus').removeClass 'select2-search-choice-focus'
          killEvent e
          @close()
          @focusSearch()
          return
        )).on 'focus', @bind(->
          if !@isInterfaceEnabled()
            return
          @container.addClass 'select2-container-active'
          @dropdown.addClass 'select2-drop-active'
          return
        )
      choice.data 'select2-data', data
      choice.insertBefore @searchContainer
      val.push id
      @setVal val
      return
    unselect: (selected) ->
      val = @getVal()
      data = undefined
      index = undefined
      selected = selected.closest('.select2-search-choice')
      if selected.length == 0
        throw 'Invalid argument: ' + selected + '. Must be .select2-search-choice'
      data = selected.data('select2-data')
      if !data
        # prevent a race condition when the 'x' is clicked really fast repeatedly the event can be queued
        # and invoked on an element already removed
        return
      evt = $.Event('select2-removing')
      evt.val = @id(data)
      evt.choice = data
      @opts.element.trigger evt
      if evt.isDefaultPrevented()
        return false
      while (index = indexOf(@id(data), val)) >= 0
        val.splice index, 1
        @setVal val
        if @select
          @postprocessResults()
      selected.remove()
      @opts.element.trigger
        type: 'select2-removed'
        val: @id(data)
        choice: data
      @triggerChange removed: data
      true
    postprocessResults: (data, initial, noHighlightUpdate) ->
      val = @getVal()
      choices = @results.find('.select2-result')
      compound = @results.find('.select2-result-with-children')
      self = this
      choices.each2 (i, choice) ->
        id = self.id(choice.data('select2-data'))
        if indexOf(id, val) >= 0
          choice.addClass 'select2-selected'
          # mark all children of the selected parent as selected
          choice.find('.select2-result-selectable').addClass 'select2-selected'
        return
      compound.each2 (i, choice) ->
        # hide an optgroup if it doesn't have any selectable children
        if !choice.is('.select2-result-selectable') and choice.find('.select2-result-selectable:not(.select2-selected)').length == 0
          choice.addClass 'select2-selected'
        return
      if @highlight() == -1 and noHighlightUpdate != false and @opts.closeOnSelect == true
        self.highlight 0
      #If all results are chosen render formatNoMatches
      if !@opts.createSearchChoice and !choices.filter('.select2-result:not(.select2-selected)').length > 0
        if !data or data and !data.more and @results.find('.select2-no-results').length == 0
          if checkFormatter(self.opts.formatNoMatches, 'formatNoMatches')
            @results.append '<li class=\'select2-no-results\'>' + evaluate(self.opts.formatNoMatches, self.opts.element, self.search.val()) + '</li>'
      return
    getMaxSearchWidth: ->
      @selection.width() - getSideBorderPadding(@search)
    resizeSearch: ->
      minimumWidth = undefined
      left = undefined
      maxWidth = undefined
      containerLeft = undefined
      searchWidth = undefined
      sideBorderPadding = getSideBorderPadding(@search)
      minimumWidth = measureTextWidth(@search) + 10
      left = @search.offset().left
      maxWidth = @selection.width()
      containerLeft = @selection.offset().left
      searchWidth = maxWidth - (left - containerLeft) - sideBorderPadding
      if searchWidth < minimumWidth
        searchWidth = maxWidth - sideBorderPadding
      if searchWidth < 40
        searchWidth = maxWidth - sideBorderPadding
      if searchWidth <= 0
        searchWidth = minimumWidth
      @search.width Math.floor(searchWidth)
      return
    getVal: ->
      val = undefined
      if @select
        val = @select.val()
        if val == null then [] else val
      else
        val = @opts.element.val()
        splitVal val, @opts.separator, @opts.transformVal
    setVal: (val) ->
      unique = undefined
      if @select
        @select.val val
      else
        unique = []
        # filter out duplicates
        $(val).each ->
          if indexOf(this, unique) < 0
            unique.push this
          return
        @opts.element.val if unique.length == 0 then '' else unique.join(@opts.separator)
      return
    buildChangeDetails: (old, current) ->
      `var old`
      `var current`
      current = current.slice(0)
      old = old.slice(0)
      # remove intersection from each array
      while i < current.length
        j = 0
        while j < old.length
          if equal(@opts.id(current[i]), @opts.id(old[j]))
            current.splice i, 1
            if i > 0
              i--
            old.splice j, 1
            j--
          j++
        i++
      {
        added: current
        removed: old
      }
    val: (val, triggerChange) ->
      oldData = undefined
      self = this
      if arguments.length == 0
        return @getVal()
      oldData = @data()
      if !oldData.length
        oldData = []
      # val is an id. !val is true for [undefined,null,'',0] - 0 is legal
      if !val and val != 0
        @opts.element.val ''
        @updateSelection []
        @clearSearch()
        if triggerChange
          @triggerChange
            added: @data()
            removed: oldData
        return
      # val is a list of ids
      @setVal val
      if @select
        @opts.initSelection @select, @bind(@updateSelection)
        if triggerChange
          @triggerChange @buildChangeDetails(oldData, @data())
      else
        if @opts.initSelection == undefined
          throw new Error('val() cannot be called if initSelection() is not defined')
        @opts.initSelection @opts.element, (data) ->
          ids = $.map(data, self.id)
          self.setVal ids
          self.updateSelection data
          self.clearSearch()
          if triggerChange
            self.triggerChange self.buildChangeDetails(oldData, self.data())
          return
      @clearSearch()
      return
    onSortStart: ->
      if @select
        throw new Error('Sorting of elements is not supported when attached to <select>. Attach to <input type=\'hidden\'/> instead.')
      # collapse search field into 0 width so its container can be collapsed as well
      @search.width 0
      # hide the container
      @searchContainer.hide()
      return
    onSortEnd: ->
      val = []
      self = this
      # show search and move it to the end of the list
      @searchContainer.show()
      # make sure the search container is the last item in the list
      @searchContainer.appendTo @searchContainer.parent()
      # since we collapsed the width in dragStarted, we resize it here
      @resizeSearch()
      # update selection
      @selection.find('.select2-search-choice').each ->
        val.push self.opts.id($(this).data('select2-data'))
        return
      @setVal val
      @triggerChange()
      return
    data: (values, triggerChange) ->
      self = this
      ids = undefined
      old = undefined
      if arguments.length == 0
        return @selection.children('.select2-search-choice').map(->
          $(this).data 'select2-data'
        ).get()
      else
        old = @data()
        if !values
          values = []
        ids = $.map(values, (e) ->
          self.opts.id e
        )
        @setVal ids
        @updateSelection values
        @clearSearch()
        if triggerChange
          @triggerChange @buildChangeDetails(old, @data())
      return
  )

  $.fn.select2 = ->
    args = Array::slice.call(arguments, 0)
    opts = undefined
    select2 = undefined
    method = undefined
    value = undefined
    multiple = undefined
    allowedMethods = [
      'val'
      'destroy'
      'opened'
      'open'
      'close'
      'focus'
      'isFocused'
      'container'
      'dropdown'
      'onSortStart'
      'onSortEnd'
      'enable'
      'disable'
      'readonly'
      'positionDropdown'
      'data'
      'search'
    ]
    valueMethods = [
      'opened'
      'isFocused'
      'container'
      'dropdown'
    ]
    propertyMethods = [
      'val'
      'data'
    ]
    methodsMap = search: 'externalSearch'
    @each ->
      if args.length == 0 or typeof args[0] == 'object'
        opts = if args.length == 0 then {} else $.extend({}, args[0])
        opts.element = $(this)
        if opts.element.get(0).tagName.toLowerCase() == 'select'
          multiple = opts.element.prop('multiple')
        else
          multiple = opts.multiple or false
          if 'tags' of opts
            opts.multiple = multiple = true
        select2 = if multiple then new (window.Select2['class'].multi) else new (window.Select2['class'].single)
        select2.init opts
      else if typeof args[0] == 'string'
        if indexOf(args[0], allowedMethods) < 0
          throw 'Unknown method: ' + args[0]
        value = undefined
        select2 = $(this).data('select2')
        if select2 == undefined
          return
        method = args[0]
        if method == 'container'
          value = select2.container
        else if method == 'dropdown'
          value = select2.dropdown
        else
          if methodsMap[method]
            method = methodsMap[method]
          value = select2[method].apply(select2, args.slice(1))
        if indexOf(args[0], valueMethods) >= 0 or indexOf(args[0], propertyMethods) >= 0 and args.length == 1
          return false
          # abort the iteration, ready to return first matched value
      else
        throw 'Invalid arguments to select2 plugin: ' + args
      return
    if value == undefined then this else value

  # plugin defaults, accessible to users
  $.fn.select2.defaults =
    width: 'copy'
    loadMorePadding: 0
    closeOnSelect: true
    openOnEnter: true
    containerCss: {}
    dropdownCss: {}
    containerCssClass: ''
    dropdownCssClass: ''
    formatResult: (result, container, query, escapeMarkup) ->
      markup = []
      markMatch @text(result), query.term, markup, escapeMarkup
      markup.join ''
    transformVal: (val) ->
      $.trim val
    formatSelection: (data, container, escapeMarkup) ->
      if data then escapeMarkup(@text(data)) else undefined
    sortResults: (results, container, query) ->
      results
    formatResultCssClass: (data) ->
      data.css
    formatSelectionCssClass: (data, container) ->
      undefined
    minimumResultsForSearch: 0
    minimumInputLength: 0
    maximumInputLength: null
    maximumSelectionSize: 0
    id: (e) ->
      if e == undefined then null else e.id
    text: (e) ->
      if e and @data and @data.text
        if $.isFunction(@data.text)
          @data.text e
        else
          e[@data.text]
      else
        e.text
    matcher: (term, text) ->
      stripDiacritics('' + text).toUpperCase().indexOf(stripDiacritics('' + term).toUpperCase()) >= 0
    separator: ','
    tokenSeparators: []
    tokenizer: defaultTokenizer
    escapeMarkup: defaultEscapeMarkup
    blurOnChange: false
    selectOnBlur: false
    adaptContainerCssClass: (c) ->
      c
    adaptDropdownCssClass: (c) ->
      null
    nextSearchTerm: (selectedObject, currentSearchTerm) ->
      undefined
    searchInputPlaceholder: ''
    createSearchChoicePosition: 'top'
    shouldFocusInput: (instance) ->
      # Attempt to detect touch devices
      supportsTouchEvents = 'ontouchstart' of window or navigator.msMaxTouchPoints > 0
      # Only devices which support touch events should be special cased
      if !supportsTouchEvents
        return true
      # Never focus the input if search is disabled
      if instance.opts.minimumResultsForSearch < 0
        return false
      true
  $.fn.select2.locales = []
  $.fn.select2.locales['en'] =
    formatMatches: (matches) ->
      if matches == 1
        return 'One result is available, press enter to select it.'
      matches + ' results are available, use up and down arrow keys to navigate.'
    formatNoMatches: ->
      'No matches found'
    formatAjaxError: (jqXHR, textStatus, errorThrown) ->
      'Loading failed'
    formatInputTooShort: (input, min) ->
      n = min - (input.length)
      'Please enter ' + n + ' or more character' + (if n == 1 then '' else 's')
    formatInputTooLong: (input, max) ->
      n = input.length - max
      'Please delete ' + n + ' character' + (if n == 1 then '' else 's')
    formatSelectionTooBig: (limit) ->
      'You can only select ' + limit + ' item' + (if limit == 1 then '' else 's')
    formatLoadMore: (pageNumber) ->
      'Loading more results…'
    formatSearching: ->
      'Searching…'
  $.extend $.fn.select2.defaults, $.fn.select2.locales['en']
  $.fn.select2.ajaxDefaults =
    transport: $.ajax
    params:
      type: 'GET'
      cache: false
      dataType: 'json'
  # exports
  window.Select2 =
    query:
      ajax: ajax
      local: local
      tags: tags
    util:
      debounce: debounce
      markMatch: markMatch
      escapeMarkup: defaultEscapeMarkup
      stripDiacritics: stripDiacritics
    'class':
      'abstract': AbstractSelect2
      'single': SingleSelect2
      'multi': MultiSelect2
  return
) jQuery

# ---
# generated by js2coffee 2.0.4
