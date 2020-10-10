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
            var head = cache.slice(i + 1, cache.size());
            var tail = cache.slice(0, i);
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
    function addOverwritesOldestItemWhenQueueFull(logger) {
        var cache = new Cache(3);
        cache.add("the");
        cache.add("quick");
        cache.add("brown");
        cache.add("jumps");
        cache.add("over");
        cache.add("a");
        cache.add("lazy");
        cache.add("dog");

        var contents = cache.toArray();
        var size = contents.size();

        return
            contents.size() == 3 &&
            contents[0].equals("a") &&
            contents[1].equals("lazy") &&
            contents[2].equals("dog");
    }
}