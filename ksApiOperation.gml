// BM: The methodName and paramMap will be passed in parameters when this is abstracted into a script.
var methodName  = argument0
var paramMap    = argument1

// BM: Security keys, the same for all methods.
var apiKey      = "YOUR_API_KEY"
var secretKey   = "YOUR_SECRET_KEY"

// BM: !!! USE HTTP EVEN IF YOU HAVE TEH SSL OPTION ENABLED ON YOUR KUMULOS APPLICATION !!!
var methodUrl   = "http://api.kumulos.com/b2.2/"

// BM: Generate the salt and hashedKey using the secret key, for security.
var salt        = irandom_range(1, 9999999)
var hashedKey   = md5_string_utf8(secretKey + string(salt))

// BM: Add on the additional parameters needed for security and tracking.
var paramString = "hashedKey=" + hashedKey
paramString     = paramString + "&salt=" + string(salt)
paramString     = paramString + "&deviceType=8&bindingVersion=0.1"

// BM: Scan the map data structure ato complete the parameter string.
var key = ds_map_find_first(paramMap);
while (is_string(key))
{
    // BM: Grab the value associated with the key and add them to the parameter string.
    value       = ds_map_find_value(paramMap, key)
    paramString = paramString + "&params["+string(key)+"]="+string(value)

    // BM: Move onto the next key/value pair, if one exists.
    key = ds_map_find_next(paramMap, key);
}

// BM: Now we have the apiKey and the methodName, complete the methodUrl
methodUrl = methodUrl + apiKey + "/" + methodName + ".json"

// BM: Debug print
//show_debug_message(methodUrl)
//show_debug_message(paramString)

// BM: Post this mother, returning the ID of the call.
return http_post_string(methodUrl, paramString)
