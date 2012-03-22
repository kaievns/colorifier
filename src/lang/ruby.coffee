#
# Ruby/Rails colorifier
#
# Copyright (C) 2012 Nikolay Nemshilov
#
Colorifier.ruby = Colorifier.rails = new Class Colorifier,
  comments: '=begin =end,#'
  keywords: 'class,module,def,do,end,if,unless,else,elsif,when,case,for,in,and,or,then,ensure,'+
            'while,begin,rescue,raise,return,try,catch,until,yield,super,break,alias,not,next'
  booleans: 'true,false,nil'
  objects:  'public,protected,private,__FILE__,__LINE__,self,include,extend'
  rails:    'render,redirect_to,respond_to,before_filter,after_filter,around_filter,'+
            # active record things
            'has_one,has_many,belongs_to,has_and_belongs_to_many,scope,'+
            'validates_acceptance_of,validates_inclusion_of,validates_associated,'+
            'validates_length_of,validates_confirmation_of,validates_numericality_of,'+
            'validates_each,validates_presence_of,validates_exclusion_of,validates_size_of,'+
            'validates_format_of,validates_uniqueness_of,attr_accessible,'+
            'before_save,before_create,before_update,before_destroy,before_validation,'+
            'after_save,after_create,after_update,after_destroy,after_validation,'+
            # active-view helpers
            'url_for,link_to,form_for,div_for,content_tag_for,content_tag,simple_format'

  paint: (text)->
    @$super text, (text)->
      text = @_symbols(text)
      text = @_variables(text)
      text = @_rails(text)


# private

  _symbols: (text)->
    @_prepare(text, [
      [/([^'"\d\w\.])(:[\a-z_]+)(?!['"\d\w\._])/ig, "boolean", "$1 "]
      [/([^'"\d\w\.])([\a-z_]+:)(?!['"\d\w\._])/ig, "boolean",   "$1 "]
    ])

  _variables: (text)->
    @_prepare(text, [
      [/([^'"\d\w])(@[\a-z_]+)(?!['"\d\w_])/ig, "property", "$1 "]
    ])

  _rails: (text)->
    replacements = []

    for token in @rails.split(',')
      replacements.push([
        new RegExp("([^'\"\\d\\w])(#{escape(token)})(?!['\"\\d\\w_])", "g"),
        'regexp', "$1 "
      ])

    @_prepare(text, replacements)