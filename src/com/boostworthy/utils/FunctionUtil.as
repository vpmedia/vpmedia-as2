// =========================================================================================
// Class: FunctionUtil
// 
// Ryan Taylor
// September 7, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.utils.ArrayUtil;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.utils.FunctionUtil
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// This is a utility class, so the constructor isn't actually used.
	private function FunctionUtil()
	{
	}
	
	// =====================================================================================
	// FUNCTION FUNCTIONS
	// =====================================================================================
	
	// Delegate
	// 
	// In order to better understand what this method does, first study this example:
	// 
	// objXML.onLoad = FunctionUtil.Delegate(this, "OnFileLoad", new Array(arg1, arg2, arg3, etc));
	// 
	// When the 'onLoad' event occurs, the function 'this.OnFileLoad' will be called. It will recieve
	// the arguments from the 'onLoad' function as well as the arguments supplied in the array parameter.
	// If the 'onLoad' function had one parameter 'bIsLoaded' and you supply 'new Array(arg1, arg2)' to
	// the 'Delegate' function, this would be delt with as follows:
	// 
	// function OnFileLoad(bIsLoaded:Boolean, arg1:whatever, arg2:whatever):Void
	// 
	// If you don't have any additional arguments to pass along with the 'Delegate' function, simply
	// pass the scope and function string without an array.
	public static function Delegate(objScope:Object, strFunction:String, aArguments:Array):Function
	{
		// If no arguments array was passed, create a new, blank array in it's place.
		aArguments = (aArguments == undefined) ? new Array() : aArguments;
		
		// Create the buffer function.
		var fncBuffer:Function = function()
		{
			// Retrieve the buffered values.
			var fnc_objScope:Object    = arguments.callee.objScope;
			var fnc_strFunction:String = arguments.callee.strFunction;
			var fnc_aArguments:Array   = ArrayUtil.Merge(arguments, arguments.callee.aArguments);
			
			// Apply the scope and arguments to the target function.
			Function(fnc_objScope[fnc_strFunction]).apply(fnc_objScope, fnc_aArguments);
		};
		
		// Set the buffer values.
		fncBuffer.objScope    = objScope;
		fncBuffer.strFunction = strFunction;
		fncBuffer.aArguments  = aArguments;
		
		// Return the delegated function.
		return fncBuffer;
	}
}