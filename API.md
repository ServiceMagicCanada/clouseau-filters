# flatMerge( target, data ) 

Merges the keys found in `data` onto `target`. 

- If key doesn't exist on `target` it is created.
- If key exists in both and is same and the key on `target` has a `concat()` method, it is merged using `concat()`. 
- Otherwise, different values types will be appended to an array created at the key on `target` with subsequent calls being cacatenated.
