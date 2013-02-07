
fs = require 'fs'
path = require 'path'

existsSync   = fs.existsSync or path.existsSync

tasks     = {}
options   = {}
switches  = []
oparse    = null

#helpers.extend
#helpers.extend global

option '-c', '--compile', 'compile to JavaScript and save as .js files'
option '-o', '--output [DIR]', 'directory for compiled code'
option '-s', '--source [DIR]', 'directory or file to compile'
option '-b', '--bare', 'compile without a top-level function wrapper'
option '-t', '--tokens', 'print out the tokens that the lexer/rewriter produce'
option '-w', '--watch', 'watch scripts for changes and rerun commands'

task 'watch', 'watch for changes and recompile into public', (options) ->
  dir  = options.output or 'public/javascripts'

{spawn} = require 'child_process'
task 'watch', -> spawn 'coffee', ['-cw', 'js'], customFds: [0..2]


# printTasks = ->
#   relative = path.relative or path.resolve
#   cakefilePath = path.join relative(__originalDirname, process.cwd()), 'Cakefile'
#   console.log "#{cakefilePath} defines the following tasks:\n"
#   for name, task of tasks
#      spaces = 20 - name.length
#      spaces = if spaces > 0 then Array(spaces + 1).join(' ') else ''
#      desc   = if task.description then "# #{task.description}" else ''
#      console.log "cake #{name}#{spaces} #{desc}"
#      console.log oparse.help() if switches.length
