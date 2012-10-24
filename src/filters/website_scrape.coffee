

invoke = require 'ouija'


module.exports = 
  validate: ( object, meta )-> object.website_url
  filter: ( object, meta, callback )->
    answered = 0 
    website_scrape = {}
    invoke object.website_url, ['html'], ( error, html )->
      answered++
      website_scrape.html = html
      if answered is 2 then return callback( null, website_scrape: website_scrape )
    invoke object.website_url, ['screen'], ( error, blob )->
      answered++
      website_scrape.screenshot = blob
      if answered is 2 then return callback( null, website_scrape: website_scrape )
