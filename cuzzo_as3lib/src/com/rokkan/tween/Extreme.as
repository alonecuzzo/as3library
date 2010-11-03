package com.rokkan.tween 
{
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class Extreme 
	{
		private static var _instance:Extreme;
		private static var _extremeEaseIn:Function;
		private static var _extremeEaseOut:Function;
		private static var _extremeEaseInOut:Function;
		
		public function Extreme() 
		{
			var easeArr:Array = [{Mx:0,Nx:36,Ny:-850,My:0,Px:131,Py:375},{Mx:167,Nx:148,Ny:-38,My:-475,Px:185,Py:13},{Mx:500,My:-500}];
			var zigoTween:ZigoTween = new ZigoTween( easeArr );
			_extremeEaseOut = zigoTween.ease;
			
			easeArr = [{Mx:0,Nx:524,Ny:-16,My:0,Px:-174,Py:-12},{Mx:350,Nx:252,Ny:-64,My:-28,Px:-102,Py:-408},{Mx:500,My:-500}];
			var zigoTween2:ZigoTween = new ZigoTween( easeArr );
			_extremeEaseIn = zigoTween2.ease;
			
			easeArr = [{Mx:0,Nx:285,Ny:-15,My:0,Px:-111,Py:-13},{Mx:174,Nx:85,Ny:-41,My:-28,Px:-18,Py:-167},{Mx:241,Nx:66,Ny:-407,My:-236,Px:4,Py:176},{Mx:311,Nx:43,Ny:-45,My:-467,Px:146,Py:12},{Mx:500,My:-500}];
			var zigoTween3:ZigoTween = new ZigoTween( easeArr );
			_extremeEaseInOut = zigoTween3.ease;
		}
		
		public static function get easeIn():Function {
			var inst:Extreme = getInstance();
			return _extremeEaseIn;
		}
		
		public static function get easeOut():Function {
			var inst:Extreme = getInstance();
			return _extremeEaseOut;
		}
		
		public static function get easeInOut():Function {
			var inst:Extreme = getInstance();
			return _extremeEaseInOut;
		}
		
		private static function getInstance():Extreme {
			if (_instance == null) {
				_instance = new Extreme();
			}
			return _instance;
       }
	}
	
}