package com.asual.swfaddress.flex {

    import com.asual.swfaddress.SWFAddress;
    import com.asual.swfaddress.SWFAddressEvent;
    import mx.core.Application;
    import mx.events.FlexEvent;

    [Event(name='change', type='com.asual.swfaddress.SWFAddressEvent')]

    public class SWFAddressWebsite extends Application {

        public function SWFAddressWebsite() {
            super();
            addEventListener(FlexEvent.APPLICATION_COMPLETE, _onComplete);
        }

        private function _onComplete(event:FlexEvent):void {
            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, _onChange);
        }
        
        private function _onChange(event:SWFAddressEvent):void {
            dispatchEvent(new SWFAddressEvent('change'));
        }

        [Bindable(event='change')]
        public function get location():String {
            var value:String = SWFAddress.getValue();
            var path:String = SWFAddress.getPath();
            return value.replace(path, path.replace(/^(.+)\/$/, '$1'));
        }

        [Bindable(event='change')]
        public function get title():String {
            return SWFAddress.getTitle();
        }
    }
}