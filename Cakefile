
fs = require 'fs'
path         = require 'path'

existsSync   = fs.existsSync or path.existsSync

tasks     = {}
options   = {}
switches  = []
oparse    = null

helpers.extend global,


  option '-o', '--output [DIR]', 'directory for compiled code'

  task 'watch', 'watch for changes and recompile into public', (options) ->

    dir  = options.output or 'public/javascripts'

