#
# Colorifer main file
#
# Copyright (C) 2011 Nikolay Nemshilov
#

# hook up dependencies
core    = require('core')
$       = require('dom')

# local variables assignments
ext     = core.ext
Class   = core.Class
Element = $.Element

# a quick re-escape
escape = (str)->
  str.replace(/([.*+?\^=!:${}()|\[\]\/\\])/g, '\\$1')

# glue in your files
include 'src/colorifer'
include 'src/lang/javascript'
include 'src/lang/css'
include 'src/lang/html'
include 'src/lang/coffeescript'

$(Colorifer.initialize); # kick in when page's loaded

# export your objects in the module
exports = ext Colorifer,
  version: '%{version}'