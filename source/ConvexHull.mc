using Toybox.System;

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

        if (!(upperHull.size() == 1 && upperHull.equals(lowerHull))) {
            upperHull.addAll(lowerHull);
        }
        return upperHull;
    }

    (:test)
    function makeHullOk(logger) {
        var edge = [
            new Point(2, 2),
            new Point(4, 2),
            new Point(1, 4),
            new Point(6, 4),
            new Point(3, 7),
            new Point(5, 6)
        ];
        var inside = [
            new Point(3, 4),
            new Point(4, 3),
            new Point(3, 6),
            new Point(4, 6)
        ];

        var all = [];
        all.addAll(edge);
        all.addAll(inside);

        var hull = ConvexHull.makeHull(new Points(all));
        logger.debug("hull=" + hull);

        for (var i = 0; i < edge.size(); i++) {
            var found = false;
            for (var j = 0; j < hull.size(); j++) {
                if (edge[i].equals(hull[j])) {
                    logger.debug(edge[i] + " is on edge");
                    found = true;
                    break;
                }
            }
            if (!found) {
                logger.debug(edge[i] + "expected but not found");
                return false;
            }
        }

        for (var i = 0; i < inside.size(); i++) {
            for (var j = 0; j < hull.size(); j++) {
                if (inside[i].equals(hull[j])) {
                    logger.debug(inside[i] + " incorrectly classified as edge");
                    return false;
                }
            }
            logger.debug(inside[i] + " is not on edge");
        }

        return true;
    }
}