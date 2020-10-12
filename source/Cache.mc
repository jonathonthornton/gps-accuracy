class Cache {
    private var cache = null;
    private var isFull = false;
    private var i = 0;

    function initialize(count) {
        cache = new [count];
    }

    function add(item) {
        if (i > cache.size() - 1) {
            i = 0;
            isFull = true;
        }
        cache[i] = item;
        i++;
    }

    function toArray() {
        if (isFull) {
            var head = cache.slice(i, cache.size());
            var tail = cache.slice(0, i);
//            System.println("head=" + head + " tail=" + tail);
            return head.addAll(tail);
        } else {
            return cache.slice(0, i);
        }
    }
}