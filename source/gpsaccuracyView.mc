using Toybox.WatchUi;
using Toybox.System;

class GpsAccuracyView extends WatchUi.View {
	private static const TEXT_Y_OFFSET = 0;
	private static const TEXT_Y_STEP = 25;	
	private static const GRAPH_WIDTH_SCALE = 0.9; 
	private static const GRAPH_WIDTH_METRES = 50;	
	private static const GRAPH_Y_OFFSET = 130; 
	private static const POINT_WIDTH = 3;
	
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
		drawPoints(dc);
//        
//        var pixelCircle = points.toPixelCircle(mapWidth, mapHeight, xOffset, yOffset);
//        if (pixelCircle != null) {
//            System.println("pixelCircle=" + pixelCircle);
//        	dc.drawCircle(pixelCircle.centre.x, pixelCircle.centre.y, pixelCircle.radius);
//        } else {
//        	System.println("pixelCircle=null");
//        }
    }
    
    private function drawPoints(dc) {
      	var mapWidth = dc.getWidth() * GRAPH_WIDTH_SCALE;
       	var mapHeight = mapWidth;          	
        var xOffset = (dc.getWidth() - mapWidth) / 2;
        var yOffset = GRAPH_Y_OFFSET;
              
        dc.drawRectangle(xOffset, yOffset, mapWidth, mapHeight); 
                
		var newMin = new Point(xOffset, yOffset);
		var newMax = new Point(xOffset + mapWidth, yOffset + mapHeight);
        var pixelArray = points.toPixelArray(newMin, newMax);
        
        for (var i = 0; i < pixelArray.size(); i++) {
        	var point = pixelArray[i];
			System.println("fillCircle=" + point);
        	dc.fillCircle(point.x, point.y, POINT_WIDTH);            	
        }    
    }
}
