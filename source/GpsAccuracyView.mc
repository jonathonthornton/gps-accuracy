using Toybox.WatchUi;
using Toybox.System;

class GpsAccuracyView extends WatchUi.View {
	var info = null;
	var points = null;
	
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
            var string = "Latitude = " + info.position.toDegrees()[0].format("%3.6f");
            dc.drawText(halfWidth, 0, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "Longitude = " + info.position.toDegrees()[1].format("%3.6f");
            dc.drawText(halfWidth, 20, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
                       
            string = "Altitude(m) = " + info.altitude.format("%4.2f");
            dc.drawText(halfWidth, 40, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
                       
            var circle = points.getSmallestEnclosingCircle();
            var gcd = circle.getDiameterAsGCD();
            string = "Accuracy(m) = " + gcd.format("%4.2f");
            dc.drawText(halfWidth, 60, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
           	var scale = 0.7;
           	var width = dc.getWidth() * scale;
           	var height = width;          	
            var xOffset = (dc.getWidth() - width) / 2;
            var yOffset = 120;
            var minPixel = new Point(xOffset, yOffset);
            var maxPixel = new Point(width, yOffset + height);
            var pixels = points.toPixelArray(minPixel, maxPixel, 1000);
            
            dc.drawRectangle(minPixel.x, minPixel.y, width, height);           
            
            for (var i = 0; i < pixels.size(); i++) {
				System.println("drawPoint=" + pixels[i]);
            	dc.drawPoint(pixels[i].x, pixels[i].y);
            }
        } else {
            dc.drawText(halfWidth, halfHeight, Graphics.FONT_SMALL, "No position info", Graphics.TEXT_JUSTIFY_CENTER);
        }
     }

    function setPosition(info) {
        self.info = info;
        WatchUi.requestUpdate();
    }
    
    function setPoints(points) {
    	self.points = points;
    }
}
