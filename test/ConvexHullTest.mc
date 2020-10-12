class ConvexHullTest {

    (:test)
    function makeHullOk(logger) {
        var vertices = [
            new Point(2, 2),
            new Point(4, 2),
            new Point(1, 4),
            new Point(6, 4),
            new Point(3, 7),
            new Point(5, 6)
        ];
        var inside = [
            new Point(3, 4),
            new Point(4, 3),
            new Point(3, 6),
            new Point(4, 6)
        ];

        var all = [];
        all.addAll(vertices);
        all.addAll(inside);

        var hull = ConvexHull.makeHull(new Points(all));
        logger.debug("hull=" + hull);

        for (var i = 0; i < vertices.size(); i++) {
            var found = false;
            for (var j = 0; j < hull.size(); j++) {
                if (vertices[i].equals(hull[j])) {
                    logger.debug(vertices[i] + " correctly classified as a hull point");
                    found = true;
                    break;
                }
            }
            if (!found) {
                logger.debug(vertices[i] + " incorrectly excluded from the hull points");
                return false;
            }
        }

        for (var i = 0; i < inside.size(); i++) {
            for (var j = 0; j < hull.size(); j++) {
                if (inside[i].equals(hull[j])) {
                    logger.debug(inside[i] + " incorrectly classified as a hull point");
                    return false;
                }
            }
            logger.debug(inside[i] + " correctly classifed as a non-hull point");
        }

        return true;
    }
}