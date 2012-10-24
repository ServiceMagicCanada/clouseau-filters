path = require 'path'
fs = require 'fs'

###

# flatMerge( target, data ) 

Merges the keys found in `data` onto `target`. 

- If key doesn't exist on `target` it is created.
- If key exists in both and is same and the key on `target` has a `concat()` method, it is merged using `concat()`. 
- Otherwise, different values types will be appended to an array created at the key on `target` with subsequent calls being cacatenated.

###

flatMerge = ( target, data )-> 
  if !data then return target
  for each of data
    if !target[each] then target[each] = data[ each ]
    else
      if data[each] isnt target[each]
        if typeof target[each] is typeof data[each] and target[each].concat
          target[each] = target[each].concat data[each]
        else target[each] = [ target[each], data[each]]
  return target

filters = fs.readdirSync( "#{__dirname}/filters" ).map ( f )->
  name  = path.basename( f ).replace(/\.\w+/,'')
  filter_module = require "#{__dirname}/filters/#{f}"
  name: name
  validate: ( data )-> 
    object = data
    meta   = data.meta||data.meta={}
    filter_module.validate object, meta
  filter: ( data, callback )->
    object = data
    meta   = data.meta||data.meta = {}
    filter_module.filter object, meta, ( error, output )->
      if error then return callback error
      flatMerge data.meta, output
      callback null, data      
  
module.exports = filters