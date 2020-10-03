using Toybox.Application;

class GpsAccuracyApp extends Application.AppBase {
    var view;
    var glanceView;
    var pointCache = new Cache(Constants.CACHE_SIZE);

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    function onStop(state) {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function onPosition(info) {
        var lat = info.position.toDegrees()[0];
        var long = info.position.toDegrees()[1];
        pointCache.add(new Point(lat, long));
        view.setPosition(info);
        view.setPoints(new Points(pointCache.toArray()));
    }

    function getInitialView() {
        view = new GpsAccuracyView();
        return [view];
    }

    function getGlanceView() {
        glanceView = new GpsAccuracyGlanceView();
        return [glanceView];
    }
}