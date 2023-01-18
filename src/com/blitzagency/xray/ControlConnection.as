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
import com.blitzagency.xray.ObjectViewer;
import com.blitzagency.xray.FPSMeter;
import com.blitzagency.xray.DragableMovieClip;
import com.blitzagency.xray.Commander;

/**
 * ControlConnection extends LocalConnection and is the lc primarily responsible for executing commands
 * from the interface (IE: changing properties of a movieclip, controlling sound, video etc)
 *
 * @author John Grden :: John@blitzagency.com
 */
class com.blitzagency.xray.ControlConnection extends LocalConnection
{
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;

	public var isConnected:Boolean;
	public var queSI:Number;
	/**
	 * Array for pushing sections of the XML string returned by objViewer eg: it's a que
	 */
	public var tree_que:Array;
	/**
	 * Dragable (EECOLOR - Thanks to Erik Westra) enables a movieclip to be dragged around the stage.
	 */
	public var dragableMovieClip:DragableMovieClip;
	/**
	 * Instance of the ObjectViewer, which is what recurses the Flash app and returns XML formatted
	 * representation of your app.
	 */
	public var objViewer:ObjectViewer;
	/**
	 * Instance of the FPSMeter object
	 */
	public var fpsMeter:FPSMeter;
	/**
	 * Highlight color when a clip is selected in the treeview of the interface
	 */
	private var highlightColor:Color;
	/**
	 * ObjectViewer returns an XML object that represents the physical layout of your app.  This returned tree is assigned to
	 * tree_xml upon return.
	 */
	private var tree_xml:XML;
	/**
     * focusEnabledCheck is a boolean property indicating whether or not a focusEabled was applied to
	 * an object onstage before we highlighted it.  When the object is deselected, we reset this property to its
	 * original value
	 */
	private var focusEnabledCheck:Boolean;
	/**
     * movieclip reference to the clip that currently is selected on stage with highlight.  Used in resetting to original
	 * state when either selecting a new object or just deselecting the object althogether.
	 */
	private var boundingBox_mc:MovieClip;

	function ControlConnection()
	{
		// initialize event dispatcher
		EventDispatcher.initialize(this);

		// call init
		this.init();
	}

	public function init():Void
	{
		this.objViewer = new ObjectViewer();
		this.tree_que = new Array();
	}

	/**
     * @summary called via the interface.  This method calles ObjectViewer to recurse the application and return an XML
	 * formatted version of the applications structure.
	 *
	 * You'll note that the XML is converted to a string and split into 5000 character chunks, then sent via LocalConnection
	 * to the interface.  This is due to LC's speed limit of 40k.  I'm not sure if it's 40k per movie frame or what, but I had
	 * throttle the que with an interval to pass the data.
	 *
	 * @param sTarget_mc:String a string representing the path of the object to start at.  IE: "_level0.main"
	 * @param recursiveSearch:Boolean a boolean indicating if ObjectViewer should recurse the application, or if they're using active treeview
	 * @param showHidden:Boolean showHidden let's ObjectViewer know whether or not to use ASSetPropFlags in the recursion
	 *
	 * NOTE:  ASSetPropFlags has a slight bug (don't know if it's fixed in 8Ball yet).  Sometimes it leaves objects/properties un
	 * writable/undeletable after using ASSetPropFlags to show it.  So, the user uses this feature at their own risk.  98% of the time
	 * it doesn't cause any bugs in the host.
	 *
	 * @return nothing
	 */
	public function viewTree(sTarget_mc:String, recursiveSearch:Boolean, showHidden:Boolean, objectSearch:Boolean):Void
	{
		var target_mc = eval(sTarget_mc);

		// if an object is passed, send along the string path
		var objPath:String = null;
		if(typeof(target_mc) == "object") objPath = sTarget_mc;

		// get the tree data
		var tree_xml = this.objViewer.viewTree(target_mc, objPath, recursiveSearch, showHidden, objectSearch);

		if(!tree_xml)
		{
			Xray.tt("treeview search returned undefined");
			return;
		}
		// loop _levels to see which ones have any content

		var iLevelCount:Number = 5000;
		var level_ary:Array = new Array();
		for(var x:Number=1;x<=iLevelCount;x++)
		{
			if(eval("_level" + x)) level_ary.push(x);
		}

		// out

		var sTree:String = tree_xml.toString();
		var treeLength:Number = sTree.length;

		/*
		NOTES:
			There's a 40k limit on LC, so we have to break up the XML string into chunks.  I also found
			that I couldn't just do it in, say, 35k chunks, I had to down to 5 to be safe AND I had to
			push it to a que (tree_que) to then be cleared by interval.
		*/
		if(treeLength > 5000)
		{
			this.tree_que = new Array();

			for(var x:Number=0;x<treeLength;x+=5000)
			{
				var toSend:String = sTree.substring(x, x+5000);

				var bLast:Boolean = (x+5000) >= sTree.length ? true : false;
				this.tree_que.push({XMLDoc: toSend, level_ary:level_ary, bLast:bLast});
			}

			this.queSI = setInterval(this, "processQue", 25);
		}else
		{
			var obj:Object = {XMLDoc: tree_xml.toString()}
			var bSent:Boolean = this.send("_xray_conn", "setTree", obj, level_ary, true);
		}

	}

	/**
     * @summary processes the que built by viewTree and sends the chunks of data via localConnection to the interface
	 *
	 * @return nothing
	 */
	public function processQue():Void
	{
		var temp:Object = this.tree_que.shift();
		var obj:Object = new Object();
		obj.XMLDoc = temp.XMLDoc;
		var level_ary = temp.level_ary;
		var bLast = temp.bLast;

		if(this.tree_que.length == 0) clearInterval(this.queSI);
		var bSent:Boolean = this.send("_xray_conn", "setTree", obj, level_ary, bLast);
	}
	/**
     * @summary sends the current fps from the FPSMeter dispatch
	 *
	 * @param obj:Object Has one property: fps
	 *
	 * @return nothing
	 */
	public function sendFPS(obj:Object):Void
	{
		var bSent:Boolean = this.send("_xray_conn", "viewFPS", obj.fps);
	}
	/**
     * @summary This is a call recieved from the interface to turn the FPSMeter on. runFPS is a setter method.
	 *
	 * @return nothing
	 */
	public function showFPS():Void
	{
		this.fpsMeter.runFPS = true;
	}
	/**
     * @summary This is a call recieved from the interface to turn the FPSMeter off. runFPS is a setter method.
	 *
	 * @return nothing
	 */
	public function hideFPS():Void
	{
		this.fpsMeter.runFPS = false;
	}
	/**
     * @summary fpsOn recieves a boolean and based on that, the FPSMeter is either turned on or off
	 *
	 * @param showFPS:Boolean true turns the FPSMeter on, false turns if off
	 *
	 * @return nothing
	 */
	public function fpsOn(showFPS:Boolean):Void
	{
		this.fpsMeter.runFPS = showFPS;
	}
	/**
     * @summary returns all movieclip properties
	 *
	 * @param sTarget_mc:String string path to the movieclip
	 * @param bShowAll:Boolean use ASSetPropFlags to show all properties and methods
	 *
	 * @return nothing
	 */
	public function getMovieClipProperties(sTarget_mc:String, bShowAll:Boolean):Void
	{
		// in
		var target_mc:MovieClip = eval(sTarget_mc);
		var obj:Object = this.objViewer.getProperties(target_mc, bShowAll);

		// out
		var bSent:Boolean = this.send("_xray_conn", "showMovieClipProperties", obj);
	}
	/**
     * @summary returns via localConnection the tooltip properties.  Hovering over a movieclip/button/textfield in the
	 * treeview will trigger the tooltip.  The call is identical to getMovieClipProperties, except, the return is
	 * sent to a different method in the interface
	 *
	 * @param sTarget_mc:String string path to the movieclip
	 * @param bShowAll:Boolean use ASSetPropFlags to show all properties and methods
	 *
	 * @return nothing
	 */
	public function getTipMovieClipProperties(sTarget_mc:String, bShowAll:Boolean):Void
	{
		// in
		var target_mc:MovieClip = eval(sTarget_mc);
		var obj:Object = this.objViewer.getProperties(target_mc, false);

		// out
		var bSent:Boolean = this.send("_xray_conn", "showTipMovieClipProperties", obj);
	}
	/**
     * @summary returns the properties of an object
	 *
	 * @param sObj:String full path to the object
	 * @param key:String when an actual intrinsic "Object" is being sent, then a property is sent along (aka "key") - ie obj._x : "_x" would be the key
	 *
	 * @return nothing
	 */
	public function getObjProperties(sObj:String, key:String):Void
	{
		// in

		var sTemp:Array = sObj.split(".");

		var target_obj:Object = eval(sTemp[0]);
		for(var x:Number=1;x<sTemp.length;x++)
		{
			target_obj = target_obj[sTemp[x]]
		}

		if(key) target_obj = target_obj[key];
		var obj:Object = this.objViewer.getObjProperties(target_obj);

		// out
		var bSent:Boolean = this.send("_xray_conn", "showMovieClipProperties", obj);
	}
	/**
     * @summary getFunctionProperties was written to retrieve Class properties and methods.  Since all Classes
	 * show up as type "Function" in the treeview and PI, I named it "getFunctionProperties"
	 *
	 * @param sObj:String full path to object
	 *
	 * @return nothing
	 */
	public function getFunctionProperties(sObj:String):Void
	{
		// in
		var target_obj:Object = eval(sObj);
		var obj:Object = this.objViewer.getFunctionProperties(target_obj);

		// out
		var bSent:Boolean = this.send("_xray_conn", "showMovieClipProperties", obj);
	}
	/**
     * @summary writes out the change history in the IDE's output panel
	 *
	 * @param obj:Object object containes all of the change history from the interface
	 *
	 * @return nothing
	 */
	public function writeChangeHistory(obj:Object):Void
	{
		var s:String = "//==========/[ CHANGES ]\============//"
		_global.trace(s);

		for(var items:String in obj)
		{
			if(typeof(obj[items]) == "object")
			{
				_global.trace(obj[items].changes  + ";");
			}
		}

		s = "//==========\\[ CHANGES ]/===========//"
		_global.trace(s);
	}
	/**
     * @summary executes commands (actionscript) from the interface.  When you want change properties of a movieclip/object etc
	 * you have to execute commands at runtime that aren't in the compiled SWF
	 *
	 * @param sExecute:String command to execute
	 *
	 * @return nothing
	 */
	public function executeScript(sExecute:String):Void
	{
		Commander.exec(sExecute);
	}
	/**
     * @summary retrieves the sound object's properties and returns them to the interface
	 *
	 * @param sSound:String path to sound object
	 *
	 * @return nothing
	 */
	public function getSoundProperties(sSound:String):Void
	{
		var obj:Object = this.objViewer.getSoundProperties(eval(sSound))
		var bSent:Boolean = this.send("_xray_conn", "setSoundProperties", obj);
	}
	/**
     * @summary retrieves the NetStream object's properties and returns them to the interface
	 *
	 * @param sNetStream:String path to NetStream object
	 *
	 * @return nothing
	 */
	public function getVideoProperties(sNetStream:String):Void
	{
		var obj:Object = this.objViewer.getVideoProperties(eval(sNetStream))
		var bSent:Boolean = this.send("_xray_conn", "setVideoProperties", obj);
	}
	/**
     * @summary plays the sound object specified.  If loops is included, that is passed along as well
	 *
	 * @param sSound:String path to sound object
	 * @param iLoops:Number number of loops to perform
	 *
	 * @return nothing
	 */
	public function playSound(sSound:String, iLoops:Number):Void
	{
		var snd:Sound = eval(sSound);
		snd.start(0,iLoops);
	}
	/**
     * @summary stops the sound object specified.
	 *
	 * @param sSound:String path to sound object
	 *
	 * @return nothing
	 */
	public function stopSound(sSound:String):Void
	{
		var snd:Sound = eval(sSound);
		snd.stop();
	}
	/**
     * @summary plays an FLV using the netStream object specified
	 *
	 * @param sVideo:String path to NetStream object
	 * @param flv:String relative url to the FLV file to play
	 *
	 * @return nothing
	 */
	public function playVideo(sVideo:String, flv:String):Void
	{
		var ns:NetStream = eval(sVideo);
		ns.play(flv);
	}
	/**
     * @summary pauses the NetStream object.
	 *
	 * @param sVideo:String path to video object
	 *
	 * @return nothing
	 */
	public function pauseVideo(sVideo:String):Void
	{
		var ns:NetStream = eval(sVideo);
		ns.pause();
	}
	/**
     * @summary stops the NetStream object specified.
	 *
	 * @param sVideo:String path to video object
	 *
	 * @return nothing
	 */
	public function stopVideo(sVideo:String):Void
	{
		var ns:NetStream = eval(sVideo);
		ns.close();
	}
	/**
     * @summary causes Flash's yellow selection rectangle to display around a movieclip
	 *
	 * @param sTarget_mc:String path to movieclip
	 *
	 * @return nothing
	 */
	public function highlightClip(sTarget_mc:String):Void
	{
		var target_mc:MovieClip = eval(sTarget_mc);

		this.focusEnabledCheck = target_mc.focusEnabled;
		target_mc.focusEnabled = true;
		_global.Selection.setFocus(sTarget_mc);
	}
	/**
     * @summary causes Flash's yellow selection rectangle to be removed
	 *
	 * @param sTarget_mc:String path to movieclip
	 *
	 * @return nothing
	 */
	public function lowlightClip(sTarget_mc:String):Void
	{
		var target_mc:MovieClip = eval(sTarget_mc);

		_global.Selection.setFocus(null);
		target_mc.focusEnabled = this.focusEnabledCheck;
	}
	/**
     * @summary applies a color transform (yellow) to a clip on stage and causes it to be dragable
	 *
	 * @param sTarget_mc:String path to movieclip
	 * @param iType:Number checking for a type of 2 (movieclip).  Had thought that later, I could figure out a way to highlight other objects
	 *
	 * @return nothing
	 */
	public function startExamineClips(sTarget_mc:String, iType:Number):Void
	{
		var target_mc:MovieClip = eval(sTarget_mc);
		// [TODO: review change moved definition of mc out of the if else block]
		var mc:MovieClip;

		if(iType == 5 || iType == 3)
		{
			// 5 is a textfield
			//var mc = target_mc._parent.createEmptyMovieClip("ATboundingBox", target_mc._parent.getNextHighestDepth());
			//mc._x = target_mc._x;
			//mc._y = target_mc._y;
		}else if(iType == 3)
		{
			// make dragable
			//DragableMovieClip.initialize(target_mc);
			//var mc = target_mc._parent.createEmptyMovieClip("ATboundingBox", target_mc._parent.getNextHighestDepth());
			//mc._x = target_mc._x;
			//mc._y = target_mc._y;

		}else if(iType == 2)
		{
			mc = target_mc;

			var colorObj:Object = this.highlightColor.getTransform();
			// [TODO: review change - defined myColorTransfor outside of if block]
			var myColorTransform:Object;

			if(colorObj && colorObj.rb == 81)
			{
				// if the color transform is already applied, we clear it
				myColorTransform = { ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0};

				// remove drag ability
				DragableMovieClip.remove(target_mc);
			}else
			{
				// make dragable
				DragableMovieClip.initialize(target_mc);

				// tint yellow
				myColorTransform = { ra: 100, rb: 81, ga: 100, gb: 56, ba: 100, bb: -57, aa: 100, ab: 0};
			}

			this.highlightColor = new Color(mc);
			this.highlightColor.setTransform(myColorTransform);
		}

		// when use clicks to turn off the highlight, this is what stopExamineClips will use
		this.boundingBox_mc = mc;

	}
	/**
     * @summary restores the movieclip to original color transform and removes the dragable code from the object
	 *
	 * @param sTarget_mc:String path to movieclip
	 * @param iType:Number represents what type of object this is (2 = movieclip)
	 *
	 * @return nothing
	 */
	public function stopExamineClips(sTarget_mc:String, iType:Number):Void
	{
		var target_mc:MovieClip = eval(sTarget_mc);

		// Create a color object called my_color for the target my_mc
		this.highlightColor = new Color(this.boundingBox_mc);
		// Create a color transform object called myColorTransform using
		// Set the values for myColorTransform
		var myColorTransform:Object = { ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0};
		// Associate the color transform object with the Color object
		// created for my_mc
		this.highlightColor.setTransform(myColorTransform);

		// remove drag ability
		DragableMovieClip.remove(target_mc);
	}
	/**
     * @summary Updates the change history object in the interface when an object is moved around on stage after making it dragable
	 *
	 * @param target_mc:MovieClip movieclip reference
	 *
	 * @return nothing
	 */
	public function updateHistory(target_mc:MovieClip):Void
	{
		var sTarget_mc = String(eval(target_mc._target));

		var obj:Object = new Object();
		var propsAry:Array = new Array("_x", "_y");

		// strip off the _level designation
		var aTemp:Array = sTarget_mc.split(".");
		aTemp.splice(0,1);
		sTarget_mc = aTemp.join(".");

		for(var x:Number=0;x<propsAry.length;x++)
		{
			var p = propsAry[x];
			var key = sTarget_mc + "." + p;
			var o = obj[key] = new Object();
			o.prop = p;
			o.value = target_mc[p];
			o.key = sTarget_mc + "." + p;
			o.sExecute = sTarget_mc + "." + p + " = " + target_mc[p];
		}

		// send back to interface to update the change history object
		var bSent:Boolean = this.send("_xray_conn", "updateHistory", obj);
	}
	public function allowDomain(sendingDomain:String):Boolean
	{
		// we want to allow all connections, so we say yes to anyone asking ;)
		return true;
	}
	public function onStatus(infoObject:Object):Void
	{
		switch (infoObject.level)
		{
		case 'status' :
		  break;
		case 'error' :
			break;
		}

	}
	/**
     * @summary This is called by Xray when the component loads.  It creates the listening connection
	 *
	 * @return Boolean false, and this means that another app is using the same localConnection name.  True otherwise
	 */
	public function initConnection():Boolean
	{
		// connection to fpsMeter
		this.fpsMeter = FPSMeter.getInstance();

		this.isConnected = this.connect("_xray_remote_conn");
		return this.isConnected;
	}
}