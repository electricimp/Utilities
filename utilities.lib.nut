//
// Utilities.lib.nut
//
// MIT License
//
// Copyright (c) 2016-19 Electric Imp
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


utilities <- {

    "VERSION" : "3.0.0",

    // HEX CONVERSION FUNCTIONS

    // ********** Hex Conversion Functions **********
    // **********         Public           **********
    "hexStringToInteger" : function(hs) {
        if (hs.slice(0, 2) == "0x") hs = hs.slice(2);
        local i = 0;
        foreach (c in hs) {
            local n = c - '0';
            if (n > 9) n = ((n & 0x1F) - 7);
            i = (i << 4) + n;
        }
        return i;
    },

    "integerToHexString" : function (i, r = 2) {
        if (r % 2 != 0) r++;
        local fs = "0x%0" + r.tostring() + "x";
        return format(fs, i);
    },

    // ********** Random Number Functions  **********
    // **********         Public           **********
    "frnd" : function(m) {
        // Return a pseudorandom float between 0 and max, inclusive
        return (1.0 * math.rand() / RAND_MAX) * (m + 1);
    },

    "rnd" : function(m) {
        // Return a pseudorandom integer between 0 and max, inclusive
        return utilities.frnd(m).tointeger();
    },

    // ********** Number Format Functions  **********
    // **********         Public           **********
    "numberFormatter" : function(n, d = null, s = ",") {
        if (d == null) {
            if (typeof n == "string") d = 0;
            else if (typeof n == "integer") d = 0;
            else if (typeof n == "float") d = 2;
            else return n;
        }

        if (typeof n == "string") {
            n = d == 0 ? n.tointeger() : n.tofloat();
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
    },

    // **********    Calendar Functions    **********
    // **********         Public           **********
    "dayOfWeek" : function(d, m, y) {
        local dim = [
            [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
            [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        ];

        local ad = ((y - 1) * 365) + utilities._totalLeapDays(y) + d - 5;
        for (local i = 0 ; i < m ; i++) {
            local a = dim[utilities._isLeapYear(y)];
            ad = ad + a[i];
        }
        return (ad % 7) - 1;
    },

    "isLeapYear" : function(y) {
        if (utilities._isLeapYear(y) == 1) return true;
        return false;
    },

    "bstCheck" : function(n = null) {
        // Checks the current date for British Summer Time,
        // returning true or false accordingly
        if (n == null) n = date();
        if (n.month > 2 && n.month < 9) return true;

        if (n.month == 2) {
            // BST starts on the last Sunday of March
            for (local i = 31 ; i > 24 ; i--) {
                if (utilities.dayOfWeek(i, 2, n.year) == 0 && n.day >= i) return true;
            }
        }

        if (n.month == 9) {
            // BST ends on the last Sunday of October
            for (local i = 31 ; i > 24 ; i--) {
                if (utilities.dayOfWeek(i, 9, n.year) == 0 && n.day < i) return true;
            }
        }
        return false;
    },

    "dstCheck" : function(n = null) {
        // Checks the current date for US Daylight Savings Time, returning true or false accordingly
        if (n == null) n = date();
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
    },

    // **********         Private         **********
    "_totalLeapDays" : function(y) {
        local t = y / 4;
        if (utilities._isLeapYear(y) == 1) t = t - 1;
        t = t - ((y / 100) - (1752 / 100)) + ((y / 400) - (1752 / 400));
        return t;
    },

    "_isLeapYear" : function(y) {
        if ((y % 400) || ((y % 100) && !(y % 4))) return 1;
        return 0;
    },

    // **********  UUID Accessor Function  **********
    // **********         Public           **********

    // We create this string here for later use, but only populte it if it is actually needed
    "getNewUUID" : function() {
        // Randomize 16 bytes (128 bits)
        local rnds = blob(16);
        for (local i = 0 ; i < 16 ; i++) rnds.writen(((1.0 * math.rand() / RAND_MAX) * 256.0).tointeger(), 'b');

        // Adjust certain bits according to RFC 4122 section 4.4
        rnds[6] = 0x40 | (rnds[6] & 0x0F);
        rnds[8] = 0x80 | (rnds[8] & 0x3F);

        // Create an return the UUID string
        local s = "";
        for (local i = 0 ; i < 16 ; i++) {
            s = s + format("%02X", rnds[i]);
            if (i == 3 || i == 5 || i == 7 || i == 9) s = s + "-";
        }
        return s;
    },

    // **********      Imp Functions       **********
    // **********         Public           **********
    "impType" : function(returnAsString = false) {
        // NOTE This is ONLY available on the the device
        if (imp.environment() == ENVIRONMENT_AGENT) throw "utilities.impType() can only be run on a device";

        local did = hardware.getdeviceid();
        local type = ("000" + imp.getmacaddress() == did.slice(1)) ? did.slice(0,1) : "1";
        if (returnAsString) {
            return "imp00" + type + ((type == "4") ? "m" : "");
        } else {
            return type.tointeger();
        }
    }
}
