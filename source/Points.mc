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
		
	// http://edspi31415.blogspot.com/2012/09/cartesian-coordinates-to-pixel-screen.html
	public function toPixelArray(minPixel, maxPixel, scaleMetres) {	
		var sec = getSmallestEnclosingCircle();		
		var diameterMetres = sec.getDiameterAsGCD();
		
		if (diameterMetres > scaleMetres || sec.radius == 0) {
			return [];
		}
		
		var xMin = sec.centre.x - sec.radius;
		var xMax = sec.centre.x + sec.radius;
		var yMin = sec.centre.y - sec.radius;
		var yMax = sec.centre.y + sec.radius;
		var xScale = (maxPixel.x - minPixel.x) / (xMax - xMin);
		var yScale = -(maxPixel.y - minPixel.y) / (yMax - yMin);
		
		System.println("minPixel=" + minPixel);
		System.println("maxPixel=" + maxPixel);
		System.println("min=" + new Point(xMin, yMin));
		System.println("max=" + new Point(xMax, yMax));
		System.println("sec.radius=" + sec.radius);	
		System.println("xScale=" + xScale);
		System.println("yScale=" + yScale);
			
		var result = new[points.size()];		
		for (var i = 0; i < points.size(); i++) {
			var xPixel = ((points[i].x - xMin) * xScale) + minPixel.x;			
			var yPixel = ((points[i].y - yMax) * yScale) + minPixel.y;				
			result[i] = new Point(xPixel, yPixel);	
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
}