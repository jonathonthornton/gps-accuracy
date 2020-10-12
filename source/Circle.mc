using Toybox.Math;
using Toybox.System;

class Circle {
    private static const MULTIPLICATIVE_EPSILON = 1 + MyMath.SMALL_DOUBLE;

    public var centre;
    public var radius;

    public function initialize(point, radius) {
        self.centre = point;
        self.radius = radius;
    }

    public function containsAll(points) {
        for (var i = 0; i < points.size(); i++) {
            if (!contains(points[i])) {
                return false;
            }
            return true;
        }
    }

    public function contains(point) {
        return centre.distance(point) <= radius * MULTIPLICATIVE_EPSILON;
    }

    public function toString() {
        return "Circle(centre=" + centre + ", r=" + radius + ")";
    }
}