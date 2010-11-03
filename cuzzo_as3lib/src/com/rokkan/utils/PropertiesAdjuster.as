package com.rokkan.utils 
{
	import com.rokkan.control.SlidingAdjustment;
	import com.rokkan.timers.AfterXFrames;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.describeType;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class PropertiesAdjuster extends Sprite 
	{
		
		// created vars
		private var _target;
		private var _adjustValues:Array;
		private var _inputFieldsArr:Array;
		
		public function PropertiesAdjuster( addTo, target:Object, adjustValues:Array = null , prevProp:PropertiesAdjuster = null , widthAmt:Number = 250, panelName:String = null ) 
		{
			if (prevProp != null) {
				this.y = prevProp.y + prevProp.height + 5;
			}
			init( target, adjustValues, widthAmt, panelName);
			
			addTo.addChild( this );
			
			var xButton:Sprite = new Sprite();
			this.addChild( xButton );
			xButton.x = widthAmt - 9;
			xButton.y = 2;
			
			// add X button
			var backShape:Shape = new Shape();
			backShape.graphics.beginFill(0xFFFF00, 0);
			backShape.graphics.lineTo(7, 0);
			backShape.graphics.lineTo(7, 7);
			backShape.graphics.lineTo(0, 7);
			backShape.graphics.lineTo(0, 0);
			backShape.graphics.endFill();
			xButton.addChild( backShape );
			
			var triangle:Shape = new Shape();
			triangle.graphics.lineStyle(1, 0x000000, 1, false, "normal", "square" );
			triangle.graphics.moveTo(1, 1);
			triangle.graphics.lineTo(6, 6);
			triangle.graphics.moveTo(6, 1);
			triangle.graphics.lineTo(1, 6);
			xButton.addChild( triangle );
			
			xButton.buttonMode = true;
			xButton.addEventListener( MouseEvent.CLICK, removeThis, false, 0, true);
		}
		
		private function removeThis( e:Event = null ) {
			this.parent.removeChild( this );
		}
		
		public function init( target:Object, adjustValues:Array = null , widthAmt:Number = 250, panelName:String = null ) {
			_target = target;
			
			if (adjustValues == null) { // no adjustment variables defined, so we'll find all of the Number variables and add them.
				adjustValues = new Array();
				var xml:XML = flash.utils.describeType(target);
				var properties:XMLList = xml..variable.@name + xml..accessor.@name;
				for each (var k:String in properties){
					try {
						if (target[k] is Number) {
							//trace("Object property: " + k + ", Property value: " + target[k]);
							target[k] = target[k];
							adjustValues.push( k );
						}
					}catch ( error) {
						//trace("error with k:" + k);
					}
				}
				adjustValues.sort();
			}
			_adjustValues = adjustValues;
			
			_inputFieldsArr = new Array(adjustValues.length);
			
			var back_mc:Sprite = new Sprite();
			this.addChild( back_mc );
			
			// Apply Name
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("_sans", 10 );
			var strLabel:String = _target.name;
			if (strLabel == null) {
				strLabel = String(_target);
			}
			if (panelName != null) {
				strLabel = panelName;
			}
			if (strLabel.length > 20) {
				strLabel = strLabel.substring(0, 20) + "...";
			}
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = "Properties - " + strLabel;
			this.addChild( textField );
			
			this.contextMenu = new ContextMenu();
			var menuItem1:ContextMenuItem = new ContextMenuItem("Copy Object");
			menuItem1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyObject);
			this.contextMenu.customItems.push( menuItem1 );
			
			
			var nextX:Number = 5;
			var nextY:Number = 20;
			
			for ( var i:uint = 0; i < adjustValues.length; i++ ) {
				if(target[ adjustValues[i] ] is Number){
					textField = new TextField();
					textField.defaultTextFormat = new TextFormat("_sans", 10 );
					textField.text = adjustValues[i] + ":";
					textField.multiline = false;
					textField.autoSize = TextFieldAutoSize.LEFT;
					textField.x = nextX;
					if ((textField.x + textField.textWidth + 60) > widthAmt) {
						textField.x = nextX = 5;
						nextY += 18;
					}
					textField.y = nextY;
					this.addChild( textField );
					
					var inputField:TextField = new TextField();
					_inputFieldsArr[i] = inputField;
					inputField.type = TextFieldType.INPUT;
					inputField.defaultTextFormat = new TextFormat("_sans", 9 );
					inputField.background = true;
					inputField.border = true;
					inputField.addEventListener("change", inputChanged, false, 0, true);
					inputField.width = 40;
					inputField.height = 14;
					inputField.x = textField.x + textField.textWidth + 5;
					inputField.y = nextY;
					this.addChild( inputField );
					
					var slideAdj:SlidingAdjustment = new SlidingAdjustment(target, adjustValues[i], Number.NEGATIVE_INFINITY, Number.POSITIVE_INFINITY);
					slideAdj.x = inputField.x + inputField.width + 3;
					slideAdj.y = nextY + 3;
					this.addChild( slideAdj );
					slideAdj.addEventListener(Event.CHANGE, updateValues, false, 0, true);
					AfterXFrames.delayedCall(1, slideAdj.init);
					
					nextX = slideAdj.x + slideAdj.width + 5;
				}
			}
			
			var backShape:Shape = new Shape();
			backShape.graphics.lineStyle(1, 0x666666 );
			backShape.graphics.beginFill(0xE5E5E5);
			backShape.graphics.lineTo(widthAmt, 0);
			backShape.graphics.lineTo(widthAmt, nextY+21);
			backShape.graphics.lineTo(0, nextY+21);
			backShape.graphics.lineTo(0, 0);
			backShape.graphics.endFill();
			back_mc.addChild( backShape );
			
			updateValues();
		}
		
		private function copyObject( e:ContextMenuEvent ) {
			var toStr:String = Serializer.jsonTo( _target, Serializer.FILTER_POSITIONS_3D);
			trace("copied:" + toStr);
			System.setClipboard( toStr );
		}
		
		private function updateValues( e:Event = null ) {
			for ( var i:uint = 0; i < _inputFieldsArr.length; i++ ) {
				_inputFieldsArr[i].text = String( NumberUtil.roundToDecimals(_target[ _adjustValues[i] ], 2) );
			}
		}
		
		private function inputChanged( event:Event = null ) {
			if ( isNaN(Number(event.target.text)) ) {
				event.target.text = event.target.text;
			}else{
				event.target.text = NumberUtil.stripNonNumbers( event.target.text );
			}
			var inputField:TextField = TextField(event.target);
			
			var adjustingVal:String = "";
			for ( var i:uint = 0; i < _inputFieldsArr.length; i++ ) {
				if (_inputFieldsArr[i] == inputField) {
					adjustingVal = _adjustValues[i];
					break;
				}
			}
			if(isNaN(Number(inputField.text))==false){
				_target[ adjustingVal ] = Number(inputField.text);
			}
		}
	}
	
}