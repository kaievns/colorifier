#
# Bash/Console/Terminal script highlighter
#
# Copyright (C) 2013 Nikolay Nemshilov
#
Colorifier.bash = Colorifier.console = Colorifier.terminal = Colorifier.inherit

  keywords: "echo,if,endif"

  paint: (text, callback)->
    text = @_keywords(text)

    text = callback.call(@, text) if callback

    @_rollback(text)
