using Toybox.Math;
using Toybox.System;

// See https://www.geeksforgeeks.org/maximum-distance-between-two-points-in-coordinate-plane-using-rotating-calipers-method/
class RotatingCalipers {
    public static function getMaxDistance(points) {
        var hull = ConvexHull.makeHull(points);
        var n = hull.size();

        // Base Cases.
        if (n <= 1) {
            return 0;
        } else if (n == 2) {
            return hull[0].calculateDistance(hull[1]);
        }
        var k = 1;

        // Find the farthest vertex from hull[0] and hull[n-1]
        while (absArea(hull[n - 1], hull[0], hull[(k + 1) % n])
               > absArea(hull[n - 1], hull[0], hull[k])) {
            k++;
        }

        var result = 0;

        // Check points from 0 to k
        for (var i = 0, j = k; i <= k && j < n; i++) {
            result = MyMath.max(result, hull[i].calculateDistance(hull[j]));

            while (j < n && absArea(hull[i], hull[(i + 1) % n], hull[(j + 1) % n])
                          > absArea(hull[i], hull[(i + 1) % n], hull[j])) {
                System.println("RotatingCaliper iterating.");
                // Update result.
                result = MyMath.max(result, hull[i].calculateDistance(hull[(j + 1) % n]));
                j++;
            }
        }

        // Return the result distance.
        return result;
    }

    private static function area(p, q, r) {
        // 2 * (area of triangle)
        return ((p.y - q.y) * (q.x - r.x) - (q.y - r.y) * (p.x - q.x));
    }

    private static function absArea(p, q, r) {
        // Unsigned area 2 * (area of triangle)
        return (area(p, q, r)).abs();
    }
}