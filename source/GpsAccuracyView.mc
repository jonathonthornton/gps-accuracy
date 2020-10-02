using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;

class GpsAccuracyView extends WatchUi.View {
    private static const TEXT_Y_OFFSET = 20;
    private static const TEXT_Y_STEP = 30;
    private static const GRAPH_SCALE = 0.9;
    private static const GRAPH_WIDTH_METRES = 35;
    private static const GRAPH_Y_OFFSET = 150;
    private static const POINT_WIDTH = 3;

    private static const ACCURACY_POOR_COLOUR = Graphics.COLOR_RED;
    private static const ACCURACY_OK_COLOUR = Graphics.COLOR_YELLOW;
    private static const ACCURACY_GOOD_COLOUR = Graphics.COLOR_GREEN;

    private static const ACCURACY_OK_THRESHOLD = GRAPH_WIDTH_METRES * 0.5;
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
            drawPositionText(dc);
            drawGraph(dc);
        } else {
            drawCentredText(dc, ["No Position Info"], dc.getHeight() / 2);
        }
     }

    public function setPosition(info) {
        self.info = info;
        WatchUi.requestUpdate();
    }

    public function setPoints(points) {
        self.points = points;
    }

    private function drawPositionText(dc) {
        var metres = points.getSmallestEnclosingCircle().getDiameterMetres();
        var text = [
            "Latitude = " + info.position.toDegrees()[0].format("%3.6f"),
            "Longitude = " + info.position.toDegrees()[1].format("%3.6f"),
            "Altitude(m) = " + info.altitude.format("%4.2f"),
            "Accuracy(m) = " + metres.format("%4.2f")
        ];
        drawCentredText(dc, text, TEXT_Y_OFFSET);
    }

    private function drawCentredText(dc, text, yOffset) {
       var halfWidth = dc.getWidth() / 2;
        for (var i = 0; i < text.size(); i++) {
            dc.drawText(
                halfWidth,
                yOffset,
                Graphics.FONT_SMALL,
                text[i],
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            yOffset += TEXT_Y_STEP;
        }
    }

    private function drawGraph(dc) {
        // Calculate the map dimensions and position.
        var mapWidth = dc.getWidth() * GRAPH_SCALE;
        var mapHeight = (dc.getHeight() - GRAPH_Y_OFFSET) * GRAPH_SCALE;
        var xOffset = (dc.getWidth() - mapWidth) / 2;

        // Draw a border around the map.
        dc.drawRectangle(xOffset, GRAPH_Y_OFFSET, mapWidth, mapHeight);
        dc.setClip(xOffset, GRAPH_Y_OFFSET, mapWidth, mapHeight);

        // Get the diameter in metres of the smallest circle containing all of the points.
        var metres = points.getSmallestEnclosingCircle().getDiameterMetres();

        if (metres > GRAPH_WIDTH_METRES) {
            // Display an error message if the accuracy is so low that points won't fit.
            dc.drawRectangle(xOffset, GRAPH_Y_OFFSET, mapWidth, mapHeight);
            var text = [
                "Poor Accuracy",
                "(or bike is moving)"
            ];
            drawCentredText(dc, text, GRAPH_Y_OFFSET + (mapHeight / 2) - 20);
        } else {
            // Calculate the dimensions and position of the rectangle within the map containing the points.
            var mapDiagonal = Math.sqrt(Math.pow(mapWidth, 2) + (mapHeight * mapHeight));
            var reductionFactor = (metres / GRAPH_WIDTH_METRES) * (mapWidth / mapDiagonal);
            var subWidth = mapWidth * reductionFactor;
            var subHeight = mapHeight * reductionFactor;
            var subXoffset = (dc.getWidth() - subWidth) / 2;
            var subYoffset = GRAPH_Y_OFFSET + ((mapHeight - subHeight) / 2);
            var subMin = new Point(subXoffset, subYoffset);
            var subMax = new Point(subXoffset + subWidth, subYoffset + subHeight);

            // Convert the lat/long values to screen sub-map x/y values.
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
            var sec = new Points(pixelArray).getSmallestEnclosingCircle();
            dc.drawCircle(
                sec.centre.x,
                sec.centre.y,
                Math.ceil(sec.radius));
        }

        // Clear the clipping rectangle set above.
        dc.clearClip();
    }
}
