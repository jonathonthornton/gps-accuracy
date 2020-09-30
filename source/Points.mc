using Toybox.Math;

class Points {
    var points = null;

    public function initialize(pointArray) {
        self.points = pointArray;
    }

    public function shuffle() {
        var shuffled = points.slice(0, points.size()); // Clone the array.
        var size = shuffled.size();

        for (var i = 0; i < size; i++) {
            var j = i + (Math.rand() % (size - i));
            var k = new Point(shuffled[j].x, shuffled[j].y);
            shuffled[j] = new Point(shuffled[i].x, shuffled[i].y);
            shuffled[i] = k;
        }
        return new Points(shuffled);
    }

    public function containsPoint(point) {
        for (var i = 0; i < points.size(); i++) {
            if (points[i].equals(point)) {
                return true;
            }
        }
        return false;
    }

    public function get(index) {
        return points[index];
    }

    public function getSmallestEnclosingCircle() {
        return SmallestEnclosingCircle.makeCircle(self);
    }

    public function toPixelArray(newMin, newMax) {
        // Convert the min/max lat/long to Mercator projection.
        var oldMin = new Point(MyMath.latToMercator(getMinX()), MyMath.longToMercator(getMinY()));
        var oldMax = new Point(MyMath.latToMercator(getMaxX()), MyMath.longToMercator(getMaxY()));
        var result = new[points.size()];

        for (var i = 0; i < points.size(); i++) {
            // Convert the y long value to Mercator and then map the result to the new x range.
            var x = MyMath.mapValueToRange(oldMin.y, oldMax.y, newMin.x, newMax.x, MyMath.longToMercator(points[i].y));

            // Convert the x lat value to Mercator and then map the result to the new y range.
            var y = MyMath.mapValueToRange(oldMin.x, oldMax.x, newMin.y, newMax.y, MyMath.latToMercator(points[i].x));

            result[i] = new Point(x.toNumber(), y.toNumber());
        }

        return result;
    }

    public function getMinX() {
        var result = MyMath.MAX_INT;
        for (var i = 0; i < points.size(); i++) {
            result = MyMath.min(result, points[i].x);
        }
        return result;
    }

    public function getMaxX() {
        var result = MyMath.MIN_INT;
        for (var i = 0; i < points.size(); i++) {
            result = MyMath.max(result, points[i].x);
        }
        return result;
    }

    public function getMinY() {
        var result = MyMath.MAX_INT;
        for (var i = 0; i < points.size(); i++) {
            result = MyMath.min(result, points[i].y);
        }
        return result;
    }

    public function getMaxY() {
        var result = MyMath.MIN_INT;
        for (var i = 0; i < points.size(); i++) {
            result = MyMath.max(result, points[i].y);
        }
        return result;
    }

    public function size() {
        return points.size();
    }

    public function toArray() {
        return points;
    }

    public function toString() {
        return points.toString();
    }

    (:test)
    function shuffleOk(logger) {
        var pointsArray = [new Point(1, 1), new Point(2, 2), new Point(3, 3), new Point(4, 4), new Point(5, 5)];
        var points = new Points(pointsArray);

        for (var i = 0; i < 20; i++) {
            var shuffled = points.shuffle();

            if (shuffled.size() != points.size()) {
                return false;
            }

            for (var j = 0; j < points.size(); j++) {
                if (!shuffled.containsPoint(points.get(j))) {
                    return false;
                }
            }
            logger.debug(shuffled);
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