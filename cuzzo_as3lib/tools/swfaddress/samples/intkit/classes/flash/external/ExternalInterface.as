import com.macromedia.javascript.JavaScriptProxy;

class flash.external.ExternalInterface {

	private static var scope:MovieClip = _level0.loader_mc ? _level0.loader_mc : _level0;
	private static var proxy:JavaScriptProxy = new JavaScriptProxy(_level0.lcId, scope);
	
    public static function get available():Boolean {
		return (_global.ASnative(302, 0) == undefined);
	}

    public static function call(methodName:String, parameter1:Object):Object {
        if (methodName.indexOf('function') == 0) {
            return available;
        } else {
    		proxy.call(methodName, parameter1);
    		return null;
        }
    }
    
    public static function addCallback(methodName:String, instance:Object, method:Function):Void {
		scope[methodName] = function(){
			method.apply(instance, arguments);
		}
	}

}