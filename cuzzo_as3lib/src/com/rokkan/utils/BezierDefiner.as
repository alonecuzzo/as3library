package com.rokkan.utils 
{
	import com.rokkan.math.BezierInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class BezierDefiner extends Sprite 
	{
		private var _gridBoundaries:Shape;
		private var _linePath:Shape;
		private var _holdBezier:Sprite;
		private var _holdDragPts:Sprite;
		private var _arrDefText:NameValue;
		private var _segmentText:NameValue;
		private var _xText:NameValue;
		private var _yText:NameValue;
		private var _gridWidth:Number;
		private var _gridHeight:Number;
		private var _draggingPt:Sprite;
		private var _dragPtArr:Array;
		private var _bezInfo:BezierInfo;
		private var _rangeFieldsArr:Array = new Array(4);
		private var _boundaryArr:Array;
		
		public function BezierDefiner(addTo, initBezier:BezierInfo = null, vars:Object = null) 
		{
			vars = vars == null ? { } : vars;
			if (vars.minX != null) {
				_boundaryArr = new Array(4);
				_boundaryArr[0] = vars.minX == null ? _boundaryArr[0] : vars.minX;
				_boundaryArr[1] = vars.maxX == null ? _boundaryArr[1] : vars.maxX;
				_boundaryArr[2] = vars.minY == null ? _boundaryArr[2] : vars.minY;
				_boundaryArr[3] = vars.maxY == null ? _boundaryArr[3] : vars.maxY;
			}
			
			if (initBezier == null) {
				_bezInfo = initBezier = new BezierInfo([]);
				updateSegmentAmt();
			}
			_bezInfo = initBezier;
			
			_gridWidth = vars.width == null ? 200 : vars.width;
			_gridHeight = vars.height == null ? 200 : vars.height;
			this.x = vars.x == null ? 0 : vars.x;
			this.y = vars.y == null ? 0 : vars.y;
			this.visible = vars.visible == null ? true : vars.visible;
			
			// Add background
			var back:Shape = new Shape();
			this.addChild( back );
			back.graphics.beginFill(0xFFFFFF, 0.5);
			back.graphics.moveTo( -15, -15);
			back.graphics.lineTo(_gridWidth + 90, -15);
			back.graphics.lineTo(_gridWidth + 90, _gridHeight + 40);
			back.graphics.lineTo(-15, _gridHeight + 40);
			back.graphics.endFill();
			
			// Add Grid
			_gridBoundaries = new Shape();
			updateBoundaries();
			this.addChild( _gridBoundaries );
			
			// Add Holders
			_holdBezier = new Sprite();
			this.addChild( _holdBezier );
			_holdDragPts = new Sprite();
			this.addChild( _holdDragPts );
			
			var orderedArr:Array = _bezInfo.orderedArr;
			_dragPtArr = new Array();
			addDragablePts( orderedArr );
			
			_linePath = new Shape();
			_holdBezier.addChild( _linePath );
			drawBezier();
			
			addTo.addChild( this );
			
			// Array Definition
			_arrDefText = new NameValue("definition", []);
			_arrDefText.y = _gridHeight + 10;
			updateTextField();
			this.addChild( _arrDefText );
			
			// Amt Segments Definition
			_segmentText = new NameValue("segments", 2);
			_segmentText.x = _gridWidth + 10;
			this.addChild( _segmentText );
			_segmentText.text = "" + Math.floor( orderedArr.length / 2 );
			_segmentText.addEventListener(Event.CHANGE, updateSegmentAmt, false, 0, true);
			
			// X Y Texts
			_xText = new NameValue("x", 0);
			_xText.x = _gridWidth + 10;
			_xText.y = _segmentText.y + _segmentText.height + 4;
			_xText.addEventListener(Event.CHANGE, xOrYUpdated, false, 0, true);
			this.addChild( _xText );
			_yText = new NameValue("y", 0);
			_yText.x = _gridWidth + 10;
			_yText.y = _xText.y + 20;
			_yText.addEventListener(Event.CHANGE, xOrYUpdated, false, 0, true);
			this.addChild( _yText );
			
			// create boundaries based on found min and maxes
			if(_boundaryArr == null)
				_boundaryArr = getBoundaries( _bezInfo.descrArr );
			
			for (var i:uint = 0; i < _rangeFieldsArr.length; i++) {
				_rangeFieldsArr[i] = new TextField();
				this.addChild( _rangeFieldsArr[i] );
				_rangeFieldsArr[i].defaultTextFormat = new TextFormat( "_sans", 8 );
				_rangeFieldsArr[i].mouseEnabled = false;
				_rangeFieldsArr[i].autoSize = "right";
				_rangeFieldsArr[i].selectable = false;
			}
			_rangeFieldsArr[0].autoSize = TextFieldAutoSize.LEFT;
			_rangeFieldsArr[0].y = -11;
			_rangeFieldsArr[0].text = _boundaryArr[0];
			_rangeFieldsArr[1].x = _gridWidth - _rangeFieldsArr[1].textWidth - 2;
			_rangeFieldsArr[1].y = -11;
			_rangeFieldsArr[1].text = _boundaryArr[1];
			_rangeFieldsArr[2].x = -_rangeFieldsArr[2].textWidth - 4;
			_rangeFieldsArr[2].text = _boundaryArr[2];
			_rangeFieldsArr[3].x = -_rangeFieldsArr[3].textWidth - 4;
			_rangeFieldsArr[3].y = _gridHeight - 10;
			_rangeFieldsArr[3].text = _boundaryArr[3];
			
			// add name title
			if (vars.name != null) {
				var nameText:TextField = new TextField();
				nameText.mouseEnabled = false;
				nameText.defaultTextFormat = new TextFormat( "_sans", 10 );
				nameText.x = _rangeFieldsArr[0].x + _rangeFieldsArr[0].textWidth + 5;
				nameText.y = -16;
				nameText.text = "Title:"+vars.name;
				this.addChild( nameText );
			}
		}
		
		private function xOrYUpdated( e:Event = null ) {
			_draggingPt.x = (Number(_xText.text) - _boundaryArr[0]) / this.xRange * _gridWidth;
			_draggingPt.y = (Number(_yText.text) - _boundaryArr[2]) / this.yRange * _gridHeight;
			
			drawBezier();
			updateTextField();
		}
		
		private function updateSegmentAmt( e:Event = null ) {
			var segmentAmt:Number = _segmentText!=null ? Number(_segmentText.text) * 2 + 1 : 5;
			
			for (var i:uint = 0; _dragPtArr != null && i < _dragPtArr.length; i++) {
				_dragPtArr[i].removeEventListener( MouseEvent.MOUSE_DOWN, dragPt );
				_holdDragPts.removeChild( _dragPtArr[i] );
			}
			
			_dragPtArr = new Array();
			
			var orderedArr:Array = new Array(segmentAmt);
			for (i = 0; i < segmentAmt; i++) {
				orderedArr[i] = { };
				orderedArr[i].x = (Math.round( 100 * i / (segmentAmt - 1) ) / 100) * xRange + _boundaryArr[0];
				orderedArr[i].y = (Math.round( 100 * i / (segmentAmt - 1) ) / 100) * yRange + _boundaryArr[2];
			}
			_bezInfo.orderedArr = orderedArr;
			
			if(_linePath!=null){
				addDragablePts( orderedArr );
				drawBezier();				
			}
		}
		
		private function get xRange():Number {
			return (_boundaryArr[1] - _boundaryArr[0]);
		}
		
		private function get yRange():Number {
			return (_boundaryArr[3] - _boundaryArr[2]);
		}
		
		private function updateTextField( e:Event = null ) {
			_arrDefText.text = "[" + ArrayMethods.trace( _bezInfo.descrArr, NumberUtil.roundToDecimals ) + "]";
		}
		
		private function addDragablePts( orderedArr:Array ) {
			var xRange:Number = (_boundaryArr[1] - _boundaryArr[0]);
			var yRange:Number = (_boundaryArr[3] - _boundaryArr[2]);
			for (var n:uint = 0; n < orderedArr.length; n++) {
				var color:Number = n % 2 == 0 ? 0x990000 : 0xFF0000;
				var shape:Sprite = createSquare( color );
				_dragPtArr.push( shape );
				_holdDragPts.addChild( shape );
				shape.buttonMode = true;
				//trace("orderedArr[n].x:" + orderedArr[n].x + " orderedArr[n].y:" + orderedArr[n].y);
				shape.x = (orderedArr[n].x - _boundaryArr[0]) / xRange * _gridWidth;
				shape.y = (orderedArr[n].y - _boundaryArr[2]) / yRange * _gridHeight;
				shape.addEventListener( MouseEvent.MOUSE_DOWN, dragPt, false, 0, true);
			}			
		}
		
		private function drawBezier( e:Event = null ) {
			var groundOrdArr:Array = new Array( _dragPtArr.length );
			var xRange:Number = (_boundaryArr[1] - _boundaryArr[0]);
			var yRange:Number = (_boundaryArr[3] - _boundaryArr[2]);
			for ( i = 0; i < _dragPtArr.length; i++) {
				groundOrdArr[i] = { };
				groundOrdArr[i].x = _dragPtArr[i].x / _gridWidth * xRange + _boundaryArr[0];
				groundOrdArr[i].y = _dragPtArr[i].y / _gridHeight * yRange + _boundaryArr[2];
			}
			
			_bezInfo.orderedArr = groundOrdArr;
			
			_linePath.graphics.clear();
			_linePath.graphics.lineStyle(1, 0x0099FF);
			for (var i:uint = 0; i <= 100; i++) {
				var xPt:Number = (_bezInfo.getPoint(i / 100, 0) - _boundaryArr[0]) / xRange * _gridWidth;
				var yPt:Number = (_bezInfo.getPoint(i / 100, 1) - _boundaryArr[2]) / yRange * _gridHeight;
				if (i == 0) {
					_linePath.graphics.moveTo( xPt, yPt );
				}else{
					_linePath.graphics.lineTo( xPt, yPt );
				}
			}
		}
		
		private function dragPt( e:MouseEvent = null ) {
			_draggingPt = e.target as Sprite;
			_draggingPt.startDrag( false, new Rectangle( 0, -1000, _gridWidth, 2000 ) );
			stage.addEventListener(MouseEvent.MOUSE_UP, dragPtStop, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, drawBezier, false, 0, true);
		}
		
		private function dragPtStop( e:Event = null ) {
			_xText.text = NumberUtil.roundToDecimals( _draggingPt.x / _gridWidth  * xRange + _boundaryArr[0] );
			_yText.text = NumberUtil.roundToDecimals( _draggingPt.y / _gridHeight * yRange + _boundaryArr[2] );
			
			this.removeEventListener(Event.ENTER_FRAME, drawBezier);
			drawBezier();
			updateTextField();
			_draggingPt.stopDrag();
		}
		
		private function getBoundaries( descrArr:Array ):Array {
			var minMaxArr:Array = [Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY]; // [ xMin, xMax, yMin, yMax ]
			
			for (var i:uint = 0; i < descrArr.length; i++) {
				for (var j:uint = 0; j < descrArr[i].length; j++) {
					for (var k:uint = 0; k < descrArr[i][j].length; k++) {
						//trace("descrArr[" + i + "][" + j + "][" + k + "]:" + descrArr[i][j][k] + " minMaxArr[" + j + " * 2]:" + minMaxArr[j * 2]);
						
						if (descrArr[i][j][k] < minMaxArr[j * 2]) {
							minMaxArr[j * 2] = descrArr[i][j][k];
							//trace("new loweset:" + descrArr[i][j][k] + " descrArr["+i+"]["+j+"]["+k+"]");
						}
						if ( descrArr[i][j][k] > minMaxArr[j * 2 + 1]) {
							minMaxArr[j * 2 + 1] = descrArr[i][j][k];
						}
					}
				}
			}
			
			return minMaxArr;
		}
		
		private function updateBoundaries( e:Event = null ) {
			_gridBoundaries.graphics.clear();
			_gridBoundaries.graphics.lineStyle(1, 0x000000, 1);
			_gridBoundaries.graphics.lineTo(0, _gridHeight);
			_gridBoundaries.graphics.lineTo(_gridWidth, _gridHeight);
			_gridBoundaries.graphics.lineTo(_gridWidth, 0);
			_gridBoundaries.graphics.lineTo(0, 0);
		}
		
		public function createSquare(color:Number = 0xFF0000):Sprite {
			var rect:Shape = new Shape();
			rect.graphics.beginFill(color);
			rect.graphics.moveTo(-2, -2);
			rect.graphics.lineTo(-2, 2);
			rect.graphics.lineTo(2, 2);
			rect.graphics.lineTo(2, -2);
			rect.graphics.lineTo(-2, -2);
			
			var sprite:Sprite = new Sprite();
			sprite.addChild( rect );
			return sprite;
		}
		
		public function get bezierInfo():BezierInfo {
			return _bezInfo;
		}
		
		//public function getPoint(ratio:Number) {
			//var num:Number = _bezInfo.getPoint( ratio, 1);
			//
			//
		//}
		
	}
	
}