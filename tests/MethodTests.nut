// MIT License
//
// Copyright 2019 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

class UtilitiesTestCase extends ImpTestCase {

    isAgent = null;

    function setUp() {
        // No need to create class instance since utilities is a table
        isAgent = (imp.environment() == ENVIRONMENT_AGENT);
        return "Test setup complete";
    }

    function testHexStringToInteger() {
        local expected = 65534;
        local actual   = utilities.hexStringToInteger("0xFFFE");

        assertEqual(actual, expected, "hexStringToInteger failed. Expected: " + expected + " Actual: " + actual);
        return "hexStringToInteger test complete";
    }

    function testIntegerToHexString() {
        local expected = "0x13364";
        local actual   = utilities.integerToHexString(78692);

        assertEqual(actual, expected, "integerToHexString failed. Expected: " + expected + " Actual: " + actual);
        return "integerToHexString test complete";
    }

    function testHexStringToBlob() {
        local expectedLen = 2;
        local actual   = utilities.hexStringToBlob("0xFFFE");

        assertEqual(actual.len(), expectedLen, "hexStringToBlob did not return blob of expected length");
        assertTrue(crypto.equals("\xFF\xFE", actual), "hexStringToBlob did not return expected value");

        return "hexStringToBlob test complete";
    }

    function testBlobToHexString() {
        local b = blob();
        b.writestring("ABCDEF");

        local expected = "0x414243444546";
        local actual   = utilities.blobToHexString(b);
        assertEqual(actual, expected, "blobToHexString default params failed. Expected: " + expected + " Actual: " + actual);

        expected = "0x004100420043004400450046";
        actual   = utilities.blobToHexString(b, 4);
        assertEqual(actual, expected, "blobToHexString custom params failed. Expected: " + expected + " Actual: " + actual);

        return "blobToHexString tests complete";
    }
    
    function testBinaryToInteger() {
        local expected = 15790320;
        local actual   = utilities.binaryToInteger("111100001111000011110000");
        assertEqual(actual, expected, "binaryToInteger failed. Expected: " + expected + " Actual: " + actual);
        
        expected = -2131693328;
        actual   = utilities.binaryToInteger("10000000111100001111000011110000");
        assertEqual(actual, expected, "binaryToInteger longer failed. Expected: " + expected + " Actual: " + actual);

        return "binaryToInteger test complete";
    }

    function testPrintBlob() {
        local expected1 = "ABCDEF";
        local expected2 = "[00][00][00][00][00][00]"
        
        local b = blob(expected1.len());
        b.writestring(expected1);
        local actual1 = utilities.printBlob(b);
        assertEqual(actual1, expected1, "printBlob failed. Expected: " + expected1 + " Actual: " + actual1);

        local actual2 = utilities.printBlob(blob(6));
        assertEqual(actual2, expected2, "printBlob failed. Expected: " + expected2 + " Actual: " + actual2);

        return "binaryToprintBlobInteger test complete";
    }

    function testRnd() {
        local max    = 100;
        local min    = 0;
        local actual = utilities.rnd(100);

        assertBetween(actual, min, max, "rnd failed. Expected value between " + min + " and " + max + " Actual: " + actual);
    
        return "rnd test complete";
    }

    function testSign() {
        local expPos = 1;
        local actPos = utilities.sign(42);
        assertEqual(actPos, expPos, "sign failed. Expected: " + expPos + " Actual: " + actPos);

        local expNeg = -1;
        local actNeg = utilities.sign(-42);
        assertEqual(actNeg, expNeg, "sign failed. Expected: " + expNeg + " Actual: " + actNeg);
        
        return "sign test complete";
    }

    function testNumberFormatter() {
        local expected = "2,000.10";
        local actual   = utilities.numberFormatter("2000.099999", 2, ",");
        assertEqual(actual, expected, "numberFormatter failed. Expected: " + expected + " Actual: " + actual);

        return "numberFormatter test complete";
    }

    function testDayOfWeek() {
        local expected = 0;
        local actual   = utilities.dayOfWeek(3, 4, 2011);
        
        assertEqual(actual, expected, "dayOfWeek failed. Expected: " + expected + " Actual: " + actual);
        return "dayOfWeek test complete";
    }

    function testIsLeapYear() {  
        local isAleapYear  = 2020;  
        assertTrue(utilities.isLeapYear(isAleapYear), "isLeapYear failed, " + isAleapYear + " is a leap year");

        local notALeapYear = 2019;    
        assertTrue(!utilities.isLeapYear(notALeapYear), "isLeapYear failed, " + notALeapYear + " is not a leap year");

        return "isLeapYear test complete";  
    }

    function testIsBST() {
        local notBSTDate = { "month" : 10, "year" : 2019, "day" : 28 };
        assertTrue(!utilities.isBST(notBSTDate), "isBST negative failed");
    
        local isBSTDate = { "month" : 7, "year" : 2019, "day" : 28 };  
        assertTrue(utilities.isBST(isBSTDate), "isBST positive failed.");

        return "isBST test complete"; 
    }

    function testImpType() {
        if (isAgent) {
            local expected = 0;
            local actual   = utilities.impType();
            assertEqual(actual, expected, "impType agent default params failed. Expected: " + expected + " Actual: " + actual);

            expected = "agent";
            actual   = utilities.impType(true);
            assertEqual(actual, expected, "impType agent expect string param failed. Expected: " + expected + " Actual: " + actual);
        } else {
            local expected = imp.info().type;
            local actual   = utilities.impType(true);
            assertEqual(actual, expected, "impType device expect string param failed. Expected: " + expected + " Actual: " + actual);

            local type = expected;
            switch(type) {
                case "imp001":
                    expected = 1;
                    break;
                case "imp002":
                    expected = 2;
                    break;
                case "imp003":
                    expected = 3;
                    break;
                case "imp004m": 
                    expected = 4;
                    break;
                case "imp005": 
                    expected = 5;
                    break;
                case "impC001": 
                    expected = 101;
                    break;
                default: 
                    expected = -1;
            }

            actual = utilities.impType();
            assertEqual(actual, expected, "impType device default param failed. Expected: " + expected + " Actual: " + actual);
        }
        
        return "impType test complete"; 
    }
}
