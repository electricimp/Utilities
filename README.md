# Utilities 1.0.0

This library provides a set of handy and compact functions for Squirrel programmers. It is not implemented as a class, but all of the functions are namespaced to *utilities* (via a table) to avoid clashes with your code’s existing functions.

**To add this library to your project, add** `#require "Utilities.nut:1.0.0"` **to the top of your agent or device code.**

## Library Functions

### utilities.hexStringToInteger(*hexString*)

This function evaluates the supplied hexadecimal string (eg. `0xFFA0`) and returns the corresponding integer value.

#### Example

```squirrel
server.log(utilities.hexStringToInteger("0xFFFE"));
// Displays '65534'
```

### utilities.integerToHexString(*integerValue*)

This function converts the supplied integer to a hexadecimal string.

#### Example

```squirrel
server.log(utilities.integerToHexString(78692));
// Displays '0x13364'
```

### utilities.rnd(*max*)

This funtion returns a random integer between 0 and *max*.

#### Example

```squirrel
// Roll for a strike on d100
local strikeSuccess = utilities.rnd(100);
```

### utilities.frnd(*max*)

This funtion returns a random float between 0.0 and *max*.

#### Example

```squirrel
server.log(utilities.frnd(100));
```

### utilities.numberFormatter(*number, decimals, separator*)

This function formats the supplied *number* to the number of decimal places specified by *decimals*.

Numbers greater than 999 are separated with the symbol string passed into *separator*, which defaults to `,`. Pass in an empty string (`""`) if you don’t want a separator to be used.

#### Example

```squirrel
server.log(utilities.numberFormatter("2000.099999", 2, ","));
// Displays '2,000.10'
```

### utilities.dayOfWeek(*dayOfMonth, month, year*)

This function returns the day of the week of the date passed into the *dayOfMonth*, *month* and *year* integer parameters. The *month* parameter should be in the range 0 (January) to 11 (December) as per Squirrel’s **date()** function. The *year* should be specified in four-digit form.

The returned integers lies in the range 0 to 6, where 0 is Sunday and 6 is Saturday.

### Example

```squirrel
local days = ["Sunday", "Monday", "Tueday", "Wednesday", "Thursday", "Friday", "Saturday"];
server.log("3 April 2011 was a " + days[utilities.dayOfWeek(3, 3, 2011)]);
```

### utilities.isLeapYear(*year*)

The function returns `true` if the supplied year is a leap year, otherwise `false`. The *year* should be specified in four-digit form.

### utilities.bstCheck()

This function returns `true` if the current date is within the British Summer Time (BST) period (last Sunday of March to last Sunday of October), otherwise `false` (GMT).

#### Example

```squirrel
if (utilities.bstCheck()) {
    server.log("The UK is observing British Summer Time");
} else {
    server.log("The UK is observing Greenwich Mean Time");
}
```

### utilities.dstCheck()

This function returns `true` if the current date is within the North American Daylight Saving Time (DST) period (second Sunday in March to first Sunday in November).

#### Example

```squirrel
if (utilities.dstCheck() && !utilities.bstCheck()) {
    server.log("The Los Altos folks will be an hour earlier");
}
```

### utilities.getNewUUID(*callback*)

This function generates a new UUID code via the webservice [uuidgenerator.net](https://www.uuidgenerator.net/). As such, it operates asynchronously and requires a callback function to be provided to accept the returned UUID. The callback should have two paramters: *err* and *uuid*. The first will be `null` if no error has occurred, otherwise it will contain an error message string. *uuid* will be requested UUID, or `null` if an error occurred.

#### Example

```squirrel
utilities.getNewUUID(function(err, uuid) {
    if (err) {
        server.error(err);
    } else {
        server.log("UUID: " + uuid);
    }
});
```

### utilities.debugI2C(*impI2Cbus*)

This function logs all the devices (by 8-bit and 7-bit address) on the specified imp I&sup2;C bus.

#### Example

```squirrel
utilities.debugI2C(hardware.i2c89);
// Displays 'Device at 8-bit address: 0xE0 (7-bit address: 0x70)'
```

### utilities.impType(*returnString*)

This function returns the type of imp on which your code is running. The *returnString* parameter is a Boolean: pass in `true` to recieve the imp type as a printable string, eg. `"imp004m"`. If *returnString* is `false` (the default), the function returns an integer, eg. 1 for the imp001, 4 for the imp004m.

## Improvements, Bug Fixes and Suggestions

Please submit pull requests to the Develop branch.

## Licence

Utilities.nut is provided under the [MIT license](./LICENSE).
