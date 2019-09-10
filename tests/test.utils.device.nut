@include "github:electricimp/utilities/utilities.lib.nut@develop"

class UtilsTestCase extends ImpTestCase {

    function tests() {

        return Promise(function(resolve, reject) {

            // The result value
            local result = false;

            // The tests
            result = (utilities.hexStringToInteger("0xFFFE") == 65534);
            if (!result) reject();

            result = (utilities.integerToHexString(78692) == "0x13364");
            if (!result) reject();

            local b = utilities.hexStringToBlob("0xFFFE");
            result = (b.len() == 2);
            if (!result) reject();

            local b = blob();
            b.writestring("ABCDEF");
            result = (utilities.blobToHexString(b) == "0x414243444546");
            if (!result) reject();

            result = (utilities.blobToHexString(b, 4) == "x004100420043004400450046");
            if (!result) reject();

            result = (utilities.binaryToInteger("111100001111000011110000") == 15790320);
            if (!result) reject();

            result = (utilities.binaryToInteger("10000000111100001111000011110000") == -2131693328);
            if (!result) reject();

            result = (utilities.printBlob(b) == "ABCDEF");
            if (!result) reject();

            result = (utilities.printBlob(blob(6)) == "[00][00][00][00][00][00]");
            if (!result) reject();

            local r = utilities.rnd(100);
            result = (r >= 0 && r <= 100);
            if (!result) reject();

            local v = 42;
            result = (utilities.sign(v) == 1);
            if (!result) reject();

            v = -42;
            result = (utilities.sign(v) == -1);
            if (!result) reject();

            result = (utilities.numberFormatter("2000.099999", 2, ",") == "2,000.10");
            if (!result) reject();

            local days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
            result = (days[utilities.dayOfWeek(3, 4, 2011)] == "Sunday");
            if (!result) reject();

            result = utilities.isLeapYear(2020);
            if (!result) reject();

            // All tests passed, so resolve
            resolve();

        }.bindenv(this));
    }
}
