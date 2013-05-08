###
 CloudFlare.push( {
  paths: {
   'piwik_analytics':
   '//labs.variablesoftware.com/test/miniature-hipster/public/javascripts/'
    } } );
###

###
# CloudFlare.push( { verbose:1 } );
###

##
# now()
#  return the window.performance.now()
#  or the getTime() for less precision on
#  browsers which are older
##

#now =->
#  fake={}
#  fake.now =->
#    new Date().getTime()
#
#  p=window.performance || window.mozPerformance ||
#    window.msPerformance || window.webkitPerformance || fake
#  try
#    p.now()
#  catch e
#    window.console.log(e)
#    fake.now() #new Date().getTime()

# set the performance function and create a timer
# wrap in try or risk failure in some browsers
#window.perfThen=now()
