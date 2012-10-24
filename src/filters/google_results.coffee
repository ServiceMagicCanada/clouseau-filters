URL = require 'url'
invoke  = require 'ouija'
cheerio = require 'cheerio'


fetchGoogleResults = ( query, callback )->
  query      = encodeURIComponent query 
  resultsurl = "https://www.google.ca/search?q=#{query}&cad=h"
  invoke resultsurl, ['html'], ( error, html )->
    if error then return callback error
    try
      $ = cheerio.load( html ) 
      data = $('li.g').map -> 
        $it = $(this)
        title: $it.find('.r').text()
        desc:  $it.find('.st').text()
        source: $it.find('.r a').attr('href')
    catch error 
      return callback error
    callback null, google_results: data

    
module.exports = 
  validate: ( object, meta )->
    object.name and object.location and object.location.country
  filter: ( object, meta, callback )->
    query = [object.name, object.location.country].join(', ')
    fetchGoogleResults query, callback
    

# fetchGoogleResults = ( query, callback )->
#   query = encodeURIComponent query 
#   phantom.create ( webpage )->
#     webpage.createPage ( page )->
#       resultsurl = "https://www.google.ca/search?q=#{query}&cad=h"
#       terminate = ( fn )->
#         webpage.exit()
#         fn() if typeof fn is 'function'
#       page.onError =( error )-> terminate -> callback error
#       page.open resultsurl, ( status )->
#         if status isnt 'success' 
#           return terminate -> callback "[phantom] Unable to get page #{url}."
#         page.evaluate(
#          ->
#            #evaluate
#            nodes = document.querySelectorAll('li.g')
#            if nodes
#              data  = Array.prototype.slice.call( nodes ).map ( n )->
#                title = n.querySelector('.r').innerText
#                desc =  n.querySelector('.st').innerText
#                source = n.querySelector('.r a').href  
#                # plus = n.querySelector('.intrlu .fl')
#                # if plus then plus = plus.href
#                return title: title, description: desc, source: source # , plus: plus
#            return data||[]
#            #/evaluate
#          ( data )-> 
#             data = data.map ( item )->
#               parsed = URL.parse( item.source, true )
#               if parsed.query and parsed.query.q
#                 if /^http/.test parsed.query.q
#                   item.link = parsed.query.q
#                 else item.source = null
#               else item.link = null
#               return item
#             terminate -> callback null, google_results: data
#         )
