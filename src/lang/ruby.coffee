#
# Ruby/Rails colorifier
#
# Copyright (C) 2012 Nikolay Nemshilov
#
Colorifier.ruby = Colorifier.rails = new Class Colorifier,
  comments: '=begin =end,#'
  keywords: 'class,module,def,do,end,if,unless,else,elsif,when,case,for,while,begin,rescue,raise,return,try,catch'
  booleans: 'true,false,nil'
  objects:  'public,protected,private'

  paint: (text)->
    @$super text, (text)->
      text = @_symbols(text)
      text = @_variables(text)


# private

  _symbols: (text)->
    @_prepare(text, [
      [/([^'"\d\w\.])(:[\a-z_]+)(?!['"\d\w\.])/ig, "boolean", "$1 "]
      [/([^'"\d\w\.])([\a-z_]+:)(?!['"\d\w\.])/ig, "boolean",   "$1 "]
    ])

  _variables: (text)->
    @_prepare(text, [
      [/([^'"\d\w])(@[\a-z_]+)(?!['"\d\w])/ig, "property", "$1 "]
    ])