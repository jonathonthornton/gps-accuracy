using Toybox.WatchUi;
using Toybox.Graphics;

(:glance)
class GpsAccuracyGlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var text = [
            Constants.APP_NAME,
            "",
            Constants.APP_AUTHOR,
            Constants.APP_VERSION
        ];
        Util.drawFullScreenCentredText(dc, text);
    }
}