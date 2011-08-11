#
# The coffee script highlighter
#
# Copyright (C) 2011 Nikolay Nemshilov
#
Colorifer.coffee = Colorifer.coffeescript = new Class Colorifer,

  comments: '#'
  keywords: "function,return,for,if,else,while,do,throw,try,catch,instanceof,class,extends,in,of,where,super"
  objects:  "new,this,self"
  booleans: "true,false,null,undefined"

  paint: (text)->
    text = @$super text, (text)->
      text.replace /(^|.)(@[a-z0-9_]+)/ig, (m, _1, _2)->
        "#{_1}<span class=\"property\">#{_2}</span>"

    # painting object properties
