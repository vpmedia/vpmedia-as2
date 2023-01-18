/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import mx.events.EventDispatcher;
/**
 * Singleton
 *
 * FunctionName attempts to return the name of the function being called and it's location/path in the host application.
 *
 * You can either create an instance pointer to FunctionName or access Xray's public static pointer - Xray.functionName
 *
 * @example <pre>
 //to create your own instance
 function foo()
 {
	import com.blitzagency.xray.Xray
 	import com.blitzagency.xray.FunctionName;
 	var functionName:FunctionName = FunctionName.getInstance();
 	var fn:String = functionName.traceFunction(this, arguments)
 	Xray.tt("what function was called?", fn);
 }

 // use Xray's instance
 function foo()
 {
	import com.blitzagency.xray.Xray
 	var fn:String = Xray.functionName.traceFunction(this, arguments)
 	Xray.tt("what function was called?", fn);
 }
 </pre>
 * @author John Grden :: John@blitzagency.com
 */
class com.blitzagency.xray.FunctionName
{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	/**
	 * @summary An event that is triggered when a function name is resolved.
	 *
	 * @return Object with one property: functionName:String
	 */
	[Event("onTraceFunction")]

	public static var _instance:FunctionName = null;

	public static function getInstance():FunctionName
	{
		if(FunctionName._instance == null)
		{
			FunctionName._instance = new FunctionName();
		}
		return FunctionName._instance;
	}

	private function FunctionName()
	{
		// initialize event dispatcher
		EventDispatcher.initialize(this);
	}

	public function traceFunction(ary:Array, obj:Object):String
	{
		_global.ASSetPropFlags(obj, null, 0, true);

		for(var items:String in obj)
		{
			//_global.tt("looping", items);
			if(typeof(obj[items]) == "function" && obj[items] == ary.callee)
			{
				// trace in the output and interface
				_global.tt("Function called :: " + items + "\ntarget :: " + obj + "\narguments", ary);

				// send dispatch
				this.dispatchEvent({type:"onTraceFunction", functionName:items});

				// send back reference
				return items;
			}
		}
		_global.ASSetPropFlags(obj, null, 1, true);
	}
}