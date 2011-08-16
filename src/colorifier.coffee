#
# Project's main unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Colorifier extends Element
  extend:
    # Default options
    Options:
      tag:    'pre'        # tag name of the elements to process
      attr:   'data-lang'  # attribute that keeps the language name
      theme:  'light'      # color theme name
      gutter: true         # show or not the gutter

    # mass-initializer
    initialize: ()->
      $("#{Colorifier.Options.tag}[#{Colorifier.Options.attr}]").forEach (element)->
        if lang = element.attr(Colorifier.Options.attr)
          if color = Colorifier[lang]
            color = element.colorifier or (element.colorifier = new color(element))
            color.addClass(Colorifier.Options.theme)
      return #


  # fallback markers
  comments: ""
  strings:  "',\""
  keywords: ""
  objects:  ""
  booleans: ""
  regexps:  [/([^\*\\\/;])(\/[^\*\/][^\n]*?[^\*\n\\](?!\\\/)\/)/] # default POSIX style regexps

  #
  # Default constructor
  #
  # @param {dom.Element}
  # @return {Colorifier} new
  #
  constructor: (element)->
    return @ unless element

    super 'div', class: 'colorifier'

    text = element.html()
    text = text.replace(/</g, '&lt;')
    text = text.replace(/>/g, '&gt;')
    text = text.replace(/(^\s+)|(\s+$)/g, '')

    @ref = element.html(this.paint(text))

    @style(element.style("font-family font-size font-weight"))
    @insertTo(element, 'before')

    if Colorifier.Options.gutter
      nums = (i for line, i in text.split("\n"))
      @insert(new Element('div', class: 'gutter', html: nums.join('<br/>')))

    @insert(new Element('div', class: 'code').insert(element))
    @addClass(Colorifier.Options.theme)



  #
  # Paints the code according to the rules
  #
  # @param {String} original
  # @param {Function} additional callback
  # @return {String} painted
  #
  paint: (text, callback)->
    text = @_comments(text)
    text = @_strings(text)
    text = @_regexps(text)
    text = @_numbers(text)
    text = @_keywords(text)
    text = @_methods(text)

    text = callback.call(@, text) if callback

    @_rollback(text)


# protected

  # painting the comments
  _comments: (text, callback)->
    replacements = []

    # replacing the comments with dummies
    for token in @comments.split(',')
      chunks = token.split(' ')

      if chunks[1]
        regex = new RegExp("(.?)(#{escape(chunks[0])}.*?#{escape(chunks[1])})(.*)", "mg")
      else
        regex = new RegExp("(.?)(#{escape(chunks[0])}.*?)(\n)", "g")

      replacements.push([regex, "comment", "$1 $3"])

    @_prepare(text, replacements)

  # painting the strings
  _strings: (text, callback)->
    replacements = []

    for token in @strings.split(',')
      regexs = [
        new RegExp("([^\\\\])((#{escape(token)})(\\3))", 'mg')
        new RegExp("([^\\\\])((#{escape(token)}).*?[^\\\\](\\3))", "mg")
      ]

      for re in regexs
        replacements.push([re, "string", "$1 "])

    @_prepare(text, replacements)

  # painting the regexps
  _regexps: (text, callback)->
    replacements = []

    for re in @regexps
      replacements.push([re, "regexp", "$1 "])

    @_prepare(text, replacements)

  # painting integers and floats
  _numbers: (text)->
    @_prepare(text, [
      [/([^'"\d\w\.])([\d]+)(?!['"\d\w\.])/g,    "integer", "$1 "]
      [/([^'"\d\w\.])(\d*\.\d+)(?!['"\d\w\.])/g, "float",   "$1 "]
    ])

  # painting the keywords
  _keywords: (text)->
    reps = []

    for name in ['keyword', 'object', 'boolean']
      regexp = @[name + "s"].replace(/,/g, '|')

      if regexp # if it's not empty
        regexp = new RegExp("([^a-zA-Z0-9_]|^)(#{regexp})(?![a-zA-Z0-9_])", "g")

        reps.push([regexp, name, "$1 "])

    @_prepare(text, reps)

  # painting attributes and methods
  _methods: (text)->
    @_prepare(text, [
      [/([^a-zA-Z0-9_]|^)([A-Z][a-zA-Z_0-9]+)(?![a-zA-Z0-9_])/g, "unit",      '$1 ']
      [/(\.)([a-z_$][a-z0-9_]*)(?![a-z0-9_\(])/ig,               "attribute", '$1 ']
      [/(\.)([a-z_$][a-z0-9_]*)(\()/i,                           "method",    '$1 $3']
    ])


  # pre-replaces the text-entries with mocks so they didn't mess with the rest
  _prepare: (text, list)->
    @___ or= []
    tokens = @___

    for [re, css, dummy] in list
      text = text.replace re, (m, _1, _2, _3, _4, _5)->
        tokens.push("<span class=\"#{css}\">#{_2}</span>")
        dummy.replace(' ', "___dummy_#{tokens.length}___")
          .replace('$1', _1).replace('$3', _3).replace('$4', _4)


    text


  # rollbacks the comments, strings and regexps prereplacements
  _rollback: (text)->
    for i in [@___.length - 1..0]
      text = text.replace("___dummy_#{i+1}___", @___[i])

    text
