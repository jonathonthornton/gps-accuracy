using Toybox.Math as Math;

class Circle {
	private static const MULTIPLICATIVE_EPSILON = 1.0d + Math.pow(10.0d, -14);
	private static const R = 6371000;
	
	public var centre;
	public var radius;

	public function initialize(point, radius) {
		self.centre = point;
		self.radius = radius;
	}
	
	public function contains(point) {
		return centre.distance(point) <= radius * MULTIPLICATIVE_EPSILON;
	}
	
	public function containsAll(points) {
		for (var i = 0; i < points.size(); i++) {
			if (!contains(points[i])) {
				return false;
			}
			return true;
		}
	}
	
	public function getWidthAsGCD() {
		var p1 = new Point(centre.x - radius, centre.y);
		var p2 = new Point(centre.x + radius, centre.y);	
		return calculateGCD(p1, p2);
	}
	
	private static function calculateGCD(p1, p2) {
		var lat1 = p1.x * Math.PI / 180;
		var lat2 = p2.x * Math.PI / 180;
		var deltaLat = (p2.x - p1.x) * Math.PI / 180;
		var deltaLong = (p2.y - p1.y) * Math.PI / 180;
		
		var a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
			Math.cos(lat1) * Math.cos(lat2) *
			Math.sin(deltaLong / 2) * Math.sin(deltaLong / 2);
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		var d = R * c; // in metres.
		
		return d;
	}
	
	public function toString() {
		return "Circle(x=" + centre.x + ", y=" + centre.y + ", r=" + radius + ")";
	}
	
	(:test)
	function containsOk(logger) {
		var circle = new Circle(new Point(0, 0), 3);
		return
			circle.contains(new Point(-1, 1)) &&
			circle.contains(new Point(1, 1)) &&
			circle.contains(new Point(-1, -1)) &&
			circle.contains(new Point(1, -1)) &&
			!circle.contains(new Point(4, 4));
	}
	
	(:test)
	function getWidthAsGCDOk(logger) {
		var p1 = new Point(38.555421, -94.799646);
		var p2 = new Point(38.855421, -94.698646);
		var gcd = Circle.calculateGCD(p1, p2);
		logger.debug("GCD=" + gcd);	
		return gcd > 34490 && gcd < 34491;
	}
}