/* START GLOBAL DEFINITIONS*/
// this file is for backbard compatibility, not used anymore, see prototypes.as
var mp = MovieClip.prototype;
/**
 * <p>Description: add properties</p>
 *
 * @author András Csizmadia
 * @version 1.0
 */
mp.addProperty ("_r", function ()
{
	return Math.round (this._r);
}, function (value)
{
	this._r = Math.round (value);
});
//
mp.addProperty ("_left", function ()
{
	return this.getBounds (this._parent).xmin;
}, function (x)
{
	this._x = x - this.getBounds ().xmin;
});
mp.addProperty ("_right", function ()
{
	return this.getBounds (this._parent).xmax;
}, function (x)
{
	this._x = x - this.getBounds ().xmax;
});
mp.addProperty ("_top", function ()
{
	return this.getBounds (this._parent).ymin;
}, function (y)
{
	this._y = y - this.getBounds ().ymin;
});
mp.addProperty ("_bottom", function ()
{
	return this.getBounds (this._parent).ymax;
}, function (y)
{
	this._y = y - this.getBounds ().ymax;
});
mp.addProperty ("_xcenter", function ()
{
	var b = this.getBounds (this._parent);
	return (b.xmax + b.xmin) / 2;
}, function (x)
{
	var b = this.getBounds (this);
	this._x = x - (b.xmax + b.xmin) / 2;
});
mp.addProperty ("_ycenter", function ()
{
	var b = this.getBounds (this._parent);
	return (b.ymax + b.ymin) / 2;
}, function (y)
{
	var b = this.getBounds (this);
	this._y = y - (b.ymax + b.ymin) / 2;
});
//
mp.addProperty ('_path', function ()
{
	if (this._path == undefined)
	{
		var a = this._url.split ('/');
		a.pop ();
		this._path = a.join ('/') + '/';
	}
	return this._path;
}, null);
/**
 * <p>Description: Trace Object</p>
 *
 * @author András Csizmadia
 * @version 2.0
 */
mp.traceObj = function (debugObject:Object, message:String)
{
	var msg:String = "";
	msg += "[" + displayCurrentTime () + "][" + message + "]";
	if (!debugObject)
	{
		//debugObject = null;
	}
	if (!message)
	{
		var message = "";
	}
	if (typeof (debugObject) == "object")
	{
		for (var prop in debugObject)
		{
			if (typeof (debugObject[prop]) == "object")
			{
				traceObj (debugObject[prop], prop);
			}
			else
			{
				msg += "\n" + prop + "=" + "" + debugObject[prop];
			}
		}
	}
	else if (debugObject)
	{
		msg += "[" + displayCurrentTime () + "]" + debugObject;
	}
	return msg;
};
/**
 * <p>Description: Object Length,Reverse</p>
 *
 * @author András Csizmadia
 * @version 1.0
 */
mp.getObjLength = function (__obj:Object)
{
	var __counter:Number = 0;
	for (var i in __obj)
	{
		//trace(i+" : "+__obj[i]);
		__counter++;
	}
	return __counter;
};
/**
 * <p>Description: Reverse Object</p>
 *
 * @author Loop
 * @version 1.0
 */
mp.reverseObject = function (o:Object):Object 
{
	var a:Array = new Array ();
	var s:Object = new Object ();
	var p:Object = new Object ();
	var r:Object = new Object ();
	for (var n in o)
	{
		a.push (n);
	}
	a.reverse ();
	var i:Number = a.length;
	while (i--)
	{
		p = a[i];
		s = o[p];
		r[p] = s;
	}
	delete o;
	return r;
};
/**
 * <p>Description: Create digit</p>
 *
 * @author András Csizmadia
 * @version 2.0
 */
mp.createDigit = function (digitNumber:Number, digitLength:Number)
{
	var digitResult:String;
	var digitSourceLength:Number = String (digitNumber).length;
	var length:Number = digitLength - digitSourceLength;
	var digitString:String = "";
	for (var i = 0; i < length; i++)
	{
		digitString += "0";
	}
	if (digitSourceLength < digitLength)
	{
		digitResult = digitString + digitNumber;
	}
	else
	{
		digitResult = String (digitNumber);
	}
	return (digitResult);
};
/**
 * <p>Description: Make a Long String to Short String + ...</p>
 *
 * @author András Csizmadia
 * @version 1.0
 */
mp.trimStr = function (stringSource:String, stringLength:Number)
{
	// trim long name
	var stringResult:String;
	if (stringSource.length > stringLength)
	{
		stringResult = stringSource.substring (0, stringLength) + "...";
	}
	else
	{
		stringResult = stringSource;
	}
	return stringResult;
};
/**
 * <p>Description: Convert seconds to time</p>
 *
 * @author Loop
 * @version 1.0
 */
// moved to com.vpmedia.CTime
mp.displayTime = function (ct, isShort)
{
	if (!ct)
	{
		ct = new Date ().getTime ();
	}
	if (isShort == undefined)
	{
		isShort = true;
	}
	var hours = Math.floor (ct / 3600);
	var minutes = Math.floor (ct / 60) - (60 * hours);
	var seconds = Math.floor (ct - (60 * minutes) - (3600 * hours));
	minutes < 10 ? minutes = "0" + minutes : "";
	seconds < 10 ? seconds = "0" + seconds : "";
	hours < 10 ? hours = "0" + hours : "";
	if (isShort)
	{
		return minutes + ":" + seconds;
	}
	else
	{
		return hours + ":" + minutes + ":" + seconds;
	}
};
mp.displayCurrentTime = function ()
{
	//com.webcam.Utils.dumpObject (null, "displayCurrentTime");
	var cDate:Date = new Date ();
	var cHour:Number = cDate.getHours ();
	var cMin:Number = cDate.getMinutes ();
	var cSec:Number = cDate.getSeconds ();
	var ct = (cHour * 3600) + cSec + (cMin * 60);
	//
	var hours = Math.floor (ct / 3600);
	var minutes = Math.floor (ct / 60) - (60 * hours);
	var seconds = Math.floor (ct - (60 * minutes) - (3600 * hours));
	//
	minutes < 10 ? minutes = "0" + minutes : "";
	seconds < 10 ? seconds = "0" + seconds : "";
	hours < 10 ? hours = "0" + hours : "";
	//
	return hours + ":" + minutes + ":" + seconds;
};
/**
 * <p>Description: Draw rectangle</p>
 *
 * @author Loop
 * @version 1.0
 */
// moved to com.vpmedia.UserInterface
mp.drawRect = function (x, y, w, h, cornerRadius)
{
	if (arguments.length < 4)
	{
		return;
	}
	// if the user has defined cornerRadius our task is a bit more complex. :)     
	if (cornerRadius > 0)
	{
		// init vars
		var theta, angle, cx, cy, px, py;
		// make sure that w + h are larger than 2*cornerRadius
		if (cornerRadius > Math.min (w, h) / 2)
		{
			cornerRadius = Math.min (w, h) / 2;
		}
		// theta = 45 degrees in radians     
		theta = Math.PI / 4;
		// draw top line
		this.moveTo (x + cornerRadius, y);
		this.lineTo (x + w - cornerRadius, y);
		//angle is currently 90 degrees
		angle = -Math.PI / 2;
		// draw tr corner in two parts
		cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		angle += theta;
		cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		// draw right line
		this.lineTo (x + w, y + h - cornerRadius);
		// draw br corner
		angle += theta;
		cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		angle += theta;
		cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		// draw bottom line
		this.lineTo (x + cornerRadius, y + h);
		// draw bl corner
		angle += theta;
		cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		angle += theta;
		cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		// draw left line
		this.lineTo (x, y + cornerRadius);
		// draw tl corner
		angle += theta;
		cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
		angle += theta;
		cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
		px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
		py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
		this.curveTo (cx, cy, px, py);
	}
	else
	{
		// cornerRadius was not defined or = 0. This makes it easy.
		this.moveTo (x, y);
		this.lineTo (x + w, y);
		this.lineTo (x + w, y + h);
		this.lineTo (x, y + h);
		this.lineTo (x, y);
	}
};
/**
 * <p>Description: Tooltip</p>
 *
 * @author Loop
 * @version 1.0
 */
mp.setTooltip = function (theText, timer, text_color, bg_color, border_color, __alpha, __textformat)
{
	if (timer == undefined)
	{
		timer = 500;
	}
	var addMsg = function (theMsg, col, bg_color, border_color, level, __alpha, __textformat)
	{
		var x = _root._xmouse;
		var y = _root._ymouse;
		if (!textformat)
		{
			var f = new TextFormat ();
			f.font = "Arial";
			f.size = 11;
			f.color = col != undefined ? col : 0x000000;
		}
		else
		{
			var f = __textformat;
		}
		_level0.createEmptyMovieClip ("tooltip", 123455);
		_level0.tooltip.removeTextField ("tooltipText");
		_level0.tooltip.createTextField ("tooltipText", 123456, x, y, 150, 20);
		with (_level0.tooltip.tooltipText)
		{
			setNewTextFormat (f);
			text = theMsg;
			selectable = false;
			autoSize = true;
			background = true;
			border = true;
			//embedFonts = true;
			borderColor = border_color != undefined ? border_color : 0x000000;
			backgroundColor = bg_color != undefined ? bg_color : 0xFFFFEE;
			_y -= _height;
			if (_x + _width > Stage.width)
			{
				_x = Stage.width - _width - 5;
			}
		}
		//trace(__alpha);
		//tooltip._alpha = __alpha;
		clearInterval (level.q_t);
	};
	this.q_t = setInterval (addMsg, timer, theText, text_color, bg_color, border_color, this, __alpha, __textformat);
};
mp.unsetTooltip = function ()
{
	_level0.tooltip.tooltipText.removeTextField ();
	clearInterval (this.q_t);
};
/**
 * <p>Description: MC helper</p>
 *
 * @author Loop
 * @version 1.0
 */
mp.hide = function ()
{
	this._visible = false;
};
mp.show = function ()
{
	this._visible = true;
};
/**
 * <p>Description: playBack</p>
 *
 * @author Loop
 * @version 1.0
 */
mp.MovieClip.prototype.playBack = function ()
{
	this.gotoAndStop (this._totalframes);
	this.onEnterFrame = function ()
	{
		this.gotoAndStop (this._currentframe - 1);
		if (this._currentframe == 1)
		{
			delete this.onEnterFrame;
		}
	};
};
mp.centerPopup = function (theUrl, title, w, h, features)
{
	trace ("@deprecated, see com.vpmedia.JavaScript");
};
mp.createFakeButton = function (__instance:MovieClip, __useCursor:Boolean):MovieClip 
{
	if (!__useCursor)
	{
		var __useCursor = true;
	}
	var bounds_obj:Object = __instance.getBounds (__instance);
	bounds_obj.w = bounds_obj.xMax - bounds_obj.xMin;
	bounds_obj.h = bounds_obj.yMax - bounds_obj.yMin;
	__instance.createEmptyMovieClip ("fake_btn_mc", 1);
	__instance.square_mc._x = bounds_obj.xMin;
	__instance.square_mc._y = bounds_obj.yMin;
	__instance.square_mc.beginFill (0xFF33FF);
	__instance.square_mc.moveTo (0, 0);
	__instance.square_mc.lineTo (bounds_obj.w, 0);
	__instance.square_mc.lineTo (bounds_obj.w, bounds_obj.h);
	__instance.square_mc.lineTo (0, bounds_obj.h);
	__instance.square_mc.lineTo (0, 0);
	__instance.square_mc.endFill ();
	__instance.square_mc._alpha = 0;
	__instance.square_mc.onRelease = function ()
	{
	};
	__instance.square_mc.useHandCursor = __useCursor;
	return __instance;
};
/**
 * <p>Description: Date Validation with Leap-Year feature</p>
 *
 * @author András Csizmadia
 * @comatible AS2.0 - Flash Player 6-7
 * @source Ported from JavaScript
 * @version 1.0
 * @method calcLeapYear
 * @usage calcLeapYear (yearToDisplay, monthToDisplay, dayToDisplay, hourToDisplay, minToDisplay);
 */
// private method
Data.prototype.calcLeapYear = function (yearToDisplay, monthToDisplay, dayToDisplay, hourToDisplay, minToDisplay)
{
	var daysInMonth:Array = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	var oD = new Date (yearToDisplay, monthToDisplay - 1, 1);
	//DD replaced line to fix date bug when current day is 31st, so we flip to 1st day of the month
	daysInMonth[1] = (((oD.getFullYear () % 100 != 0) && (oD.getFullYear () % 4 == 0)) || (oD.getFullYear () % 400 == 0)) ? 29 : 28;
	// debug
	trace (oD.getFullYear () + " februar has " + daysInMonth[1] + " days.");
	// return days in month Array
	return daysInMonth;
};
/**
 * <p>Description: E-Mail Address Checker</p>
 *
 * @author Loop
 * @version 1.0
 */
String.prototype.isEmail = function ()
{
	var ref = arguments.callee;
	if (this.indexOf ("@") == -1)
	{
		return false;
	}
	if (!isNaN (this.charAt (0)))
	{
		return false;
	}
	var email, user, domain, user_dots, domain_dots;
	if ((email = this.split ("@")).length == 2)
	{
		if ((domain = email[1]).split (".").pop ().length > 3)
		{
			return false;
		}
		// update 27 Mar 2003                                                                                 
		// David Pérez Ortuńo (david@ideas-shop.com)	    
		if (domain.split (".").length < 2)
		{
			return false;
		}
		// end update                                                                                
		if ((user = email[0]).indexOf (".") && domain.indexOf ("."))
		{
			if (domain.lastIndexOf (".") > domain.length - 3)
			{
				return false;
			}
			for (var c, t, i = (user_dots = user.split (".")).length; i--; )
			{
				c = user_dots[i];
				t = !ref.$_text.call (c, "-", ".", "_");
				if (t || !isNaN (c))
				{
					return false;
				}
			}
			for (var c, t, i = (domain_dots = domain.split (".")).length; i--; )
			{
				c = domain_dots[i];
				t = !ref.$_text.call (c, "-", ".");
				if (t || !isNaN (c))
				{
					return false;
				}
			}
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
	return true;
};
String.prototype.isEmail.$_punctuation = function ()
{
	if (this == "")
	{
		return false;
	}
	for (var i = arguments.length; i--; )
	{
		if (this.indexOf (arguments[i]) == 0)
		{
			return false;
		}
		if (this.indexOf (arguments[i]) == this.length - 1)
		{
			return false;
		}
	}
	return true;
};
String.prototype.isEmail.$_text = function ()
{
	var ref = arguments.caller;
	if (!ref.$_punctuation.apply (this, arguments))
	{
		return false;
	}
	var others = arguments;
	var checkOthers = function (str)
	{
		for (var i = others.length; i--; )
		{
			if (str == others[i])
			{
				return true;
			}
		}
		return false;
	};
	for (var c, alpha, num, i = this.length; i--; )
	{
		c = this.charAt (i).toLowerCase ();
		alpha = (c <= "z") && (c >= "a");
		num = (c <= "9") && (c >= "0");
		if (!alpha && !num && !checkOthers (c))
		{
			return false;
		}
	}
	return true;
};
//
function showProto ()
{
	trace ("**Prototypes**");
	trace ("Date.calcLeapYear(year, month, day, hour, min):Array");
	trace ("String.isEmail(void):Boolean");
	trace ("MovieClip: _ycenter, _xcenter, _bottom, _top, _right, _left, _r, _path");
	trace ("MovieClip.createFakeButton(Target:MovieClip,useCursor:Boolean):MovieClip");
	trace ("MovieClip.setTooltip(theText, timer, text_color, bg_color, border_color)");
	trace ("MovieClip.unsetTooltip(void):Void");
	trace ("MovieClip.hide(void):Void");
	trace ("MovieClip.show(void):Void");
	trace ("MovieClip.createDigit(Count:Number,Length:Number):String");
	trace ("MovieClip.displayTime(ct, isShort)");
	trace ("MovieClip.displayCurrentTime()");
	trace ("MovieClip.trimStr(String,Number)");
	trace ("MovieClip.getObjLength(Object):Number");
	trace ("MovieClip.traceObj(Object, String, TextField)");
	trace ("MovieClip.reverseObject(Object):Object");
}
showProto ();
delete showProto;
//
ASSetPropFlags (Date.prototype, "calcLeapYear", 1, 0);
ASSetPropFlags (String.prototype, "isEmail", 1, 0);
ASSetPropFlags (mp, "_ycenter", 1, 0);
ASSetPropFlags (mp, "_xcenter", 1, 0);
ASSetPropFlags (mp, "_bottom", 1, 0);
ASSetPropFlags (mp, "_top", 1, 0);
ASSetPropFlags (mp, "_right", 1, 0);
ASSetPropFlags (mp, "_left", 1, 0);
ASSetPropFlags (mp, "_r", 1, 0);
ASSetPropFlags (mp, "_path", 1, 0);
ASSetPropFlags (mp, "createFakeButton", 1, 0);
ASSetPropFlags (mp, "createDigit", 1, 0);
ASSetPropFlags (mp, "drawRect", 1, 0);
ASSetPropFlags (mp, "displayTime", 1, 0);
ASSetPropFlags (mp, "displayCurrentTime", 1, 0);
ASSetPropFlags (mp, "playBack", 1, 0);
ASSetPropFlags (mp, "setTooltip", 1, 0);
ASSetPropFlags (mp, "unsetTooltip", 1, 0);
ASSetPropFlags (mp, "hide", 1, 0);
ASSetPropFlags (mp, "show", 1, 0);
ASSetPropFlags (mp, "trimStr", 1, 0);
ASSetPropFlags (mp, "getObjLength", 1, 0);
ASSetPropFlags (mp, "traceObj", 1, 0);
ASSetPropFlags (mp, "reverseObject", 1, 0);
delete mp;
