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

/**
 * Watch works with DragableMovieClip to add the necessary watchs to the object needing to be dragged.  In this way,
 * we're able to leave the host object's onPress/onRelease code intact and drag the clip around.
 *
 * Another big thanks to Erik Westra (aka EECOLOR) for this code!!
 * @author Erik Westra 	eecolor@zonnet.nl
 */
class com.blitzagency.xray.Watch
{
	public static function createCallBack(obj:Object, prop_str:String, callBack:Function):Void
	{
		var old:Function = obj[prop_str];

		obj.watch(prop_str, _functionChanged, callBack);

		obj[prop_str] = undefined;
		if (old)
		{
			obj[prop_str] = old;
		}
	}

	public static function removeCallBack(obj:Object, prop_str:String, callBack:Function):Void
	{
		obj.unwatch(prop_str);

		var currentFunction:Function = obj[prop_str];
		var origFunction:Function;
		var currentCallBack:Function;
		var callBackFunctions_array:Array = new Array();

		while(true)
		{
			currentCallBack = currentFunction.callBack;
			if (typeof currentCallBack == "function")
			{
				origFunction = currentFunction.newVal;

				currentFunction.callBack = undefined;
				if (currentCallBack == callBack || callBack == undefined)
				{
					break;
				}

				callBackFunctions_array.push(currentCallBack);

				currentFunction = origFunction;
			} else
			{
				break;
			}
		};

		if (origFunction)
		{
			obj[prop_str] = origFunction;
		} else
		{
			delete obj[prop_str];
		}

		for (var i = 0; i < callBackFunctions_array.length; i++)
		{
			callBack = callBackFunctions_array[i];
			createCallBack(obj, prop_str, callBack);
		}
	}

	private static function _functionChanged(prop_str:String, oldVal:Function, newVal:Function, callBack:Function):Function
	{
		var returnFunction:Function = function():Void
		{
			var self:Function = arguments.callee;
			var newVal = self.newVal;
			var callBack = self.callBack;

			newVal.apply(this, arguments);
			callBack.apply(this, arguments);
		}
		returnFunction.newVal = newVal;
		returnFunction.callBack = callBack;

		return returnFunction;
	}
}