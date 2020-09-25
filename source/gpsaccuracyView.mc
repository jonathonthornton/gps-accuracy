using Toybox.WatchUi;

class gpsaccuracyView extends WatchUi.View {
	var info = null;
	var smallestCircle = null;
	
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
        // Set background color
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
            
            string = "speed = " + info.speed.toString();
            dc.drawText(halfWidth, halfHeight, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "alt = " + info.altitude.toString();
            dc.drawText(halfWidth, halfHeight + 20, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "heading = " + info.heading.toString();
            dc.drawText(halfWidth, halfHeight + 40, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
            string = "GPS Accuracy(m) = " + smallestCircle.getWidthAsGCD();
            dc.drawText(halfWidth, halfHeight + 80, Graphics.FONT_SMALL, string, Graphics.TEXT_JUSTIFY_CENTER);
            
        } else {
            dc.drawText(halfWidth, halfHeight, Graphics.FONT_SMALL, "No position info", Graphics.TEXT_JUSTIFY_CENTER);
        }
     }

    function setPosition(info) {
        self.info = info;
        WatchUi.requestUpdate();
    }
    
    function setSmallestCircle(smallestCircle) {
    	self.smallestCircle = smallestCircle;
    }

}
