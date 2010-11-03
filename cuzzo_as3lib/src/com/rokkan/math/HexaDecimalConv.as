package com.rokkan.math {
	
	/**
	* ...
	* @author Russell Savage
	*/
	public class HexaDecimalConv {
		
		public function HexaDecimalConv() {
			
		}
		
		public static function tohex(val){
			var i:int;
			var str="";
			for (var bit=0;bit<2;bit++)
			{
			 var j=int(val%16);
			 if (j==0) str=str+"0";
			 else if (j==1) str=str+"1";
			 else if (j==2) str=str+"2";
			 else if (j==3) str=str+"3";
			 else if (j==4) str=str+"4";
			 else if (j==5) str=str+"5";
			 else if (j==6) str=str+"6";
			 else if (j==7) str=str+"7";
			 else if (j==8) str=str+"8";
			 else if (j==9) str=str+"9";
			 else if (j==10) str=str+"A";
			 else if (j==11) str=str+"B";
			 else if (j==12) str=str+"C";
			 else if (j==13) str=str+"D";
			 else if (j==14) str=str+"E";
			 else if (j==15) str=str+"F";
			 val=int(val/16);
			 //trace(val);
			}
			var tmp=str;
			str="";
			for (i=7;i>=0;i--)
			{
			 str=str+tmp.slice(i,i+1);
			}

			return(str);
		}
		
	}
	
}