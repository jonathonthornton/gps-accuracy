using Toybox.Math;
using Toybox.System;

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
        for (var i = 0; i < pointsArray.size(); i++) {
            var j = i + (Math.rand() % (pointsArray.size() - i));
            var tempPoint = new Point(pointsArray[j].x, pointsArray[j].y);
            pointsArray[j] = new Point(pointsArray[i].x, pointsArray[i].y);
            pointsArray[i] = tempPoint;
        }
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

    public function getAccuracySmallestEnclosingCircle() {
        System.println("getAccuracySmallestEnclosingCircle()");
        var sec = getSmallestEnclosingCircle();
        var pointsNearCircumference = [];
        var thresholdDistance = sec.radius * 0.8;

        for (var i = 0; i < pointsArray.size(); i++) {
            if (sec.centre.distance(pointsArray[i]) >= thresholdDistance) {
                pointsNearCircumference.add(pointsArray[i]);
            }
        }

        return Points.getAccuracyBruteForceImpl(pointsNearCircumference);
    }

    public function getAccuracyConvexHull() {
        System.println("getAccuracyConvexHull()");
        var convexHull = ConvexHull.makeHull(self);
        return Points.getAccuracyBruteForceImpl(convexHull);
    }

    public function getAccuracyAntipodal() {
        System.println("getAccuracyAntipodal()");
        return Antipodal.findLargestDistance(self);
    }

    public function getAccuracyBruteForce() {
        return Points.getAccuracyBruteForceImpl(pointsArray);
    }

    private static function getAccuracyBruteForceImpl(pointsArray) {
        // N^2 efficiency.
        var result = null;
        var distanceCount = 0;

        for (var i = 0; i < pointsArray.size() - 1; i++) {
            for (var j = i + 1; j < pointsArray.size(); j++) {
                var distance = pointsArray[i].calculateGCD(pointsArray[j]);
                distanceCount++;
                System.println("getAccracyBruteForce() distance=" + distance);
                if (result == null || result < distance) {
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

        System.println("points size=" + pointsArray.size() + " mercPoints size=" + mercArray.size());

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
            var y = MyMath.mapValueToRange(
                boundingBoxFrom.topLeft.x,
                boundingBoxFrom.bottomRight.x,
                boundingBoxTo.topLeft.y,
                boundingBoxTo.bottomRight.y,
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
        return new BoundingBox(
            new Point(getMinX(), getMinY()),
            new Point(getMaxX(), getMaxY()));
    }

    public function getMinX() {
        var result = MyMath.MAX_INT;
        for (var i = 0; i < pointsArray.size(); i++) {
            result = MyMath.min(result, pointsArray[i].x);
        }
        return result;
    }

    public function getMaxX() {
        var result = MyMath.MIN_INT;
        for (var i = 0; i < pointsArray.size(); i++) {
            result = MyMath.max(result, pointsArray[i].x);
        }
        return result;
    }

    public function getMinY() {
        var result = MyMath.MAX_INT;
        for (var i = 0; i < pointsArray.size(); i++) {
            result = MyMath.min(result, pointsArray[i].y);
        }
        return result;
    }

    public function getMaxY() {
        var result = MyMath.MIN_INT;
        for (var i = 0; i < pointsArray.size(); i++) {
            result = MyMath.max(result, pointsArray[i].y);
        }
        return result;
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

    (:test)
    function shuffleOk(logger) {
        var pointsArray = [new Point(1, 1), new Point(2, 2), new Point(3, 3), new Point(4, 4), new Point(5, 5)];
        var points = new Points(pointsArray);
        var shuffledPoints = points.clone();

        for (var i = 0; i < 10; i++) {
            shuffledPoints.shuffle();

            if (shuffledPoints.size() != points.size()) {
                return false;
            }

            for (var j = 0; j < points.size(); j++) {
                if (!shuffledPoints.containsPoint(points.get(j))) {
                    return false;
                }
            }

            logger.debug("shuffled=" + shuffledPoints);
        }
        return true;
    }

    (:test)
    function minXOk(logger) {
        var pointsArray = [new Point(1, 2), new Point(3, 4), new Point(5, 6)];
        var points = new Points(pointsArray);
        return points.getMinX() == 1;
    }

    (:test)
    function maxXOk(logger) {
        var pointsArray = [new Point(1, 2), new Point(3, 4), new Point(5, 6)];
        var points = new Points(pointsArray);
        return points.getMaxX() == 5;
    }

    (:test)
    function minYOk(logger) {
        var pointsArray = [new Point(1, 2), new Point(3, 4), new Point(5, 6)];
        var points = new Points(pointsArray);
        return points.getMinY() == 2;
    }

    (:test)
    function maxYOk(logger) {
        var pointsArray = [new Point(1, 2), new Point(3, 4), new Point(5, 6)];
        var points = new Points(pointsArray);
        return points.getMaxY() == 6;
    }
}