using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;

class GpsAccuracyGlanceView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        var text = [
            "GPS Accuracy",
            "Jon Thornton",
            "Version " + GpsAccuracyView.VERSION
        ];
        drawCentredText(dc, text, (dc.getHeight() / 2) - 30);
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
}