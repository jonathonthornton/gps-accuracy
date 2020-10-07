using Toybox.Math;
using Toybox.Lang;
using Toybox.System;

class MyMath {
    public static const MIN_INT = 1 << 31;
    public static const MAX_INT = ~(1 << 31);
    public static const SMALL_DOUBLE = Math.pow(10, -14);

    // See https://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio
    public static function mapValueToRange(oldMin, oldMax, newMin, newMax, oldValue) {
        return ((oldValue - oldMin) * (newMax - newMin) / (oldMax - oldMin + SMALL_DOUBLE)) + newMin;
    }

    public static function hypot(x, y) {
        return Math.sqrt(x * x + y * y);
    }

    public static function min(x, y) {
        return (x < y) ? x : y;
    }

    public static function max(x, y) {
        return (x > y) ? x : y;
    }

    (:test)
    function mapValueToRangeOk(logger) {
        var oldMin = 1000;
        var oldMax = 5000;
        var oldStep = 100;

        var newMin = 20;
        var newMax = 30;

        var expected = [];
        var actual = [];

        for (var oldValue = oldMin; oldValue <= oldMax; oldValue += oldStep) {
            expected.add(oldValue);
        }

        for (var oldValue = oldMin; oldValue <= oldMax; oldValue += oldStep) {
            var newValue = MyMath.mapValueToRange(oldMin, oldMax, newMin, newMax, oldValue).toNumber();
            actual.add(newValue);
            logger.debug("oldValue=" + oldValue + " newValue=" + newValue);
        }

        for (var newValue = newMin; newValue <= newMax; newValue++) {
            if (actual.indexOf(newValue) != -1) {
                logger.debug("indexOf(" + newValue + ")=" + actual.indexOf(newValue));
            } else {
                logger.debug("not found newValue=" + newValue);
                return false;
            }
        }
        return true;
    }
}