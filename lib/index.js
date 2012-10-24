// Generated by CoffeeScript 1.3.3
var filters, flatMerge, fs, path;

path = require('path');

fs = require('fs');

/*

# flatMerge( target, data ) 

Merges the keys found in `data` onto `target`. 

- If key doesn't exist on `target` it is created.
- If key exists in both and is same and the key on `target` has a `concat()` method, it is merged using `concat()`. 
- Otherwise, different values types will be appended to an array created at the key on `target` with subsequent calls being cacatenated.
*/


flatMerge = function(target, data) {
  var each;
  if (!data) {
    return target;
  }
  for (each in data) {
    if (!target[each]) {
      target[each] = data[each];
    } else {
      if (data[each] !== target[each]) {
        if (typeof target[each] === typeof data[each] && target[each].concat) {
          target[each] = target[each].concat(data[each]);
        } else {
          target[each] = [target[each], data[each]];
        }
      }
    }
  }
  return target;
};

filters = fs.readdirSync("" + __dirname + "/filters").map(function(f) {
  var filter_module, name;
  name = path.basename(f).replace(/\.\w+/, '');
  filter_module = require("" + __dirname + "/filters/" + f);
  return {
    name: name,
    validate: function(data) {
      var meta, object;
      object = data;
      meta = data.meta || (data.meta = {});
      return filter_module.validate(object, meta);
    },
    filter: function(data, callback) {
      var meta, object;
      object = data;
      meta = data.meta || (data.meta = {});
      return filter_module.filter(object, meta, function(error, output) {
        if (error) {
          return callback(error);
        }
        flatMerge(data.meta, output);
        return callback(null, data);
      });
    }
  };
});

module.exports = filters;