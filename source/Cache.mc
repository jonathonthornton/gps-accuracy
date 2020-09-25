class Cache {

	private var cache = null;
	private var isFull = false;
	private var i = 0;
	
	function initialize(count) {
		cache = new[count];
	}
	
	function add(item) {
		if (i > cache.size() - 1) {
			i = 0;
			isFull = true;
		}
		cache[i] = item;
		i++;
	}
	
	function get() {
		if (isFull) {
			return cache;
		} else {
			return cache.slice(0, i);
		}
	}
		
	(:test)
	function addItemOk(logger) {
		var cache = new Cache(3);
		cache.add("the");
		var size = cache.get().size();
		var contents = cache.get();
		
		return 
			size == 1 &&
			contents[0].equals("the");
	}
	
	(:test)
	function addItemWrapsOk(logger) {
		var cache = new Cache(3);
		cache.add("the");
		cache.add("quick");
		cache.add("brown");
		cache.add("fox");
		
		var size = cache.get().size();
		var contents = cache.get();
		
		return
			size == 3 &&
			contents[0].equals("fox") &&
			contents[1].equals("quick") &&
			contents[2].equals("brown");
	}	
}