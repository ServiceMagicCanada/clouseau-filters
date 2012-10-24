URL = require 'url'
invoke = require 'ouija'
cheerio = require 'cheerio'
fetchGoogleDescriptions = ( url, callback )->
  hostname = encodeURIComponent URL.parse( url ).hostname
  resultsurl = "https://www.google.ca/search?q=#{hostname}&oq=site:#{hostname}&cad=h"
  invoke resultsurl, ['html'], ( error, html )->
    try
      $ = cheerio.load( html ) 
      texts = $('li.g .st').map -> $( this ).text()
    catch error 
      return callback error
    callback null, google_descriptions:  texts
    
module.exports = 
  validate: ( object, meta )-> object.website_url
  filter: ( object, meta, callback )->
    fetchGoogleDescriptions object.website_url, callback