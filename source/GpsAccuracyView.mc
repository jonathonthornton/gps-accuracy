using Toybox.WatchUi;
using Toybox.System;

class GpsAccuracyView extends WatchUi.View {
	private static const TEXT_Y_OFFSET = 0;
	private static const TEXT_Y_STEP = 25;	
	private static const GRAPH_WIDTH_SCALE = 0.9; 
	private static const GRAPH_WIDTH_METRES = 1000;	
	private static const GRAPH_Y_OFFSET = 130; 
	
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
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                     
        if (info != null) {
        	drawText(dc);
        	drawGraph(dc);
        } else { 
        	drawErrorMessage(dc, "No position info");      
        }
     }

    public function setPosition(info) {
        self.info = info;
        WatchUi.requestUpdate();
    }
    
    public function setPoints(points) {
    	self.points = points;
    }
    
    private function drawText(dc) {
		var circle = points.getSmallestEnclosingCircle();
        var gcd = circle.getDiameterAsGCD();
    	var text = [
        	"Latitude = " + info.position.toDegrees()[0].format("%3.6f"),
         	"Longitude = " + info.position.toDegrees()[1].format("%3.6f"),
         	"Altitude(m) = " + info.altitude.format("%4.2f"),
        	"Accuracy(m) = " + gcd.format("%4.2f")
        ];
        
        var halfWidth = dc.getWidth() / 2;
        var yOffset = TEXT_Y_OFFSET;          
        for (var i = 0; i < text.size(); i++) {
        	dc.drawText(halfWidth, yOffset, Graphics.FONT_SMALL, text[i], Graphics.TEXT_JUSTIFY_CENTER);
        	yOffset += TEXT_Y_STEP;
       	}    
    }
    
    private function drawErrorMessage(dc, errorMessage) {
		var halfWidth = dc.getWidth() / 2;
    	var halfHeight = dc.getHeight() / 2;               
    	dc.drawText(halfWidth, halfHeight, Graphics.FONT_SMALL, errorMessage, Graphics.TEXT_JUSTIFY_CENTER);
	}
    
    private function drawGraph(dc) {
      	var width = dc.getWidth() * GRAPH_WIDTH_SCALE;
       	var height = width;          	
        var xOffset = (dc.getWidth() - width) / 2;
        var minPixel = new Point(xOffset, GRAPH_Y_OFFSET);
        var maxPixel = new Point(width, GRAPH_Y_OFFSET + height);
        var pixels = points.toPixelArray(minPixel, maxPixel, GRAPH_WIDTH_METRES);
        
        dc.drawRectangle(minPixel.x, minPixel.y, width, height);           
        
        for (var i = 0; i < pixels.size(); i++) {
			System.println("fillCircle=" + pixels[i]);
        	dc.fillCircle(pixels[i].x, pixels[i].y, 3);            	
        }    
    }
}
