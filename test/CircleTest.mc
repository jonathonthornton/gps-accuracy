class CircleTest {

    (:test)
    function containsOk(logger) {
        var circle = new Circle(new Point(0, 0), 3);
        logger.debug(circle);
        return
            circle.contains(new Point(-1, 1)) &&
            circle.contains(new Point(1, 1)) &&
            circle.contains(new Point(-1, -1)) &&
            circle.contains(new Point(1, -1)) &&
            !circle.contains(new Point(4, 4));
    }
}