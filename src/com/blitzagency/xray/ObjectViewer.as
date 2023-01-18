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
import com.blitzagency.xray.ClassPath;

/**
 * ObjectViewer has 2 over all jobs:
 *
 * 1.  Recurse application and return XML formatted view for the interface's treeview component<br>
 * 2.  Return object data to the interface
 *
 * It's core concept is to return information about the application.  All calls to the OV come through ControlConnection
 *
 * @author John Grden :: John@blitzagency.com
 */

class com.blitzagency.xray.ObjectViewer
{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	/**
	 * movieclip property array - represents all of the properties we want to have returned about a MovieClip object
	 */
	private var mc_prop_ary:Array;
	/**
	 * textfield property array - represents all of the properties we want to have returned about a TextField object
	  */
	private var TextField_prop_ary:Array;
	/**
	 * button property array - represents all of the properties we want to have returned about a Button object
	 */
	private var Button_prop_ary:Array;
	/**
	 * sound property array - represents all of the properties we want to have returned about a Sound object
	 */
	private var Sound_prop_ary:Array;
	/**
	 * movieclip property small array - represents all of the properties we want to have returned about a MovieClip object, this is the short version
	 */
	private var mc_prop_small_ary:Array;
	/**
	 * objMap is used by buildTree function.  It contains a physical view of the app's structure.  buildTree function will recurse
	 * this object to create the xml that is returned to the interface.
	 *
	 * The point of using a separate object rather than building the XML while in the initial recursion (see viewTree function),
	 * is so that we can format/sort the items that are returned in the xml
	 */
	private var objMap:Object;
	/**
	 * _recursionCount is a fractional counter that allows an object to be looped several times yet avoid the 256 recursion error.
	 * When an object is first found in a loop, it's __recursionCheck is updated to match Xray.recursionControl.  Then, __recursionCheck is added
	 * to with .001.  The _recursionCount number represents the "cap" times an object can be recursed.
	 *
	 * The current setting is .003 = it can be recursed and shown 3 times.  This number could be as high as 255, but the higher the number
	 * the slower the process
	 */
	private var _recursionCount:Number;
	/**
	 * Used in buildTree for stripping out unecessary path information on objects
	 */
	private var currentObjPath:String;
	/**
	 * XMLStr is what buildTree adds to as it recurses objMap.  This will then be converted to a true XML object with XMLDoc, and returned to the caller
	 */
	public var XMLStr:String;
	/**
     * The actual XML Object that is finally returned to the caller
	 */
	public var XMLDoc:XML;



	function ObjectViewer()
	{
		// constructor

		// _recursionCount is the control number that represents how many times an object may be recursed.
		// an example would be an array/object referenced in several locations/timelines.  You want to show it fully in the areas its
		// referenced just for usability's sake.  It would suck if you found your array, but since it was recurrsed elsewhere, it only shows
		// the name of it where you currently have found it.  If you're wading through someone elses code, you'll not want to have to hunt this down
		this._recursionCount = (.003);

		mc_prop_ary = new Array(
					"_name",
					"_x",
					"_y",
					"_width",
					"_height",
					"_rotation",
					"_visible",
					"_alpha",
					"_xscale",
					"_yscale",
					"cacheAsBitmap",
					"filters",
					"_currentframe",
					"_totalframes",
					"_framesloaded",
					"enabled",
					"hitArea",
					"_droptarget",
					"_target",
					"_focusEnabled",
					"_focusrect",
					"_lockroot",
					"menu",
					"_quality",
					"soundbuftime",
					"tabChildren",
					"tabEnabled",
					"tabIndex",
					"trackAsMenu",
					"_url",
					"useHandCursor"
					);
		TextField_prop_ary = new Array(
					"_name",
					"_x",
					"_y",
					"_width",
					"_height",
					"_rotation",
					"_visible",
					"_alpha",
					"_xscale",
					"_yscale",
					"html",
					"htmlText",
					"text"
					);
		Button_prop_ary = new Array(
					"_name",
					"_x",
					"_y",
					"_width",
					"_height",
					"_rotation",
					"_visible",
					"_alpha",
					"_xscale",
					"_yscale",
					"enabled"
					);
		Sound_prop_ary = new Array(
					"position",
					"duration",
					"id3.comment",
					"id3.album",
					"id3.genre",
					"id3.songname",
					"id3.artist",
					"id3.track",
					"id3.year",
					"volume",
					"pan"
					);
		mc_prop_small_ary = new Array(
					"_x",
					"_y",
					"_width",
					"_height",
					"_visible",
					"_alpha",
					"_currentframe"
					);
		mc_prop_ary.reverse();
		TextField_prop_ary.reverse();
		Button_prop_ary.reverse();
		Sound_prop_ary.reverse();
		mc_prop_small_ary.reverse();

		// initialize event dispatcher
		EventDispatcher.initialize(this);
	}


	/**
     * @summary replace works with strings to change out certain characters that might not be XML friendly
	 * @param str:String	string object to work with
	 * @param srch_str:String	what you're wanting to replace
	 * @param repl_str:String	what you want to put in place
	 * @return String
	 */
	private function replace(str:String, srch_str:String, repl_str:String):String
	{
		var str_ary = new Array()
		str_ary = str.split(srch_str);

		var return_str = str_ary.join(repl_str);
		return return_str;
	}
	/**
     * @summary setAttributes takes the object passed in and adds the properties as attributes to the XMLNode sent in
	 * @param xmlNode:XMLNode
	 * @param obj:Object	properties to convert to attributes
	 * @return nothing
	 */
	private function setAttributes(xmlNode:XMLNode, obj:Object):Void
	{
		for(var items:String in obj)
		{
			if(items != "__recursionCheck" && items != "getRecursionChecked" && items != "setRecursionChecked")
			xmlNode.attributes[items] = obj[items];
		}
	}

	/**
     * @summary getObjProperties was meant to be a one stop shop to get all other properties beyond the array props (mc_prop_ary and so on)
	 * @param obj:Object	Object to loop
	 * @return Object
	 */
	public function getObjProperties(obj:Object):Object
	{
		var return_obj:Object = new Object();
		// you want EVERYTHING in the movie clip.

		for(var items:String in obj)
		{
			if(items != "Xray"
				&& items != "__recursionCheck"
				&& items != "getRecursionChecked"
				&& items != "setRecursionChecked")
			{

				var sClass:String = ClassPath.getClass(obj[items]);
				sClass = sClass != "" ? sClass : typeof(obj[items])
				return_obj[items] = sClass + " :: " + obj[items];
			}
		}

		return return_obj;
	}

	/**
     * @summary getFunctionProperties - not sure if this is old.  There is reference to it in ControlConnection.as
	 *  - John 8.3.2005 10.12pm EST
	 * @return Object
	 */
	public function getFunctionProperties(obj, sPath):Object
	{
		_global.ASSetPropFlags(obj,null,0,true);
		var return_obj:Object = new Object();
		// you want EVERYTHING in the movie clip.

		for(var items:String in obj)
		{
			if(items != "__proto__"
			&& items != "prototype"
			&& items != "Xray"
			&& items != "__recursionCheck"
			&& items != "getRecursionChecked"
			&& items != "setRecursionChecked")
			{
				var value = typeof(obj[items]) == "function" ? "function" : obj[items];
				return_obj[items] = value;
			}
		}

		if(obj.prototype)
		{
			for(var items:String in obj.prototype)
			{
				if(items != "__proto__"
				&& items != "prototype"
				&& items != "Xray"
				&& items != "__recursionCheck"
				&& items != "getRecursionChecked"
				&& items != "setRecursionChecked")
				{
					//_global.Xray.trace("getFunctionProp - proto - 2", items);
					var value = typeof(obj.prototype[items]) == "function" ? "function" : "property";
					return_obj[items] = value;
				}
			}
		}
		_global.ASSetPropFlags(obj,null,1,true);
		return return_obj;
	}

	/**
     * @summary getProperties is the main call to return all data about a Movieclip/Button/TextField/Sound object
	 * @param target_obj:Object	can be either MovieClip, Button, TextField or Sound object
	 * @param showAll:Boolean	whether or not to loopthe object for all other properties and methods
	 * @return Object
	 */
	public function getProperties(target_obj:Object, showAll:Boolean):Object
	{
		_global.ASSetPropFlags(target_obj,null,0,true);
		var obj:Object = new Object();
		obj.sTarget_mc = String(eval(target_obj._target));
		// you want EVERYTHING in the movie clip.

		if(showAll)
		{
			for(var items:String in target_obj)
			{
				if(items != "__recursionCheck"
				&& items != "Xray"
				&& items != "getRecursionChecked"
				&& items != "setRecursionChecked")
				{
					var sClass:String = ClassPath.getClass(target_obj[items]);
					sClass = sClass != "" ? sClass : typeof(target_obj[items])
					//if(typeof(target_mc[items]) != "movieclip")
						obj[items] = sClass + " :: " + target_obj[items];
				}
			}
		}

		obj.Class = ClassPath.getClass(target_obj, true);

		obj["_props"] = new Object();

		// [TODO: John, please review to make sure it still works. I changed so that ary was defined only once.  now compiles with MTASC.]

		var ary:Array;
		if(target_obj instanceof MovieClip) ary = mc_prop_ary;
		if(target_obj instanceof TextField) ary = TextField_prop_ary;
		if(target_obj instanceof Button) ary= Button_prop_ary;
		if(target_obj instanceof Sound) ary = Sound_prop_ary;

		for(var x:Number=0;x<ary.length;x++)
		{
			switch(ary)
			{
				case mc_prop_ary:
					if(ary[x] == "_y") obj["_props"].depth = target_obj.getDepth();
					obj["_props"][ary[x]] = target_obj[ary[x]];
					break;
				case TextField_prop_ary:
					obj["_props"][ary[x]] = target_obj[ary[x]];
					break;
				case Button_prop_ary:
					obj["_props"][ary[x]] = target_obj[ary[x]];
					break;
				case Sound_prop_ary:

					if(ary[x] == "volume")
					{
						obj["_props"].volume = target_obj.getVolume();
					}else if(ary[x] == "pan")
					{
						obj["_props"].pan = target_obj.getPan();
					}else if(ary[x] == "id3.comment")
					{
						obj["_props"].id3_comment = target_obj.id3.comment;
					}else if(ary[x] == "id3.album")
					{
						obj["_props"].id3_album = target_obj.id3.album();
					}else if(ary[x] == "id3.genre")
					{
						obj["_props"].id3_genre = target_obj.id3.genre();
					}else if(ary[x] == "id3.songname")
					{
						obj["_props"].id3_songname = target_obj.id3.songname();
					}else if(ary[x] == "id3.artist")
					{
						obj["_props"].id3_artist = target_obj.id3.artist();
					}else if(ary[x] == "id3.track")
					{
						obj["_props"].id3_track = target_obj.id3.track();
					}else if(ary[x] == "id3.year")
					{
						obj["_props"].id3_year = target_obj.id3.year();
					}else
					{
						obj["_props"][ary[x]] = target_obj[ary[x]];
					}
					break;
				default:

			}
		}
		//_global.ASSetPropFlags(target_mc,null,1,false);
		_global.ASSetPropFlags(obj,["constructor", "__constructor__", "prototype", "__proto__", "__recursionCheck"],1,true);
		return obj;
	}

	/**
     * @summary getStandardProperties is currently not in use.  It was created to be an abreviated list of main properties about a movieclip.
	 * @param target_mc:MovieClip	MovieClip reference
	 * @return Object
	 */
	public function getStandardProperties(target_mc:MovieClip):Object
	{

		var obj:Object = new Object();
		obj["_props"] = new Object();

		for(var x:Number=0;x<mc_prop_small_ary.length;x++)
		{
			if(mc_prop_small_ary[x] == "_y")obj["_props"].depth = target_mc.getDepth();
			obj["_props"][mc_prop_small_ary[x]] = target_mc[mc_prop_small_ary[x]];
		}

		return obj;
	}

	/**
     * @summary getSoundProperties is used to return specific Sound object information including ID3 object properties
	 * @param snd:Sound - Sound object
	 * @return Object
	 */
	public function getSoundProperties(snd:Sound):Object
	{
		var obj:Object = new Object();
		obj["txtPosition"] = snd.position;
		obj["txtDuration"] = snd.duration;
		obj["txtComment"] = snd.id3.comment;
 		obj["txtAlbum"] = snd.id3.album;
		obj["txtGenre"] = snd.id3.genre;
		obj["txtSongName"] = snd.id3.songname;
		obj["txtArtist"] = snd.id3.artist;
		obj["txtTrack"] = snd.id3.track;
		obj["txtYear"] = snd.id3.year;
		obj["txtVolume"] = snd.getVolume();
		obj["txtPan"] = snd.getPan();

		return obj;
	}

	/**
     * @summarygetVideoProperties is used to return specific video object information
	 * @param ns:NetStream - NetStream object
	 * @return Object
	 */
	public function getVideoProperties(ns:NetStream):Object
	{
		var obj:Object = new Object();
		obj["txtPosition"] = ns.time;
		//obj["txtDuration"] = ns.duration;
		obj["txtBufferLength"] =ns.bufferLength;
 		obj["txtBufferTime"] = ns.bufferTime;
		obj["txtBytesLoaded"] = ns.bytesLoaded;
		obj["txtBytesTotal"] = ns.bytesTotal;
		obj["txtCurrentFps"] = ns.currentFps;

		var props:Object = getObjProperties(ns);
		obj.props = props;

		return obj;
	}

	/**
     * @summary getName is used to return either a _name property if the object is a movieclip, or the sClip.  This is
	 * weird in that clip can be a String or Movieclip
	 *
	 * @param clip:Object
	 * @return String
	 */
	private function getName(clip:Object):String
	{
		var sName:String = clip._name;
		return (!sName) ? String(clip) : sName;
	}

	/**
     * @summary addObject is called during the recursion process (parseTree) to build an Object structure that mirrors the application
	 * @param link:String	"_level0.home.news.latest"
	 * @param iType:Number	represents type of object (refer to getType())
	 * @param sName:Sting	name of the item
	 * @return nothing
	 */
	private function addObject(link:String, iType:Number, sName:String):Void
	{
		if(link.lastIndexOf(".") > -1)
		{
			// if there's something to loop, do so
			var aTemp:Array = link.split(".");
			var obj:Object = this.objMap;

			for(var x:Number=0;x<aTemp.length;x++)
			{
				var keyName:String = (x == aTemp.length-1) ? sName : aTemp[x];
				// [TODO: Review and String type variable - changed so that the path variable was not redefined. Now compiles with MTASC ]
				var path = aTemp.slice(0,x).join(".");
				var exists:Boolean = true;
				if(!obj[keyName])
				{
					exists = false;
					obj[keyName] = new Object();
					path = x > 0 ? path + "." + keyName : path
					obj[keyName].sPath = path;
					obj[keyName].iType = iType;
					obj[keyName].sName = keyName;
				}

				obj = obj[keyName];

				if(x == aTemp.length-1 && !exists)
				{
					// [TODO: verify that the change works. removed local variable redefinition for "link". Now compiles with MTASC]
					var aLink = link.split(".");
					var lastObj = aLink.pop();
					link = aLink.join('.') + "." + sName;
					obj.sPath = link;
					obj.iType = iType;
					obj.sName = sName;
				}
			}
		}else
		{
			// if nothing to loop, just check for existance
			// we're going to assume that if there's no "."'s in the string
			// that we're dealing with a root level object.
			if(!objMap[link]) objMap[link] = new Object();
			objMap[link].sPath = link;
			objMap[link].iType = iType;
			objMap[link].sName = sName;
		}
	}

	/**
     * @summary buildTree parses the objMap object and creates an XML representation of the application
	 * @param obj:Object
	 * @return	nothing
	 */
	function buildTree(obj:Object):Void
	{
		var len:Number = currentObjPath.split(".").length;
		var aTemp:Array = obj.sPath.split(".");

		aTemp.splice(0,len-1);
// [TODO: review change - Moved variable definitions outside of the if block. Now compiles with MTASC]
// [TODO: review change - strong typed variables sNodeLabel, sCurrentTarget, and iType]
		var checkPath = aTemp.join(".") == "" ? false : true;
		var sNodeName:String;
		var sNodeLabel:String;
		var sCurrentTarget:String;
		var iType:Number;
		// [TODO: review change - defined variable o outside of switch statement - no compiles with MTASC]
		var o:Object;

		if(obj.sPath != undefined
			&& checkPath
			&& obj.sName != undefined)
		{
			/*
			NOTES:
				to NOT have an entire path returned, we need to strip everything to the left of the original object that was passed in
				using the currentObjPath

				if the currentObjPath = _level0.main
					len = 2
				if the sPath = _level0.main.video.playBtn
					sPath = main.video.playBtn
			*/

			sNodeName= getName(obj.sName);
			sNodeName = replace(sNodeName, " ", "_");
			sNodeLabel = getName(obj.sName);
			sCurrentTarget = obj.sPath;
			iType = obj.iType;

			switch(iType)
			{
				// object
				case 0:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					if(!sClass)
					{
						var func:String = typeof(eval(sCurrentTarget));
						//sClass = (func == "function") ? func : sClass;
						sClass = "Object";
					}
					sNodeLabel = sNodeLabel + " (" + sClass + ")";

					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				// array
				case 1:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					sNodeLabel = sNodeLabel + " (" + sClass + ")";
					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;

				// movieclip
				case 2:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					sNodeLabel = sNodeLabel + " (" + sClass + ")";
					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				// button
				case 3:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					sNodeLabel = sNodeLabel + " (" + sClass + ")";
					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				// sound
				case 4:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					sNodeLabel = sNodeLabel + " (" + sClass + ")";
					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				case 5:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					sNodeLabel = sNodeLabel + " (" + sClass + ")";
					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				// video
				case 6:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					if(!sClass)
					{
						var func:String = typeof(eval(sCurrentTarget));
						//sClass = (func == "function") ? func : sClass;
						sClass = "Object";
					}
					sNodeLabel = sNodeLabel + " (" + sClass + ")";

					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				// function
				case 7:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					if(sClass)
					{
						sClass = "( " + sClass + " )";
					}else
					{
						sClass = "( function )";
					}
					sNodeLabel += sClass
					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
				// netStream
				case 8:
					var sClass:String = ClassPath.getClass(eval(sCurrentTarget), false)
					if(!sClass)
					{
						var func:String = typeof(eval(sCurrentTarget));
						//sClass = (func == "function") ? func : sClass;
						sClass = "Object";
					}
					sNodeLabel = sNodeLabel + " (" + sClass + ")";

					o = {label:sNodeLabel, mc:sCurrentTarget, t:iType};
					break;
			}

			XMLStr += "<" + sNodeName + " ";

			for(var atr:String in o)
			{
				XMLStr += atr + "=\"" + o[atr] + "\" "
			}

			XMLStr += ">";

		}

		// [TODO: review change - Local variable redefinition. Now compiles with MTASC]
		aTemp = new Array();

		for(var items in obj)
		{
			//Xray.tt("items", items);

			if(typeof(obj[items]) == "object")
			{
				//buildTree(obj[items]);
				aTemp.push(obj[items]);
			}
		}

		aTemp.sortOn("sName");

		for(var x:Number=0;x<aTemp.length;x++)
		{
			buildTree(aTemp[x]);
		}
		// [TODO: review change - Defined sNodeName outside of switch block. Now compiles with MTASC]
		if(sNodeName) XMLStr += "</" + sNodeName + ">";

	}

	/**
     * @summary _protect is for resetting prop flags via ASSetPropFlags - I hadn't implemented since it didn't seem to work on small tests, but I've left here for further review
	 * @return	nothing
	 */
	private function _protect(package_obj:Object, unprotected_array:Array):Void
	{
		//_global.tt("_protect called", unprotected_array);
		_global.ASSetPropFlags(package_obj, null, 1, true);
		_global.ASSetPropFlags(package_obj, unprotected_array, 0, true);
		_global.ASSetPropFlags(package_obj,["constructor", "__constructor__", "prototype", "__proto__"],1,true);
	}

	/**
     * @summary viewTree is where the process starts for building an XML view of the application.
	 *
	 * @param obj:Object	this can be a MovieClip, Button, TextField, Sound, Object, Array - an object.
	 * @param objPath:String	starting path.
	 * @param recursiveSearch:Boolean	whether or not to loop more than one object per call.
	 * @param showHidden:Boolean	whether or not to apply ASSetPropFlags to objects as we recurse.
	 *
	 * @return	XML
	 */
	public function viewTree(obj:Object, objPath:String, recursiveSearch:Boolean, showHidden:Boolean, objectSearch:Boolean):XML
	{

		dispatchEvent({type:"onViewTree", obj:obj});

		// reset
		objMap = new Object();
		XMLStr = "";

		// reset recursion check
		Xray.recursionControl += 1;

		var sNodeName:String
		if(typeof(obj) == "movieclip")
		{
			sNodeName = getName(obj);
		}else if(typeof(obj) == "object")
		{
			sNodeName = objPath.split(".")[0];
		}


		// set attributes for this root element
		var objType:Number = getType(obj);
		var targetPath:String;
		if(objType == 2)
		{
			targetPath = String(eval(obj._target));
			objPath = targetPath;
		}else
		{
			targetPath = objPath;
		}

		// set currentObjPath so that buildTree can strip what's not needed.
		currentObjPath = objPath;

		// create base path for the XML object to return full paths with
		var aTemp:Array = currentObjPath.split(".");
		if(aTemp.length > 1)
		{
			aTemp.splice(aTemp.length-1);
		}
// [TODO: review change - local variable redefinition aTemp- now compiles with MTASC]
		var o:Object;
		aTemp= targetPath.split(".");

		// setup the xml with the _root node, which will represent the target_mc sent in
		XMLDoc = new XML();

		if(recursiveSearch || (!recursiveSearch && targetPath == "_level0"))
		{
			var currentNode:XMLNode;

			// set first element
			var element1:XMLNode = XMLDoc.createElement(aTemp[0]);
			XMLDoc.appendChild(element1);

			var attribute_obj:Object = {label:aTemp[0], mc:aTemp[0], t:objType};
			setAttributes(XMLDoc.lastChild, attribute_obj);


			currentNode = XMLDoc.lastChild;
		}

		// send it off to be parsed
		var bParsed:Boolean = false;

		this.addObject(sNodeName, getType(obj), sNodeName, obj.getDepth());

		// if the original object sent in IS an "object" (IE: not movieclip), then set to true to that objects will be recursed
		// otherwise, to save time, when we find an object, we simply list it in it's location and let the
		// user drill down into the object with the property inspector.
		// If the param objectSearch = false, then evaluate the type of object being searched.  if it's a true "object", then set to true
		if(!objectSearch) objectSearch = getType(obj) == 0 ? true : false;

		this.parseTree(obj, sNodeName, objPath, recursiveSearch, showHidden, objectSearch);

		this.buildTree(objMap);
		this.XMLDoc = new XML(XMLStr)

		// [TODO: review change - local variable redefinition obj - now compiles with MTASC]
		// return the xml for use elsewhere
		obj = new Object();
		obj.XMLDoc = this.XMLDoc;

		dispatchEvent({type:"onViewTreeReturn", obj:obj});
		return this.XMLDoc;
	}

	/**
     * @summary parseTree is responsible for recursing the application and adding objects to the objMap via addObject() method
	 *
	 * @param obj:Object	this can be a MovieClip, Button, TextField, Sound, Object, Array - an object.
	 * @param objPath:String	starting path.
	 * @param recursiveSearch:Boolean	whether or not to loop more than one object per call.
	 * @param showHidden:Boolean	whether or not to apply ASSetPropFlags to objects as we recurse.
	 * @param objectSearch:Boolean	based on whether or not an object is a true "Object"
	 * @param parent:String	name of parent
	 * @param lastParent:String	name of last parent
	 *
	 * @return	nothing
	 */
	 // [TODO: - John, verify that I typed the parent and lastParent arguments correctly.]
	public function parseTree(obj:Object, sName:String, sPath:String, recursiveSearch:Boolean, showHidden:Boolean,objectSearch:Boolean, parent:Object, lastParent:Object):Void
	{
		var iDepth:Number = Number(typeof(obj) == "movieclip" ? obj.getDepth() : 0);
		var objType:Number = getType(obj);
		var unprotected_array:Array = new Array();

		if(typeof( obj ) == "object" || typeof( obj ) == "movieclip" || typeof( obj ) == "function")
		{
			if(showHidden)
			{
				for(var items:String in obj)
				{
					unprotected_array.push(items);
				}
				//====================================================>
				_global.ASSetPropFlags(obj,null,0,true);
				//====================================================>
			}

			if(recursiveSearch)
			{
				if(obj.__recursionCheck == null)
				{
					obj.prototype.getRecursionChecked = function(){}
					obj.prototype.setRecursionChecked = function(value){}

					var created = obj.prototype.addProperty("__recursionCheck", obj.prototype.getRecursionChecked, obj.prototype.setRecursionChecked);

					obj.__recursionCheck = 0; // initially set to zero

					//====================================================>
					_global.ASSetPropFlags(obj,["__recursionCheck", "getRecursionChecked", "setRecursionChecked"],1,true);
					//====================================================>
				}

				if(Math.floor(obj.__recursionCheck) != Math.floor(Xray.recursionControl))
				{
					obj.__recursionCheck = Xray.recursionControl;
				}
			}else
			{
				delete obj.__recursionCheck;
				delete obj.getRecursionChecked;
				delete obj.setRecursionChecked;
			}

			if(typeof(obj) == "object" && recursiveSearch && !objectSearch)
			{
				if(showHidden)
				{
					this._protect(obj, unprotected_array);
				}
				return;
			}

			for(var items:String in obj)
			{
				if(items != "__recursionCheck" && (typeof(obj[items]) == "object" || typeof(obj[items]) == "movieclip" || typeof( obj[items] ) == "function"))
				{
					var bReturn:Boolean = false;

					var pathCheck:String = "";
					if(typeof( obj[items] ) == "movieclip")
					{
						// check for sPath's length, if it's the same as _target, then it's a reference, not a true movieclip
						var pathLength:Number = sPath.split(".").length
						var targetLength:Number = String(eval(obj[items]._target)).split(".").length;

						if(pathLength <= targetLength)
						{
							pathCheck = sPath + "." + items;
						}else
						{
							//testing 8.12.2005 - if still in effect, delete the rest of the "if" block and just build the path string
							pathCheck = sPath + "." + items;
							//pathCheck = String(eval(obj[items]._target));
						}
						//(5020) pathCheck: owner :: focusTextField :: _level0.textArea_mc.focusTextField :: 3 :: 2 :: _level0.textArea_mc
					//	_global.tt("pathCheck", items, sName, sPath, pathLength, targetLength, pathCheck, getType(obj[items]));
					}else
					{
						pathCheck = sPath + "." + items;
						//_global.tt("object pathCheck", items, pathCheck, sName);
					}

					if((typeof( obj[items] ) == "object" || typeof( obj[items] ) == "movieclip" || typeof( obj[items] ) == "function")
						&& items.toLowerCase() != "xray"
						&& items != "__recursionCheck"
						&& items != "getRecursionChecked"
						&& items != "setRecursionChecked"
						&& items.toLowerCase() != "xray"
						&& items != "__proto__"
						&& items != "prototype"
						&& items != "__constructor__"
						&& items != "__resolve"
						&& items != "constructor")
					{

						// add to objMap
						iDepth = Number(typeof(obj[items]) == "movieclip" ? obj[items].getDepth() : 0);
						this.addObject(pathCheck, getType(obj[items]), items, iDepth);

						/*
						NOTES:
							Recursion control not only needs to check once, but it needs to allow items to repeat.

							So, to do this, we need to increment at a fractional rate.

							If the recursionCheck is == 1, then we need to increment it by .1 until it equals 1.255 - I'm thinking
							we need to stay just shy of 256 to avoid the error message.
						*/

						if(recursiveSearch)
						{
							if(Math.floor(obj[items].__recursionCheck) != Math.floor(Xray.recursionControl) || obj[items].__recursionCheck < Xray.recursionControl+this._recursionCount)
							{
								// increment by .001
								if(Math.floor(obj[items].__recursionCheck) == Math.floor(Xray.recursionControl))
								{
									obj[items].__recursionCheck += (.001);
								}
								if(obj[items].__recursionCheck < Xray.recursionControl+this._recursionCount || obj[items].__recursionCheck == undefined)
								{
									parseTree(obj[items], items, pathCheck, recursiveSearch, showHidden, objectSearch, obj, parent);
								}
							}
						}
					}
				}
			}
			if(showHidden)
			{
				this._protect(obj, unprotected_array);
			}
		}
	}

	/**
     * @summary getType returns a number representing the "type" of object sent in
	 * @param obj:Object
	 * @returns	number
	 */
	private function getType(obj:Object):Number
	{
		var bMc:Boolean = obj instanceof MovieClip;
		var bButton:Boolean = obj instanceof Button;
		var bSound:Boolean = obj instanceof Sound;
		var bVideo:Boolean = obj instanceof Video;
		var bNetStream:Boolean = obj instanceof NetStream;
		var bTextField:Boolean = obj instanceof TextField;
// [TODO: review change - added cast to Boolean]
		var bObject:Boolean = Boolean(typeof(obj) == "object" ? true : false);
		var bAry:Boolean = obj.constructor == Array ? true : false;
// [TODO: review change - added cast to Boolean]
		var bFunction:Boolean = Boolean(typeof(obj) == "function" ? true : false);
		var i:Number;


		if(bObject) i=0;
		if(bAry) i=1;
		if(bMc) i=2;
		if(bButton) i=3;
		if(bSound) i=4;
		if(bTextField) i=5;
		if(bVideo) i=6;
		if(bFunction) i = 7;
		if(bNetStream) i = 8;
		return i;
	}
}