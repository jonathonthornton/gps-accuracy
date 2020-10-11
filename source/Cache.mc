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

    (:test)
    function toArrayReturnsPortionOfCacheWhenCacheNotFull(logger) {
        var cache = new Cache(3);
        cache.add("the");

        var contents = cache.toArray();
        return
            contents.size() == 1 &&
            contents[0].equals("the");
    }

    (:test)
    function addOverwritesOldestItemWhenCacheFull(logger) {
        var cache = new Cache(3);
        cache.add("the");
        cache.add("quick");
        cache.add("brown");
        cache.add("fox");

        var contents = cache.toArray();
        if (!(
            contents.size() == 3 &&
            contents[0].equals("quick") &&
            contents[1].equals("brown") &&
            contents[2].equals("fox"))) {
                return false;
        }

        cache.add("jumps");
        contents = cache.toArray();
        if (!(
            contents.size() == 3 &&
            contents[0].equals("brown") &&
            contents[1].equals("fox") &&
            contents[2].equals("jumps"))) {
                return false;
        }

        cache.add("over");
        contents = cache.toArray();
        if (!(
            contents.size() == 3 &&
            contents[0].equals("fox") &&
            contents[1].equals("jumps") &&
            contents[2].equals("over"))) {
                return false;
        }

        cache.add("a");
        contents = cache.toArray();
        if (!(
            contents.size() == 3 &&
            contents[0].equals("jumps") &&
            contents[1].equals("over") &&
            contents[2].equals("a"))) {
                return false;
        }

        cache.add("dog");
        contents = cache.toArray();
        return
            contents.size() == 3 &&
            contents[0].equals("over") &&
            contents[1].equals("a") &&
            contents[2].equals("dog");
    }
}