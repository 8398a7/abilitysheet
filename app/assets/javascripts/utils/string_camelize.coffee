String::camelize = ->
  @replace /(\-|\_)(\w)/g, (a,b,c)->
    c.toUpperCase()

@camelizeObject = (object) ->
  newObject = {}
  for k, v of object
    newObject[k.camelize()] = v
  newObject
