
MiniatureHipster = {}
MiniatureHipster.VERSION = "0.0.34b"
MiniatureHipster.LICENSE =
  "//github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt"

# Built-in file header.
header = """
 ###
 * @name      Miniature Hipster
 * @author    Rob Friedman
 * @url       http://playerx.net
 * @copyright #{new Date().getFullYear()} Rob Friedman
 * @license   #{MiniatureHipster.LICENSE}
 ###
"""


#helpers.extend
#helpers.extend global
###
# INCLUDES
###
coffee    = require 'coffee-script'
fs        = require 'fs'
path = require 'path'
util      = require 'util'
{exec}    = require 'child_process'

#minify
UglifyJS = require("uglify-js")

###
#
# cake bake,
#
# watchAll files
#
# test changes, lint
#
# Compile coffeescript for changed files
#
# Compress changed files
#
# Stitch .js
#
# Compress again?
#
# cake frosting
#
#   same as above, minus compressing
#
###


## output when run
#console.log coffee.compile header, bare:on

###
# FILE ARRAYS
#     file arrangements
###

## Files which should be watched
projectFiles = [
  'Cakefile'
  'cloudflare.json'
  'package.json'
  'src/coffeescripts/testApp.coffee'
  'src/coffeescripts/piwik_analytics/config.coffee'
  'src/coffeescripts/piwik_analytics/multi_config.coffee'
]

## Files which are compiled into our application file
# dependency order matters!
appFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'coffeescripts/piwik_analytics/perf'
  'coffeescripts/piwik_analytics/tracker'   # set the tracker
  'coffeescripts/piwik_analytics/main'
  'coffeescripts/piwik_analytics/showPerf'
]


###
# Tasks
###

task 'say:hello', 'Description of task', -> console.log 'Hello World!'

task 'all',' do all(buildApp->minify) the tasks!', -> buildApp -> minify1()

task 'buildApp', 'Build single application and support files from source', -> buildApp()

task 'minify', 'Minify the resulting application file after compile', -> minify1()

task 'bake', 'Bake the cake, aka watchAll.', -> invoke 'watchAll'

task 'watchAll', 'Invoke "all" and watch for project file changes.', ->
  watchAll()

###
#
#  HELPERS
#
###
# ANSI Terminal Colors.
bold = red = green = reset = ''
unless process.env.NODE_DISABLE_COLORS
  bold  = '\x1B[0;1m'
  red   = '\x1B[0;31m'
  green = '\x1B[0;32m'
  reset = '\x1B[0m'

# Log a message with a color.
log = (message="What no message?", color=reset, explanation="You got some splaining to do.") ->
  console.log color + message + reset + ' ' + (explanation or '')

watchAll = (callback) ->
  invoke 'all'
  log "Watching for project changes", green
  watchProjectFiles watchAppFiles callback


watchProjectFiles = (callback) ->
  ## watch the projectFiles
  for file in projectFiles then do (file) ->
    log "watching "+"#{file}", reset
    fs.watchFile "#{file}", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        log "Changed #{file}", bold
        if file is "Cakefile"
          throw log "!!!!Restart 'cake bake'!!", red
        # should be better way to rebuild only what is changed
        # the appFiles has more.
        log 'Rebuilding all.', green
        invoke 'all'

watchAppFiles = (callback) ->
  ## watch the appFiles
  for file in appFiles then do (file) ->
    log "watching "+"src/#{file}.coffee", reset
    fs.watchFile "src/#{file}.coffee", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        util.log "Changed #{file}"
        log 'Rebuilding all.'
        invoke 'all'


###
# compileCoffee filename using src and dest defaults is needed
###
compileCoffee =
  ( filename , src='src/coffeescripts/', dest='public/javascripts/', callback ) ->
    log "Compiling #{filename}", green
    coffee_src = fs.readFileSync((src+filename+'.coffee'), 'utf8')
    # compile the coffee_src into js_src using bare option
    try
      js_src = coffee.compile coffee_src, bare: on
    catch e
      log("!!!    -----  uhoh! ",red,e)
    #fs.writeFileSync (dest+filename).replace(/\.coffee$/, '.js'), js_src
    fs.writeFileSync (dest+filename)+'.js', js_src
    callback?()



###
# minify the application
###
minify1 = (code, callback) ->
  header=coffee.compile header, bare:on
  log "hot minifier", red+bold
  options = {}
  filename=code || "public/javascripts/piwik_analytics.js"
  if filename.indexOf(".js")
    console.log "filename is #{filename}"
    minFilename = filename.replace ".js", ".min.js"
    console.log "minFilename is #{minFilename}"
    code=fs.readFileSync(filename)
  
  result = UglifyJS.minify(filename,options)
  #console.log(result.code)

  #result = UglifyJS.minify(code, options)
  code = result.code

  #code = UglifyJs.gen_code uglify.ast_squeeze uglify.ast_mangle ast, extra: yes
  fs.writeFileSync minFilename, header + '\n' + code
  callback?()


minify2 = (callback) ->
  log "minify the stuff", bold
  # minify compiled piwik_analytics.js file into the output file
  cmd="""uglifyjs public/javascripts/piwik_analytics.js \
     --verbose --lint --stats  --comments --no-dead-code \
     --compress hoist_vars=false,squeeze:true,dead_code:true \
     --mangle mangle:true,squeeze:true,dead_code:true,show_copyright:true,unsafe:true,lift-vars:true \
     -m mangle-toplevel:true mangle:true \
     >public/javascripts/piwik_analytics.min.js
     """
  exec cmd, (err, stdout, stderr) ->
    throw err if err
    log stdout + stderr, red
    callback?()


###
#buildApp
# compile the application and it's components
# concatenating files, and building development confgs
###
buildApp = (callback) ->
  log "compile the dev config and testApp", green+bold

  compileCoffee 'piwik_analytics/config'
  compileCoffee 'piwik_analytics/multi_config'

  compileCoffee 'testApp'

  log "concatenate app",green
  # add one to the length of the size of the appContents
  appContents = new Array remaining = (1+ appFiles.length)
  # append the header in position zero of the array
  appContents[0]=header

  for file, index in appFiles then do (file, index) ->
    log "#{index} and #{file}", red
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index+1] = fileContents
      ## process when 1, because we add header
      process() if --remaining is 1

  ###
# process
  ###
  process = ->
    log "concatenated! Now processing!", green+bold
    # join the file contents and output to coffee script for compiling.
    fs.writeFile 'src/coffeescripts/piwik_analytics.coffee',appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      # compile the coffeescript
      compileCoffee("piwik_analytics")
      fs.unlink 'src/coffeescripts/piwik_analytics.coffee', (err) ->
        throw err if err
        log 'Done.'
        callback?()


minify = (callback) ->
  log "minify the stuff", bold+green
  # minify compiled piwik_analytics.js file into the output file
  exec 'uglifyjs public/javascripts/piwik_analytics.js --lint --stats --comments --compress --mangle --reserved "__console"  >public/javascripts/piwik_analytics.min.js', (err, stdout, stderr) ->
    throw err if err
    log stdout + stderr
    log "minified done"
    callback?()



option '-c', '--compile', 'compile to JavaScript and save as .js files'
option '-o', '--output [DIR]', 'directory for compiled code'
option '-s', '--source [DIR]', 'directory or file to compile'
option '-b', '--bare', 'compile without a top-level function wrapper'
option '-t', '--tokens', 'print out the tokens that the lexer/rewriter produce'
option '-w', '--watch', 'watch scripts for changes and rerun commands'

