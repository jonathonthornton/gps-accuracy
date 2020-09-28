using Toybox.Math;
using Toybox.Lang;
using Toybox.System;

class MyMath {
	private static const R = 6371000;
	private static const PI_OVER_180 = Math.PI / 180;

	// See https://www.movable-type.co.uk/scripts/latlong.html
	public static function calculateGCD(p1, p2) {
		var lat1 = p1.x * PI_OVER_180;
		var lat2 = p2.x * PI_OVER_180;
		var deltaLat = (p2.x - p1.x) * PI_OVER_180;
		var deltaLong = (p2.y - p1.y) * PI_OVER_180;
		
		var a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
			Math.cos(lat1) * Math.cos(lat2) *
			Math.sin(deltaLong / 2) * Math.sin(deltaLong / 2);
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
		
		// Return distance in metres.
		return R * c;
	}
	
	public static function mapValueToRange(oldMin, oldMax, newMin, newMax, oldValue) {
		var divideByZeroFiddle = 0.000001;
        return ((oldValue - oldMin) * (newMax - newMin) / (oldMax - oldMin + divideByZeroFiddle)) + newMin;
	}

	public static function hypot(x, y) {
		return Math.sqrt(x * x + y * y);
	}

	public static function min(x, y) {
		return (x < y) ? x : y;
	}
	
	public static function max(x, y) {
		return (x > y) ? x : y;
	}	

	public static function metresToDegrees(metres) {
		return (0.00001 * metres) / 1.105743;
	}
	
	public static function degreesToMetres(degrees) {
		return (1.105743 * degrees) / 0.00001;
	}
	
	(:test)
	function mapValueToRangeOk(logger) {
		var oldMin = 1000;
		var oldMax = 5000;
		var oldStep = 100;
		
		var newMin = 20;
		var newMax = 30;
		
		var expected = [];
		var actual = [];
		
		for (var oldValue = oldMin; oldValue <= oldMax; oldValue += oldStep) {
			expected.add(oldValue);
		}
				
		for (var oldValue = oldMin; oldValue <= oldMax; oldValue += oldStep) {
			var newValue = MyMath.mapValueToRange(oldMin, oldMax, newMin, newMax, oldValue);
			actual.add(newValue);
			logger.debug("oldValue=" + oldValue + " newValue=" + newValue);
		}
		
		for (var newValue = newMin; newValue <= newMax; newValue++) {
			if (actual.indexOf(newValue)) {
				logger.debug("found newValue=" + newValue);
			} else {
				logger.debug("not found newValue=" + newValue);
				return false;
			}
		}
		return true;
	}

	(:test)
	function metresToDegreesOk(logger) {
		var metres = [1.11, 1105.74, 11057.43];
		var degrees = [0.00001, 0.01, 0.1];
		
		for (var i = 0; i < metres.size(); i++) {
			var expected = degrees[i];
			var actual = MyMath.metresToDegrees(metres[i]);
			var difference = (expected - actual).abs();
			logger.debug("expected=" + expected + " actual=" + actual + " difference=" + difference);
			
			if (difference > 0.000001) {
				return false;
			}		
		}
		return true;
	}
	
	(:test)
	function degreesToMetresOk(logger) {
		var metres = [1.11, 1105.74, 11057.43];
		var degrees = [0.00001, 0.01, 0.1];
		
		for (var i = 0; i < metres.size(); i++) {
			var expected = metres[i];
			var actual = MyMath.degreesToMetres(degrees[i]);
			var difference = (expected - actual).abs();
			logger.debug("expected=" + expected + " actual=" + actual + " difference=" + difference);
			
			if (difference > 0.01) {
				return false;
			}		
		}
		return true;
	}	
		
	(:test)
	function getWidthAsGCDOk(logger) {
		var p1 = new Point(38.555421, -94.799646);
		var p2 = new Point(38.855421, -94.698646);
		var gcd = MyMath.calculateGCD(p1, p2);
		logger.debug("GCD=" + gcd);	
		return gcd > 34490 && gcd < 34491;
	}
}