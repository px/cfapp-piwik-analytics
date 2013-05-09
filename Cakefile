fs     = require 'fs'
{exec} = require 'child_process'

# dependency order matters!
appFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'coffeescripts/header'
  'coffeescripts/extra_comments'
  'coffeescripts/piwik_analytics/perf'
  'coffeescripts/piwik_analytics/setup'     # use sane defaults
  'coffeescripts/piwik_analytics/tracker'   # set the tracker
#  'coffeescripts/piwik_analytics/piwik_js'  # fetch configured piwik.js
  #, and website id
  'coffeescripts/main'
  'coffeescripts/piwik_analytics/showPerf'
]

task 'all',' do all(compile->minify) the tasks!', -> compile -> minify()

task 'compile', 'Build single application file from source files', ->
  compile()

task 'minify', 'Minify the resulting application file after compile', ->
  minify()

compile = (callback) ->
  console.log "do compile!"
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'src/coffeescripts/piwik_analytics.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --lint --bare --output public/javascripts/ --compile src/coffeescripts/piwik_analytics.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'src/coffeescripts/piwik_analytics.coffee', (err) ->
          throw err if err
          console.log 'Done.'
          callback?()

minify = (callback) ->
  console.log "minify the stuff"
  # minify compiled piwik_analytics.js file into the output file
  exec 'uglifyjs public/javascripts/piwik_analytics.js --lint --stats --comments --compress --mangle --reserved "__console"  >public/javascripts/piwik_analytics.min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
    callback?()

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

task 'say:hello', 'Description of task', ->
    console.log 'Hello World!'

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
