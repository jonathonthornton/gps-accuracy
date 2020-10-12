class PointTest {

    (:test)
    function distanceOk(logger) {
        var p = new Point(0, 0);
        var q = new Point(3, 4);
        return p.distance(q) == 5;
    }

    (:test)
    function calculateGCDOk(logger) {
        var mtDonnaBuang = new Point(-37.706628, 145.681540);
        var lakeMountain = new Point(-37.495378, 145.877245);
        var gcd = mtDonnaBuang.calculateGCD(lakeMountain);
        logger.debug("GCD=" + gcd);
        return (gcd - 29140).abs() < 10;
    }

    (:test)
    function toMercatorOk(logger) {
        for (var lat = -85d; lat <= 85; lat += 5) {
            var point = new Point(lat, 0);
            logger.debug("toMercator(" + point + ")=" + point.toMercator());
        }

        return
            new Point(-85d, 0).toMercator().x.toNumber() == -179 &&
            new Point(-40d, 0).toMercator().x.toNumber() == -43 &&
            new Point(0d, 0).toMercator().x.toNumber() == 0 &&
            new Point(60d, 0).toMercator().x.toNumber() == 75 &&
            new Point(85d, 0).toMercator().x.toNumber() == 179;
    }
}