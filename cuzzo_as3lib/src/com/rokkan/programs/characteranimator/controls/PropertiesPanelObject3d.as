package com.rokkan.programs.characteranimator.controls 
{
	import com.rokkan.math.Format;
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.utils.NumberUtil;
	import fl.controls.ComboBox;
	import fl.managers.FocusManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import com.rokkan.programs.characteranimator.events.HasFocus;
	import com.rokkan.control.SlidingAdjustment;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class PropertiesPanelObject3d extends Sprite 
	{
		public var disabler_mc:MovieClip;
		
		public var xRotationInput:TextField;
		public var xRotationSlider:SlidingAdjustment;
		public var yRotationInput:TextField;
		public var yRotationSlider:SlidingAdjustment;
		public var zRotationInput:TextField;
		public var zRotationSlider:SlidingAdjustment;
		
		public var xContainerInput:TextField;
		public var xContainerSlider:SlidingAdjustment;
		public var yContainerInput:TextField;
		public var yContainerSlider:SlidingAdjustment;
		public var zContainerInput:TextField;
		public var zContainerSlider:SlidingAdjustment;
		
		public var xCubeInput:TextField;
		public var xCubeSlider:SlidingAdjustment;
		public var yCubeInput:TextField;
		public var yCubeSlider:SlidingAdjustment;
		public var zCubeInput:TextField;
		public var zCubeSlider:SlidingAdjustment;
		
		public var widthInput:TextField;
		public var heightInput:TextField;
		public var depthInput:TextField;
		
		public var viewMode_mc:ComboBox;
		
		// created vars
		private var _target:BoxRotator;
		private var _inputArr:Array;
		private var _sliderArr:Array;
		
		public function PropertiesPanelObject3d() 
		{
			
		}
		
		public function init( target:BoxRotator ) {
			_target = target;
			
			_inputArr = [ xRotationInput, yRotationInput, zRotationInput, xContainerInput, yContainerInput, zContainerInput, 
			xCubeInput, yCubeInput, zCubeInput, widthInput, heightInput, depthInput];
			this.tabChildren = true;
			
			for (var i:uint = 0; i < _inputArr.length; i++) {
				_inputArr[i].addEventListener("change", textInputCapture);
				_inputArr[i].type = TextFieldType.INPUT;
				_inputArr[i].background = true;
				_inputArr[i].tabIndex = i + 1;
				//_inputArr[i].tabEnabled = true;
				trace("_inputArr[i].tabIndex:" + _inputArr[i].tabIndex);
			}
			
			viewMode_mc.tabEnabled = false;
			viewMode_mc.tabChildren = false;
			disabler_mc.tabEnabled = false;
			
			_sliderArr = [["rotationX", xRotationSlider], ["rotationY", yRotationSlider], ["rotationZ", zRotationSlider],
			["x", xContainerSlider], ["y", yContainerSlider], ["z", zContainerSlider] ];
			for (i = 0; i < _sliderArr.length; i++) {
				_sliderArr[i][1].init( _target, _sliderArr[i][0] );
				_sliderArr[i][1].addEventListener( Event.CHANGE, updateProperties, false, 0, true);
				_sliderArr[i][1].tabEnabled = false;
			}
			
			xCubeSlider.init( target.part, "x" );
			xCubeSlider.addEventListener( Event.CHANGE, updateProperties, false, 0, true);
			yCubeSlider.init( target.part, "y" );
			yCubeSlider.addEventListener( Event.CHANGE, updateProperties, false, 0, true);
			zCubeSlider.init( target.part, "z" );
			zCubeSlider.addEventListener( Event.CHANGE, updateProperties, false, 0, true);
			
			viewMode_mc.addItem( { label:"Box", data:"boxMode" } );
			if(_target.meshAvailable){
				viewMode_mc.addItem( { label:"Mesh", data:"meshMode" } );
			}
			if (_target.mode == BoxRotator.MODE_BOX) {
				viewMode_mc.selectedIndex = 0;
			}else if (_target.mode == BoxRotator.MODE_MESH) {
				viewMode_mc.selectedIndex = 1;
			}
			viewMode_mc.addEventListener("change", viewModeChange, false, 0, true);
			
			disabler_mc.addEventListener(MouseEvent.CLICK, disabler, false, 0, true);
			
			setPropTextFields();
			Main.objectRot.addEventListener( ControlEvent.KEYFRAME_UPDATED, updateProperties, false, 0, true);
			
			if (Main.mainRef.timeLine_mc.selectedFrame == 1) {
				disabler_mc.visible = false;
			}
		}
		
		private function disabler( e:Event = null) {
			trace("disabled");
		}
		
		public function die() {
			if(Main.objectRot!=null && Main.objectRot.hasEventListener( ControlEvent.KEYFRAME_UPDATED ) )
				Main.objectRot.removeEventListener( ControlEvent.KEYFRAME_UPDATED, updateProperties);
		}
		
		private function updateProperties( e:Event) {
			trace("updateProperties");
			setPropTextFields();
			
			dispatchEvent( new ControlEvent(ControlEvent.KEYFRAME_UPDATED, { mc:_target }, true ) );
		}
		
		private function setPropTextFields() {
			
			xRotationInput.text = Format.minFix(_target.rotationX, 1);
			yRotationInput.text = Format.minFix(_target.rotationY, 1);
			zRotationInput.text = Format.minFix(_target.rotationZ, 1);
			
			xContainerInput.text = Format.minFix(_target.x, 1);
			yContainerInput.text = Format.minFix(_target.y, 1);
			zContainerInput.text = Format.minFix(_target.z, 1);
			
			if (_target.part == null) {
				xCubeInput.text = Format.minFix(_target.cube.x, 1);
				yCubeInput.text = Format.minFix(_target.cube.y, 1);
				zCubeInput.text = Format.minFix(_target.cube.z, 1);
			}else {
				xCubeInput.text = Format.minFix(_target.part.x, 1);
				yCubeInput.text = Format.minFix(_target.part.y, 1);
				zCubeInput.text = Format.minFix(_target.part.z, 1);
			}
			
			
			widthInput.text = Format.minFix(_target.cube.width, 1);
			heightInput.text = Format.minFix(_target.cube.height, 1);
			depthInput.text = Format.minFix(_target.cube.depth, 1);
		}
		
		private function textInputCapture(event:Event):void {
			event.target.text = NumberUtil.stripNonNumbers( event.target.text );
			var newValue:Number = Number( event.target.text );
			
			if(isNaN(newValue)==false){
				switch( event.target.name )
				{
					case "xContainerInput":
						_target.x = newValue;
						break;
					case "yContainerInput":
						_target.y = newValue;
						break;
					case "zContainerInput":
						_target.z = newValue;
						break;
					case "xRotationInput":
						_target.rotationX = newValue;
						break;
					case "yRotationInput":
						_target.rotationY = newValue;
						break;
					case "zRotationInput":
						_target.rotationZ = newValue;
						break;
					case "xCubeInput":
						_target.cube.x = newValue;
						if (_target.part != null)
							_target.part.x = newValue;
						break;
					case "yCubeInput":
						_target.cube.y = newValue;
						if (_target.part != null)
							_target.part.y = newValue;
						break;
					case "zCubeInput":
						_target.cube.z = newValue;
						if (_target.part != null)
							_target.part.z = newValue;
						break;
					case "widthInput":
						_target.cube.width = newValue;
						break;
					case "heightInput":
						_target.cube.height = newValue;
						break;
					case "depthInput":
						_target.cube.depth = newValue;
						break;
					default:
						trace("Unkown Input");
						break;
				}
			}
			
			dispatchEvent( new HasFocus( HasFocus.CHANGE_FOCUS, { focus:this.parent }, true ) );
			dispatchEvent( new ControlEvent(ControlEvent.KEYFRAME_UPDATED, { mc:_target }, true ) );
        }
		
		private function viewModeChange( e:Event ) {
			var itemSelected = viewMode_mc.selectedItem;
			
			switch( itemSelected.data )
			{
				case "boxMode":
					_target.mode = BoxRotator.MODE_BOX;
					break;
				case "meshMode":
					_target.mode = BoxRotator.MODE_MESH;
					break;
				default:
					trace("Unkown Input");
					break;
			}
		}
	}
	
}