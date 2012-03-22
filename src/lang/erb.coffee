#
# Rails Embedded Ruby support
#
# Copyright (C) 2012 Nikolay Nemshilov
#
Colorifier.erb = new Class Colorifier.html,

  paint: (text)->
    @$super text, (text)->
      console.log(text)
      @_ruby(text)

  _ruby: (text)->
    @___ or= []
    tokens = @___

    text.replace /(&lt;%)([\s\S]*?)(%&gt;)/ig, (m, _1, _2, _3)->
      tokens.push(ruby.paint(_2))
      "#{_1}___dummy_#{tokens.length}___#{_3}"


ruby  = new Colorifier.ruby()