using Toybox.Math;
using Toybox.Lang;
using Toybox.System;

class MyMath {
    public static const MIN_INT = 1 << 31;
    public static const MAX_INT = ~(1 << 31);
    public static const SMALL_DOUBLE = Math.pow(10, -14);

    private static const R = 6371000;
    private static const PI_OVER_180 = Math.PI / 180;
    private static const PI_UNDER_180 = 180 / Math.PI;
    private static const PI_OVER_4 = Math.PI / 4;

    // See https://www.movable-type.co.uk/scripts/latlong.html
    public static function calculateGCD(p1, p2) {
        var lat1 = p1.x * PI_OVER_180;
        var lat2 = p2.x * PI_OVER_180;
        var deltaLat = (p2.x - p1.x) * PI_OVER_180;
        var deltaLong = (p2.y - p1.y) * PI_OVER_180;

        var a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
            Math.cos(lat1) * Math.cos(lat2) *
            Math.sin(deltaLong / 2) * Math.sin(deltaLong / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        // Return distance in metres.
        return R * c;
    }

    // See https://wiki.openstreetmap.org/wiki/Mercator
    public static function latToMercator(lat) {
        return Math.ln(Math.tan((lat / 90 + 1) * PI_OVER_4)) * PI_UNDER_180;
    }

    public static function longToMercator(long) {
        return long;
    }

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

    (:test)
    function getWidthAsGCDOk(logger) {
        var p1 = new Point(38.555421, -94.799646);
        var p2 = new Point(38.855421, -94.698646);
        var gcd = MyMath.calculateGCD(p1, p2);
        logger.debug("GCD=" + gcd);
        return gcd.toNumber() == 34490;
    }
}