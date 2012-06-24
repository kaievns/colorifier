# Colorifier

Colorifier is a code highlighting tool for [Lovely.IO](http://lovely.io)

By default it doesn't require any configuration, just include the script on
your page, or hook it up with `Lovely`. Once the document body is loaded it
will automatically search for things like that

    :html
    <pre data-lang="language">
      // some code in here
    </pre>



## Configuration

There are a bunch of options you might change if you like

    :javascript
    Lovely(['colorifier'], function(Colorifier) {
      Colorifier.Options.tag    = 'pre';       // the tag name of the target elements
      Colorifier.Options.attr   = 'data-lang'; // the attribute with language
      Colorifier.Options.theme  = 'light';     // the color theme to use ('light' or 'dark')
      Colorifier.Options.gutter = true;        // show/hide the gutter
      Colorifier.Options.trim   = false;       // trim trailing spaces or not

      Colorifier.initialize();                 // reinitializing with new settings
    });

You also can use per unit configuration via the `data-colorifier` attributes

    :html
    <pre data-lang="ruby" data-colorifier='{"gutter": false}'>
      # some code in here
    </pre>

__NOTE__ the value of the attribute should be a properly formatted JSON data


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011-2012 Nikolay Nemshilov