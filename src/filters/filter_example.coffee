module.exports=
	validate: ( object, meta )->
		return true
	filter: ( object, meta, callback )->
		# use data you need in object
		# use data you need in meta
		# call back using callback( error ) if it fails
		# call back providing null errro, and new meta data when succeeds
		callback null, example: true