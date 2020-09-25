using Toybox.WatchUi;
using Toybox.System;

class GpsAccuracyView extends WatchUi.View {
	var info = null;
	var smallestCircle = null;
	var pointArray = null;
	
    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
    }
    
    function onShow() {
    }

    function onHide() {
    }

	function onUpdate(dc) {
        // Set background colour.
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
               
        var halfWidth = dc.getWidth() / 2;
        var halfHeight = dc.getHeight() / 2;     
        
        if (info != null) {
            var string = "Location lat = " + info.position.toDegrees()[0].toString();
            dc.drawText(halfWidth, halfHeight - 40, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "Location long = " + info.position.toDegrees()[1].toString();
            dc.drawText(halfWidth, halfHeight - 20, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "speed = " + info.speed.format("%4.2f");
            dc.drawText(halfWidth, halfHeight, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "alt = " + info.altitude.format("%4.2f");
            dc.drawText(halfWidth, halfHeight + 20, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "heading = " + info.heading.toString();
            dc.drawText(halfWidth, halfHeight + 40, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "GPS Accuracy(m) = " + smallestCircle.getDiameterAsGCD().format("%4.2f");
            dc.drawText(halfWidth, halfHeight + 80, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
        } else {
            dc.drawText(halfWidth, halfHeight, Graphics.FONT_SMALL, "No position info", Graphics.TEXT_JUSTIFY_CENTER);
        }
     }

    function setPosition(info) {
        self.info = info;
        WatchUi.requestUpdate();
    }
    
    function setpointArray(pointArray) {
    	self.pointArray = pointArray;
    }
    
    function setSmallestCircle(smallestCircle) {
    	self.smallestCircle = smallestCircle;
    }

	private static function translate(points) {
		// TODO Y value increase up the screen. Need to flip.
		var translated = new[points.size()];
		var min = GpsAccuracyView.minXY(points);
		
		for (var i = 0; i < points.size(); i++) {
			var x = min.x < 0 ? points[i].x + Math.abs(min.x) : points[i].x - min.x;
			var y = min.y < 0 ? points[i].y + Math.abs(min.y) : points[i].y - min.y;
			translated[i] = new Point(x, y);
		}
		
		return translated;
	}
	
	private static function minXY(points) {
		var minX = 999999;
		var minY = 999999;
		
		for (var i = 0; i < points.size(); i++) {
			if (points[i].x < minX) {
				minX = points[i].x;
			}
			if (points[i].y < minY) {
				minY = points[i].y;
			}			
		}
		
		return new Point(minX, minY);
	}
	
	(:test)
	function minXYOk(logger) {
		var points = [ new Point(1, 30),  new Point(2, 20),  new Point(3, 10)];
		var result = GpsAccuracyView.minXY(points);
		return result.x == 1 && result.y == 10;
	}
	
	(:test)
	function translateOk(logger) {
		var points = [ new Point(10, 100),  new Point(20, 200),  new Point(30, 300)];
		var translated = GpsAccuracyView.translate(points);
		logger.debug("points=" + points);		
		logger.debug("translated=" + translated);
		return
			translated[0].x == 0 &&
			translated[0].y == 0 &&
			translated[1].x == 10 &&
			translated[1].y == 100 &&
			translated[2].x == 20 &&
			translated[2].y == 200;	
	}
}
