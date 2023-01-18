import gugga.debug.MethodCallInfo;
import gugga.utils.ReflectUtil;

/** 
 * @author Todor Kolev
 */
class gugga.utils.Weaver 
{
	public static function weaveToAllMethods(aScopeObject:Object, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{
		var methodNames : Array = ReflectUtil.getMethodNames(aScopeObject);		
		weaveToMethods(aScopeObject, methodNames, aWeavedBeforeFunction, aWeavedAfterFunction);
	}

	public static function weaveToAllGetters(aScopeObject:Object, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{
		var methodNames : Array = ReflectUtil.getGetterNames(aScopeObject);
		weaveToMethods(aScopeObject, methodNames, aWeavedBeforeFunction, aWeavedAfterFunction);
	}

	public static function weaveToAllSetters(aScopeObject:Object, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{
		var methodNames : Array = ReflectUtil.getSetterNames(aScopeObject);
		weaveToMethods(aScopeObject, methodNames, aWeavedBeforeFunction, aWeavedAfterFunction);
	}

	public static function weaveToAllMethodsAndAccessors(aScopeObject:Object, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{
		var methodNames : Array = ReflectUtil.getMethodAndAccessorNames(aScopeObject);
		weaveToMethods(aScopeObject, methodNames, aWeavedBeforeFunction, aWeavedAfterFunction);
	}

	public static function weaveToAllAccessors(aScopeObject:Object, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{
		var methodNames : Array = ReflectUtil.getAccessorNames(aScopeObject);
		weaveToMethods(aScopeObject, methodNames, aWeavedBeforeFunction, aWeavedAfterFunction);
	}

	public static function weaveToMethods(aScopeObject:Object, aMethodNames:Array, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{	
		for (var key:String in aMethodNames)
		{
			weaveToMethod(aScopeObject, aMethodNames[key], aWeavedBeforeFunction, aWeavedAfterFunction);
		}
	}	

	public static function weaveToGettersFor(aScopeObject:Object, aVariableNames:Array, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{	
		for (var key:String in aVariableNames)
		{
			weaveToMethod(aScopeObject, "__get__" + aVariableNames[key], aWeavedBeforeFunction, aWeavedAfterFunction);
		}
	}	
	
	public static function weaveToSettersFor(aScopeObject:Object, aVariableNames:Array, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{	
		for (var key:String in aVariableNames)
		{
			weaveToMethod(aScopeObject, "__set__" + aVariableNames[key], aWeavedBeforeFunction, aWeavedAfterFunction);
		}
	}	
	
	public static function weaveToMethod(aScopeObject:Object, aMethodName:String, aWeavedBeforeFunction:Function, aWeavedAfterFunction:Function)
	{
		if(aMethodName == "onEnterFrame")
		{
			return;
		}
		
		var wrapperFunction : Function;
		wrapperFunction = function()
		{
			var WeavedBeforeFunction = arguments.callee.WeavedBeforeFunction;
			var WeavedAfterFunction = arguments.callee.WeavedAfterFunction;
			var ActualFunction = arguments.callee.ActualFunction;
			var ScopeObject = arguments.callee.ScopeObject;
			
			arguments.callee = ActualFunction;
			
			var methodCallInfo : MethodCallInfo = new MethodCallInfo(
				aScopeObject, aMethodName, arguments
			);
			
			WeavedBeforeFunction.apply(null, [methodCallInfo]);
			var result = ActualFunction.apply(ScopeObject, arguments);
			WeavedAfterFunction.apply(null, [methodCallInfo, result]);
			
			return result;
		};

		wrapperFunction.WeavedBeforeFunction = aWeavedBeforeFunction;
		wrapperFunction.WeavedAfterFunction = aWeavedAfterFunction;
		wrapperFunction.ActualFunction = aScopeObject[aMethodName];
		wrapperFunction.ScopeObject = aScopeObject;	
		
		aScopeObject[aMethodName] = wrapperFunction;
	}
}