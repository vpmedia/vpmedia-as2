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
import com.blitzagency.xray.Xray;
/**
 * Singleton
 *
 * XrayTrace is the main logger class for Xray (AdminTool).  You can send as many arguments as you like and all
 * objects will be recursed (if necessary) and traced not only in the interface, but in Flash's output panel if
 * you're debugging in the IDE.
 *
 * @example <pre>

 // to create your own instance
 import com.blitzagency.xray.XrayTrace;
 var xrayTrace:XrayTrace = XrayTrace.getInstance();
 xrayTrace.trace("what's my array?", myArray);

 // to use Xray's static property
 import com.blitzagency.xray.Xray;
 Xray.tt("what's my array?", myArray);
 </pre>

 * @author John Grden :: John@blitzagency.com
 */
class com.blitzagency.xray.XrayTrace
{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	/**
	 * @summary An event that is triggered when trace information is complete and sent back.
	 *
	 * @return Object with one property: sInfo
	 */
	[Event("onTrace")]
	/**
     * @summary sendSI is the interval id for sending data back to the interface
	 */
	private var sendSI:Number;
	/**
     * @summary array of broken up trace output to send back to the interface via localConnection
	 */
	private var sendAry:Array;
	/**
     * @summary when recursing objects, I indent the nested objects/properties.  This is the counter for each time
	 * an object is recursed
	 */
	private var iViewColCount:Number;
	/**
     * @summary recursion controller number to keep it from going into a 256 loops error
	 */
	private var _recursionCount:Number;
	/**
     * @summary the full output that is broken up and sent back to the interface
	 */
	private var _sViewInfo:String;
	/**
     * @summary clean formatted for Flash IDE/non HTML textboxes || this is actually not being used.
	 * currently, all output is passed back without formatting.  I'm keeping it here for future use incase
	 * there's a breakthrough with displaying large amounts of trace output.
	 */
	private var _sViewInfoClean:String;
	// @traceInfo:  running archive
	//public var _traceInfo:String;
	// @separator
	/**
     * @summary the separator to be used in the trace output.  Currently it's "::".  IE: (3486) my vars: john :: sally :: joe
	 */
	public var _separator:String;
	/**
     * @summary interval speed to send output back to localConnection
	 */
	public var _queInterval:Number;

	//=========================/[ GETTERS SETTERS ]\======================>
	public function get sViewInfo():String
	{
		return _sViewInfo;
	}

	public function set sViewInfo(newValue:String):Void
	{
		_sViewInfo = newValue;
	}

	public function get sViewInfoClean():String
	{
		return _sViewInfoClean;
	}

	public function set sViewInfoClean(newValue:String):Void
	{
		_sViewInfoClean = newValue;
	}

	// -------------------------------------------------------------------

	public function get queInterval():Number
	{
		return _queInterval;
	}

	public function set queInterval(newValue:Number):Void
	{
		_queInterval = newValue;
		clearInterval(this.sendSI);
		this.sendSI = setInterval(this, "sendData", newValue);
	}

	//---------------------------------------------------------------------
	public function get separator():String
	{
		return _separator;
	}

	public function set separator(newValue:String):Void
	{
		_separator = newValue;
	}

	//=========================\[ GETTERS SETTERS ]/======================>

	public static var _instance:XrayTrace = null;

	public static function getInstance():XrayTrace
	{
		if(XrayTrace._instance == null)
		{
			XrayTrace._instance = new XrayTrace();
		}
		return XrayTrace._instance;
	}


	private function XrayTrace()
	{
		// initialize event dispatcher
		EventDispatcher.initialize(this);

		separator = " :: ";

		_recursionCount = (.003);
	}

	/**
     * @summary sends the data chunks back to the interface by dispatching an event "onSendData".  LoggerConnection
	 * is the only listener right now.
	 *
	 * @return
	 */
	private function sendData()
	{
		var obj:Object = this.sendAry.shift();
		if(obj)
		{
			this.dispatchEvent({type:"onSendData", info:obj.sViewInfo, last:obj.bLast});
		}
	}
	/**
     * @summary examine actually does the recursion of objects and builds upon the string to be sent back
	 *
	 * @param obj:Object what to be recursed
	 *
	 * @return Boolean when completed, it returns true
	 */
	private function examine(obj:Object):Boolean
	{
		var vChr:String = "";
		var vChrClean:String = "";

		for(var x:Number=0;x<iViewColCount;x++)
		{
			vChr += "&nbsp;";
			vChrClean += " ";
		}

		//=========================/[  ]\======================>
		if(obj.__recursionCheck == null)
		{
			obj.prototype.getRecursionChecked = function(){};
			obj.prototype.setRecursionChecked = function(value){}

			obj.prototype.addProperty("__recursionCheck", obj.prototype.getRecursionChecked, obj.prototype.setRecursionChecked);

			obj.__recursionCheck = 0; // initially set to zero

			//====================================================>
			_global.ASSetPropFlags(obj,["__recursionCheck", "getRecursionChecked", "setRecursionChecked"],1,true);
			//====================================================>
		}

		if(Math.floor(obj.__recursionCheck) != Math.floor(_global.recursionControl))
		{
			obj.__recursionCheck = _global.recursionControl;
		}
		//=========================\[  ]/======================>

		for(var items:String in obj)
		{
			var bReturn:Boolean = false;

			sViewInfo += vChr + "<font size=\"12\" color=\"#0000FF\">" + items + "</font>" + " = " + obj[items] + "\n";
			sViewInfoClean += vChrClean + items + " = " + obj[items] + "\n";

			if(typeof obj[items] == "object")
			{
			//=========================/[  ]\======================>
				if(Math.floor(obj[items].__recursionCheck) != Math.floor(_global.recursionControl) || obj[items].__recursionCheck < _global.recursionControl+_recursionCount)
				{
					// increment by .1
					if(Math.floor(obj[items].__recursionCheck) == Math.floor(_global.recursionControl))
					{
						obj[items].__recursionCheck += (.001);
					}
					if(obj[items].__recursionCheck < _global.recursionControl+_recursionCount || obj[items].__recursionCheck == undefined)
					{
						//bReturn = parseObjTree(obj[items], items, sPath, recursiveSearch, showHidden, obj, parent);
						iViewColCount += 4;
						bReturn = examine(obj[items]);
						if(!bReturn) return true;
					}
				}
				//=========================\[  ]/======================>
			}
		}

		iViewColCount -= 4;
		sViewInfo += "\n";
		sViewInfoClean += "\n";
		return true;
	}
	/**
     * @summary loops the arguments sent in. If it finds an object, it sends it off to be examined. If not,
	 * it adds it to the string to be returned
	 *
	 * @param mulitple arguments can be passed
	 *
	 * @return String
	 */
	public function trace():String
	{
		sViewInfo = "";
		sViewInfoClean = "";

		for(var x:Number=0;x<arguments.length;x++)
		{
			// OBJECT EXAMINE
			if(typeof arguments[x] == "object")
			{
				sViewInfo += "\n";
				sViewInfoClean += "\n";

				// reset tab count
				iViewColCount = 2;

				// dispatch event
				dispatchEvent({type:"onStatus", code:"Trace.object"});

				_global.recursionControl += 1;
				examine(arguments[x]);
			}else
			{
				if(x > 0)
				{
					sViewInfo += arguments[x] + " :: ";
					sViewInfoClean += arguments[x] + " :: ";
				}
			}
		}

		if(sViewInfo.substring(sViewInfo.length-4,sViewInfo.length) == " :: ")
		{
			sViewInfo = sViewInfo.substring(0,sViewInfo.length-4);
		}

		if(sViewInfoClean.substring(sViewInfoClean.length-4,sViewInfoClean.length) == " :: ")
		{
			sViewInfoClean = sViewInfoClean.substring(0,sViewInfoClean.length-4);
		}

		//HTML version
		//var sInfo = "(" + getTimer() + ") " + "<font size=\"12\" color=\"#0000ff\">" + arguments[0] + "</font>" + ": \n" + sViewInfo + " \n";

		//plain text version
		var sInfo = "(" + getTimer() + ") " + arguments[0] + ": " + sViewInfoClean


		if(Xray.lc_info)
		{
			if(sInfo != undefined)
			{
				if(sInfo.length > 5000)
				{
					for(var x:Number=0;x<sInfo.length;x+=5000)
					{
						var toSend:String = sInfo.substring(x, x+5000);

						var bLast:Boolean = (x+5000) >= sInfo.length ? true : false;
						this.sendAry.push({sViewInfo: toSend, bLast:bLast});
					}
				}else
				{
					this.sendAry.push({sViewInfo: sInfo, bLast:true});
				}
			}
		}

		// output to the Flash IDE
		_global.trace("(" + getTimer() + ") " + arguments[0] + ": " + sViewInfoClean);

		// dispatch event
		dispatchEvent({type:"onTrace", sInfo:sInfo});

		if(Xray.lc_info && !this.queInterval && !_global.isLivePreview)
		{
			this.queInterval = 50; // the setter will kick off the interval call
			this.sendAry = new Array();
		}

		// return output
		return sInfo;
	}
}