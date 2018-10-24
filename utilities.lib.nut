// 
// Utilities.lib.nut
// 
// MIT License
// 
// Copyright (c) 2016-18 Electric Imp
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


utilities <- {};
utilities.version <- "1.1.0";

// ********** Hex Conversion Functions **********
// **********         Public           **********
utilities.hexStringToInteger <- function(hs) {
    if (hs.slice(0, 2) == "0x") hs = hs.slice(2);
    local i = 0;
    foreach (c in hs) {
        local n = c - '0';
        if (n > 9) n = ((n & 0x1F) - 7);
        i = (i << 4) + n;
    }
    return i;
}

utilities.integerToHexString <- function (i) {
    return format("0x%02x", i);
}

// ********** Random Number Functions  **********
// **********         Public           **********
utilities.frnd <- function(m) {
    // Return a pseudorandom float between 0 and max, inclusive
    return (1.0 * math.rand() / RAND_MAX) * (m + 1);
}

utilities.rnd <- function(m) {
    // Return a pseudorandom integer between 0 and max, inclusive
    return frnd(m).tointeger();
}

// ********** Number Format Functions  **********
// **********         Public           **********
utilities.numberFormatter <- function(n, d = null, s = ",") {
    if (d == null) {
        if (typeof n == "string") d = 0;
        else if (typeof n == "integer") d = 0;
        else if (typeof n == "float") d = 2;
        else return n;
    }

    if (typeof n == "string") {
        if (d == 0) {
            n = n.tointeger();
        } else {
            n = n.tofloat();
        }
    } else if (typeof n != "integer" && typeof n != "float") {
        return n;
    }

    local ns = 0;
    if (d == 0) {
        n = format("%0.0f", n.tofloat());
        ns = n.len();
    } else {
        ns = format("%0.0f", n.tofloat()).len();
        n = format("%0.0" + d + "f", n.tofloat());
    }

    local nn = "";
    for (local i = 0 ; i < n.len() ; i++) {
        local ch = n[i];
        nn += ch.tochar();
        if (i >= ns - 2) {
            nn += n.slice(i + 1);
            break;
        }

        if ((ns - i) % 3 == 1) nn += s;
    }

    return nn;
}

// **********    Calendar Functions    **********
// **********         Public           **********
utilities.dayOfWeek <- function(d, m, y) {
    local dim = [
        [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
        [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    ];

    local ad = ((y - 1) * 365) + _totalLeapDays(y) + d - 5;
    for (local i = 0 ; i < m ; ++i) {
        local a = dim[utilities._isLeapYear(y)];
        ad = ad + a[i];
    }
    return (ad % 7) - 1;
}

utilities.isLeapYear <- function(y) {
    if (utilities._isLeapYear(y) == 1) return true;
    return false;
}

utilities.bstCheck <- function() {
    // Checks the current date for British Summer Time,
    // returning true or false accordingly
    local n = date();
    if (n.month > 2 && n.month < 9) return true;

    if (n.month == 2) {
        // BST starts on the last Sunday of March
        for (local i = 31 ; i > 24 ; --i) {
            if (utilities.dayOfWeek(i, 2, n.year) == 0 && n.day >= i) return true;
        }
    }

    if (n.month == 9) {
        // BST ends on the last Sunday of October
        for (local i = 31 ; i > 24 ; --i) {
            if (utilities.dayOfWeek(i, 9, n.year) == 0 && n.day < i) return true;
        }
    }
    return false;
}

utilities.dstCheck <- function() {
    // Checks the current date for US Daylight Savings Time,
    // returning true or false accordingly
    local n = date();
    if (n.month > 2 && n.month < 10) return true;

    if (n.month == 2) {
        // DST starts second Sunday in March
        for (local i = 8 ; i < 15 ; ++i) {
            if (utilities.dayOfWeek(i, 2, n.year) == 0 && n.day >= i) return true;
        }
    }

    if (n.month == 10) {
        // DST ends first Sunday in November
        for (local i = 1 ; i < 8 ; ++i) {
            if (utilities.dayOfWeek(i, 10, n.year) == 0 && n.day <= i) return true;
        }
    }

    return false;
}

// **********         Private         **********
utilities._totalLeapDays <- function(y) {
    local t = y / 4;
    if (utilities._isLeapYear(y) == 1) t = t - 1;
    t = t - ((y / 100) - (1752 / 100)) + ((y / 400) - (1752 / 400));
    return t;
}

utilities._isLeapYear <- function(y) {
    if ((y % 400) || ((y % 100) && !(y % 4))) return 1;
    return 0;
}

// **********  UUID Accessor Function  **********
// **********         Public           **********
utilities.getNewUUID <- function(cb = null) {
    if (cb == null) {
        throw "getNewUUID() requires a callback function with err, data parameters";
    }

    ::_uuidcb <- cb;
    http.get("https://www.uuidgenerator.net/api/version1").sendasync(utilities._extractUUID);
}

// **********         Private          **********
utilities._extractUUID <- function(rs) {
    // Handle the text returned by the API, https://www.uuidgenerator.net/api
    // by TransparenTech LLC
    if (rs.statuscode == 200) {
        if (rs.body.len() > 0) {
            ::_uuidcb(null, rs.body.slice(0, 36));
        }
    } else {
        ::_uuidcb("Error connecting to or receiving data from UUID generator", null);
    }
}

// **********       I2C Function       **********
// **********         Public           **********
utilities.debugI2C <- function(i2c) {
    if (imp.environment() == ENVIRONMENT_AGENT) {
        throw "utilities.debugI2C() can only be run on a device";
    }

    for (local i = 2 ; i < 256 ; i+=2) {
        if (i2c.read(i, "", 1) != null) {
            server.log(format("Device at 8-bit address: 0x%02X (7-bit address: 0x%02X)", i, (i >> 1)));
        }
    }
}

// **********      Imp Functions       **********
// **********         Public           **********
utilities.impType <- function(rs = false) {
    if (imp.environment() == ENVIRONMENT_AGENT) {
        throw "utilities.impType() can only be run on a device";
    }
    
    local di = hardware.getdeviceid();
    local t = ("000" + imp.getmacaddress() == di.slice(1)) ? di.slice(0,1) : "1";
    if (rs) {
        return "imp00" + t + ((t == "4") ? "m" : "");
    } else {
        return t.tointeger();
    }
}