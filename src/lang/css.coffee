#
# The CSS/SASS highlighter
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Colorifer.css = Colorifer.sass = new Class Colorifer,

  comments: "/* */"
  booleans: "collapse,solid,dotted,dashed,none,auto,url,any,block,normal,"+
            "italic,bold,unerline,inherit,inline,inline-block,inset,outset,"+
            "hidden,visible,no-repeat,center,left,top,bottom,right"

  paint: (text)->
    text = @_comments(text)
    text = @_strings(text)
    text = @_properties(text)
    text = @_numbers(text)
    text = @_keywords(text)
    text = @_selectors(text)

    @_rollback(text)

# protected

  # painting the css-property names
  _properties: (text)->
    @_prepare(text, [
      [/([^a-z\-])([a-z\-]+?)(\s*:)/g, "attribute", "$1 $3"]
    ])

  # painting the css-selectors
  _selectors: (text)->
    @_prepare(text, [
      [/([^a-z_\-0-9\.])([a-z]+?)(?![a-z_\-0-9\.=\^|])/ig, "keyword", "$1 "]
      [/(^|.)(#[a-z\-0-9\_]+)/ig,  "unit", "$1 "]
      [/(^|.)(\.[a-z\-0-9\_]+)/ig, "method", "$1 "]
    ])

  # painting the numbers and all sorts of sizes
  _numbers: (text)->
    @_prepare(text, [
      [/([^'"\d\w\.])(\-?[0-9]*\.?[0-9]+[a-z]*)(?!['"\d\w\.])/g, "integer",   "$1 "]
    ])