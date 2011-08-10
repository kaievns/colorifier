#
# Project's main unit
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class Colorifer
  extend:
    # Default options
    Options:
      tag:     'pre'
      attr:    'data-lang'

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


  #
  # Default constructor
  #
  # @param {dom.Element}
  # @return {Colorifer} new
  #
  constructor: (element)->
    return # nothing