package com.rokkan.tween {
	
	/**
	* ZigoTween - An animation object that can be used to create custom tweens with TweenLite
	* 
	* for example:
	* var customAnimationArr:Array = [{Nx:250,Py:0,Ny:-250,Px:0,Mx:0,My:0},{Nx:250,Py:0,Ny:-250,Px:0,Mx:250,My:-250},{Mx:500,My:-500}];
	* var zigoTween:ZigoTween = new ZigoTween( customAnimationArr ));
	* TweenLite.to(mc,1,{ease:zigoTween.ease});
	* 
	* @author Russell Savage, based on Ladislav Zigo's LMC Tween Panel
	*/
	public class ZigoTween {
		
		private var _tweenArr:Array;
		private static const BASE_WIDTH:Number = 500;
		
		public function ZigoTween( tweenArr:Array ) {
			_tweenArr = tweenArr;
		}
		
		public function ease(t:Number,b:Number,c:Number,d:Number){
			var i,r;
			r = BASE_WIDTH * t/d;
			for(i = 0;r>_tweenArr[i+1].Mx;i++){
			}
			i = _tweenArr[i];
			if(i.Px != 0){
				r=(-i.Nx+Math.sqrt(i.Nx*i.Nx-4*i.Px*(i.Mx-r)))/(2*i.Px);
			}else{
				r=-(i.Mx-r)/i.Nx;
			}
			return b-c*((i.My+i.Ny*r+i.Py*r*r)/BASE_WIDTH);
		}
		
	}
	
}