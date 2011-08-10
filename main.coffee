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

# glue in your files
include 'src/colorifer'

$(Colorifer.initialize); # kick in when page's loaded

# export your objects in the module
exports = ext Colorifer,
  version: '%{version}'