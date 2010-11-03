package com.asual.swfaddress.flex {

    import com.asual.swfaddress.SWFAddress;
    import flash.events.MouseEvent;
    import mx.controls.Button;
    import mx.core.mx_internal;
    
    use namespace mx_internal;
    
    public class SWFAddressLink extends Button {

        private var _href:String;

        public function SWFAddressLink() {
            super();
            buttonMode = true;
            extraSpacing = 6;
            addEventListener(MouseEvent.CLICK, _onClick);
        }
    
        [Bindable]
        public function get href():String {
            return _href;
        }
        
        public function set href(href:String):void {
            _href = href;
        }
        
        private function _onClick(evt:MouseEvent):void {
            SWFAddress.setValue(href);
        }        
    }
}