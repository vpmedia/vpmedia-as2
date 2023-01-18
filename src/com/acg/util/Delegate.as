
/**
* Delegate 확장버젼, 함수 argument를 전달할수 있습니다.
* @author	 홍준수 
**/

class com.acg.util.Delegate 
{
	
	/**
	* 델리게이트 확장 클래스
	* @param target 타겟 오브젝트
	* @param handler 핸들링 function
	*/

	public static function create(target:Object, handler:Function):Function 
	{
		var extraArgs:Array = arguments.slice(2);
		var delegate:Function = function() {
            var self:Function = arguments.callee;
			var fullArgs:Array = arguments.concat(self.extraArgs, [self]);
			return self.handler.apply(self.target, fullArgs);
		};
		delegate.extraArgs = extraArgs;
		delegate.handler = handler;
		delegate.target = target;
		return delegate;
	}
}
