using Toybox.Math;

class Arrays {

    // Array elements must implement the clone() method.
    public static function shuffle(array) {
        var size = array.size();

        for (var i = 0; i < size; i++) {
            var j = i + (Math.rand() % (size - i));
            var temp = array[j].clone();
            array[j] = array[i];
            array[i] = temp;
        }
    }

    // See https://www.geeksforgeeks.org/merge-sort/
    // Array elements must implement the compareTo() method.
    public static function mergeSort(array) {
        mergeSortImpl(array, 0, array.size() - 1);
    }

    private static function merge(array, l, m, r)
    {
        // Find sizes of two subarrays to be merged.
        var n1 = m - l + 1;
        var n2 = r - m;

        // Create temp arrays.
        var L = new [n1];
        var R = new [n2];

        // Copy array to temp arrays.
        for (var i = 0; i < n1; i++) {
            L[i] = array[l + i];
        }

        for (var j = 0; j < n2; j++) {
            R[j] = array[m + 1 + j];
        }

        // Merge the temp arrays.

        // Initial indexes of first and second subarrays.
        var i = 0, j = 0;

        // Initial index of merged subarray.
        var k = l;

        while (i < n1 && j < n2) {
            if (L[i].compareTo(R[j]) <= 0) {
                array[k] = L[i];
                i++;
            }
            else {
                array[k] = R[j];
                j++;
            }
            k++;
        }

        // Copy remaining elements of L[] if any.
        while (i < n1) {
            array[k] = L[i];
            i++;
            k++;
        }

        // Copy remaining elements of R[] if any.
        while (j < n2) {
            array[k] = R[j];
            j++;
            k++;
        }
    }

    private static function mergeSortImpl(array, l, r) {
        if (l < r) {
            // Find the middle point.
            var m = (l + r) / 2;

            // Sort first and second halves.
            Arrays.mergeSortImpl(array, l, m);
            Arrays.mergeSortImpl(array, m + 1, r);

            // Merge the sorted halves.
            Arrays.merge(array, l, m, r);
       }
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
}