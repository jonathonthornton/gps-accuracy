using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Lang;

class GpsAccuracyView extends WatchUi.View {
    private static const GRAPH_WIDTH_METRES = 70;

    private static const TEXT_Y_OFFSET = 40;
    private static const GRAPH_SCALE = 0.9;
    private static const VIEWPORT_Y_OFFSET = 150;
    private static const POINT_WIDTH = 3;

    private static const ACCURACY_POOR_COLOUR = Graphics.COLOR_RED;
    private static const ACCURACY_OK_COLOUR = Graphics.COLOR_YELLOW;
    private static const ACCURACY_GOOD_COLOUR = Graphics.COLOR_GREEN;

    private static const ACCURACY_OK_THRESHOLD = GRAPH_WIDTH_METRES * 0.5;
    private static const ACCURACY_GOOD_THRESHOLD = GRAPH_WIDTH_METRES * 0.2;

    private var info = null;
    private var points = null;
    private var viewportWidth = 0;
    private var viewportHeight = 0;
    private var viewportXOffset = 0;
    private var mapWidth = 0;
    private var mapHeight = 0;
    private var mapXOffset = 0;
    private var mapYOffset = 0;
    private var mapDiagonal = 0;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc) {
        // Calculate the viewport dimensions and position.
        viewportWidth = dc.getWidth() * GRAPH_SCALE;
        viewportHeight = (dc.getHeight() - VIEWPORT_Y_OFFSET) * GRAPH_SCALE;
        viewportXOffset = (dc.getWidth() - viewportWidth) / 2;

        // Calculate the map dimensions and position.
        mapWidth = viewportWidth;
        mapHeight = mapWidth / 2;
        mapXOffset = viewportXOffset;
        mapYOffset = VIEWPORT_Y_OFFSET - ((mapHeight - viewportHeight) / 2);
        mapDiagonal = MyMath.hypot(mapWidth, mapHeight);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (info != null && points != null) {
            var metres = points.getGreatestDistanceConvexHull();
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
        // Draw a border around the viewport.
        dc.drawRectangle(viewportXOffset, VIEWPORT_Y_OFFSET, viewportWidth, viewportHeight);
        dc.setClip(viewportXOffset, VIEWPORT_Y_OFFSET, viewportWidth, viewportHeight);

        if (metres > GRAPH_WIDTH_METRES) {
            // Display an error message if the accuracy is so low that points won't fit.
            var text = ["Poor Accuracy", "(or bike is moving)"];
            Util.drawCentredText(dc, text, VIEWPORT_Y_OFFSET + (viewportHeight / 2) - (Constants.TEXT_Y_STEP / 2));
        } else {
            // Set the draw colour.
            if (metres < ACCURACY_GOOD_THRESHOLD) {
                dc.setColor(ACCURACY_GOOD_COLOUR, Graphics.COLOR_TRANSPARENT);
            } else if (metres < ACCURACY_OK_THRESHOLD) {
                dc.setColor(ACCURACY_OK_COLOUR, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(ACCURACY_POOR_COLOUR, Graphics.COLOR_TRANSPARENT);
            }

            // Convert the lat/long values to pixel x/y values.
            var boundingBox = calculateBoundingBox(metres);
            System.println(boundingBox);
            var pixelArray = points.toPixelArray(boundingBox);

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

    private function calculateBoundingBox(metres) {
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
