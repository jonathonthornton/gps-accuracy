using Toybox.Math;

class Point {
    private static const R = 6371000;
    private static const PI_OVER_180 = Math.PI / 180;
    private static const PI_UNDER_180 = 180 / Math.PI;
    private static const PI_OVER_4 = Math.PI / 4;

    public var x;
    public var y;

    public function initialize(x, y) {
        self.x = x;
        self.y = y;
    }

    public function clone() {
        return new Point(x, y);
    }

    public function subtract(p) {
        return new Point(x - p.x, y - p.y);
    }

    public function distance(p) {
        return MyMath.hypot(x - p.x, y - p.y);
    }

    public function cross(p) {
        return x * p.y - y * p.x;
    }

    public function equals(other) {
        return x == other.x && y == other.y;
    }

    public function compareTo(other) {
        if (x == other.x) {
            if (y < other.y) {
                return -1;
            } else if (y > other.y) {
                return 1;
            } else {
                return 0;
            }
        } else {
            if (x < other.x) {
                return -1;
            } else {
                return 1;
            }
        }
    }

    public function toString() {
        return "Point(" + x + "," + y + ")";
    }

    public function calculateDistance(other) {
        return calculateGCD(other);
    }

    // See https://www.movable-type.co.uk/scripts/latlong.html
    public function calculateGCD(other) {
        var lat1 = x * PI_OVER_180;
        var lat2 = other.x * PI_OVER_180;
        var deltaLat = (other.x - x) * PI_OVER_180;
        var deltaLong = (other.y - y) * PI_OVER_180;

        var a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
            Math.cos(lat1) * Math.cos(lat2) *
            Math.sin(deltaLong / 2) * Math.sin(deltaLong / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        // Return distance in metres.
        return R * c;
    }

    // See https://wiki.openstreetmap.org/wiki/Mercator
    public function toMercator() {
        return new Point(Math.ln(Math.tan((x / 90 + 1) * PI_OVER_4)) * PI_UNDER_180, y);
    }
}