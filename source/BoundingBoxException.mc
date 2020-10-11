using Toybox.Lang;

class BoundingBoxException extends Lang.Exception {
    private var errorMessage = null;

    function initialize(errorMessage) {
        Exception.initialize();
        self.errorMessage = errorMessage;
    }

    function getErrorMessage() {
        return errorMessage;
    }
}