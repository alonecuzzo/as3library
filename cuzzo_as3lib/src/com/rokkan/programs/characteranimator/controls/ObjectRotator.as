package com.rokkan.programs.characteranimator.controls 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;
	import away3d.primitives.Cube;
	import away3d.primitives.Torus;
	import com.rokkan.math.LineDef;
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class ObjectRotator extends ObjectContainer3D 
	{
		private var _torusRed:Object3D;
		private var _torusGreen:Object3D;
		private var _torusBlue:Object3D;
		private var _tempCrossHairs:ObjectContainer3D;
		
		private var _control:BoxRotator;
		private var _lastX:Number = 0;
		private var _lastY:Number = 0;
		private var _adjustValue:String = "rotationX";
		
		public function ObjectRotator() 
		{
			
		}
		
		public function init( control:BoxRotator ) {
			_control = control;
			var highestPt:Number = _control.boundingRadius;
			trace("_control.x:" + _control.x + "_control.y:" + _control.y + " _control.z:" + _control.z);
			_torusRed = new Torus({material:0xFF0000, name:"torusRed", x:0, y:0, z:0, radius:highestPt, tube:highestPt/40, segmentsR:8, segmentsT:3});
			this.addChild( _torusRed );
			_torusRed.useHandCursor = true;
			_torusRed.addOnMouseDown( handleOnDown );
			
			_torusGreen = new Torus( { material:0x00FF00, name:"torusGreen", x:0, y:0, z:0, radius:highestPt, tube:highestPt/40, segmentsR:8, segmentsT:3, rotationX:90 } );
			this.addChild( _torusGreen );
			_torusGreen.useHandCursor = true;
			_torusGreen.addOnMouseDown( handleOnDown );
			
			_torusBlue = new Torus( { material:0x0000FF, name:"torusBlue", x:0, y:0, z:0, radius:highestPt, tube:highestPt/40, segmentsR:8, segmentsT:3, rotationX:90, rotationY:90 } );
			this.addChild( _torusBlue );
			_torusBlue.useHandCursor = true;
			_torusBlue.addOnMouseDown( handleOnDown );
			
			_tempCrossHairs = new ObjectContainer3D();
			this.addChild( _tempCrossHairs );
			var cross1:Cube = new Cube( { material:"black", width:1000, height:2, depth:2 } );
			_tempCrossHairs.addChild( cross1 );
			var cross2:Cube = new Cube( { material:"black", width:2, height:1000, depth:2 } );
			_tempCrossHairs.addChild( cross2 );
			var cross3:Cube = new Cube( { material:"black", width:2, height:2, depth:1000 } );
			_tempCrossHairs.addChild( cross3 );
		}
		
		public function die() {
			if( Main.stageRef.hasEventListener(MouseEvent.MOUSE_UP) )
				Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, handleOnMouseUp);
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, controlOnEnter);
			this.parent.removeChild( this );
		}
		
		private function handleOnDown(e:MouseEvent3D = null) {
			_lastX = Main.stageRef.mouseX;
			_lastY = Main.stageRef.mouseY;
			if (e.target.name.indexOf("Red") >= 0) {
				_adjustValue = "rotationY";
			}else if (e.target.name.indexOf("Green") >= 0) {
				_adjustValue = "rotationZ";
			}else if (e.target.name.indexOf("Blue") >= 0) {
				_adjustValue = "rotationX";
			}
			
			Main.stageRef.addEventListener(Event.ENTER_FRAME, controlOnEnter, false, 0, true);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, handleOnMouseUp, false, 0, true);
			Main.backRef.addEventListener(MouseEvent.MOUSE_UP, handleOnMouseUp, false, 0, true);
		}
		
		private function handleOnMouseUp( e:Event = null ) {
			Main.stageRef.removeEventListener(Event.ENTER_FRAME, controlOnEnter);
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, handleOnMouseUp);
			Main.backRef.removeEventListener(MouseEvent.MOUSE_UP, handleOnMouseUp);
			
			dispatchEvent( new ControlEvent(ControlEvent.KEYFRAME_UPDATED, { } ) );
			//stage.removeEventListener(MouseEvent.MOUSE_UP, blueOnMouseUp);
		}
		
		
		private function controlOnEnter( e:Event = null) {
			var diff:Number = _lastX - Main.stageRef.mouseX;
			diff += _lastY - Main.stageRef.mouseY;
			if(isNaN(diff)==false){
				if(LineDef.sanitizeDegreePos(Main.hoverCamera.targetpanangle)<180){
					_control[ _adjustValue ] += diff;
				}else {
					if (_adjustValue.indexOf("X") >= 0) {
						_control[ _adjustValue ] -= diff;
					}else if (_adjustValue.indexOf("Y") >= 0) {
						_control[ _adjustValue ] += diff;
					}else if (_adjustValue.indexOf("Z") >= 0) {
						_control[ _adjustValue ] += diff;
					}
					
				}
				_lastX = Main.stageRef.mouseX;
				_lastY = Main.stageRef.mouseY;
			}
		}
		
	}
	
}