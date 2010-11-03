package com.asual.swfaddress.flex {

    import mx.skins.Border;

    public class SWFAddressLinkSkin extends Border {

        override protected function updateDisplayList(w:Number, h:Number):void {
            super.updateDisplayList(w, h);
            graphics.clear();
            drawRoundRect(0, 0, w, h, 0, 0x000000, 0);
        }
    }
}