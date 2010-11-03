package com.rokkan.layout
{
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
	
	/**
	 * The Carousel2D class organizes a specified group of display objects into a two dimensional
	 * horizontal or vertical carousel with an equal distance between them. This type of carousel 
	 * moves objects from side to side or top to bottom using a specified positive or negative 
	 * speed value and specifying a driving object which must be one of the objects in the carousel.
	 * After you've created an instance of the Carousel2D class, call the <code>start()</code> 
	 * method to begin the animation of the carousel.
	 */
    public class Carousel2D extends EventDispatcher
    {
        
		/**
		 * Constant value to use when specifying a horizontal axis for the carousel.
		 */
        public static const HORIZONTAL:String = "horizontal";
		
		/**
		 * Constant value to use when specifying a vertical axis for the carousel.
		 */
        public static const VERTICAL:String = "vertical";
        
        
        private var _axis:String;
        private var _center:Number;
        private var _driver:DisplayObject;
        private var _driverIndex:Number;
        private var _items:Array;
        private var _speed:Number;
        private var _margin:Number;
        private var _completeRange:Number;
        private var _itemsRange:Number;
        private var _marginRange:Number;
        private var _prop1:String;
        private var _prop2:String;
        private var _bound1:Number;
        private var _bound2:Number;
        
        /**
         * Creates a Carousel2D instance.
         * @param	axis	The orientation of the carousel's axis
         * @param	items	An array specifiying all the items to organize
         * @param	driver	One of the items in the carousel to use as the driver
         * @param	center	The center value for the carousel (x or y)
         * @param	margin	The space, in pixels, to place between each item
         * @param	speed	The initial speed to move the carousel in
         */
        public function Carousel2D( axis:String, 
                                    items:Array, 
                                    driver:DisplayObject, 
                                    center:Number, 
                                    margin:Number, 
                                    speed:Number )  
        {
            _center = center;
            _itemsRange = 0;
            
            this.axis = axis;
            this.items = items;
            this.driver = driver;
            this.margin = margin;
            this.speed = speed;
            
            lineUpItems();
        }
        
        private function lineUpItems():void
        {
            var nextX:Number = _bound1;
            
            for( var i:Number = 0; i < _items.length; i++ )
            {
                var item:DisplayObject = _items[i];
                item[_prop1] = nextX;
                nextX = item[_prop1] + item[_prop2] + _margin;
            }
        }
        
        private function adjustBounds():void
        {
            for( var i:Number = 0; i < _items.length; i++ )
                _itemsRange += _items[i][_prop2];
            
            _marginRange = ( _items.length - 1 ) * _margin;
            _completeRange = _itemsRange + _marginRange;
            
            var halfRange:Number = Math.round( _completeRange / 2 );
            _bound1 = _center - halfRange;
            _bound2 = _center + halfRange;
        }
        
        private function adjustItemOrder():void
        {
            var oppositeEndItem:DisplayObject = null;
            
            if( _driver[_prop1] < _bound1 - _margin - _driver[_prop2] )
            {
                oppositeEndItem = _items[_items.length - 1];
                _driver[_prop1] = oppositeEndItem[_prop1] + oppositeEndItem[_prop2] + _margin;
                _items.push( _items.shift() );
            }
            
            if( _driver[_prop1] > _bound2 + _margin )
            {
                oppositeEndItem = _items[0];
                _driver[_prop1] = oppositeEndItem[_prop1] - _driver[_prop2] - _margin;
                _items.unshift( _items.pop() );
            }
            
            
            if( _items[0][_prop1] < _bound1 - _margin - _items[0][_prop2]  )
                _items.push( _items.shift() );
            
            if( _items[_items.length-1][_prop1] > _bound2 + _margin )
                _items.unshift( _items.pop() );
            
            _driverIndex = _items.indexOf( _driver );
        }
        
        private function adjustItemPositions():void
        {
            var currentItem:DisplayObject = null;
            var lastItem:DisplayObject = _driver;
            
            var i:Number = _driverIndex + 1;
            for( i; i < _items.length; i++ )
            {
                currentItem = _items[i];
                currentItem[_prop1] = lastItem[_prop1] + lastItem[_prop2] + _margin;
                lastItem = currentItem;
            }
            
            lastItem = _driver;
            
            i = _driverIndex - 1;
            for( i; i < _driverIndex && i >= 0; i-- )
            {
                currentItem = _items[i];
                currentItem[_prop1] = lastItem[_prop1] - currentItem[_prop2] - _margin;
                lastItem = currentItem;
            }
        }
        
		private function doUpdate( event:Event ):void
        {
            _driver[_prop1] += _speed;
            
            adjustItemOrder();
            adjustItemPositions();
		}
        
		/**
		 * Starts the movement of the carousel.
		 */
        public function start():void
        {
            _driver.stage.addEventListener( Event.ENTER_FRAME, doUpdate );
        }
        
		/**
		 * Stops the movement of the carousel.
		 */
        public function stop():void
        {
            _driver.stage.removeEventListener( Event.ENTER_FRAME, doUpdate );
        }
        
		/**
		 * Manually updates the position of all the items after applying the speed to the driver.
		 * @param	event	Event object. Leave null if calling from outside
		 */
        public function update():void
		{
			doUpdate( null );
        }
        
        
        /**
         * Specifies the orientation of the carousel's axis.
         */
		public function get axis():String
		{
			return _axis;
		}
		
        public function set axis( axis:String ):void
        {
            _axis = axis;
            
            _prop1 = ( _axis == Carousel2D.HORIZONTAL ) ? "x" : null;
            _prop1 = ( _axis == Carousel2D.VERTICAL ) ? "y" : _prop1;
            
            _prop2 = ( _axis == Carousel2D.HORIZONTAL ) ? "width" : null;
            _prop2 = ( _axis == Carousel2D.VERTICAL ) ? "height" : _prop2;
        }
        
		/**
		 * Specifies the amount of space, in pixels, to place between each item in the carousel.
		 */
		public function get margin():Number
		{
			return _margin;
		}
		
        public function set margin( margin:Number ):void
        {
            _margin = margin;
            
            adjustBounds();
        }
        
        /**
		 * Specifies the driving display object. This object manages the movement of all items in the carousel.
		 */
		public function get driver():DisplayObject
		{
			return _driver
		}
		
        public function set driver( driver:DisplayObject ):void
        {
            _driver = driver;
        }
        
		/**
		 * Specifies the speed at which to move the carousel.
		 */
		public function get speed():Number
		{
			return _speed;
		}
		
        public function set speed( speed:Number ):void
        {
            _speed = speed;
        }
        
		/**
		 * Specifies the items to place in the carousel.
		 */
		public function get items():Array
		{
			return _items;
		}
		
        public function set items( items:Array ):void
        {
            _items = items;
            
            lineUpItems();
        }
        
        
    }
    
}
