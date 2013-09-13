
MiniatureHipster = {}
MiniatureHipster.VERSION = "0.2.4"
MiniatureHipster.LICENSE =
  "//github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt"

# Built-in file header.
header = """
 ###
 * @name      Miniature Hipster
 * @author    Rob Friedman
 * @url       http://playerx.net
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

task 'all',' do all(buildApp->minify) the tasks!', -> buildApp -> minify()

task 'buildApp', 'Build single application and support files from source', -> buildApp()

task 'minify', 'Minify the resulting application file after compile', -> minify()

task 'bake', 'Bake the cake, aka watchAll.', -> invoke 'watchAll'

task 'watchAll', 'Invoke "all" and watch for project file changes.', -> watchAll()

###
#
#  HELPERS
#
###
compiledHeader=coffee.compile header, bare:on

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

# Log a message with a color.
error = (message="What no error?", color=red, explanation="Writing errors without errors. I like your style.") ->
  console.error color + message + reset + ' ' + (explanation or '')

watchAll = (callback) ->
  invoke 'all'
  log "Watching for project changes", green, "watching _ALL_ the stuff"
  watchProjectFiles watchAppFiles callback


watchProjectFiles = (callback) ->
  ## watch the projectFiles
  for file in projectFiles then do (file) ->
    log "watching "+"#{file}", reset, "something"
    fs.watchFile "#{file}", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        log "Changed #{file}", bold, "something may happen"
        if file is "Cakefile"
          throw log "Exiting, 'cake bake'!! try this:\n ", red, "while (true) do echo waiting ;sleep 4;cake bake; echo complete; done"
          #exec 'cake bake'
        if file is "cloudflare.json"
          exec 'jsonlint cloudflare.json'
        # should be better way to rebuild only what is changed
        # the appFiles has more.
        log 'Rebuilding all.', green, "do it."
        invoke 'all'
        callback?()

watchAppFiles = (callback) ->
  ## watch the appFiles
  for file in appFiles then do (file) ->
    log "watching "+"src/#{file}.coffee", reset, "watchAppFiles"
    fs.watchFile "src/#{file}.coffee", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        util.log "Changed #{file}"
        log 'Rebuilding all.', "magic making"
        invoke 'all'
        callback?()


###
# compileCoffee filename using src and dest defaults is needed
###
compileCoffee =
  ( filename , src='src/coffeescripts/', dest='public/javascripts/', callback ) ->
    log "Compiling #{filename}", green, ""
    coffee_src = fs.readFileSync((src+filename+'.coffee'), 'utf8')
    # compile the coffee_src into js_src using bare option
    try
      js_src = coffee.compile coffee_src, bare: on
    catch e
      log "!!!    -----  uhoh! ",red,e,"WTF?!"
    #fs.writeFileSync (dest+filename).replace(/\.coffee$/, '.js'), js_src
    fs.writeFileSync (dest+filename)+'.js', js_src
    callback?()



###
# minify the application
###
minify = (code, callback) ->
  log "hot minifier",(bold+red),"making it small"
  options =
    comments:yes
    dead_code:yes
    mangle:yes
    unsafe:yes
    width:80
    max_line_len:80
    output:null
    warnings:yes
    compress:
      dead_code:yes
      drop_debugger:yes
      unsafe:yes
      comparisons:yes
      warnings:yes

  filename=code || "public/javascripts/piwik_analytics.js"
  ## so terrible
  #console.log filename.indexOf(".js"),filename.length-3
  if filename.indexOf(".js") is filename.length-3
    log "filename is #{filename}", reset, ""
    minFilename = filename.replace ".js", ".min.js"
    log "minFilename is #{minFilename}", reset,""
    code=fs.readFileSync(filename)
  
  result = UglifyJS.minify(filename,options)
  ## twice
  #result = UglifyJS.minify(result.code, fromString:true )
  #console.log(result.code)

  code = result.code

  #code = UglifyJs.gen_code uglify.ast_squeeze uglify.ast_mangle ast, extra: yes
  fs.writeFileSync minFilename, compiledHeader + code
  callback?()


###
#buildApp
# compile the application and it's components
# concatenating files, and building development confgs
###
buildApp = (callback) ->
  log "compile the dev config and testApp", bold+green, ""

  compileCoffee 'piwik_analytics/config'
  compileCoffee 'piwik_analytics/multi_config'

  compileCoffee 'testApp'

  log "concatenate app",green, ""
  # add one to the length of the size of the appContents
  appContents = new Array remaining = (1+ appFiles.length)
  # append the uncompiled header in position zero of the array
  appContents[0]=header

  for file, index in appFiles then do (file, index) ->
    log "#{index} and #{file}", red, ""
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index+1] = fileContents
      ## process when 1, because we add header
      process() if --remaining is 1

  ###
# process
  ###
  process = ->
    log "concatenated! Now processing!",bold+green,"writing!"
    # join the file contents and output to coffee script for compiling.
    fs.writeFile 'src/coffeescripts/piwik_analytics.coffee',appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      # compile the coffeescript
      compileCoffee("piwik_analytics")
      fs.unlink 'src/coffeescripts/piwik_analytics.coffee', (err) ->
        throw err if err
        log 'Done.'
        callback?()



option '-c', '--compile', 'compile to JavaScript and save as .js files'
option '-o', '--output [DIR]', 'directory for compiled code'
option '-s', '--source [DIR]', 'directory or file to compile'
option '-b', '--bare', 'compile without a top-level function wrapper'
option '-t', '--tokens', 'print out the tokens that the lexer/rewriter produce'
option '-w', '--watch', 'watch scripts for changes and rerun commands'

