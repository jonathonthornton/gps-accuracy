using Toybox.Math;

class Arrays {

    // Array elements must implement the equals() method.
    public static function equals(a1, a2) {
        if (a1 == null) {
            return a2 == null;
        }

        if (a2 == null) {
            return false;
        }

        if (a1.size() != a2.size()) {
            return false;
        }

        for (var i = 0; i < a1.size(); i++) {
            if (!a1[i].equals(a2[i])) {
                return false;
            }
        }

        return true;
    }

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
}