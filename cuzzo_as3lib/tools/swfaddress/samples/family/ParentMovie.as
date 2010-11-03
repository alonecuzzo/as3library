package {

    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;   
    import flash.events.Event;
    import flash.events.MouseEvent; 
    import flash.net.URLRequest;    
    
    public class ParentMovie extends MovieClip {
    
        private var menuButton:Sprite;    

        public function ParentMovie() {
            addEventListener(Event.ENTER_FRAME, enterFrame);        
        }

        private function init():void {

            menuButton = new Sprite();
            menuButton.mouseEnabled = true;
            menuButton.x = 140;
            menuButton.y = 80;            
            menuButton.graphics.beginFill(0x999999);
            menuButton.graphics.drawRect(0, 0, 100, 20);
            menuButton.graphics.endFill();
            menuButton.addEventListener(MouseEvent.CLICK, handleClick);
            addChild(menuButton);

            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, childComplete);
            loader.load(new URLRequest('child.swf'));
        }

        private function childComplete(event:Event):void {
            addChild(event.target.loader);
        }
        
        public function enterFrame(event:Event):void {
            if (framesLoaded == totalFrames) {
                removeEventListener(Event.ENTER_FRAME, enterFrame);
                init();
            }
        }
        
        private function handleClick(event:MouseEvent):void {
            SWFAddress.setValue('/parent/');
        }     
    }
}