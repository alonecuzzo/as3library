package com.rokkan.programs.characteranimator 
{
	import away3d.cameras.HoverCamera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.core.clip.Clipping;
	import away3d.core.clip.RectangleClipping;
	import away3d.lights.DirectionalLight3D;
	import away3d.primitives.Cube;
	import away3d.primitives.Torus;
	import com.rokkan.programs.characteranimator.controls.FileDropDown;
	import com.rokkan.programs.characteranimator.controls.ObjectRotator;
	import com.rokkan.programs.characteranimator.controls.PropertiesPanel;
	import com.rokkan.programs.characteranimator.controls.TimeLine;
	import com.rokkan.programs.characteranimator.controls.TimeLineTitlePiece;
	import com.rokkan.programs.characteranimator.events.BoxRotatorEvent;
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.programs.characteranimator.shared.BoxAnimator;
	import com.rokkan.threedimensions.CameraManualControl;
	import com.rokkan.utils.ArrayMethods;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import com.rokkan.programs.characteranimator.events.HasFocus;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class Main extends Sprite 
	{
		// inherent vars
		public var fileDropDown_mc:FileDropDown;
		public var propertiesPanel_mc:PropertiesPanel;
		public var timeLine_mc:TimeLine;
		public var stageArea_mc:MovieClip;
		public var under3d_mc:MovieClip;
		public var back_mc:MovieClip;
		
		// created vars
		private var _view:View3D;
		public static var hoverCamera:HoverCamera3D;
		public static var objectRot:ObjectRotator;
		public static var hasFocus:Object;
		private var _characterHolder:ObjectContainer3D;
		private var _base:BoxRotator;
		private var _cameraManualCntrl:CameraManualControl;
		private var _isPlaying:Boolean = false;
		private var _boxAnim:BoxAnimator;
		
		//private var _defaultChar:String = "<box data='id:base,x:0,y:0,z:0,widthCube:300,heightCube:10,depthCube:300,xCube:0,yCube:0,zCube:0'><box data='id:torso,x:0,y:66,z:0,widthCube:90,heightCube:110,depthCube:90,xCube:0,yCube:85,zCube:0'><box data='id:head,x:0,y:120,z:0,widthCube:130,heightCube:85,depthCube:110,xCube:0,yCube:50,zCube:0'></box><box data='id:armLeft,x:-70,y:67,z:0,widthCube:70,heightCube:100,depthCube:50,xCube:0,yCube:-30,zCube:0'></box><box data='id:armRight,x:70,y:70,z:0,widthCube:70,heightCube:100,depthCube:50,xCube:0,yCube:-30,zCube:0'></box></box><box data='id:hipsAndLegs,x:0,y:90,z:0,widthCube:100,heightCube:110,depthCube:90,xCube:0,yCube:-40,zCube:0'></box></box>";
		private var _defaultChar:String = "<box data='id:base,x:0,y:0,z:0,widthCube:300,heightCube:10,depthCube:300,xCube:0,yCube:0,zCube:0,scaleX:1,scaleY:1'><box data='id:torso,x:0,y:66,z:0,widthCube:90,heightCube:110,depthCube:90,xCube:0,yCube:85,zCube:0,scaleX:1,scaleY:1,partPath:air/torso_default.obj,_partScale:10'><box data='id:head,x:0,y:120,z:0,widthCube:10,heightCube:85,depthCube:110,xCube:0,yCube:50,zCube:0,scaleX:1,scaleY:1,partPath:air/head_gorilla.obj,_partScale:10'></box><box data='id:armLeft,x:30,y:79,z:0,widthCube:70,heightCube:100,depthCube:50,xCube:39,yCube:-42,zCube:-1,scaleX:1,scaleY:1,partPath:air/armRight_proud.obj,_partScale:10'></box><box data='id:armRight,x:-30,y:80,z:0,widthCube:70,heightCube:100,depthCube:50,xCube:-39,yCube:-42,zCube:-1,scaleX:1,scaleY:1,partPath:air/armLeft_proud.obj,_partScale:10'></box></box><box data='id:hipsAndLegs,x:0,y:90,z:0,widthCube:100,heightCube:110,depthCube:90,xCube:0,yCube:-40,zCube:0,scaleX:1,scaleY:1,partPath:air/legs_proud.obj,_partScale:10'></box></box>";
		
		
		// static vars
		public static var stageRef:Stage;
		public static var mainRef:Main;
		public static var under3d:MovieClip;
		public static var backRef:MovieClip;
		
		public function Main() 
		{
			
		}
		
		public function init() {
			stage.align = "TL";
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stageRef = stage;
			mainRef = this;
			backRef = back_mc;
			under3d = under3d_mc;
			under3d.mouseEnabled = false;
			under3d.mouseChildren = false;
			
			// Time Line Stuff
			timeLine_mc.init();
			timeLine_mc.addEventListener( ControlEvent.KEYFRAME_SELECTED, objectSelected, true);
			timeLine_mc.addEventListener( HasFocus.CHANGE_FOCUS, changeFocus, false, 0, true);
			
			hoverCamera = new HoverCamera3D( { mintiltangle: -90, targetpanangle:180, tiltangle:0, targettiltangle:0, panangle:180, steps:3 } );
			trace("hoverCamera.distance:" + hoverCamera.distance);
			var clipHeight:Number = 900;
			var clipWidth:Number = 1400;
			var clip:Clipping = new RectangleClipping(-clipWidth/2, -clipHeight/2, clipWidth/2, clipHeight/2);
			_view = new View3D( { camera:hoverCamera, clip:clip } );
			_cameraManualCntrl = new CameraManualControl( hoverCamera, stage, true);
			stageArea_mc.addChild( _view );
			
			// Add body parts
			_characterHolder = new ObjectContainer3D( {y:-70} );
			_view.scene.addChild( _characterHolder );
			
			// Load default character
			var base:BoxRotator = modelFromXML( new XML( _defaultChar ) );
			
			// Properties Panel
			propertiesPanel_mc.addEventListener( HasFocus.CHANGE_FOCUS, changeFocus, false, 0, true);
			
			// File Access 
			fileDropDown_mc.init();
			
			// Add listeners
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			back_mc.addEventListener(MouseEvent.MOUSE_UP, backClicked, false, 0, true);
			stage.addEventListener(Event.RESIZE, resizeDisplay, false, 0, true);
			
			resizeDisplay();
			
			_boxAnim = new BoxAnimator();
			
			
			// testing animation
			//var boxAnim:BoxAnimator = new BoxAnimator();
			//var animDef:String = '<boxAnimatorAnimation>  <timeLine>    <timeLineItem id="base"><![CDATA[frame:1,easingFunc:null,x:0,y:0,z:0,rotationX:0,rotationY:0,rotationZ:0]]></timeLineItem>    <timeLineItem id="torso"><![CDATA[frame:1,easingFunc:null,x:0,y:66,z:0,rotationX:0,rotationY:0,rotationZ:0]]></timeLineItem>    <timeLineItem id="head"><![CDATA[frame:1,easingFunc:null,x:0,y:120,z:0,rotationX:0,rotationY:0,rotationZ:0|frame:15,easingFunc:null,x:0,y:120,z:0,rotationX:0,rotationY:-31.00000000000001,rotationZ:0|frame:25,easingFunc:null,x:0,y:120,z:0,rotationX:-35.00000000000001,rotationY:-31.00000000000001,rotationZ:0]]></timeLineItem>    <timeLineItem id="armLeft"><![CDATA[frame:1,easingFunc:null,x:-70,y:67,z:0,rotationX:0,rotationY:0,rotationZ:0]]></timeLineItem>    <timeLineItem id="armRight"><![CDATA[frame:1,easingFunc:null,x:70,y:70,z:0,rotationX:0,rotationY:0,rotationZ:0]]></timeLineItem>    <timeLineItem id="hipsAndLegs"><![CDATA[frame:1,easingFunc:null,x:0,y:90,z:0,rotationX:0,rotationY:0,rotationZ:0]]></timeLineItem>  </timeLine></boxAnimatorAnimation>';
			//BoxAnimator.animate( base, new XML( animDef ), 3 );
		}
		
		private function resizeDisplay( e:Event = null ) {
			propertiesPanel_mc.y = Math.round( stage.stageHeight - 102 ); 
			back_mc.width = stage.stageWidth;
			back_mc.height = stage.stageHeight;
			
			_view.x = stage.stageWidth / 2;
			_view.y = stage.stageHeight / 2 + timeLine_mc.height;
			under3d_mc.x = stage.stageWidth / 2;
			under3d_mc.y = stage.stageHeight / 2 + timeLine_mc.height;
			timeLine_mc.resizeDisplay();
		}
		
		public function reset() {
			timeLine_mc.resetAnim();
			timeLine_mc.selectFrame(1);
		}
		
		public function resetModel() {
			reset();
			timeLine_mc.clear();
			addModelItem( timeLine_mc, _characterHolder, new XML('<box data="id:base,x:0,y:0,z:0,widthCube:300,heightCube:10,depthCube:300,xCube:0,yCube:0,zCube:0" />'));
		}
		
		private function backClicked( e:MouseEvent = null) {
			resetFocus();
			hasFocus = back_mc;
		}
		
		public function resetFocus( e:Event = null ) {
			if (objectRot != null) {
				objectRot.die();
				objectRot = null;
			}
		}
		
		private function changeFocus( e:HasFocus = null ) {
			hasFocus = e.params.focus;
			//trace("changeFocus hasFocus:" + hasFocus);
		}
		
		private function objectSelected( e:ControlEvent = null ) {
			var target = e.params.mc;
			propertiesPanel_mc.die();
			
			if (objectRot != null) {
				if (propertiesPanel_mc.hasEventListener( ControlEvent.KEYFRAME_UPDATED ) ) {
					propertiesPanel_mc.removeEventListener( ControlEvent.KEYFRAME_UPDATED, timeLine_mc.updateProperties );
				}
				
				objectRot.parent.removeChild( objectRot );
				objectRot = null;
			}
			if(target is BoxRotator){
				objectRot = new ObjectRotator();
				target.parent.addChild( objectRot );
				propertiesPanel_mc.addEventListener( ControlEvent.KEYFRAME_UPDATED, timeLine_mc.updateProperties, false, 0, true );
				objectRot.init( target );
				
				objectRot.x = target.x;
				objectRot.y = target.y;
				objectRot.z = target.z;
			}
			
			propertiesPanel_mc.init( target );
		}
		
		private function onEnterFrame(event:Event):void {
			//trace("keyEnter:" + _cameraManualCntrl.keyEnter + " _isPlaying:" + _isPlaying + " hasFocus:" + hasFocus);
			var wrapFromBeginnging:Boolean = false;
			if (_cameraManualCntrl.keyEnter && _isPlaying==false && hasFocus is TimeLine) {
				_isPlaying = true;
				_boxAnim.start( timeLine_mc.selectedFrame );
				if (timeLine_mc.selectedFrame + 1 > timeLine_mc.totalFrames) { // it's already at the end wrap around
					wrapFromBeginnging = true;
				}
			}else if (_cameraManualCntrl.keyEnter && _isPlaying) {
				_isPlaying = false;
				timeLine_mc.stopSounds();
			}
			if (_cameraManualCntrl.keyEnter) { // to keep double key-enters from happening (since the user will usually leave the button down for more than one onEnterFrame)
				_cameraManualCntrl.keyEnter = false;
			}
			
			var totalFrames:Number = timeLine_mc.totalFrames;
			
			if (_isPlaying) {
				//trace("playing selectedFrame:" + timeLine_mc.selectedFrame + " totalFrames:" + timeLine_mc.totalFrames + " wrapFromBeginnging:" + wrapFromBeginnging);
				if (Math.round(timeLine_mc.selectedFrame) >= totalFrames && wrapFromBeginnging == false) { // End reached
					trace("end reached");
					_isPlaying = false;
					timeLine_mc.stopSounds();
				}else{
					if (wrapFromBeginnging) {
						timeLine_mc.selectFrame( 1 );
						timeLine_mc.selectFrameSounds( 1 );
						_boxAnim.start( timeLine_mc.selectedFrame );
					}else {
						//trace("selected frame:"+timeLine_mc.selectedFrame +" current calculated:"+_boxAnim.current);
						var selectFrame:Number = Math.round( _boxAnim.current );
						if (selectFrame > totalFrames)
							selectFrame = totalFrames;
						timeLine_mc.selectFrame( selectFrame );
						timeLine_mc.selectFrameSounds( selectFrame );
					}
				}
			}else {
				if (_cameraManualCntrl.keyComma) {
					timeLine_mc.selectFrame( timeLine_mc.selectedFrame - 1 );
					_cameraManualCntrl.keyComma = false;
				}else if (_cameraManualCntrl.keyPeriod) {
					timeLine_mc.selectFrame( timeLine_mc.selectedFrame + 1 );
				}
				_cameraManualCntrl.keyPeriod = _cameraManualCntrl.keyComma = false;
			}
			
			// file-menu hotkeys
			if (_cameraManualCntrl.keyCtrl && _cameraManualCntrl.key83) {
				fileDropDown_mc.animSaveAs();
				_cameraManualCntrl.key83 = false;
			}
			
			// perspective hotkeys
			if(_cameraManualCntrl.keyCtrl){
				if (_cameraManualCntrl.keyZero || _cameraManualCntrl.keyOne || _cameraManualCntrl.keyTwo || _cameraManualCntrl.keyThree ) {
					hoverCamera.targetpanangle = 180;
					hoverCamera.targettiltangle = 0;
					hoverCamera.panangle = 180;
					hoverCamera.distance = 800;
				}
				if (_cameraManualCntrl.keyZero) {
					hoverCamera.targetpanangle = 180;
					hoverCamera.targettiltangle = 90;
				}else if (_cameraManualCntrl.keyOne) {
					hoverCamera.targetpanangle = 270;
				}else if (_cameraManualCntrl.keyTwo) {
					hoverCamera.targetpanangle = 180;
				}else if (_cameraManualCntrl.keyThree) {
					hoverCamera.targetpanangle = 90;
				}
				_cameraManualCntrl.keyZero = _cameraManualCntrl.keyOne = _cameraManualCntrl.keyTwo = _cameraManualCntrl.keyThree = false;
			}
			//trace("hoverCamera.targettiltangle:" + hoverCamera.targettiltangle + " hoverCamera.targetpanangle:" + hoverCamera.targetpanangle);
			
			// rerender viewport on each frame
			hoverCamera.hover();
			_view.render();
		}
		
		public function modelToXML():XML {
			timeLine_mc.selectFrame(1);
			
			var base:BoxRotator = _characterHolder.children[0];
			var xmlStr:String = base.serialize();
			trace("xmlStr:" + xmlStr + " base:" + base + " _characterHolder.children:" + ArrayMethods.trace( _characterHolder.children ));
			
			return new XML(xmlStr);
		}
		
		public function addModelItemSingle( addToItem:BoxRotator, xmlData:XML, timeLineTitle:TimeLineTitlePiece, level:Number) {
			var addBox:BoxRotator = new BoxRotator("temp");
			addBox.deserialize( xmlData.attribute("data") );
			
			addBox.addEventListener( ControlEvent.PART_SELECTED, objectSelected, false, 0, true);
			addToItem.addChild( addBox );
			timeLine_mc.addItem( addBox, level, timeLineTitle );
		}
		
		public function modelFromXML( xml:XML ):BoxRotator {
			timeLine_mc.clear(); // clean up any leftovers
			
			var base:BoxRotator = addModelItem(timeLine_mc, _characterHolder, xml);
			trace("modelFromXML base.serialized:" + base.serialize());
			return base;
		}
		
		// recursively adds parts
		private function addModelItem( timeLineRef:TimeLine, addToItem, xmlData:XML, level:Number = 0):BoxRotator {
			var addBox:BoxRotator = new BoxRotator("temp");
			addBox.deserialize( xmlData.attribute("data") );
			
			addBox.addEventListener( ControlEvent.PART_SELECTED, objectSelected, false, 0, true);
			//trace("addModelItem level:"+level + " addBox:"+addBox);
			addToItem.addChild( addBox );
			timeLineRef.addItem( addBox, level );
			
			if (xmlData.children().length() > 0) {
				var boxList:XMLList = xmlData.children();		
				for each (var  boxInfo:XML in boxList){
					addModelItem( timeLineRef, addBox, boxInfo, level + 1);
				}
			}
			
			return addBox;
		}
		
		public function toXML():XML {
			var output:String = "<boxAnimatorAnimation>";
			output += timeLine_mc.toXML();
			output += "</boxAnimatorAnimation>";
			
			var returnXML:XML = new XML(output);
			return returnXML;
		}
		
		public function fromXML( xml:XML ) {
			trace("Main fromXML xml" + xml);
			
			timeLine_mc.fromXML( XML(xml.timeLine) );
		}
	}
	
}