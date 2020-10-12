using Toybox.System;

// See https://www.nayuki.io/page/convex-hull-algorithm
class ConvexHull {
    // Returns a new list of points representing the convex hull of
    // the given set of points. The convex hull excludes collinear points.
    // This algorithm runs in O(n log n) time.
    public static function makeHull(points) {
        var clonedPoints = points.clone();
        clonedPoints.sort();
        return ConvexHull.makeHullPresorted(clonedPoints);
    }

    // Returns the convex hull, assuming that each points[i] <= points[i + 1]. Runs in O(n) time.
    public static function makeHullPresorted(points) {
        if (points.size() <= 1) {
            return [];
        }

        // Andrew's monotone chain algorithm. Positive y coordinates correspond to "up"
        // as per the mathematical convention, instead of "down" as per the computer
        // graphics convention. This doesn't affect the correctness of the result.

        var upperHull = [];
        for (var i = 0; i < points.size(); i++) {
            var p = points.get(i);
            while (upperHull.size() >= 2) {
                var q = upperHull[upperHull.size() - 1];
                var r = upperHull[upperHull.size() - 2];
                if ((q.x - r.x) * (p.y - r.y) >= (q.y - r.y) * (p.x - r.x)) {
                    upperHull.remove(upperHull[upperHull.size() - 1]);
                } else {
                    break;
                }
            }
            upperHull.add(p);
        }

        upperHull.remove(upperHull[upperHull.size() - 1]);

        var lowerHull = [];
        for (var i = points.size() - 1; i >= 0; i--) {
            var p = points.get(i);
            while (lowerHull.size() >= 2) {
                var q = lowerHull[lowerHull.size() - 1];
                var r = lowerHull[lowerHull.size() - 2];
                if ((q.x - r.x) * (p.y - r.y) >= (q.y - r.y) * (p.x - r.x)) {
                    lowerHull.remove(lowerHull[lowerHull.size() - 1]);
                } else {
                    break;
                }
            }
            lowerHull.add(p);
        }

        lowerHull.remove(lowerHull[lowerHull.size() - 1]);

        if (!(upperHull.size() == 1 && Arrays.equals(upperHull, lowerHull))) {
            upperHull.addAll(lowerHull);
        }
        return upperHull;
    }
}