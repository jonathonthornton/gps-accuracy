class BoundingBox {
    public var topLeft;
    public var bottomRight;

    function initialize(topLeft, bottomRight) {
        self.topLeft = topLeft;
        self.bottomRight = bottomRight;
    }

    public function toString() {
        return "BoundingBox topLeft=" + topLeft + ", bottomRight=" + bottomRight;
    }
}