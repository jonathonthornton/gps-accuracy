class ArraysTest {
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
    function mergeSortOk(logger) {
        var array = [];
        var pointCount = 10;

        for (var i = 0; i < pointCount; i++) {
            array.add(new Point(Math.rand() % 100, Math.rand() % 100));
        }

        Arrays.mergeSort(array);

        for (var i = 0; i < pointCount - 1; i++) {
            logger.debug(array[i]);
            if (array[i].compareTo(array[i + 1]) > 0) {
                return false;
            }
        }

        return true;
    }

    (:test)
    function equalsTrueWhenEqual(logger) {
        var a1 = [new Point(1, 1)];
        var a2 = [new Point(1, 1)];
        return Arrays.equals(a1, a2);
    }

    (:test)
    function equalsTrueWhenBothNull(logger) {
        return Arrays.equals(null, null);
    }

    (:test)
    function equalsFalseWhenDifferentLength(logger) {
        var a1 = [new Point(1, 1), new Point(2, 2)];
        var a2 = [new Point(1, 1)];
        return !Arrays.equals(a1, a2);
    }

    (:test)
    function equalsFalseWhenDifferentContent(logger) {
        var a1 = [new Point(1, 1), new Point(2, 2)];
        var a2 = [new Point(1, 1), new Point(3, 3)];
        return !Arrays.equals(a1, a2);
    }

    (:test)
    function equalsFalseWhenFirstNull(logger) {
        var a1 = null;
        var a2 = [new Point(1, 1)];
        return !Arrays.equals(a1, a2);
    }

    (:test)
    function equalsFalseWhenSecondNull(logger) {
        var a1 = [new Point(1, 1)];
        var a2 = null;
        return !Arrays.equals(a1, a2);
    }
}