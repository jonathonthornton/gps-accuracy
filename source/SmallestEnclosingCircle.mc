using Toybox.Math;
using Toybox.System;

class SmallestEnclosingCircle {

	public static function makeCircle(points) {
		var shuffled = shuffle(points);
		System.println("shuffled=" + shuffled);
		
		var c = null;
		for (var i = 0; i < shuffled.size(); i++) {
			var p = shuffled[i];
			if (c == null || !c.contains(p)) {
				c = makeCircleOnePoint(shuffled.slice(0, i + 1), p);
			}
		}
		return c;
	}
	
	private static function makeCircleOnePoint(points, p) {
		var c = new Circle(p, 0);
		for (var i = 0; i < points.size(); i++) {
			var q = points[i];
			if (!c.contains(q)) {
				if (c.radius == 0) {
					c = makeDiameter(p, q);
				} else {
					c = makeCircleTwoPoints(points.slice(0, i + 1), p, q);
				}
			}
		}
		return c;
	}
	
	private static function makeCircleTwoPoints(points, p, q) {
		var circle = makeDiameter(p, q);
		var left = null;
		var right = null;
		
		// For each point not in the two-point circle
		var pq = q.subtract(p);
		for (var i = 0; i < points.size(); i++) {
			var r = points[i];
			if (circle.contains(r)) {
				continue;
			}
			
			// Form a circumcircle and classify it on left or right side
			var cross = pq.cross(r.subtract(p));
			var c = makeCircumcircle(p, q, r);
			if (c == null) {
				continue;
			} else if (cross > 0 && (left == null || pq.cross(c.centre.subtract(p)) > pq.cross(left.centre.subtract(p)))) {
				left = c;
			} else if (cross < 0 && (right == null || pq.cross(c.centre.subtract(p)) < pq.cross(right.centre.subtract(p)))) {
				right = c;
			}
		}
		
		// Select which circle to return
		if (left == null && right == null) {
			return circle;
		} else if (left == null) {
			return right;
		} else if (right == null) {
			return left;
		} else {
			return left.radius <= right.radius ? left : right;
		}
	}
	
	private static function makeCircumcircle(a, b, c) {
		// Mathematical algorithm from Wikipedia: Circumscribed circle
		var ox = (min(min(a.x, b.x), c.x) + max(max(a.x, b.x), c.x)) / 2;
		var oy = (min(min(a.y, b.y), c.y) + max(max(a.y, b.y), c.y)) / 2;
		var ax = a.x - ox, ay = a.y - oy;
		var bx = b.x - ox, by = b.y - oy;
		var cx = c.x - ox, cy = c.y - oy;
		var d = (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)) * 2;
		if (d == 0) {
			return null;
		}
		var x = ((ax * ax + ay * ay) * (by - cy) + (bx * bx + by * by) * (cy - ay) + (cx * cx + cy * cy) * (ay - by)) / d;
		var y = ((ax * ax + ay * ay) * (cx - bx) + (bx * bx + by * by) * (ax - cx) + (cx * cx + cy * cy) * (bx - ax)) / d;
		var p = new Point(ox + x, oy + y);
		var r = max(max(p.distance(a), p.distance(b)), p.distance(c));
		return new Circle(p, r);
	}
	
	private static function makeDiameter(a, b) {
		var c = new Point((a.x + b.x) / 2, (a.y + b.y) / 2);
		return new Circle(c, max(c.distance(a), c.distance(b)));
	}
	
	private static function min(x, y) {
		return (x < y) ? x : y;
	}
	
	private static function max(x, y) {
		return (x > y) ? x : y;
	}
	
	private static function shuffle(points) {
		var shuffled = points.slice(0, points.size()); // Clone the array.
		var size = shuffled.size();
		
		for (var i = 0; i < size; i++) {
			var j = i + (Math.rand() % (size - i));
			var k = new Point(shuffled[j].x, shuffled[j].y);
			shuffled[j] = new Point(shuffled[i].x, shuffled[i].y);
			shuffled[i] = k;
		}
		return shuffled;
	}
	
	(:test)
	function shuffleOk(logger) {
		var points = [new Point(1, 1), new Point(2, 2), new Point(3, 3), new Point(4, 4), new Point(5, 5)];
		
		for (var i = 0; i < 20; i++) {
			var shuffled = SmallestEnclosingCircle.shuffle(points);
			
			if (shuffled.size() != points.size()) {
				return false;
			}
			
			for (var j = 0; j < points.size(); j++) {
				if (!SmallestEnclosingCircle.arrayContainsPoint(shuffled, points[j])) {
					return false;
				}
			}
			logger.debug(shuffled);
		}
		return true;
	}
	
	private static function arrayContainsPoint(array, point) {
		for (var i = 0; i < array.size(); i++) {
			if (array[i].equals(point)) {
				return true;
			}
		}
		return false;
	}
}