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
    });

You also can initialize colorifier at any moment with the `Colorifier.initialize()` call


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov