package com.rokkan.control 
{
	
	import com.rokkan.control.abstract.AbstractProgressBar;
	import com.rokkan.control.interfaces.IProgressIndicator;
	import com.rokkan.core.UIComponent;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * The ProgressBar control displays the progress of a given source our is manually
	 * updated using the control's <code>progress</code> property. This class also serves 
	 * as an example of how to use the AbstractProgressBar class and the IProgressIndicator interface.
	 */
	public class ProgressBar extends AbstractProgressBar implements IProgressIndicator
	{
		
		private var _source:Object;
		private var _barColor:uint;
		private var _trackColor:uint;
		
		private var _track:Sprite;
		private var _bar:Sprite;
		
		/**
		 * Creates a ProgressBar instance.
		 * @param	x	x position
		 * @param	y	y position
		 * @param	width	Progress _bar width
		 * @param	height	Progress _bar height
		 * @param	startProgress	Beginning progress position
		 * @param	barColor	Indicator _bar color
		 * @param	trackColor	Track color
		 */
		public function ProgressBar( x:Number,
								     y:Number,
									 width:Number = 200, 
									 height:Number = 15, 
									 startProgress:Number = 0,
									 barColor:uint = 0x999999, 
									 trackColor:Number = 0xCCCCCC )
		{
			super( this );
			
			addChildren();
			
			_barColor = barColor;
			_trackColor = trackColor;
			
			_width = width;
			_height = height;
			
			this.move( x, y );
			
			draw();
			
			this.progress = startProgress;
		}
		
		
		/* Event Handlers */
		private function onSourceProgress( event:ProgressEvent ):void
		{
			this.progress = event.bytesLoaded / event.bytesTotal;
		}
		
		
		/* Private Overrides */
		override protected function addChildren():void
		{
			super.addChildren();
			
			_track = new Sprite();
			this.addChild( _track );
			
			_bar = new Sprite();
			this.addChild( _bar );
		}
		
		
		/* Private Methods */
		private function updateView():void
		{
			_bar.scaleX = this.progress;
		}
		
		
		/**
		 * Redraws the ProgressBar control.
		 */
		override public function draw():void
		{
			_track.graphics.clear();
			_track.graphics.beginFill( _trackColor, 1 );
			_track.graphics.lineTo( _width, 0 );
			_track.graphics.lineTo( _width, _height );
			_track.graphics.lineTo( 0, _height );
			_track.graphics.lineTo( 0, 0 );
			_track.graphics.endFill();
			
			_bar.graphics.clear();
			_bar.graphics.beginFill( _barColor, 1 );
			_bar.graphics.lineTo( _width, 0 );
			_bar.graphics.lineTo( _width, _height );
			_bar.graphics.lineTo( 0, _height );
			_bar.graphics.lineTo( 0, 0 );
			_bar.graphics.endFill();
			
			super.draw();
		}
		
		
		override public function set progress( v:Number ):void
		{
			super.progress = v;
			updateView();
		}
		
		
		
		/**
		 * Specifies the source object to control the progress _bar. This object must dispatch
		 * <code>ProgressEvent.PROGRESS</code> events in order for this functionality to work properly.
		 */
		public function get source():Object
		{
			return _source;
		}
		
		public function set source( v:Object ):void
		{
			if ( _source ) _source.removeEventListener( ProgressEvent.PROGRESS, onSourceProgress );
			
			_source = v;
			
			if( _source )
				_source.addEventListener( ProgressEvent.PROGRESS, onSourceProgress );			
		}
		
		public function get track():Sprite 
		{
			return _track;
		}
		
		public function get bar():Sprite 
		{
			return _bar;
		}
	}
	
}
