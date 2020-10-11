using Toybox.Math;
using Toybox.Lang;
using Toybox.System;

class MyMath {
    public static const MIN_INT = 1 << 31;
    public static const MAX_INT = ~(1 << 31);
    public static const SMALL_DOUBLE = Math.pow(10, -14);

    // See https://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio
    public static function mapValueToRange(oldMin, oldMax, newMin, newMax, oldValue) {
        if (oldMax - oldMin == 0) {
            return newMin;
        } else {
            return ((oldValue - oldMin) * (newMax - newMin) / (oldMax - oldMin)) + newMin;
        }
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
    function mapToZeroRangeOk(logger) {
        var oldMin = 1000;
        var oldMax = 5000;
        var oldStep = 100;
        var newMin = 20;
        var newMax = newMin;
        var expected = MyMath.getExpected(logger, oldMin, oldMax, oldStep);
        var actual = MyMath.getActual(logger, oldMin, oldMax, oldStep, newMin, newMax);
        return MyMath.mapToSmallerRange(logger, oldMin, oldMax, oldStep, newMin, newMax);
    }

    (:test)
    function mapToSmallerRangeOk(logger) {
        var oldMin = 1000;
        var oldMax = 5000;
        var oldStep = 100;
        var newMin = 20;
        var newMax = 30;
        var expected = MyMath.getExpected(logger, oldMin, oldMax, oldStep);
        var actual = MyMath.getActual(logger, oldMin, oldMax, oldStep, newMin, newMax);
        return MyMath.mapToSmallerRange(logger, oldMin, oldMax, oldStep, newMin, newMax);
    }

    (:test)
    function mapToInvertedSmallerRangeOk(logger) {
        var oldMin = 1000;
        var oldMax = 5000;
        var oldStep = 100;
        var newMin = 100;
        var newMax = 0;
        var expected = MyMath.getExpected(logger, oldMin, oldMax, oldStep);
        var actual = MyMath.getActual(logger, oldMin, oldMax, oldStep, newMin, newMax);
        return MyMath.mapToSmallerRange(logger, oldMin, oldMax, oldStep, newMin, newMax);
    }

    (:test)
    function mapToLargerRangeOk(logger) {
        var oldMin = 10;
        var oldMax = 20;
        var oldStep = 1;
        var newMin = 100;
        var newMax = 400;
        var expected = MyMath.getExpected(logger, oldMin, oldMax, oldStep);
        var actual = MyMath.getActual(logger, oldMin, oldMax, oldStep, newMin, newMax);
        logger.debug("actual first=" + actual[0]);
        logger.debug("actual last=" + actual[actual.size() - 1]);

        return
            actual[0] == newMin &&
            actual[actual.size() - 1] == newMax;
    }

    private static function getExpected(logger, oldMin, oldMax, oldStep) {
        var expected = [];
        for (var oldValue = oldMin; oldValue <= oldMax; oldValue += oldStep) {
            expected.add(oldValue);
        }
        return expected;
    }

    private static function getActual(logger, oldMin, oldMax, oldStep, newMin, newMax) {
        var actual = [];
        for (var oldValue = oldMin; oldValue <= oldMax; oldValue += oldStep) {
            var newValue = MyMath.mapValueToRange(oldMin, oldMax, newMin, newMax, oldValue).toNumber();
            actual.add(newValue);
            logger.debug("oldValue=" + oldValue + " newValue=" + newValue);
        }
        return actual;
    }

    private static function mapToSmallerRange(logger, oldMin, oldMax, oldStep, newMin, newMax) {
        var expected = MyMath.getExpected(logger, oldMin, oldMax, oldStep);
        var actual = MyMath.getActual(logger, oldMin, oldMax, oldStep, newMin, newMax);
        logger.debug("actual first=" + actual[0]);
        logger.debug("actual last=" + actual[actual.size() - 1]);

        for (var newValue = newMin; newValue <= newMax; newValue++) {
            if (actual.indexOf(newValue) != -1) {
                logger.debug("indexOf(" + newValue + ")=" + actual.indexOf(newValue));
            } else {
                logger.debug("not found newValue=" + newValue);
                return false;
            }
        }
        return
            actual[0] == newMin &&
            actual[actual.size() - 1] == newMax;
    }
}