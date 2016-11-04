# Utilities 1.0.0

The library provides a set of handy and compact functions for Squirrel programmers. It is not implemented as a class, but all of the functions are namespaced to *utilities* (via a table) to avoid clashes with your code’s existing functions.

## Library Functions

### utilities.hexStringToInteger(*hexString*)

This function evaluates the supplied hexadecimal string (eg. `0xFFA0`) and returns the corresponding integer value.

### utilities.integerToHexString(*integerValue*)

This function converts the supplied integer to a hexadecimal string.

### utilities.rnd(*max*)

This funtion returns a random integer between 0 and *max*.

### utilities.frnd(*max*)

This funtion returns a random float between 0.0 and *max*.

### utilities.numberFormatter(*number, decimals, separator*)

This function formats the supplied *number* to the number of decimal places specified by *decimals*. 

Numbers greater than 999 are separated with the symbol string passed into *separator*, which defaults to `,`. Pass in an empty string (`""`) if you don’t want a separator to be used.

### utilities.dayOfWeek(*dayOfMonth, month, year*)

This function returns the day of the week of the date passed into the *dayOfMonth*, *month* and *year* integer parameters. The *month* parameter should be in the range 0 (January) to 11 (December) as per Squirrel’s **date()** function. The *year* should be specified in four-digit form.

The returned integers lies in the range 0 to 6, where 0 is Sunday and 6 is Saturday.

### utilities.isLeapYear(*year*)

The function returns `true` if the supplied year is a leap year, otherwise `false`. The *year* should be specified in four-digit form.

### utilities.bstCheck()

This function returns `true` if the current date is within the British Summer Time (BST) period (last Sunday of March to last Sunday of October), otherwise `false` (GMT).

### utilities.dstCheck()

This function returns `true` if the current date is within the North American Daylight Saving Time (DST) period (second Sunday in March to first Sunday in November).

### utilities.getNewUUID(*callback*)

This function generates a new UUID code via the webservice [uuidgenerator.net](https://www.uuidgenerator.net/). As such, it operates asynchronously and requires a callback function to be provided to accept the returned UUID. The callback should have two paramters: *err* and *uuid*. The first will be `null` if no error has occurred, otherwise it will contain an error message string. *uuid* will be requested UUID, or `null` if an error occurred.

### utilities.debugI2C(*impI2Cbus*)

This function logs all the devices (by 8-bit and 7-bit address) on the specified imp I&sup2;C bus.

### utilities.impType(*returnString*)

This function returns the type of imp on which your code is running. The *returnString* parameter is a Boolean: pass in `true` to recieve the imp type as a printable string, eg. `"imp004m"`. If *returnString* is `false` (the default), the function returns an integer, eg. 1 for the imp001, 4 for the imp004m.

## Improvements, Bug Fixes and Suggestions

Please submit pull requests to the Develop branch.

## Licence

Utilities.nut is provided under the [MIT license](./LICENSE).
