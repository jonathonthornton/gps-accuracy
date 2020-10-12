class PointsTest {

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
        var rotatingCalipers = points.getAccuracyRotatingCalipers();

        logger.debug("bruteForce=" + bruteForce);
        logger.debug("rotatingCalipers=" + rotatingCalipers);

        return bruteForce == rotatingCalipers;
    }

    (:test)
    function boundingBoxOkWhenOnePoint(logger) {
        var pointsArray = [new Point(2, 2)];
        var points = new Points(pointsArray);
        var boundingBox = points.getBoundingBox();
        logger.debug("boundingBox=" + boundingBox);
        return
            boundingBox.topLeft.x == 2 &&
            boundingBox.topLeft.y == 2 &&
            boundingBox.bottomRight.x == 2 &&
            boundingBox.bottomRight.y == 2;
    }

    (:test)
    function boundingBoxOkWhenMultiplePoints(logger) {
        var pointsArray = [
            new Point(2, 2),
            new Point(1, 4),
            new Point(3, 7),
            new Point(5, 6),
            new Point(6, 4),
            new Point(4, 2)
        ];
        var points = new Points(pointsArray);
        var boundingBox = points.getBoundingBox();
        logger.debug("boundingBox=" + boundingBox);
        return
            boundingBox.topLeft.x == 1 &&
            boundingBox.topLeft.y == 7 &&
            boundingBox.bottomRight.x == 6 &&
            boundingBox.bottomRight.y == 2;
    }

    (:test)
    function boundingBoxThrowsWhenNullPoints(logger) {
        var points = new Points(null);

        try {
            points.getBoundingBox();
        } catch (e) {
            return true;
        }

        return false;
    }

    (:test)
    function boundingBoxThrowsWhenZeroPoints(logger) {
        var points = new Points([]);

        try {
            points.getBoundingBox();
        } catch (e) {
            return true;
        }

        return false;
    }
}