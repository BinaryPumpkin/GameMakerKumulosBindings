//Copyright (c) 2013 Binary Pumpkin Ltd
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the //rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE //AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE //SOFTWARE.

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
