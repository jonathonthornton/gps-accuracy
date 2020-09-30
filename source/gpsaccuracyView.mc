using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;

class GpsAccuracyView extends WatchUi.View {
    private static const TEXT_Y_OFFSET = 20;
    private static const TEXT_Y_STEP = 30;
    private static const GRAPH_WIDTH_SCALE = 0.9;
    private static const GRAPH_WIDTH_METRES = 40;
    private static const GRAPH_Y_OFFSET = 150;
    private static const POINT_WIDTH = 3;

    private static const ACCURACY_POOR_COLOUR = Graphics.COLOR_RED;
    private static const ACCURACY_OK_COLOUR = Graphics.COLOR_YELLOW;
    private static const ACCURACY_GOOD_COLOUR = Graphics.COLOR_GREEN;

    private static const ACCURACY_OK_THRESHOLD = GRAPH_WIDTH_METRES * 0.4;
    private static const ACCURACY_GOOD_THRESHOLD = GRAPH_WIDTH_METRES * 0.2;

    var info = null;
    var points = null;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (info != null) {
            drawText(dc);
            drawGraph(dc);
        } else {
            drawErrorMessage(dc, "No Position Info");
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
        var metres = points.getSmallestEnclosingCircle().getDiameterMetres();
        var text = [
            "Latitude = " + info.position.toDegrees()[0].format("%3.6f"),
            "Longitude = " + info.position.toDegrees()[1].format("%3.6f"),
            "Altitude(m) = " + info.altitude.format("%4.2f"),
            "Accuracy(m) = " + metres.format("%4.2f")
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
        // Calculate the map dimensions and position.
        var mapWidth = dc.getWidth() * GRAPH_WIDTH_SCALE;
        var mapHeight = mapWidth;
        var xOffset = (dc.getWidth() - mapWidth) / 2;
        var yOffset = GRAPH_Y_OFFSET;

        // Draw a border around the map.
        dc.drawRectangle(xOffset, yOffset, mapWidth, mapHeight);
        dc.setClip(xOffset, yOffset, mapWidth, mapHeight);

        // Get the diameter in metres of the smallest circle containing all of the points.
        var metres = points.getSmallestEnclosingCircle().getDiameterMetres();

        if (metres > GRAPH_WIDTH_METRES) {
            // Display an error message if the accuracy is so low that points won't fit.
            dc.drawRectangle(xOffset, yOffset, mapWidth, mapHeight);
            var x = xOffset + (mapWidth / 2);
            var y = yOffset + (mapHeight / 2) - 30;
            dc.drawText(x, y, Graphics.FONT_SMALL, "Poor Accuracy", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(x, y + TEXT_Y_STEP, Graphics.FONT_SMALL, "(or bike is moving)", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            // Calculate the dimensions and position of the square within the map containing the points.
            var reductionRatio = metres / GRAPH_WIDTH_METRES;
            var subWidth = mapWidth * reductionRatio;
            var subHeight = mapHeight * reductionRatio;
            var subXoffset = (dc.getWidth() - subWidth) / 2;
            var subYoffset = GRAPH_Y_OFFSET + ((mapHeight - subHeight) / 2);
            var subMin = new Point(subXoffset, subYoffset);
            var subMax = new Point(subXoffset + subWidth, subYoffset + subHeight);

            // Convert the lat/long values to screen x/y values within the sub-map.
            var pixelArray = points.toPixelArray(subMin, subMax);

            // Set the draw colour.
            if (metres < ACCURACY_GOOD_THRESHOLD) {
                dc.setColor(ACCURACY_GOOD_COLOUR, Graphics.COLOR_TRANSPARENT);
            } else if (metres < ACCURACY_OK_THRESHOLD) {
                dc.setColor(ACCURACY_OK_COLOUR, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(ACCURACY_POOR_COLOUR, Graphics.COLOR_TRANSPARENT);
            }

            // Draw the points.
            for (var i = 0; i < pixelArray.size(); i++) {
                var point = pixelArray[i];
                System.println("fillCircle=" + point);
                dc.fillCircle(point.x, point.y, POINT_WIDTH);
            }

            // Draw a circle around the points.
            var pixelPoints = new Points(pixelArray);
            var sec = pixelPoints.getSmallestEnclosingCircle();
            dc.drawCircle(
                sec.centre.x,
                sec.centre.y,
                Math.ceil(sec.radius));
        }

        // Clear the clipping rectangle set above.
        dc.clearClip();
    }
}
