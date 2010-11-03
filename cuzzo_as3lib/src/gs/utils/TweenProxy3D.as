/*
VERSION: 0.92
DATE: 1/31/2009
ACTIONSCRIPT VERSION: 3.0 (Requires Flash Player 10)
DESCRIPTION: 
	TweenProxy3D essentially "stands in" for a DisplayObject, so you set the various properties of 
	the TweenProxy3D and in turn, it handles setting the corresponding properties of the DisplayObject
	which it controls, adding three important capabilities:
	
		1) Dynamically define a custom registration point (actually a Object) around which all transformations (like rotation, 
		   scale, and skew) occur. It is compatible with 3D transformations, so your registration point can be offset on any 
		   axis including the z-axis.
		   
		2) Easily skew a DisplayObject using skewX, skewY, skewX2, or skewY2 properties. These are completely tweenable. 
		
		3) Avoids a bug in Flash that renders certain scale tweens incorrectly. To see the Flash bug, just set the z property
		   of a DisplayObject to any value, then tween scaleX to a negative value using any tweening engine (including the Adobe
		   Tween class). Once it goes below zero, the DisplayObject will keep flipping and often rotate in strange ways.
	
	The "registration" point is based on the DisplayObject's parent's coordinate space whereas the "localRegistration" corresponds 
	to the DisplayObject's inner coordinates, so it's very simple to define the registration point whichever way you prefer.
	
	Tween the skewX and/or skewY for normal skews (which visually adjust scale to compensate), or skewX2 and/or skewY2 in order to 
	skew without visually adjusting scale. Either way, the actual scaleX/scaleY/scaleZ values are not altered as far as the proxy 
	is concerned.
	
	Once you create a TweenProxy3D, it is best to always control your DisplayObject's properties through the 
	TweenProxy3D so that the values don't become out of sync. You can set ANY DisplayObject property through the TweenProxy3D, 
	and you can call DisplayObject methods as well. If you directly change the properties of the target (without going through the proxy), 
	you'll need to call the	calibrate() method on the proxy. It's usually best to create only ONE proxy for each target, but if 
	you create more than one, they will communicate with each other to keep the transformations and registration position in sync
	(unless you set ignoreSiblingUpdates to true).
	
	For example:
	
		var myProxy:TweenProxy3D = TweenProxy3D.create(mySprite);
		myProxy.registration = new Object(100, 100, 100); //sets a custom registration point at x:100, y:100, and z:100
		myProxy.rotationY = 30; //sets mySprite.rotationY to 30, rotating around the custom registration point
		myProxy.skewX = 45; 
		TweenLite.to(myProxy, 3, {rotationX:50}); //tweens the rotationX around the custom registration point.
	
	
PROPERTIES ADDED WITH TweenProxy3D:
	- scale : Number (sets scaleX, scaleY, and scaleZ with a single call)
	- skewX : Number (visually adjusts scale to compensate)
	- skewY : Number (visually adjusts scale to compensate)
	- skewX2 : Number (does NOT visually adjust scale to compensate)
	- skewY2 : Number (does NOT visually adjust scale to compensate)
	- registration : Object
	- registrationX : Number
	- registrationY : Number
	- registrationZ : Number
	- localRegistration : Object
	- localRegistrationX : Number
	- localRegistrationY : Number
	- localRegistrationZ : Number
	- skewXRadians : Number
	- skewYRadians : Number
	- skewX2Radians : Number
	- skewY2Radians : Number
	- ignoreSiblingUpdates : Boolean  (normally TweenProxy3D updates all proxies of the same object as the registation point moves so that it appears "pinned" to the object itself. However, if you want to avoid this behavior, set ignoreSiblingUpdates to true so that the registration point will NOT be affected by sibling updates, thus "pinning" the registration point wherever it is in the parent's coordinate space.)
	
EXAMPLE:

	To set a custom registration piont of x:100, y:100, z:100, and tween the skew of a MovieClip named "my_mc" 30 degrees 
	on the x-axis and scale to half-size over the course of 3 seconds using an Elastic ease, do:
	
	import gs.*;
	import gs.utils.*;
	import gs.easing.*;
	import flash.geom.*;
	
	var myProxy:TweenProxy3D = TweenProxy3D.create(my_mc);
	myProxy.registration = new Object(100, 100, 100);
	TweenLite.to(myProxy, 3, {skewX:30, scale:0.5, ease:Elastic.easeOut});

AUTHOR: Jack Doyle, jack@greensock.com
Copyright 2009, GreenSock. All rights reserved. This work is subject to the terms in http://www.greensock.com/terms_of_use.html or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
*/

package gs.utils 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.*;	

	dynamic public class TweenProxy3D extends Proxy {
		public static const VERSION:Number = 0.92;
		private static const _DEG2RAD:Number = Math.PI / 180; //precompute for speed
		private static const _RAD2DEG:Number = 180 / Math.PI; //precompute for speed
		private static var _dict:Dictionary = new Dictionary(false);
		private static var _addedProps:String = " tint tintPercent scale skewX skewY skewX2 skewY2 target registration registrationX registrationY localRegistration localRegistrationX localRegistrationY "; //used in hasProperty
		private var _target:Object;
		private var _root:DisplayObject;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _scaleZ:Number;
		private var _rotationX:Number;
		private var _rotationY:Number;
		private var _rotationZ:Number;
		private var _skewX:Number; //in radians!
		private var _skewY:Number; //in radians!
		private var _skewX2Mode:Boolean;
		private var _skewY2Mode:Boolean;
		private var _proxies:Array; //populated with all TweenProxy3D instances with the same _target (basically a faster way to access _dict[_target])
		private var _localRegistration:Object; //according to the local coordinates of _target (not _target.parent)
		private var _registration:Object; //according to _target.parent coordinates
		private var _regAt0:Boolean; //If the localRegistration point is at 0, 0, this is true. We just use it to speed up processing in getters/setters.
		
		public var ignoreSiblingUpdates:Boolean = false;
		
		private var v3d:Class;
		
		public function TweenProxy3D($target:Object, $ignoreSiblingUpdates:Boolean=false) {
			_target = $target;
			if (v3d == null)
			{
				v3d = getDefinitionByName("flash.geom.Vector3D") as Class;
			}
			if (_dict[_target] == undefined) {
				_dict[_target] = [];
			}
			if (_target.root != null) {
				_root = _target.root;
			} else {
				_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
			_proxies = _dict[_target];
			_proxies[_proxies.length] = this;
			_localRegistration = new Object();
			_registration = new Object();
			if (_target.transform.matrix3D == null) {
				_target.z = 0;
			}
			this.ignoreSiblingUpdates = $ignoreSiblingUpdates;
			calibrateRegistration();
			calibrate();
		}
		
		public static function create($target:DisplayObject, $allowRecycle:Boolean=true):TweenProxy3D {
			if (_dict[$target] != null && $allowRecycle) {
				return _dict[$target][0];
			} else {
				return new TweenProxy3D($target);
			}
		}
		
		protected function onAddedToStage($e:Event):void {
			_root = _target.root;
			_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function calibrate():void {
			_rotationX = _target.rotationX;
			_rotationY = _target.rotationY;
			_rotationZ = _target.rotationZ;
			_target.rotationX = _rotationX; //just forces the skew to be zero.
			_skewX = _skewY = 0;
			_scaleX = _target.scaleX;
			_scaleY = _target.scaleY;
			_scaleZ = _target.scaleZ;
		}
		
		public function get target():DisplayObject {
			return _target as DisplayObject;
		}
		
		public function destroy():void {
			var a:Array = _dict[_target], i:int;
			for (i = a.length - 1; i > -1; i--) {
				if (a[i] == this) {
					a.splice(i, 1);
				}
			}
			if (a.length == 0) {
				delete _dict[_target];
			}
			_target = null;
			_localRegistration = null;
			_registration = null;
			_proxies = null;
		}
		
		
//---- PROXY FUNCTIONS ------------------------------------------------------------------------------------------
				
		flash_proxy override function callProperty($name:*, ...$args:Array):* {
			return _target[$name].apply(null, $args);
		}
		
		flash_proxy override function getProperty($prop:*):* {
			return _target[$prop];
		}
		
		flash_proxy override function setProperty($prop:*, $value:*):void {
			_target[$prop] = $value;
		}
		
		flash_proxy override function hasProperty($name:*):Boolean {
			if (_target.hasOwnProperty($name)) {
				return true;
			} else if (_addedProps.indexOf(" " + $name + " ") != -1) {
				return true;
			} else {
				return false;
			}
		}

//---- GENERAL REGISTRATION -----------------------------------------------------------------------
		
		public function moveRegX($n:Number):void {
			_registration.x += $n;
		}
		
		public function moveRegY($n:Number):void {
			_registration.y += $n;
		}
		
		public function moveRegZ($n:Number):void {
			_registration.z += $n;
		}
		
		private function reposition():void {
			if (_root != null) {
				var v:Object = _target.transform.getRelativeObject(_root).deltaTransformVector(_localRegistration);
				_target.x = _registration.x - v.x;
				_target.y = _registration.y - v.y;
				_target.z = _registration.z - v.z;
			}
		}
		
		private function updateSiblingProxies():void {
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] != this) {
					_proxies[i].onSiblingUpdate(_scaleX, _scaleY, _scaleZ, _rotationX, _rotationY, _rotationZ, _skewX, _skewY);
				}
			}
		}
		
		private function calibrateLocal():void {
			if (_target.parent != null) {
				var m:Object = _target.transform.getRelativeObject(_target.parent);
				m.invert();
				var v:Object = m.deltaTransformVector(new v3d(_registration.x - _target.x, _registration.y - _target.y, _registration.z - _target.z));
				_localRegistration.x = v.x;
				_localRegistration.y = v.y;
				_localRegistration.z = v.z;
				_regAt0 = (_localRegistration.x == 0 && _localRegistration.y == 0 && _localRegistration.z == 0);
			}
		}
		
		private function calibrateRegistration():void {
			if (_root != null) {
				var v:Object = _target.transform.getRelativeObject(_root).deltaTransformVector(_localRegistration);
				_registration.x = _target.x + v.x;
				_registration.y = _target.y + v.y;
				_registration.z = _target.z + v.z;
			}
		}
		
		public function onSiblingUpdate($scaleX:Number, $scaleY:Number, $scaleZ:Number, $rotationX:Number, $rotationY:Number, $rotationZ:Number, $skewX:Number, $skewY:Number):void {
			_scaleX = $scaleX;
			_scaleY = $scaleY;
			_scaleZ = $scaleZ;
			_rotationX = $rotationX;
			_rotationY = $rotationY;
			_rotationZ = $rotationZ;
			_skewX = $skewX;
			_skewY = $skewY;
			if (this.ignoreSiblingUpdates) {
				calibrateLocal();
			} else {
				calibrateRegistration();
			}
		}
		
		
//---- LOCAL REGISTRATION ---------------------------------------------------------------------------
		
		public function get localRegistration():Object {
			return _localRegistration;
		}
		public function set localRegistration($v:Object):void {
			_localRegistration = $v;
			calibrateRegistration();
		}
		
		public function get localRegistrationX():Number {
			return _localRegistration.x;
		}
		public function set localRegistrationX($n:Number):void {
			_localRegistration.x = $n;
			calibrateRegistration();
		}
		
		public function get localRegistrationY():Number {
			return _localRegistration.y;
		}
		public function set localRegistrationY($n:Number):void {
			_localRegistration.y = $n;
			calibrateRegistration();
		}
		
		public function get localRegistrationZ():Number {
			return _localRegistration.z;
		}
		public function set localRegistrationZ($n:Number):void {
			_localRegistration.z = $n;
			calibrateRegistration();
		}
		
//---- REGISTRATION (OUTER) ----------------------------------------------------------------------
		
		public function get registration():Object {
			return _registration;
		}
		public function set registration($v:Object):void {
			_registration = $v;
			calibrateLocal();
		}
		
		public function get registrationX():Number {
			return _registration.x;
		}
		public function set registrationX($n:Number):void {
			_registration.x = $n;
			calibrateLocal();
		}
		
		public function get registrationY():Number {
			return _registration.y;
		}
		public function set registrationY($n:Number):void {
			_registration.y = $n;
			calibrateLocal();
		}
		
		public function get registrationZ():Number {
			return _registration.z;
		}
		public function set registrationZ($n:Number):void {
			_registration.z = $n;
			calibrateLocal();
		}
		
		
//---- X/Y MOVEMENT ---------------------------------------------------------------------------------
		
		public function get x():Number {
			return _registration.x;
		}
		public function set x($n:Number):void {
			var tx:Number = ($n - _registration.x);
			_target.x += tx;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegX(tx);
				}
			}
		}
		
		public function get y():Number {
			return _registration.y;
		}
		public function set y($n:Number):void {
			var ty:Number = ($n - _registration.y);
			_target.y += ty;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegY(ty);
				}
			}
		}
		
		public function get z():Number {
			return _registration.z;
		}
		public function set z($n:Number):void {
			var tz:Number = ($n - _registration.z);
			_target.z += tz;
			for (var i:int = _proxies.length - 1; i > -1; i--) {
				if (_proxies[i] == this || !_proxies[i].ignoreSiblingUpdates) {
					_proxies[i].moveRegZ(tz);
				}
			}
		}
		
	
//---- ROTATION ----------------------------------------------------------------------------
		
		public function get rotationX():Number {
			return _rotationX;
		}
		public function set rotationX($n:Number):void {
			_rotationX = $n;
			if (_skewX != 0 || _skewY != 0) {				
				updateWithSkew();
			} else {
				_target.rotationX = $n;
				if (!_regAt0) {
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get rotationY():Number {
			return _rotationY;
		}
		public function set rotationY($n:Number):void {
			_rotationY = $n;
			if (_skewX != 0 || _skewY != 0) {
				updateWithSkew();
			} else {
				_target.rotationY = $n;
				if (!_regAt0) {
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get rotationZ():Number {
			return _rotationZ;
		}
		public function set rotationZ($n:Number):void {
			_rotationZ = $n;
			if (_skewX != 0 || _skewY != 0) {
				updateWithSkew();
			} else {
				_target.rotationZ = $n;
				if (!_regAt0) {
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get rotation():Number {
			return _rotationZ;
		}
		public function set rotation($n:Number):void {
			this.rotationZ = $n;
		}
		
		
//---- SKEW -------------------------------------------------------------------------------
		
		private function updateWithSkew():void {
			var sm:Object, v:Object;
			var m:Object = new Object();
			
			var sx:Number = _scaleX, sy:Number = _scaleY, rz:Number = _rotationZ * _DEG2RAD;
			if (_scaleX < 0) { //get around a bug in Flash which causes negative scaleX values to report as negative scaleY with 180 degrees added to the rotation!
				sx = -sx;
				m.appendRotation(180, v3d.Z_AXIS);
				sy = -sy;
			}
			
			if (sx != 1 || sy != 1 || _scaleZ != 1) {
				m.appendScale(sx, sy, _scaleZ);
			}
			if (_skewX != 0) {
				sm = new Object();
				v = sm.rawData;
				if (_skewX2Mode) {
					v[4] = Math.tan(-_skewX + rz);
				} else {
					v[4] = -Math.sin(_skewX + rz);
					v[5] = Math.cos(_skewX + rz);
				}
				sm.rawData = v;
				m.prepend(sm);
			}
			if (_skewY != 0) {
				sm = new Object();
				v = sm.rawData;
				if (_skewY2Mode) {
					v[1] = Math.tan(_skewY + rz);
				} else {
					v[0] = Math.cos(_skewY + rz);
					v[1] = Math.sin(_skewY + rz);
				}
				sm.rawData = v;
				m.prepend(sm);
			}
			if (_rotationX != 0) {
				m.appendRotation(_rotationX, v3d.X_AXIS);
			}
			if (_rotationY != 0) {
				m.appendRotation(_rotationY, v3d.Y_AXIS);
			}
			if (_rotationZ != 0) {
				m.appendRotation(_rotationZ, v3d.Z_AXIS);
			}
			_target.transform.matrix3D = m;
			reposition();
			
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
		public function get skewX():Number {
			return _skewX * _RAD2DEG;
		}
		public function set skewX($n:Number):void {
			_skewX2Mode = false;
			_skewX = $n * _DEG2RAD;
			updateWithSkew();
		}
		public function get skewY():Number {
			return _skewY * _RAD2DEG;
		}
		public function set skewY($n:Number):void {
			_skewY2Mode = false;
			_skewY = $n * _DEG2RAD;
			updateWithSkew();
		}
		
		
//---- SKEW2 ----------------------------------------------------------------------------------
		
		public function get skewX2():Number {
			return _skewX * _RAD2DEG;
		}
		public function set skewX2($n:Number):void {
			_skewX2Mode = true;
			_skewX = $n * _DEG2RAD;
			updateWithSkew();
		}
		public function get skewY2():Number {
			return _skewY * _RAD2DEG;
		}
		public function set skewY2($n:Number):void {
			_skewY2Mode = true;
			_skewY = $n * _DEG2RAD;
			updateWithSkew();
		}
		
		
//---- SCALE --------------------------------------------------------------------------------------
		
		public function get scaleX():Number {
			return _scaleX;
		}
		public function set scaleX($n:Number):void {
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleX < 0) {
				_scaleX = $n;
				updateWithSkew();
			} else {
				_scaleX = _target.scaleX = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get scaleY():Number {
			return _scaleY;
		}
		public function set scaleY($n:Number):void {
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleY < 0) {
				_scaleY = $n;
				updateWithSkew();
			} else {
				_scaleY = _target.scaleY = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get scaleZ():Number {
			return _scaleZ;
		}
		public function set scaleZ($n:Number):void {
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleZ < 0) {
				_scaleZ = $n;
				updateWithSkew();
			} else {
				_scaleZ = _target.scaleZ = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
		
		public function get scale():Number {
			return (_scaleX + _scaleY + _scaleZ) / 3;
		}
		public function set scale($n:Number):void {
			if (_skewX != 0 || _skewY != 0 || $n < 0 || _scaleX < 0 || _scaleY < 0 || _scaleZ < 0) {
				_scaleX = _scaleY = _scaleZ = $n;
				updateWithSkew();
			} else {
				_scaleX = _scaleY = _scaleZ = _target.scaleX = _target.scaleY = _target.scaleZ = $n;
				if (!_regAt0) { 
					reposition();
				}
				if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
					updateSiblingProxies();
				}
			}
		}
	
				
//---- OTHER PROPERTIES ---------------------------------------------------------------------------------
	
		public function get alpha():Number {
			return _target.alpha;
		}
		public function set alpha($n:Number):void {
			_target.alpha = $n;
		}
		public function get width():Number {
			return _target.width;
		}
		public function set width($n:Number):void {
			_target.width = $n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		public function get height():Number {
			return _target.height;
		}
		public function set height($n:Number):void {
			_target.height = $n;
			if (!_regAt0) { 
				reposition();
			}
			if (_proxies.length > 1) { //if there are other proxies controlling the same _target, make sure their _registration variable is updated
				updateSiblingProxies();
			}
		}
		
	}
}