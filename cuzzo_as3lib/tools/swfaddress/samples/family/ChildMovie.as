package {

    import flash.display.MovieClip;
    import flash.display.Sprite;    
    import flash.events.MouseEvent; 
    
    public class ChildMovie extends MovieClip {
    
        private var menuButton:Sprite;    
    
        public function ChildMovie() {
        
            menuButton = new Sprite();
            menuButton.mouseEnabled = true;
            menuButton.x = 260;
            menuButton.y = 80;
            menuButton.graphics.beginFill(0xCCCCCC);
            menuButton.graphics.drawRect(0, 0, 100, 20);
            menuButton.graphics.endFill();
            menuButton.addEventListener(MouseEvent.CLICK, handleClick);
            addChild(menuButton);
        }
        
        private function handleClick(event:MouseEvent):void {
            SWFAddress.setValue('/child/');
        }     
    }
}