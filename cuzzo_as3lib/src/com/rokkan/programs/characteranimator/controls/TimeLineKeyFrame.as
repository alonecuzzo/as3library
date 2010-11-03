package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.math.Format;
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.events.HasFocus;
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import gs.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class TimeLineKeyFrame extends Sprite 
	{
		// inherent vars
		public var dot_mc:MovieClip;
		public var back_mc:MovieClip;
		
		public var frame:Number;
		public var properties:Object;
		public var easingFunc:String;
		
		private var _isSelected:Boolean = false;
		
		public function TimeLineKeyFrame(frameIn:Number = NaN) 
		{
			frame = frameIn;
			properties = { x:NaN, y:NaN, z:NaN, rotationX:NaN, rotationY:NaN, rotationZ:NaN };
		}
		
		public function init() {
			var rightClickMenu:ContextMenu = new ContextMenu();
			rightClickMenu.hideBuiltInItems();
			
			var clearKey:ContextMenuItem = new ContextMenuItem("Clear Key Frame");
			clearKey.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, clearKeyFrame, false, 0, true );
			
			rightClickMenu.customItems.push( clearKey );
			this.contextMenu = rightClickMenu;
			
			this.addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			this.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
		}
		
		public static function copyProperties(from:Object, into:Object) {
			into.x = from.x;
			into.y = from.y;
			into.z = from.z;
			into.rotationX = from.rotationX;
			into.rotationY = from.rotationY;
			into.rotationZ = from.rotationZ;
		}
		
		public static function tweenPropertiesLinear(from:Object, to:Object, into:Object, frames:Number, frameOffset:Number) {
			// linear tween
			var ratio:Number = (frameOffset / frames);
			into.x = from.x + (to.x - from.x) * ratio;
			into.y = from.y + (to.y - from.y) * ratio;
			into.z = from.z + (to.z - from.z) * ratio;
			into.rotationX = from.rotationX + (to.rotationX - from.rotationX) * ratio;
			into.rotationY = from.rotationY + (to.rotationY - from.rotationY) * ratio;
			into.rotationZ = from.rotationZ + (to.rotationZ - from.rotationZ) * ratio;
		}
		
		public static function tweenProperties(from:Object, to:Object, into:Object, frames:Number, frameOffset:Number, tweenFunc:Function) {
			// General tween
			into.x = tweenFunc( frameOffset, from.x, (to.x-from.x), frames );
			into.y = tweenFunc( frameOffset, from.y, (to.y - from.y), frames );
			into.z = tweenFunc( frameOffset, from.z, (to.z - from.z), frames );
			into.rotationX = tweenFunc( frameOffset, from.rotationX, (to.rotationX - from.rotationX), frames );
			into.rotationY = tweenFunc( frameOffset, from.rotationY, (to.rotationY - from.rotationY), frames );
			into.rotationZ = tweenFunc( frameOffset, from.rotationZ, (to.rotationZ - from.rotationZ), frames );
		}
		
		public function updateProperties( target:BoxRotator, easingFuncIn:String = null ) {
			copyProperties(target, properties);
			easingFunc = easingFuncIn;
		}
		
		public function deSelect() {
			//trace("KeyFrame deselect:" + this.name);
			_isSelected = false;
			TweenLite.to( back_mc, 0, { tint:0xACA899 } );
			TweenLite.to( dot_mc, 0, { tint:0x000000 } );
		}
		
		public function select() {
			//trace("KeyFrame select this.name:" + this.name);
			_isSelected = true;
			TweenLite.to( back_mc, 0, { tint:0x000000 } );
			TweenLite.to( dot_mc, 0, { tint:0xFFFFFF } );
			parent["keyFrameSelected"]();
		}
		
		private function handleMouseUp( e:MouseEvent = null ) {
			//trace("\nkeyframe onMouseUp this.name:"+this.name + " frame:"+this.frame);
			select();
			
			parent["selectKeyFrame"]( this );
			dispatchEvent( new ControlEvent( ControlEvent.KEYFRAME_SELECTED, { mc:this }, true) );
			dispatchEvent( new HasFocus( HasFocus.CHANGE_FOCUS, { focus:Main.mainRef.timeLine_mc }, true ) );
		}
		
		private function handleMouseDown( e:MouseEvent = null) {
			if(_isSelected && frame!=1){
				parent["startDraggingKey"]( this );
			}
		}
		
		private function clearKeyFrame( e:ContextMenuEvent = null ) {
			parent["clearKeyFrame"]( this );
		}
		
		/*********************
		 * Get/Set Methods
		 * *******************/
		
		
		override public function toString():String {
			var f:Function = Format.minFix;
			var stringRep:String = "TimeLineKeyFrame {frame:" + frame;
			stringRep += ",properties:{x:"+f(properties.x, 6)+",y:"+f(properties.y, 6)+",z:"+f(properties.z, 6);
			stringRep += ",rotationX:"+f(properties.rotationX, 6)+",rotationY:"+f(properties.rotationY, 6)+",rotationZ:"+f(properties.rotationZ, 6);
			stringRep += "}";
			stringRep += "}";
			
			return stringRep;
		}
		
		/*********************
		 * Serialize Methods
		 * *******************/
		
		public function serialize():String {
			var f:Function = Format.minFix;
			var output:String = "frame:" + frame;
			if(easingFunc!=null)
				output += ",easingFunc:" + easingFunc;
			output += ",x:" + f(properties.x, 6) + ",y:" + f(properties.y, 6) + ",z:" + f(properties.z, 6);
			output += ",rotationX:" + f(properties.rotationX, 6) + ",rotationY:" + f(properties.rotationY, 6) + ",rotationZ:" + f(properties.rotationZ, 6);
			return output;
		}
		
		public function deserialize( str:String ) {
			var propArr:Array = str.split(",");
			var subPairs:String;
			var propVal:String;
			var propName:String;
			
			var indexPt:uint;
			for (var i:uint = 0; i < propArr.length; i++) {
				subPairs = propArr[i];
				indexPt = subPairs.indexOf(":");
				propName = subPairs.substring(0, indexPt);
				propVal = subPairs.substring(indexPt + 1);
				if (propName.indexOf("frame") >= 0) {
					this[propName] = Number(propVal);
				}else if (propName.indexOf("easingFunc") >= 0) {
					this[propName] = String(propVal);
				}else {
					this.properties[propName] = Number(propVal);
				}
			}
		}
	}
	
}