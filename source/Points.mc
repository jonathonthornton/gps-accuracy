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
	
	public function get(index) {
		return points[index];
	}
	
	public function getSmallestEnclosingCircle() {
		return SmallestEnclosingCircle.makeCircle(self);
	}
	
	public function toPixelArray(newMin, newMax) {
		var factor = 1 << 6;
		var oldMin = new Point(getMinX() * factor, getMinY() * factor);
		var oldMax = new Point(getMaxX() * factor, getMaxY() * factor);
		var result = [];
		
		for (var i = 0; i < points.size(); i++) {
			var x = MyMath.mapValueToRange(oldMin.x, oldMax.x, newMin.x, newMax.x, points[i].x * factor);
        	var y = MyMath.mapValueToRange(oldMin.y, oldMax.y, newMin.y, newMax.y, points[i].y * factor);
        	result.add(new Point(x.toNumber(), y.toNumber()));
		}
		
		return result;
	}
	
	public function toPixelCircle(newMin, newMax) {
		var sec = getSmallestEnclosingCircle();
		var factor = 1 << 6;
		var oldMin = new Point(getMinX() * factor, getMinY() * factor);
		var oldMax = new Point(getMaxX() * factor, getMaxY() * factor);
		
		var centreX = MyMath.mapValueToRange(oldMin.x, oldMax.x, newMin.x, newMax.x, sec.centre.x * factor).toNumber();
        var edgeX = MyMath.mapValueToRange(oldMin.x, oldMax.x, newMin.x, newMax.x, (sec.centre.x + sec.radius) * factor).toNumber();		
        var centreY = MyMath.mapValueToRange(oldMin.y, oldMax.y, newMin.y, newMax.y, sec.centre.y * factor).toNumber();
        var radius = edgeX - centreX;
        return new Circle(new Point(centreX.toNumber(), centreY.toNumber()), radius);	
	}
	
	public function getMinX() {
		var result = 9999999;
		for (var i = 0; i < points.size(); i++) {
			if (points[i].x < result) {
				result = points[i].x;
			}
		}
		return result;
	}
	
	public function getMaxX() {
		var result = -9999999;
		for (var i = 0; i < points.size(); i++) {
			if (points[i].x > result) {
				result = points[i].x;
			}
		}
		return result;
	}
	
	public function getMinY() {
		var result = 9999999;
		for (var i = 0; i < points.size(); i++) {
			if (points[i].y < result) {
				result = points[i].y;
			}
		}
		return result;
	}
	
	public function getMaxY() {
		var result = -9999999;
		for (var i = 0; i < points.size(); i++) {
			if (points[i].y > result) {
				result = points[i].y;
			}
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