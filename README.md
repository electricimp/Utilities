# utilities 3.0.1 #

This library provides a set of handy and compact functions for Squirrel programmers. It is not implemented as a class, but all of the functions are namespaced to *utilities* (via a table) to avoid clashes with your code’s existing functions.

View library release notes [here](#release-notes).

**To include this library in your project, add** `#require "utilities.lib.nut:3.0.1"` **at the top of your agent or device code.**

![Build Status](https://cse-ci.electricimp.com/app/rest/builds/buildType:(id:Utilities_BuildAndTest)/statusIcon)

## Conversion Functions ##

### utilities.hexStringToInteger(*hexString*) ###

This function evaluates the supplied hexadecimal string (eg. `"0xFFA0"`) into an integer.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *hexString* | String | Yes | A string of hexadecimal values |

#### Returns ####

Integer &mdash; The integer evaluation of the hex string.

#### Example ####

```squirrel
server.log(utilities.hexStringToInteger("0xFFFE"));
// Displays '65534'
```

### utilities.integerToHexString(*integerValue*) ###

This function converts the supplied integer to a hexadecimal string (eg. `"0xFFA0"`).

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *integerValue* | Integer | Yes | An integer value |

#### Returns ####

String &mdash; The hex string.

#### Example ####

```squirrel
server.log(utilities.integerToHexString(78692));
// Displays '0x13364'
```

### utilities.hexStringToBlob(*hexString*) ###

This function converts the supplied hexadecimal string (eg. `"0xFFA0"`) into a blob containing one byte per pair of hex characters.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *hexString* | String | Yes | A string of hexadecimal values |

#### Returns ####

Blob &mdash; The blob evaluation of the hex string.

#### Example ####

```squirrel
local b = utilities.hexStringToBlob("0xFFFE");
server.log(b.len());
// Displays '2'
```

### utilities.blobToHexString(*aBlob[, charactersPerByte]*) ###

This function converts the supplied blob to a hexadecimal string (eg. `"0xFFA0"`).

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *aBlob* | Blob | Yes | The blob to be converted |
| *charactersPerByte* | String | No | The number of hex characters to display in each byte. The function imposes a minimum of two characters. Default: 2 |

#### Returns ####

String &mdash; The hex string evaluation of the blob.

#### Examples ####

```squirrel
local b = blob();
b.writestring("ABCDEF");
server.log(utilities.blobToHexString(b));
// Displays '0x414243444546'

server.log(utilities.blobToHexString(b, 4));
// Displays '0x004100420043004400450046'
```

### utilities.binaryToInteger(*binaryString*) ###

This function converts the supplied binary string (eg. `"11110000"`) into a decimal integer. Squirrel uses signed integers, so the character representing bit 31, if present, will always be used as a sign bit.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *binaryString* | String | Yes | A binary value represented as a string of 1s and 0s. Must by 32 characters or less |

#### Returns ####

Integer &mdash; The decimal integer evaluation of the binary representation.

#### Examples ####

```squirrel
server.log(utilities.binaryToInteger("111100001111000011110000"));
// Displays '15790320'

server.log(utilities.binaryToInteger("10000000111100001111000011110000"));
// Displays '-2131693328'
```

### utilities.printBlob(*aBlob*) ###

This function provides a printable representation of a blob. Bytes are presented as Ascii characters; byte values outside the Ascii range are presented as hexadecimal values in square brackets.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *aBlob* | Blob | Yes | The blob to be converted |

#### Returns ####

String &mdash; The printable string.

#### Examples ####

```squirrel
local b = blob();
b.writestring("ABCDEF");
server.log(utilities.printBlob(b));
// Displays 'ABCDEF'

local b = blob(6);
server.log(utilities.printBlob(b));
// Displays '[00][00][00][00][00][00]'
```

## Random Number and Numerical Functions ##

### utilities.frnd(*max*) ###

This function generates a random float between 0.0 and *max*.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *max* | Integer | Yes | The maximum possible value |

#### Returns ####

Float &mdash; The random value.

#### Example ####

```squirrel
server.log(utilities.frnd(100));
```

### utilities.rnd(*max*) ###

This function generates a random integer between 0 and *max*.

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *max* | Integer | Yes | The maximum possible value |

#### Returns ####

Integer &mdash; The random value.

#### Example ####

```squirrel
// Roll for a strike on d100
local strikeSuccess = utilities.rnd(100);
```

### utilities.sign(*value*) ###

This indicates whether the supplied numeric value is positive, negative or zero.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *value* | Integer or float | Yes | A numeric value |

#### Returns ####

Integer &mdash; 1, -1 or 0 if the supplied value is, respectively, positive, negative or zero.

#### Example ####

```squirrel
local v = 42;
server.log("Value is " + (utilities.sign(v) == 1 ? "greater than zero" : "zero or negative"));
// Displays 'Value is greater than zero'
```

### utilities.numberFormatter(*number[, decimalPlaces][, separator]*) ###

This function formats the supplied numeric value to the specified number of decimal places.

Numbers greater than 999 are separated with the symbol string passed into *separator*, which defaults to `,`. Pass in an empty string (`""`) if you don’t want a separator to be used.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *number* | Integer, float or string | Yes | A numeric value |
| *decimalPlaces* | Integer | No | The required number of decimal places. Default: 2 for floats, otherwise 0 |
| *separator* | String | No | A hundreds separator character. Default: `,` |

#### Returns ####

String &mdash; The formatted number.

#### Example ####

```squirrel
server.log(utilities.numberFormatter("2000.099999", 2, ","));
// Displays '2,000.10'
```

## Calendar Functions ##

### utilities.dayOfWeek(*dayOfMonth, month, year*) ###

This function calculates the day of the week of the supplied date using [Zeller’s Rule](http://mathforum.org/dr.math/faq/faq.calendar.html).

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *dayOfMonth* | Integer | Yes | The day of the month (1-31) |
| *month* | Integer | Yes | The month (1-12) |
| *year* | Integer | Yes | The four-digit year, eg. 2019 |

#### Returns ####

Integer &mdash; The day value in the range 0 to 6, where 0 is Sunday and 6 is Saturday.

#### Example ####

```squirrel
local days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
server.log("3 April 2011 was a " + days[utilities.dayOfWeek(3, 4, 2011)]);
// Displays '3 April 2011 was a Sunday'
```

### utilities.isLeapYear(*year*) ###

This function indicates whether the supplied year is a leap year.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *year* | Integer | Yes | The four-digit year, eg. 2019 |

#### Returns ####

Boolean &mdash; `true` if the supplied year is a leap year, otherwise `false`.

#### Example ####

```squirrel
server.log("2020 " + (utilities.isLeapYear(2020) ? "is" : "is not") + " a leap year");
// Displays '2020 is a leap year'
```

### utilities.bstCheck(*[date]*) ###

This function indicates whether the supplied date lies within the British Summer Time (BST) period (last Sunday of March to last Sunday of October).

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *date* | Squirrel *date()* Table | No | A date as per Squirrel’s *date()* function. Default: the current date and time |

#### Returns ####

Boolean &mdash; `true` if the date is within the British Summer Time (BST) period , otherwise `false` (GMT).

#### Example ####

```squirrel
if (utilities.bstCheck()) {
    server.log("The UK is observing British Summer Time");
} else {
    server.log("The UK is observing Greenwich Mean Time");
}
```

### utilities.dstCheck(*[date]*) ###

This function indicates whether the supplied date lies within North American Daylight Saving Time (DST) period (second Sunday in March to first Sunday in November).

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *date* | Squirrel *date()* Table | No | A date as per Squirrel’s *date()* function. Default: the current date and time |

#### Returns ####

Boolean &mdash; `true` if the date is within Daylight Saving Time, otherwise `false`.

#### Example ####

```squirrel
if (utilities.dstCheck() && !utilities.bstCheck()) {
    server.log("The Los Altos folks will be an hour earlier");
}
```

## UUID Generator Functions ##

### utilities.getNewUUID() ###

This function generates a new 16-byte UUID code.

#### Returns ####

String &mdash; A UUID in RFC 4122 format.

#### Example ####

```squirrel
server.log(utilities.getNewUUID());
// Logs, for example, 52473CFA-ACB1-4978-831F-1B1A74A2E265
```

## Imp Functions ##

### utilities.impType(*[returnAString]*) ###

This function returns the type of imp on which your code is running. Agents have a value of zero. Cellular imps are counted from 100, so an impC001 will return the integer 101, not 1, to avoid clashes with other imps, all of which return their correct number.

#### Parameters ####

| Parameter | Type | Required? | Description |
| --- | --- | --- | --- |
| *returnAString* | Boolean | No | Whether to return a string (`true`) or an integer (`false`). Default: `false` |

#### Returns ####

Integer or string &mdash; The imp type, eg. 4 or `"imp004m"`; or 0 / "agent"; -1 indicates unknown imp.

#### Examples ####

```squirrel
server.log(utilities.impType());
// Displays, eg. '4'

server.log(utilities.impType(true));
// Displays, eg. 'imp004m'
```

## Release Notes ##

- 3.0.1
    - Fixed an issue causing incorrect BST/DST reporting (mismatch in numeric month values across functions).
    - Updated *impType()* to deal with cellular imps and remove a deprecated method call.
- 3.0.0
    - Removed *debugI2C()* function.
    - Added *hexStringToBlob()*, *blobToHexString()*, *binaryToInteger()*, *printBlob()* and *sign()* functions.
    - Revised documentation.
    - Added test case.
- 2.0.0
    - Improve UUID code.
- 1.0.0
    - Initial release.

## Improvements, Bug Fixes and Suggestions ##

Please submit pull requests to the `develop` branch.

## Licence ##

This library is provided under the [MIT license](LICENSE).
