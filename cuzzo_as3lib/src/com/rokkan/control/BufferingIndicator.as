package com.rokkan.control 
{
	
	import com.rokkan.control.interfaces.IComponent;
	import com.rokkan.core.UIComponent;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * The BufferingIndicator control contains a generic pinwheel type loading/buffering animation.
	 */
	public class BufferingIndicator extends UIComponent implements IComponent
	{
		
		private var _tickers:Array;
		private var _currentIndex:int;
		private var _trailAmount:int;
		private var _minAlpha:Number;
		private var _updateTimer:Timer;
		
		/**
		 * Creates a new BufferingIndicator instance.
		 * @param	radius	The radius of the pinwheel
		 * @param	tickerWidth	The width of each pinwheel ticker
		 * @param	tickerHeight	The height of each pinwheel ticker
		 * @param	tickerAmount	The mount of tickers to display
		 * @param	tickerColor	The color of the tickers
		 * @param	trailAmount	The amount of tickers to use in the alpha transition
		 * @param	minAlpha	The minimum alpha value of each ticker
		 * @param	speed	The speed at which to animate the pinwheel in milliseconds
		 */
		public function BufferingIndicator( radius:Number = 26, 
											tickerWidth:Number = 12, 
											tickerHeight:Number = 5, 
											tickerAmount:int = 16, 
											tickerColor:uint = 0x000000, 
											trailAmount:int = 4, 
											minAlpha:Number = 0.2, 
											speed:Number = 50 ) 
		{
			_trailAmount = trailAmount;
			_minAlpha = minAlpha;
			_currentIndex = 0;
			
			_tickers = new Array();
			
			for ( var i:int = 0; i < tickerAmount; i++ )
			{
				var ticker:Sprite = new Sprite();
				ticker.graphics.moveTo( -tickerHeight / 2, -radius + tickerWidth );
				ticker.graphics.beginFill( tickerColor, 1 );
				ticker.graphics.lineTo( -tickerHeight / 2, -radius + ( tickerHeight / 2 ) );
				ticker.graphics.curveTo( -tickerHeight / 2, -radius, 0, -radius );
				ticker.graphics.curveTo( tickerHeight / 2, -radius, tickerHeight / 2, -radius + ( tickerHeight / 2 ) );
				ticker.graphics.lineTo( tickerHeight / 2, -radius + tickerWidth );
				ticker.graphics.lineTo( -tickerHeight / 2, -radius + tickerWidth );
				ticker.graphics.endFill();
				ticker.alpha = _minAlpha;
				ticker.rotation = i * ( 360 / tickerAmount );
				_tickers.push( ticker );
				this.addChild( ticker );
			}
			
			updateView();
			
			_updateTimer = new Timer( speed );
			_updateTimer.addEventListener( TimerEvent.TIMER, onTimer );
			_updateTimer.start();
		}
		
		private function onTimer( event:TimerEvent ):void
		{
			_currentIndex = ( _currentIndex + 1 == _tickers.length ) ? 0 : _currentIndex + 1;
			updateView();
		}
		
		private function updateView():void
		{
			_tickers[_currentIndex].alpha = 1;
			
			var ticker:Sprite = null;
			var trailTickers:Array = new Array();
			var trailIndexEnd:int = _currentIndex - _trailAmount;
			
			for ( var i:int = 1; i <= _trailAmount; i++ )
			{
				var index:int = _currentIndex - i;
				index = ( index < 0 ) ? _tickers.length + index : index;
				
				ticker = _tickers[index] as Sprite;
				var alphaIncrement:Number = ( 1 - _minAlpha ) / _trailAmount;
				ticker.alpha = 1 - ( alphaIncrement * i );
			}
			
			for ( i = _currentIndex + 1; i < _currentIndex + 1 + _tickers.length - _trailAmount; i++ )
			{
				ticker = _tickers[i] as Sprite;
				if( ticker ) ticker.alpha = _minAlpha;
			}
		}
		
	}
	
}
