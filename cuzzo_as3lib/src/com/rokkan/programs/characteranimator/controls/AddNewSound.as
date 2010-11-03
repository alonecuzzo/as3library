package com.rokkan.programs.characteranimator.controls 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.primitives.Cube;
	import com.rokkan.programs.characteranimator.Main;
	import com.rokkan.programs.characteranimator.parts.BoxRotator;
	import com.rokkan.control.SlidingAdjustment;
	import com.rokkan.utils.NumberUtil;
	import fl.motion.easing.Quadratic;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import gs.TweenLite;
	
	/**
	* Not used
	* @author Russell Savage
	*/
	public class AddNewSound extends Sprite 
	{
		// inherent vars
		private var _mask_mc:MovieClip;
		
		public var btnCancel_mc:MovieClip;
		public var btnCreate_mc:MovieClip;
		
		public var fileInput:TextField;
		public var nameInput:TextField;
		
		
		// created vars
		private var _target:BoxRotator;
		private var _level:Number;
		private var _titlePiece:TimeLineTitlePiece;
		private var _tempHolder:ObjectContainer3D;
		private var _tempCube:Cube;
		private var _tempCrossHairs:ObjectContainer3D;
		
		
		public function AddNewSound() 
		{
			
		}
		
		public function init( target:BoxRotator, level:Number, titlePiece:TimeLineTitlePiece ) {
			_target = target;
			_level = level;
			_titlePiece = titlePiece;
			
			btnCancel_mc.title_txt.text = "Cancel";
			btnCancel_mc.buttonMode = true;
			btnCancel_mc.addEventListener( MouseEvent.CLICK, cancel, false, 0, true);
			
			btnCreate_mc.title_txt.text = "Create";
			btnCreate_mc.buttonMode = true;
			btnCreate_mc.addEventListener( MouseEvent.CLICK, create, false, 0, true);
			
			namerInput.type = xContainerInput.type = yContainerInput.type = zContainerInput.type = TextFieldType.INPUT;
			xCubeInput.type = yCubeInput.type = zCubeInput.type = widthInput.type = heightInput.type = depthInput.type = TextFieldType.INPUT;
			
			xContainerInput.addEventListener("change", textInputCapture);
			yContainerInput.addEventListener("change", textInputCapture);
			zContainerInput.addEventListener("change", textInputCapture);
			xCubeInput.addEventListener("change", textInputCapture);
			yCubeInput.addEventListener("change", textInputCapture);
			zCubeInput.addEventListener("change", textInputCapture);
			widthInput.addEventListener("change", textInputCapture);
			heightInput.addEventListener("change", textInputCapture);
			depthInput.addEventListener("change", textInputCapture);
			
			namerInput.text = target.id + (level + 1);
			
			_mask_mc = MovieClip( new rectangleRed() );
			this.parent.addChild( _mask_mc );
			_mask_mc.alpha = 0.5;
			_mask_mc.x = this.x;
			_mask_mc.y = this.y;
			this.mask = _mask_mc;
			
			_tempHolder = new ObjectContainer3D();
			target.addChild( _tempHolder );
			_tempCube = new Cube( { material:"red#", width:100, height:100, depth:100 } );
			_tempHolder.addChild( _tempCube );
			
			_tempCrossHairs = new ObjectContainer3D();
			target.addChild( _tempCrossHairs );
			var cross1:Cube = new Cube( { material:"black", width:1000, height:2, depth:2 } );
			_tempCrossHairs.addChild( cross1 );
			var cross2:Cube = new Cube( { material:"black", width:2, height:1000, depth:2 } );
			_tempCrossHairs.addChild( cross2 );
			var cross3:Cube = new Cube( { material:"black", width:2, height:2, depth:1000 } );
			_tempCrossHairs.addChild( cross3 );
			
			animateIn();
		}
		
		private function textInputCapture(event:Event):void {
			if (event.target.name != "nameInput") {
				// clean up text box
				event.target.text = NumberUtil.stripNonNumbers( event.target.text );
				var newValue:Number = Number( event.target.text);
				
				if(isNaN(newValue)==false){
					switch( event.target.name ){
						case "xContainerInput":
							_tempCrossHairs.x = _tempHolder.x = newValue;						 
							break;
						case "yContainerInput":
							_tempCrossHairs.y =_tempHolder.y = newValue;
							break;
						case "zContainerInput":
							_tempCrossHairs.z =_tempHolder.z = newValue;
							break;
						case "xCubeInput":
							_tempCube.x = newValue;
							break;
						case "yCubeInput":
							_tempCube.y = newValue;
							break;
						case "zCubeInput":
							_tempCube.z = newValue;
							break;
						case "widthInput":
							_tempCube.width = newValue;
							break;
						case "heightInput":
							_tempCube.height = newValue;
							break;
						case "depthInput":
							_tempCube.depth = newValue;
							break;
						default:
							trace("Unkown Input");
							break;
					}
				}
			}
        }
		
		public function animateIn() {
			_mask_mc.width = 17;
			_mask_mc.height = 15.5;
			TweenLite.to( _mask_mc, 0.1, { height:101, overwrite:false });
			TweenLite.to( _mask_mc, 0.15, { width:426, delay:0.1, overwrite:false });
		}
		
		public function animateOut() {
			TweenLite.to( _mask_mc, 0.07, { width:0, overwrite:false, ease:Quadratic.easeOut, onComplete:animateOutEnd } );
		}
		
		private function animateOutEnd() {
			this.parent.removeChild( this );
		}
		
		private function cancel( e:MouseEvent = null ) {
			btnCancel_mc.removeEventListener( MouseEvent.CLICK, cancel );
			btnCreate_mc.removeEventListener( MouseEvent.CLICK, create );
			animateOut();
			
			_target.removeChild( _tempHolder );
			_target.removeChild( _tempCrossHairs );
			
		}
		
		private function create( e:MouseEvent = null ) {
			var xmlRep:String = "<box data='id:" + namerInput.text + ",x:" + xContainerInput.text + ",y:" + yContainerInput.text + ",z:" + zContainerInput.text + ",";
			xmlRep += "widthCube:" + widthInput.text + ",heightCube:" + heightInput.text + ",depthCube:" + depthInput.text + ",";
			xmlRep += "xCube:" + xCubeInput.text + ",yCube:" + yCubeInput.text + ",zCube:" + zCubeInput.text + "' />";
			
			Main.mainRef.addModelItemSingle( _target, new XML(xmlRep), _titlePiece, _level + 1);
			
			cancel();
		}
		
	}
	
}