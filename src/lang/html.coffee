#
# HTML/XML highlighter
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Colorifier.html = Colorifier.xml = new Class Colorifier,
  comments: "&lt;!-- --&gt;"

  paint: (text)->
    text = @_comments(text)
    text = @_embedded(text)
    text = @_strings(text)
    text = @_tags(text)

    @_rollback(text)

# protected

  # painting embedded javascript/css
  _embedded: (text)->
    @___ or= []
    tokens = @___

    js     = new Colorifier.js()
    css    = new Colorifier.css()

    text = text.replace /(&lt;script.*?&gt;)([\s\S]*?)(&lt;\/script&gt;)/ig, (m, _1, _2, _3)->
      tokens.push(js.paint(_2))
      "#{_1}___dummy_#{tokens.length}___#{_3}"

    text = text.replace /(&lt;style.*?&gt;)([\s\S]+?)(&lt;\/style&gt;)/ig, (m, _1, _2, _3)->
      tokens.push(css.paint(_2))
      "#{_1}___dummy_#{tokens.length}___#{_3}"

    text

  # painting the tags and attributes
  _tags: (text)->
    @_prepare(text, [
      [/(&lt;[\/]*)([a-z]+)/ig, "keyword", "$1 "],
      [/(\s+)([a-z]+)(=)/ig, "float", "$1 $3"]
    ])