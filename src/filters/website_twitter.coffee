module.exports=
  validate: ( object, meta, callback )->
    meta.website_scrape and meta.website_scrape.html
  filter: ( object, meta, callback )->
    html =  meta.website_scrape.html
    twurls = html.match /https?\:\/\/twitter\.com(\/\#\!)?\/([^\"\']+)/g
    if !twurls then return callback() 
    unique = twurls.reduce ( uniq, url )->
      url = url.toLowerCase().replace(/https/,'http')
      uniq.push( url ) if uniq.indexOf( url ) is -1
      return uniq
    , []
    callback null, website_twitter: unique
      
      