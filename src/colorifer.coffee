#
# Project's main unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Colorifer extends Element
  extend:
    # Default options
    Options:
      tag:    'pre'
      attr:   'data-lang'
      scheme: 'default'

    # mass-initializer
    initialize: (element)->
      if element && (element = $(element))
        element = element[0] if element instanceof $.Search
        if lang = element.attr(Colorifer.Options.attr)
          if color = Colorifer[lang]
            if !element._color
              element._color = new color(element);
      else
        $("#{Colorifer.Options.tag}[#{Colorifer.Options.attr}]"
        ).forEach Colorifer.initialize


  # fallback markers
  comments: ""
  strings:  ""
  keywords: ""
  objects:  ""
  booleans: ""
  regexps:  [/([^\*\\\/;])(\/[^\*\/][^\n]*?[^\*\n\\](?!\\\/)\/)/] # default POSIX style regexps

  #
  # Default constructor
  #
  # @param {dom.Element}
  # @return {Colorifer} new
  #
  constructor: (element)->
    super 'div', class: 'colorifer'

    @ref = element.html(this.paint(element.html()))

    @style(@ref.style("font-family font-size font-weight"))
    @insertTo(@ref, 'before').insert(@ref).addClass(Colorifer.Options.scheme)

  #
  # Paints the code according to the rules
  #
  # @param {String} original
  # @return {String} painted
  #
  paint: (text)->
    text = text.replace(/</g, '&lt;')
    text = text.replace(/>/g, '&gt;')
    text = text.replace(/(^\s+)|(\s+$)/g, '')

    text = @_comments(text,
      (text)-> @_strings(text,
      (text)-> @_regexps(text,
      (text)-> @_methods(@_keywords(@_numbers(text))))))

    text


# protected

  # painting the comments
  _comments: (text, callback)->
    comments = []

    # replacing the comments with dummies
    for token in @comments.split(',')
      chunks = token.split(' ')

      if chunks[1]
        regex = new RegExp("(.?)(#{escape(chunks[0])}.*?#{escape(chunks[1])})(.*)", "mg")
      else
        regex = new RegExp("(.?)(#{escape(chunks[0])}.*?)(\n)", "g")

      text = text.replace regex, (m, _1, _2, _3)->
        comments.push("<span class=\"comment\">#{_2}</span>")
        "#{_1}___comments_#{comments.length}___#{_3}"

    text = callback.call(this, text) if callback

    @_rollback(text, comments, "comments")

  # painting the strings
  _strings: (text, callback)->
    strings = []

    for token in @strings.split(',')
      regexs = [
        new RegExp("([^\\\\])((#{escape(token)})(\\3))", 'mg')
        new RegExp("([^\\\\])((#{escape(token)}).*?[^\\\\](\\3))", "mg")
      ]

      for re in regexs
        text = text.replace re, (m, _1, _2)->
          strings.push("<span class=\"string\">#{_2}</span>")
          "#{_1}___strings_#{strings.length}___"

    text = callback.call(this, text) if callback

    @_rollback(text, strings, "strings")

  # painting the regexps
  _regexps: (text, callback)->
    regexps = []

    for re in @regexps
      text = text.replace re, (m, _1, _2)->
        regexps.push("<span class=\"regexp\">#{_2}</span>")
        "#{_1}___regexps_#{regexps.length}___"

    text = callback.call(this, text) if callback

    @_rollback(text, regexps, "regexps")

  # rollbacks the comments, strings and regexps prereplacements
  _rollback: (text, tokens, key)->
    for token, i in tokens
      text = text.replace("___#{key}_#{i+1}___", token)

    text

  _numbers: (text)->
    text = text.replace /([^'"\d\w\.])([\d]+)(?!['"\d\w\.])/g, (m, _1, _2)->
      "#{_1}<span class=\"integer\">#{_2}</span>"

    text = text.replace /([^'"\d\w\.])(\d*\.\d+)(?!['"\d\w\.])/g, (m, _1, _2)->
      "#{_1}<span class=\"float\">#{_2}</span>"

  # painting the keywords
  _keywords: (text)->
    for name in ['keyword', 'object', 'boolean']
      regexp = @[name + "s"].replace(/,/g, '|')
      regexp = new RegExp("([^a-zA-Z0-9_]|^)(#{regexp})(?![a-zA-Z0-9_])", "g")

      text = text.replace regexp, (m, _1, _2)->
        "#{_1}<span class=\"#{name}\">#{_2}</span>"

    text

  # painting attributes and methods
  _methods: (text)->
    text = text.replace /([^a-zA-Z0-9_]|^)([A-Z][a-zA-Z_0-9]+)(?![a-zA-Z0-9_])/, (m, _1, _2)->
      "#{_1}<span class=\"unit\">#{_2}</span>"

    text = text.replace /(\.)([a-z_$][a-z0-9_]*)(?![a-z0-9_\(])/i, (m, _1, _2)->
      "#{_1}<span class=\"attribute\">#{_2}</span>"

    text = text.replace /(\.)([a-z_$][a-z0-9_]*)(\()/i, (m, _1, _2, _3)->
      "#{_1}<span class=\"method\">#{_2}</span>#{_3}"

    text
