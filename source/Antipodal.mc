using Toybox.Math;
using Toybox.System;

class Antipodal {
    static var turnComplete = false;

    // Find the distance between two points.
    private static function distance(p, q) {
        // Return the Euclidean distance between the two points.
//        return Math.sqrt((p.x - q.x) * (p.x - q.x) + (p.y - q.y) * (p.y - q.y));
        var distance = p.calculateGCD(q);
        System.println("antipodal distance=" + distance);
        return distance;
    }

    // Find the max distance for a set of 3 points.
    private static function findMaxDistance3(points, a, b, c) {
        // Compute the distance between each of ab, ac and bc and return the largest.
        var distAB = distance (points[a], points[b]);
        var distBC = distance (points[c], points[b]);
        var distAC = distance (points[a], points[c]);
        var maxDist = distAB;

        if (distBC > maxDist) {
            maxDist = distBC;
        }

        if (distAC > maxDist) {
            maxDist = distAC;
        }

        return maxDist;
    }

    // Find the next point in the list going counterclockwise,
    // that is, in increasing order. Go back to zero if needed.
    // Return the array index.
    private static function nextCounterClockwise(points, i) {
        if (i >= points.size() - 1) {
            turnComplete = true;
            return 0;
        }  else {
            return i + 1;
        }
    }

    // Find the next point in counterclockwise order.
    private static function prevCounterClockwise(points, i) {
        if (i <= 0) {
            return points.size() - 1;
        }  else {
            return i - 1;
        }
    }

    public static function twiceTriangleArea(a, b, c) {
//        System.println("twiceTriangleArea(" + a + ", " + b + ", " + c + ")");
        return (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)).abs();
    }

    // Given a convex polygon, an index into the vertex array (a particular vertex),
    // find it's antipodal vertex, the one farthest away. Start the search from
    // a specified vertex, the "startAntipodalIndex"
    private static function findAntipodalIndex(hullPoints, currentIndex, startAntipodalIndex) {
        // Short forms:
        var b = currentIndex;
        var c = startAntipodalIndex;

        // Find the point preceding b:
        var a = prevCounterClockwise(hullPoints, b);

        // We start just behind the starting index:
        var current = prevCounterClockwise(hullPoints, c);

        // Start with area computations, to use in lieu of distance comparisons.
        var areaABC = Antipodal.twiceTriangleArea(hullPoints[a], hullPoints[b], hullPoints[c]);
        var areaABCurrent = Antipodal.twiceTriangleArea(hullPoints[a], hullPoints[b], hullPoints[current]);
//        System.println("areaABC=" + areaABC.format("%3.32f") + " areaABCurrent=" +  areaABCurrent.format("%3.32f"));

        // While the current point (current) is closer than c:
        while (areaABC >= areaABCurrent) {
            // Move current up:
            current = c;

            // Move c up:
            c = nextCounterClockwise(hullPoints, c);

            // Compare distances again:
            areaABC = Antipodal.twiceTriangleArea(hullPoints[a], hullPoints[b], hullPoints[c]);
            areaABCurrent = Antipodal.twiceTriangleArea(hullPoints[a], hullPoints[b], hullPoints[current]);
//            System.println("areaABC=" + areaABC + " areaABCurrent=" +  areaABCurrent);
        }

        // When distances start decreasing, return the currently largest one:
        return current;
    }

    public static function findLargestDistance(points) {
        // Compute the convex hull:
        var hullPoints = ConvexHull.makeHull(points);

        if (hullPoints.size() <= 1) {
            return 0;
        } else if (hullPoints.size() == 2) {
            return Antipodal.distance(hullPoints[0], hullPoints[1]);
        } else if (hullPoints.size() == 3) {
            return findMaxDistance3(hullPoints, 0, 1, 2);
        }

        // Otherwise, we start an antipodal scan.
        var over = false;

        // Start the scan at vertex 0, using the edge ending at 0:
        var currentIndex = 0;
        var prevIndex = prevCounterClockwise(hullPoints, currentIndex);

        // Find the antipodal vertex for edge (n - 1, 0):
        var antiPodalIndex = findAntipodalIndex(hullPoints, currentIndex, 1);

        // Set the current largest distance:
        var maxDist = findMaxDistance3(hullPoints, currentIndex, prevIndex, antiPodalIndex);
        // We'll stop once we've gone around and come back to vertex 0.
        var dist = 0;
        turnComplete = false;

        // While the turn is not complete:
        while (!over) {
            // Find the next edge:
            prevIndex = currentIndex;
            currentIndex = nextCounterClockwise(hullPoints, currentIndex);

            // Get its antipodal vertex:
            antiPodalIndex = findAntipodalIndex(hullPoints, currentIndex, antiPodalIndex);

            // Compute the distance:
            dist = findMaxDistance3(hullPoints, currentIndex, prevIndex, antiPodalIndex);

            // Record maximum:
            if (dist > maxDist) {
                maxDist = dist;
            }

            // Check whether turn is complete:
            if (turnComplete) {
                over = true;
            }
        }

        // Return largest distance found.
        return maxDist;
    }


    (:test)
    function twiceTriangleAreaOk(logger) {
        var expected = 335;
        var actual = Antipodal.twiceTriangleArea(new Point(15, 15), new Point(23, 30), new Point(40, 20));
        logger.debug("expected=" + expected + " actual=" + actual);
        return expected == actual;
    }
}