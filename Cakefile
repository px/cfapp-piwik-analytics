coffee    = require 'coffee-script'
fs        = require 'fs'
path = require 'path'
util      = require 'util'
{exec}    = require 'child_process'
{spawn}   = require 'child_process'



existsSync   = fs.existsSync or path.existsSync

tasks     = {}
options   = {}
switches  = []
oparse    = null

MiniatureHipster = {}
MiniatureHipster.VERSION = "0.0.34b"
MiniatureHipster.LICENSE =
  "//github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt"

# Built-in file header.
header = """
 ###
 * @name      Miniature Hipster
 * @version   #{MiniatureHipster.VERSION}
 * @author    Rob Friedman
 * @url       http://playerx.net
 * @license   #{MiniatureHipster.LICENSE}
 ###
"""

console.log header


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
  'coffeescripts/main'
  'coffeescripts/piwik_analytics/showPerf'
]


###
# Tasks
###

task 'all',' do all(buildApp->minify) the tasks!', -> buildApp -> minify()

task 'buildApp', 'Build single application and support files from source', -> buildApp()

task 'minify', 'Minify the resulting application file after compile', -> minify()


###
# compileCoffee filename using src and dest defaults is needed
###
compileCoffee =
  ( filename , src='src/coffeescripts/', dest='public/javascripts/' ) ->
    console.log "Compiling #{filename}."
    coffee_src = fs.readFileSync((src+filename+'.coffee'), 'utf8')
    # compile the coffee_src into js_src using bare option
    js_src = coffee.compile coffee_src, bare: on
    #fs.writeFileSync (dest+filename).replace(/\.coffee$/, '.js'), js_src
    fs.writeFileSync (dest+filename)+'.js', js_src


###
#buildApp
# compile the application and it's components
# concatenating files, and building development confgs
###
buildApp = (callback) ->
  console.log "compile the dev config and testApp"

  compileCoffee 'piwik_analytics/config'
  compileCoffee 'piwik_analytics/multi_config'

  compileCoffee 'testApp'

  console.log "concatenate app"
  # add one to the length of the size of the appContents
  appContents = new Array remaining = (1+ appFiles.length)
  # append the header in position zero of the array
  appContents[0]=header

  for file, index in appFiles then do (file, index) ->
    console.log "#{index} and #{file}"
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index+1] = fileContents
      ## process when 1, because we add header
      process() if --remaining is 1

  process = ->
    console.log ("concatendated! Now processing!")
    fs.writeFile 'src/coffeescripts/piwik_analytics.coffee',appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      compileCoffee("piwik_analytics")
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


#helpers.extend
#helpers.extend global

option '-c', '--compile', 'compile to JavaScript and save as .js files'
option '-o', '--output [DIR]', 'directory for compiled code'
option '-s', '--source [DIR]', 'directory or file to compile'
option '-b', '--bare', 'compile without a top-level function wrapper'
option '-t', '--tokens', 'print out the tokens that the lexer/rewriter produce'
option '-w', '--watch', 'watch scripts for changes and rerun commands'

task 'say:hello', 'Description of task', ->
  console.log 'Hello World!'

task 'bake', 'Bake the cake, aka watchAll.', -> invoke 'watchAll'

task 'watchAll', 'Invoke "all" and watch for project file changes.', ->
  watchAll()

watchAll = (callback) ->
  invoke 'all'
  util.log "Watching for project changes"

  ## watch the projectFiles
  for file in projectFiles then do (file) ->
    console.log ("watching "+"#{file}")
    fs.watchFile "#{file}", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        util.log "Changed #{file}"
        console.error("!!!!Restart cake watch!!") if file is "Cakefile"
        # should be better way to rebuild only what is changed
        # the appFiles has more.
        console.log 'Rebuilding all.'
        invoke 'all'

  ## watch the appFiles
  for file in appFiles then do (file) ->
    #console.log ("watching "+"src/#{file}.coffee")
    fs.watchFile "src/#{file}.coffee", (curr, prev) ->
      if +curr.mtime isnt +prev.mtime
        util.log "Changed #{file}"
        console.log 'Rebuilding all.'
        invoke 'all'

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
