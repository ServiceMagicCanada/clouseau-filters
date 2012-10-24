EventEmitter = require( 'events').EventEmitter
http = require 'http'

dispatch = new EventEmitter()
  
  
getBios = ( urls, callback, bios=[], index=0 )->
  if !urls or index >= urls.length then return callback( null, bios )
  
  url = urls[index]
  screename = url.match( /(\w+)$/ )
  
  if !screename then return getBios( urls, callback, bios, index+1 )
  else screename = screename[0]
  options = {
    host: 'api.twitter.com'
    port: 80
    method: 'GET'
    path: "/1/users/show.json?screen_name=#{screename}"
  }
  req = http.request options, ( res )-> 
    if res.statusCode is 200
     body = ''
     res.setEncoding 'utf8'
     res.on 'data', ( chunk )-> 
       body += chunk
     res.on 'end', (  )->
       try
         json = JSON.parse body
         bios.push json.description
       catch E
         console.log "JSON PARSER ERROR. Got response:", body
       finally
         getBios( urls, callback, bios, index+1 )
    else return getBios( urls, callback, bios, index+1 )    
  req.on 'error', -> 
    return callback( error )
  req.end()
  
module.exports=
  validate: ( object, meta )->
    meta.website_twitter isnt undefined
  filter: ( object, meta, callback )->
    getBios meta.website_twitter, ( error, bios )->
      if error then return callback( error )
      callback( null, twitter_bio: bios)
    
