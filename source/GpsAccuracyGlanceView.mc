using Toybox.WatchUi;

(:glance)
class GpsAccuracyGlanceView extends WatchUi.GlanceView {

    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc) {
        var text = [
            Constants.APP_NAME,
            "",
            Constants.APP_AUTHOR,
            Constants.APP_VERSION
        ];
        Util.drawFullScreenCentredText(dc, text);
    }
}