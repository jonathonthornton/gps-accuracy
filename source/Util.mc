using Toybox.Graphics;

class Util {
    public static function drawFullScreenCentredText(dc, text) {
       var textHeight = (text.size() - 1) * Constants.TEXT_Y_STEP;
       var yOffset = (dc.getHeight() - textHeight) / 2;
       drawCentredText(dc, text, yOffset);
    }

    public static function drawCentredText(dc, text, yOffset) {
       var halfWidth = dc.getWidth() / 2;
        for (var i = 0; i < text.size(); i++) {
           dc.drawText(
                halfWidth,
                yOffset,
                Graphics.FONT_SMALL,
                text[i],
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            yOffset += Constants.TEXT_Y_STEP;
        }
    }
}