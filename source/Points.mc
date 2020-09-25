using Toybox.Math;

class Points {
	var points = null;
	
	public function initialize(pointArray) {
		self.points = pointArray;
	}
	
	public  function shuffle() {
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
	
	function get(index) {
		return points[index];
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
	

}