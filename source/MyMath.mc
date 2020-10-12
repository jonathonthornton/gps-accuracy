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
}