using Toybox.Math;
using Toybox.System;
using Toybox.Time;

class Points {
    var pointsArray = null;

    public function initialize(pointsArray) {
        self.pointsArray = pointsArray;
    }

    public function clone() {
        var clonedPointsArray = pointsArray.slice(0, pointsArray.size());
        return new Points(clonedPointsArray);
    }

    public function shuffle() {
        Arrays.shuffle(pointsArray);
    }

    public function sort() {
        Arrays.mergeSort(pointsArray);
    }

    public function containsPoint(point) {
        for (var i = 0; i < pointsArray.size(); i++) {
            if (pointsArray[i].equals(point)) {
                return true;
            }
        }
        return false;
    }

    public function getSmallestEnclosingCircle() {
        return SmallestEnclosingCircle.makeCircle(self);
    }

    public function getAccuracyRotatingCalipers() {
        System.println("getAccuracyRotatingCalipers()");
        return RotatingCalipers.getMaxDistance(self);
    }

    public function getAccuracyBruteForce() {
        // N^2 efficiency.
        var result = 0;
        var distanceCount = 0;

        for (var i = 0; i < pointsArray.size() - 1; i++) {
            for (var j = i + 1; j < pointsArray.size(); j++) {
                var distance = pointsArray[i].calculateGCD(pointsArray[j]);
                distanceCount++;
                if (distance > result) {
                    result = distance;
                }
            }
        }

        System.println("getAccracyBruteForce() distanceCount=" + distanceCount);

        return result == null ? 0 : result;
    }

    public function toPixelArray(boundingBoxTo) {
        var mercPoints = toMercator();
        var mercArray = mercPoints.pointsArray;
        var boundingBoxFrom = mercPoints.getBoundingBox();
        var result = new [mercArray.size()];

        for (var i = 0; i < mercArray.size(); i++) {
            var merc = mercArray[i];

           // Map the longitude merc to the x range.
            var x = MyMath.mapValueToRange(
                boundingBoxFrom.topLeft.y,
                boundingBoxFrom.bottomRight.y,
                boundingBoxTo.topLeft.x,
                boundingBoxTo.bottomRight.x,
                merc.y);

            // Map the latitude to the y range.
            // Invert the values on output so that y increases down the screen.
            var y = MyMath.mapValueToRange(
                boundingBoxFrom.topLeft.x,
                boundingBoxFrom.bottomRight.x,
                boundingBoxTo.bottomRight.y,
                boundingBoxTo.topLeft.y,
                merc.x);

            result[i] = new Point(x.toNumber(), y.toNumber());
        }

        return result;
    }

    public function toMercator() {
        var result = new [pointsArray.size()];
        for (var i = 0; i < pointsArray.size(); i++) {
            result[i] = pointsArray[i].toMercator();
        }
        return new Points(result);
    }

    public function getBoundingBox() {
        if (pointsArray == null || pointsArray.size() <= 0) {
            throw new BoundingBoxException("Cannot compute bounding box of empty array.");
        }

        var minX = pointsArray[0].x;
        var minY = pointsArray[0].y;
        var maxX = minX;
        var maxY = minY;

        for (var i = 1; i < pointsArray.size(); i++) {
            var point = pointsArray[i];
            if (point.x < minX) {
                minX = point.x;
            } else if (point.x > maxX) {
                maxX = point.x;
            }
            if (point.y < minY) {
                minY = point.y;
            } else if (point.y > maxY) {
                maxY = point.y;
            }
        }

        return new BoundingBox(new Point(minX, maxY), new Point(maxX, minY));
    }

    public function get(index) {
        return pointsArray[index];
    }

    public function size() {
        return pointsArray.size();
    }

    public function toArray() {
        return pointsArray;
    }

    public function toString() {
        return pointsArray.toString();
    }

    public static function getRandomPoints(pointCount) {
        Math.srand(Time.now().value());
        var pointArray = new [pointCount];
        var point = new Point(-37.706568, 145.681750);
        var i = 0;

        do {
            pointArray[i] = point;
            point = point.clone();

            var sign = Math.rand() % 2 ? 1 : -1;
            point.x += (Math.rand() % 1000) * 0.000001 * sign;

            sign = Math.rand() % 2 ? 1 : -1;
            point.y += (Math.rand() % 1000) * 0.000001 * sign;
            i++;
        } while (i < pointArray.size());

        return new Points(pointArray);
    }

    // Edges are parallel and angles are right, but shape only approximately square. Shape is a rectangle.
    public static function getSquare() {
        var latTop = -37.706963;
        var latBottom = -37.715580;
        var longLeft = 145.680826;
        var longRight = 145.692423;
        var pointArray = [
            new Point(latTop, longLeft),
            new Point(latTop, longRight),
            new Point(latBottom, longLeft),
            new Point(latBottom, longRight)
        ];
        return new Points(pointArray);
    }
}