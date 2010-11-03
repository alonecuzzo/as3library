package {

    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign; 
    import flash.display.StageScaleMode;    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;

    public class FamilyMovie extends MovieClip {
    
        private var content:TextField;
        private var menuButton:Sprite;

        public function FamilyMovie() {

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP;
        
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }

        private function init():void {

            var titleFormat:TextFormat = new TextFormat();
            titleFormat.font = 'Arial';
            titleFormat.color = 0x666666;
            titleFormat.size = 32;
            titleFormat.bold = true;
            titleFormat.letterSpacing = -2.5;

            var title:TextField = new TextField();
            title.autoSize = TextFieldAutoSize.LEFT;            
            title.x = 20;
            title.y = 20;
            title.defaultTextFormat = titleFormat;
            title.text = 'SWFAddress Application';
            addChild(title);

            menuButton = new Sprite();
            menuButton.mouseEnabled = true;
            menuButton.x = 20;
            menuButton.y = 80;
            menuButton.graphics.beginFill(0x666666);
            menuButton.graphics.drawRect(0, 0, 100, 20);
            menuButton.graphics.endFill();
            menuButton.addEventListener(MouseEvent.CLICK, handleClick);
            addChild(menuButton);

            var contentFormat:TextFormat = new TextFormat();
            contentFormat.font = 'Arial';
            contentFormat.color = 0x000000;
            contentFormat.size = 14;

            content = new TextField();
            content.autoSize = TextFieldAutoSize.LEFT;            
            content.x = 20;
            content.y = 140;
            content.defaultTextFormat = contentFormat;
            addChild(content);
        
            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);

            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
            loader.load(new URLRequest('parent.swf'));
        }
        
        private function handleComplete(event:Event):void {
            addChild(event.target.loader);
        } 
        
        private function enterFrame(event:Event):void {
            if (framesLoaded == totalFrames) {
                removeEventListener(Event.ENTER_FRAME, enterFrame);
                init();
            }
        }
        
        private function toTitleCase(str:String):String {
            return str.substr(0,1).toUpperCase() + 
                str.substr(1);
        }
        
        private function handleSWFAddress(event:SWFAddressEvent):void {
            content.text = 'The current value is "' + event.value + '".';
            SWFAddress.setTitle('SWFAddress Application' + (event.value != '/' ? 
                ' » ' + toTitleCase(event.value.replace(/\//g, '')) : ''));            
        }

        private function handleClick(event:MouseEvent):void {
            SWFAddress.setValue('/');
        }
    }
}