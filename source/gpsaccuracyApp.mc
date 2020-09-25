using Toybox.Application;

class gpsaccuracyApp extends Application.AppBase {
	var view;
	var positionCache;
	
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    	positionCache = new Cache(10);
    }

    function onStop(state) {
	    Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

	function onPosition(info) {
	    view.setPosition(info);
	
		var lat = info.position.toDegrees()[0];
		var long = info.position.toDegrees()[1];		
		positionCache.add(new Point(lat, long));		
        var circle = SmallestEnclosingCircle.makeCircle(positionCache.get());
		view.setSmallestCircle(circle); 
    }

    function getInitialView() {
    	view = new gpsaccuracyView();
        return [ view ];
    }
}