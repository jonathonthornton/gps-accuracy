class Point {
	public var x;
	public var y;
	
	public function initialize(x, y) {
		self.x = x;
		self.y = y;
	}
	
	public function subtract(p) {
		return new Point(x - p.x, y - p.y);
	}
	
	public function distance(p) {
		return MyMath.hypot(x - p.x, y - p.y);
	}
	
	public function cross(p) {
		return self.x * p.y - y * p.x;
	}
	
	public function equals(other) {
		return x == other.x && y == other.y;
	}
	
	public function toString() {
		return "Point(" + x + "," + y + ")";
	}
}