using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;

class GpsAccuracyView extends WatchUi.View {
    private static const GRAPH_WIDTH_METRES = 20;

    private static const TEXT_Y_OFFSET = 40;
    private static const GRAPH_SCALE = 0.9;
    private static const VIEWPORT_Y_OFFSET = 150;
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
            var metres = points.getGreatestDistanceNearCircumference();
            drawPositionText(dc, metres);
            drawGraph(dc, metres);
        } else {
            drawNoPositionText(dc);
        }
     }

    public function setPosition(info) {
        self.info = info;
        WatchUi.requestUpdate();
    }

    public function setPoints(points) {
        self.points = points;
    }

    private function drawPositionText(dc, metres) {
        var text = [
            "Latitude = " + info.position.toDegrees()[0].format("%3.6f"),
            "Longitude = " + info.position.toDegrees()[1].format("%3.6f"),
            "Altitude(m) = " + info.altitude.format("%4.2f"),
            "Accuracy(m) = " + metres.format("%4.2f")
        ];
        Util.drawCentredText(dc, text, TEXT_Y_OFFSET);
    }

    private function drawNoPositionText(dc) {
        var text = [
            Constants.APP_NAME,
            "",
            "No Position Info",
            "(please wait)",
            "",
            Constants.APP_AUTHOR,
            Constants.APP_VERSION
        ];
        Util.drawFullScreenCentredText(dc, text);
    }

    private function drawGraph(dc, metres) {
        // Calculate the viewport dimensions and position.
        var viewportWidth = dc.getWidth() * GRAPH_SCALE;
        var viewportHeight = (dc.getHeight() - VIEWPORT_Y_OFFSET) * GRAPH_SCALE;
        var viewportXOffset = (dc.getWidth() - viewportWidth) / 2;

        // Draw a border around the viewport.
        dc.drawRectangle(viewportXOffset, VIEWPORT_Y_OFFSET, viewportWidth, viewportHeight);
        dc.setClip(viewportXOffset, VIEWPORT_Y_OFFSET, viewportWidth, viewportHeight);

        if (metres > GRAPH_WIDTH_METRES) {
            // Display an error message if the accuracy is so low that points won't fit.
            var text = ["Poor Accuracy", "(or bike is moving)"];
            Util.drawCentredText(dc, text, VIEWPORT_Y_OFFSET + (viewportHeight / 2) - (Constants.TEXT_Y_STEP / 2));
        } else {
            // Convert the lat/long values to screen sub-map x/y values.
            var boundingBox = calculateBoundingBox(metres, viewportXOffset, viewportWidth, viewportHeight);
            System.println(boundingBox);
            var pixelArray = points.toPixelArray(boundingBox);

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

    private function calculateBoundingBox(metres, viewportXOffset, viewportWidth, viewportHeight) {
        // Calculate the map dimensions and position.
        var mapWidth = viewportWidth;
        var mapHeight = mapWidth / 2;
        var mapXOffset = viewportXOffset;
        var mapYOffset = VIEWPORT_Y_OFFSET - ((mapHeight - viewportHeight) / 2);
        var mapDiagonal = MyMath.hypot(mapWidth, mapHeight);

        // Calculate the dimensions and position of the square within the map containing the points.
        var reductionFactor = (metres / GRAPH_WIDTH_METRES) * (mapWidth / mapDiagonal);
        var pointsWidth = mapWidth * reductionFactor;
        var pointsHeight = mapHeight * reductionFactor;
        var pointsXOffset = mapXOffset + ((mapWidth - pointsWidth) / 2);
        var pointsYOffset = mapYOffset + ((mapHeight - pointsHeight) / 2);
        var topLeft = new Point(
            pointsXOffset.toNumber(),
            pointsYOffset.toNumber());
        var bottomRight = new Point(
            (pointsXOffset + pointsWidth).toNumber(),
            (pointsYOffset + pointsHeight).toNumber());

        return new BoundingBox(topLeft, bottomRight);
    }
}
