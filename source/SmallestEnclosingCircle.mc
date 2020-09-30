using Toybox.Math;
using Toybox.System;

// See https://www.nayuki.io/page/smallest-enclosing-circle
class SmallestEnclosingCircle {
	public static function makeCircle(points) {
		System.println("makeCircle points=" + points);
		var shuffled = points.shuffle().toArray();
		
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
		var ox = (MyMath.min(MyMath.min(a.x, b.x), c.x) + MyMath.max(MyMath.max(a.x, b.x), c.x)) / 2;
		var oy = (MyMath.min(MyMath.min(a.y, b.y), c.y) + MyMath.max(MyMath.max(a.y, b.y), c.y)) / 2;
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
		var r = MyMath.max(MyMath.max(p.distance(a), p.distance(b)), p.distance(c));
		return new Circle(p, r);
	}
	
	private static function makeDiameter(a, b) {
		var c = new Point((a.x + b.x) / 2, (a.y + b.y) / 2);
		return new Circle(c, MyMath.max(c.distance(a), c.distance(b)));
	}
}