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

    public function getAccuracyRotatingCalipers() {
        System.println("getAccuracyRotatingCalipers()");
        return RotatingCalipers.getMaxDistance(self);
    }

    public function getAccuracyBruteForce() {
        return Points.getAccuracyBruteForceImpl(pointsArray);
    }

    private static function getAccuracyBruteForceImpl(pointsArray) {
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

    // Edges are parallel, but shape only approximately square. Shape is a rectangle.
    public static function getSquare() {
        var pointArray = [
            new Point(-37.706963, 145.680826), // Top left.
            new Point(-37.706963, 145.692423), // Top right.
            new Point(-37.715580, 145.680826), // Bottom left.
            new Point(-37.715580, 145.692423)  // Bottom right.
        ];
        return new Points(pointArray);
    }

    (:test)
    function isSmallestEnclosingCircleFast(logger) {
        var pointCount = 1000;
        var points = Points.getRandomPoints(pointCount);

        var t1 = Time.now();
        points.getSmallestEnclosingCircle();
        var t2 = Time.now();

        var secs = MyMath.max(t2.subtract(t1).value(), 1);
        var pointsPerSec = pointCount / secs;

        logger.debug("duration=" + secs + " secs");
        logger.debug("pointsPerSec=" + pointsPerSec);
        return pointsPerSec > 100;
    }

    (:test)
    function areRotatingCalipersFast(logger) {
        var pointCount = 1000;
        var points = Points.getRandomPoints(pointCount);

        var t1 = Time.now();
        points.getAccuracyRotatingCalipers();
        var t2 = Time.now();

        var secs = MyMath.max(t2.subtract(t1).value(), 1);
        var pointsPerSec = pointCount / secs;

        logger.debug("duration=" + secs + " secs");
        logger.debug("pointsPerSec=" + pointsPerSec);
        return pointsPerSec > 100;
    }

    (:test)
    function doAccuracyMethodsAgree(logger) {
        var points = Points.getRandomPoints(10);
        var bruteForce = points.getAccuracyBruteForce();
        var smallestEnclosingCircle = points.getAccuracySmallestEnclosingCircle();
        var convexHull = points.getAccuracyConvexHull();
        var rotatingCalipers = points.getAccuracyRotatingCalipers();

        logger.debug("bruteForce=" + bruteForce);
        logger.debug("smallestEnclosingCircle=" + smallestEnclosingCircle);
        logger.debug("convexHull=" + convexHull);
        logger.debug("rotatingCalipers=" + rotatingCalipers);

        return
            bruteForce == smallestEnclosingCircle &&
            smallestEnclosingCircle == convexHull &&
            convexHull == rotatingCalipers;
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