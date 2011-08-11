# Colorifer

Colorifer is a code highlighting tool for [Lovely.IO](http://lovely.io)

By default it doesn't require any configuration, just include the script on
your page, or hook it up with `Lovely`. Once the document body is loaded it
will automatically search for things like that

    :html
    <pre data-lang="language">
      // some code in here
    </pre>



## Configuration

There are a bunch of options you might change if you like

    Lovely(['colorifer'], function(Colorifer) {
      Colorifer.Options.tag  = 'pre'; // the tag name of the target elements
      Colorifer.Options.attr = 'data-lang'; // the attribute with language
      Colorifer.Options.scheme = 'default'; // the color scheme to use
      Colorifer.Options.gutter = true;      // show/hide the gutter
    });

You also can initialize colorifer at any moment with the `Colorifer.initialize()` call


## Copyright And License

This project is released under the terms of the MIT license

Copyright (C) 2011 Nikolay Nemshilov