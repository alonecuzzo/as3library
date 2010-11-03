package com.rokkan.programs.characteranimator.parts 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.base.Object3D;
	import away3d.core.utils.Cast;
	import away3d.events.MouseEvent3D;
	import away3d.loaders.Obj;
	import away3d.loaders.Object3DLoader;
	import away3d.loaders.utils.MaterialLibrary;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import com.rokkan.net.LoadingQueue;
	import com.rokkan.programs.characteranimator.events.BoxRotatorEvent;
	import com.rokkan.programs.characteranimator.events.ControlEvent;
	import com.rokkan.utils.ArrayMethods;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class BoxRotator extends ObjectContainer3D 
	{
		// constants
		public static const MODE_BOX:uint = 0;
		public static const MODE_MESH:uint = 1;
		
		// created vars
		private var _cube:Cube;
		private var _partLoader:Object3DLoader;
		private var _part:Object3D;
		private var _partMaterial;
		private var _partScale:Number;
		private var _mode:uint = MODE_BOX;
		private var _texturePath:String;
		private var _partPath:String;
		private var _onSuccessAndTexture:Function;
		private var _loadExternalTexture:Function;
		private var _loadingQueue:LoadingQueue;
		
		public var id:String;
		public var meshAvailable:Boolean = false;
		
		public function BoxRotator(id:String, boxX:Number = 0, boxY:Number = 0, boxZ:Number = 0, boxHeight:Number = 50, boxWidth:Number = 50, boxDepth:Number = 50, 
		holdX:Number = 0, holdY:Number = 0, holdZ:Number = 0) 
		{
			this.id = id;
			this.x = holdX;
			this.y = holdY;
			this.z = holdZ;
			_cube = new Cube( { material:"yellow#", name:"cube", x:boxX, y:boxY, z:boxZ, height:boxHeight, width:boxWidth, depth:boxDepth } );
			this.addChild( _cube );
			_cube.useHandCursor = true;
			_cube.addOnMouseDown( activatorRotator );
		}
		
		public function removeCube() {
			_cube.removeOnMouseDown( activatorRotator );
			this.removeChild( _cube );
			_cube = null;
		}
		
		private function activatorRotator(e:MouseEvent3D = null) {
			//_cube.removeOnMouseDown( activatorRotator );
			
			//_cube.ownCanvas = true;
			//_cube.filters = [ new GlowFilter(0x00ffff, 1, 5, 5, 1000) ];
			
			dispatchEvent( new ControlEvent(ControlEvent.PART_SELECTED, { mc:this }, true) );
		}
		
		public function init() {
			
		}
		
		public function die() {
			try{
				_cube.removeOnMouseDown( activatorRotator );
				if (_part != null) {
					_part.removeOnMouseDown( activatorRotator );
				}
			}catch (e:Error) {
				
			}
			
			/*if (_part != null) {
				_part.removeOnMouseDown( activatorRotator );
				this.removeChild( _part );
			}
			if (_cube != null) {
				_cube.removeOnMouseDown( activatorRotator );
				this.removeChild( _cube );
			}
			
			var childrenArr:Array = this.children;
			for (var i:uint = 0; i < childrenArr.length; i++) {
				if (childrenArr[i] is BoxRotator) {
					output += childrenArr[i].serialize();
				}
			}*/
		}
		
		public function loadObj(objPath:String, scale:Number = 1, onSuccess:Function = null, texturePath:String = null, material = "magenta#") {
			_partPath = objPath;
			_partScale = scale;
			_partMaterial = material;
			
			trace("Loading obj:" + objPath);
			
			_partLoader = Obj.load( objPath, { material:material, x:_cube.x, y:_cube.y, z:_cube.z, 
			rotationX:_cube.rotationX, rotationY:_cube.rotationY, rotationZ:_cube.rotationZ } );
			
			_partLoader.addOnSuccess( onLoaderSuccess );
			
			if(onSuccess!=null && texturePath == null){
				_partLoader.addOnSuccess( onSuccess );
			}
			
			if (texturePath != null ) {
				_onSuccessAndTexture = onSuccess;
				_texturePath = texturePath;
				_partLoader.addOnSuccess( loadObjAndTexture );
			}
			
			this.addChild( _partLoader );
		}
		
		private function loadObjAndTexture( e:Event = null) {
			_loadingQueue = new LoadingQueue();
			_loadingQueue.load( _texturePath, andTextureLoaded );
		}
		
		private function andTextureLoaded( disp:Bitmap, params:Object ) {
			loadTexture( disp.bitmapData );
			if(_onSuccessAndTexture!=null)
				_onSuccessAndTexture();
			
			dispatchEvent( new BoxRotatorEvent( BoxRotatorEvent.LOADED_TEXTUREANDPART, null, false) );
		}
		
		public function loadOcclusionTextureExternal( path:String, callback:Function = null ):BitmapData {
			var mat:BitmapMaterial = this.currentMesh.material as BitmapMaterial;
			_loadingQueue.load( path, andOcclusionTextureLoaded, { callback:callback } );
			
			return mat.bitmap;
		}
		
		private function andOcclusionTextureLoaded( disp:Bitmap, params:Object) {
			loadOcclusionTexture( disp );
			
			if(params.callback!=null)
				params.callback();
		}
		
		public function get currentMesh():Mesh {
			if(_part != null){
				var container = _part;
				for ( var i:uint = 0; i < 10 && !(container is Mesh); i++) {
					container = container["children"][0];
				}
				
				var mesh:Mesh = Mesh( container );
				return mesh;
			}
			return null;
		}
		
		public function loadOcclusionTexture( occlusion:Bitmap ):BitmapData {
			var mesh:Mesh = this.currentMesh;
			var bitmapMat:BitmapMaterial = mesh.material as BitmapMaterial;
			var bitmap:Bitmap = new Bitmap( bitmapMat.bitmap );
			var sprite:Sprite = new Sprite();
			sprite.addChild( bitmap );
			occlusion.blendMode = BlendMode.HARDLIGHT;
			occlusion.alpha = 0.5;
			sprite.addChild( occlusion );
			mesh.material = new BitmapMaterial(Cast.bitmap( sprite ), { } );
			
			return bitmap.bitmapData;
		}
		
		public function removeOcclusionTexture() {
			
		}
		
		public function loadExternalTexture( texturePath:String, callback:Function = null ) {
			_texturePath = texturePath;
			_loadExternalTexture = callback;
			_loadingQueue = new LoadingQueue();
			_loadingQueue.load( texturePath, loadExternalTextureSuccess );
		}
		
		private function loadExternalTextureSuccess( disp:Bitmap, params:Object ) {
			trace("loadExternalTextureSuccess disp:" + disp);
			loadTexture( disp.bitmapData );
			if(_loadExternalTexture!=null){
				_loadExternalTexture();
			}
		}
		
		public function loadTexture( material:BitmapData ) {
			if(_part!=null){
				var mesh:Mesh = this.currentMesh;
				mesh.material = new BitmapMaterial(material, { } );
			}else {
				_cube.material = new BitmapMaterial(material, { } );
			}
		}
		
		public function set mode( mode:uint ) {
			if ( mode == MODE_BOX ) {
				this.removeChild( _part );
				_part.removeOnMouseDown( activatorRotator );
				this.addChild( _cube );
				_cube.addOnMouseDown( activatorRotator );
			}else if ( mode == MODE_MESH ) {
				this.removeChild( _cube );
				_cube.removeOnMouseDown( activatorRotator );
				this.addChild( _part );
				_part.addOnMouseDown( activatorRotator );
			}
			
			_mode = mode;
		}
		
		public function get mode():uint {
			return _mode;
		}
		
		public function serialize():String {
			var offsetInfo = _part != null ? _part : _cube;
			
			var output:String = "<box data='id:" + this.id + ",x:" + this.x + ",y:" + this.y + ",z:" + this.z;
			output += ",scaleX:" + this.scaleX + ",scaleY:" + this.scaleY + ",scaleZ:" + this.scaleZ;
			if (_cube != null) {
				output += ",widthCube:" + _cube.width + ",heightCube:" + _cube.height + ",depthCube:" + _cube.depth
			}
			if (offsetInfo != null) {
				output += ",xCube:" + offsetInfo.x + ",yCube:" + offsetInfo.y + ",zCube:" + offsetInfo.z;
			}
			
			if (_partPath != null) {
				output += ",partPath:"+_partPath+",_partScale:"+_partScale;
			}
			if (_texturePath != null) {
				output += ",texturePath:"+_texturePath;
			}
			output += "'>";
			
			var childrenArr:Array = this.children;
			for (var i:uint = 0; i < childrenArr.length; i++) {
				if (childrenArr[i] is BoxRotator) {
					output += childrenArr[i].serialize();
				}
			}
			
			output += "</box>";
			return output;
		}
		
		public function deserialize( str:String ) {
			var ptsArr:Array = str.split(",");
			var nameValueArr:Array;
			var partPath:String;
			var texturePath:String;
			for (var i:uint = 0; i <ptsArr.length; i++) {
				nameValueArr = ptsArr[i].split(":");
				if (nameValueArr[0].indexOf("Cube") >= 0) {
					var cubeVal:String = nameValueArr[0].substring(0, nameValueArr[0].indexOf("Cube") );
					_cube[ cubeVal ] = Number( nameValueArr[1] );
				}else if ( nameValueArr[0].indexOf("partPath") >= 0 ) {
					partPath = ptsArr[i].substring( ptsArr[i].indexOf(":") + 1);
				}else if ( nameValueArr[0].indexOf("texturePath") >= 0 ) {
					texturePath = ptsArr[i].substring( ptsArr[i].indexOf(":") + 1);
				}else {
					if (this[ nameValueArr[0] ] is Number) {
						this[ nameValueArr[0] ] = Number( nameValueArr[1] );
					}else {
						this[ nameValueArr[0] ] = nameValueArr[1];
						if(nameValueArr[0].indexOf("id") >= 0) {
							this.name = nameValueArr[1];
						}
					}
				}
			}
			
			if (partPath && texturePath) {
				trace("loading new Texture");
				loadObj( partPath, _partScale, null, texturePath);
			}else if (partPath) {
				loadObj( partPath, _partScale );
			}
		}
		
		private function onLoaderSuccess( e:Event ) {
			if (_part != null) {
				this.removeChild( _part );
			}
			_part = _partLoader.handle;
			_part.x = _cube.x;
			_part.y = _cube.y;
			_part.z = _part.z;
			
			_part.scale( _partScale );
			_part.useHandCursor = true;
			_part.addOnMouseDown( activatorRotator );
			_cube.removeOnMouseDown( activatorRotator );
			this.removeChild( _cube );
			
			_mode = MODE_MESH;
			meshAvailable = true;
		}
		
		override public function toString():String {
			return "BoxRotator {id:" + id + ",x:" + this.x + ", y:" + this.y + ", z:" + this.z + "}";
		}
		
		public function get cube():Cube {
			return _cube;
		}
		
		public function get part():Object3D {
			return _part;
		}
		
		public function set texturePath( path:String ) {
			_texturePath = path;
		}
		
		public function get maxHeight():Number {
			return _cube.height + _cube.y;
		}
		
		public function get maxWidth():Number {
			return _cube.width + _cube.x;
		}
		
		public function get maxDepth():Number {
			return _cube.depth + _cube.z;
		}
		
		public function get texturePath():String { return _texturePath; }
		
		public function get partPath():String { return _partPath; }
		
	}
	
}