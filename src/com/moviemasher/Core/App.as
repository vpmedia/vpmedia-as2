/*
* The contents of this file are subject to the Mozilla Public
* License Version 1.1 (the "License"); you may not use this
* file except in compliance with the License. You may obtain a
* copy of the License at http://www.mozilla.org/MPL/
* 
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
* or implied. See the License for the specific language
* governing rights and limitations under the License.
* 
* The Original Code is 'Movie Masher'. The Initial Developer
* of the Original Code is Doug Anarino. Portions created by
* Doug Anarino are Copyright (C) 2007 Syntropo.com, Inc. All
* Rights Reserved.
*/



import mx.video.VideoPlayer; 
import flash.display.BitmapData;

/** MovieClip symbol loads and parses configuration, creating all panels.
The App class is bound to the App symbol of player.fla, which creates a single
instance during playback of its first frame.
The private constructor sets default options and requests configuration. 
Objects of this class are event dispatchers, but only the propertyChange event is broadcast.
<br>
TODO: move timing related options to panels tag?
*/

class com.moviemasher.Core.App extends MovieClip
{


/**	Boolean is true when a control is in the middle of a drag operation. */
	var dragging : Boolean = false; 

	

/** Number of pixels tall */
	function get height() : Number { return __height; }
	
/** Mash that's currently active (moviemasher.mash) */
	function get mash()  : com.moviemasher.Mash.Mash { return __mash; }
	function set mash(new_mash : com.moviemasher.Mash.Mash)
	{
		if (__mash != new_mash)
		{
			stopPlaying();
			
			if (com.moviemasher.Core.Panel.controls.timeline == undefined) new_mash.setValue('location', 0);
			__mash = new_mash;
			
			dispatchEvent({type: 'propertyChange', property: 'mash', value: __mash});
		}
	}
	

/** An object representation of all option tags in configuration. */
	var options : Object;


/** Number of pixels wide */
	function get width() : Number { return __width; }

	
/** Add handler for specified event.
See mx.events.EventDispatcher API for details.
@param event string containing event name
@param handler object or movieclip event handler
*/
	function addEventListener(event:String, handler) : Void {}

	
/** Return full URL for relative URL using _root.base.
@param url string containing URL
@param swf boolean true to use moviemasher.swf's directory
@return string full URL
*/

	function basedURL(url : String, swf : Boolean) : String
	{
		if (url.substr(0, 7) != 'http://')
		{
			var base = (swf ? __swfBase : __base);
			if (base.length)
			{
				if (url.substr(0, 3) == '../')
				{
					var url_a = url.split('/');
					url_a.shift();
					url = url_a.join('/');
					var base_a = base.split('/');
					base_a.pop();
					base_a.pop();
					base = base_a.join('/') + '/';
				}
				url = base + url;
			
			}
		}
		return url;
	}


/** Called as each panel's control graphics are all loaded. 
If all panels have loaded, panels are sized and displayed.
@param event string containing event name
*/
	function controlsComplete(event : Object) : Void
	{
		__loadingThings --;
		if (! __loadingThings) __controlsDidLoad();
		event.target.removeEventListener('controlsComplete', this);
	}
	
/** Broadcast event to handlers.
See mx.events.EventDispatcher API for details. 
@param event object with 'type' key equal to event name
*/
	function dispatchEvent(event : Object) : Void {}



/** Returns the frame time closest to supplied time.	
@param time floating point number of seconds
@return floating point number of seconds rounded to nearest frame time
*/
	function fpsTime(time : Number) : Number
	{
//		return Math.round(time * 1000) / 1000;
		return Math.round(time * options.video.fps) / options.video.fps;
	}



/** Creates or return scratch space for mash.
@param mash com.moviemasher.Mash.Mash object
@param prefix string to put before clip's name
@return an offscreen movie clip for mash to use as scratch space.
*/
	function mashClip(mash : com.moviemasher.Mash.Mash, prefix : String) : MovieClip
	{
		if (! prefix.length) prefix = '';
		var mash_name : String  = prefix + 'mash_' + mash.getValue('id');
		var mash_clip : MovieClip = __scratchpad_mc[mash_name];
		if (! mash_clip) 
		{
			var highest_depth = __scratchpad_mc.getNextHighestDepth();
			__scratchpad_mc.createEmptyMovieClip(mash_name, highest_depth);
			mash_clip = __scratchpad_mc[mash_name];
			
		}
		return mash_clip;
	}


/** Returns property of _root
@param key string property name
@return string value
*/
	function getValue(key : String) : String
	{
		
		return _global.root[key];
	}

/** Creates a debug message
@param s string message
*/
	function msg(s : String) : Void
	{
		_global.com.moviemasher.Control.Debug.msg(s);
	}



/** Create a new empty mash and make it active. */

	function newMash() : Void
	{
		//_global.com.moviemasher.Control.Debug.msg('newMash');
		var new_mash = com.moviemasher.Mash.Mash.factory();
		var dims;
		if (options.mash.width) dims = options.mash;
		else if (__mash) dims = __mash.dimensions;
		else dims = __optionDimensions();
		
		new_mash.setValue('width', dims.width);
		new_mash.setValue('height', dims.height);
		
		__mashes.addItem(new_mash);
		mash = new_mash;
	}

/** Indicates whether or not property is always defined
@param property string property name
@return true if property specified redefines
*/
	function propertyRedefines(property : String) : Boolean
	{
		return false;
	}


/** Remove handler for specified event.
See mx.events.EventDispatcher API for details. 
@param event string containing event name
@param handler object or movieclip event handler
*/
	function removeEventListener(event:String, handler) : Void  {}

	
	
/** Requests additional configuration if needed.
@param config object with URL value in 'config' key
@param dont_force boolean will load if false and first time call for this url
@param callback CallbackUtility object if something should be done after configuration loaded
*/
	function requestConfiguration(config : Object, dont_force : Boolean, callback : com.moviemasher.Core.Callback)
	{
		if (config.items == undefined) config.items = [];
		if (! dont_force) config.lazy = false;
		if (! __includeConfig(config, com.moviemasher.Core.Callback.factory('__mediaDidLoad', this, config, callback)))
		{
			if (callback) callback.back();
		}
	}

	
	
/** Attach a new bitmap graphic to the mouse.
@param bm bitmap data
*/
	function setCursor(bm : BitmapData, off_x : Number, off_y : Number) : Void
	{
		
		if (__cursorBitmap != bm)
		{
			__cursorBitmap = bm;
			if (__cursorBitmap)
			{
				Mouse.hide();
				if (! __cursor_mc)
				{
					var container = _parent;
					
					var d = container.getNextHighestDepth();
			//		msg('setCursor ' + d);
					container.createEmptyMovieClip('__cursor_mc', d);
					__cursor_mc = container.__cursor_mc;
					__cursor_mc.createEmptyMovieClip('mc', 1);
					__cursor_mc.onMouseMove = function()
					{
						if (this._visible)
						{
						//	_global.app.msg('onMouseMove cursor ' + _root._xmouse + ' ' + _root._ymouse);
							this._x = _root._xmouse;
							this._y = _root._ymouse;
							updateAfterEvent();
						}
					}
				}
				
				__cursor_mc.mc.attachBitmap(bm, 1);
				__cursor_mc.mc._x = - ((__cursor_mc._width / 2) - (off_x ? Number(off_x) : 0));
				__cursor_mc.mc._y = - ((__cursor_mc._height / 2) - (off_y ? Number(off_y) : 0));
				__cursor_mc._visible = true;
				__cursor_mc.onMouseMove();
			}
			else
			{
				Mouse.show();
				__cursor_mc._visible = false;
				__cursor_mc.mc.createEmptyMovieClip('mc', 1);
				__cursor_mc.removeMovieClip();
				__cursor_mc = undefined;
				
			}
		}
	}
	
/** Called when stage resized, sets dimensions and calls size().
See Include/player.as for the stage binding code.
@param w number of pixels wide
@param h number of pixels tall
*/
	function setSize(w : Number, h : Number) : Void
	{
		__width = w;
		__height = h;
		size();
	}

/** Called from setSize(), currently does nothing. */

	function size() : Void
	{

	}
	
/** Call this function when a mash starts playing to have it pause the next time it's called.
@param clip movieclip with cancelPlay method
*/
	function startPlaying(clip : MovieClip) : Void
	{
		stopPlaying();
		__playingClip = clip;
	}
	
	
/** Stops any currently playing mash. */

	function stopPlaying() : Void // sent from _root when SetVariable('paused') called from javascript in response to paused event
	{
		if (__playingClip != undefined) __playingClip.cancelPlay();
		__playingClip = undefined;
	}
	
	
	
/** Called as each panel's swf controls are all loaded. 
If all panels have loaded, panel controls are instanced and initialized.
@param event string containing event name

*/
	function swfComplete(event : Object) // sent when each panel's SWF is loaded
	{
		__loadingThings --;
		if (! __loadingThings) __swfsDidLoad();
		event.target.removeEventListener('swfComplete', this);
	}
	
	
	// PRIVATE INTERFACE
	
	private static var __base : String;
	private static var __swfBase : String;
	private static var __needsNCManager : mx.video.NCManager; 
	
	private static var __needsMediaVideo : com.moviemasher.Media.Video;
	private static var __needsMediaAudio : com.moviemasher.Media.Audio;
	private static var __needsMediaEffect : com.moviemasher.Media.Effect;
	private static var __needsMediaImage : com.moviemasher.Media.Image;
	private static var __needsMediaTheme : com.moviemasher.Media.Theme;
	private static var __needsMediaTransition : com.moviemasher.Media.Transition;

	private static var __needsItemVideo : com.moviemasher.Clip.Video;
	private static var __needsItemAudio : com.moviemasher.Clip.Audio;
	private static var __needsItemEffect : com.moviemasher.Clip.Effect;
	private static var __needsItemImage : com.moviemasher.Clip.Image;
	private static var __needsItemTheme : com.moviemasher.Clip.Theme;
	private static var __needsItemTransition : com.moviemasher.Clip.Transition;
	
	private static var __madeEventDispatcher : Boolean = false;
	
	private static var symbolName : String = 'App';
	private static var symbolOwner : Object = com.moviemasher.Core.App;
	
	
	private var __width : Number = 0;
	private var __height : Number = 0;
	
	private var __playingClip : MovieClip;
	
	private var __cursorBitmap : BitmapData;
	private var __cursor_mc : MovieClip;
	
	private var __didCreatePanels : Boolean = false;
	private var __panels : Array; 
	private var __mashes : Array;
	
	private var __loadingThings : Number = 0;		
	
	
	private var __mash : com.moviemasher.Mash.Mash;
	
	private var __scratchpad_mc : MovieClip;
	
	

	private function App()
	{
		_global.app = this;
		
		if (! __madeEventDispatcher)
		{
			__madeEventDispatcher = true;
			mx.events.EventDispatcher.initialize(com.moviemasher.Core.App.prototype);
		}
		
		_global.root.anim_mc.mc.setProgress(40);
		
		var pausedWatcher:Function = function(prop, oldVal, newVal) 
		{
			com.moviemasher.Core.Panel.controls.player.paused = Boolean(newVal);
			return newVal;
		}
		_global.root.watch('paused', pausedWatcher);
		
		
		
		com.moviemasher.Core.Panel.controls.moviemasher = this;
		mx.controls.listclasses.DataProvider.Initialize(Array);
		
		
		__panels = [];
		__mashes = [];
		
		options = {servers: []};
		
		options.module = {remote: 0};
		
		options.audio = {dataFields: {start: true, track: true, volume: true}, color: '999966', grad: 40, angle: 90};
		options.transition = {dataFields: {length: true, freeze: true}, color: '996666', grad: 40, angle: 90};
		options.video = {dataFields: {trim: true, speed: true}, color: '669999', grad: 40, angle: 90};
		options.image = {dataFields: {length: true}, color: '669966', grad: 40, angle: 90};
		options.theme = {dataFields: {length: true}, color: '666699', grad: 40, angle: 90};
		options.effect = {dataFields: {start: true, track: true, length: true}, color: '996699', grad: 40, angle: 90};

		options.mash = {width:320, height: 240, dataFields: {zoom: true, location: true}, id: _global.com.moviemasher.Utility.StringUtility.safeKey(_global.root.config)}; // id is for saving local mash
		options.clip = {dataFields: {label: true}};
		setFPS(10);
		
		options.loadedURLs = {};
		
		createEmptyMovieClip('__scratchpad_mc', getNextHighestDepth());
		__scratchpad_mc._y = com.moviemasher.Utility.DrawUtility.offStage;
		
		__base = _global.root.base;
		__swfBase = _global.root.swfBase;
		
		if (_global.root.policy.length) System.security.loadPolicyFile(_global.root.policy);
		__includeConfig({config: _global.root.config});
		
	}

	
	private function __flushMonitor() : Void
	{
		var available_ticks = com.moviemasher.Media.Media.flush(500, options.upticks);
		if (available_ticks > 0)
		{
			var d = new Date();
			d = new Date();
			var unticks : Number = 5;
			com.moviemasher.Clip.Clip.flush(d.getTime() - (1000 * unticks), available_ticks);
		}
	}
	private function setFPS(new_fps) 
	{
		if (new_fps != undefined) options.video.fps = new_fps;
		options.frameticks = 1000 / options.video.fps;
		options.frametime = 1 / options.video.fps;
		options.halfframetime = options.frametime / 2;
		options.upticks = options.frameticks / 2;
		com.moviemasher.Manager.LoadManager.setUpticks(options.upticks);
		if (__mash) __mash.invalidateLength('video', true);
		
	}
	
	private function __mediaParse(node : XMLNode) : com.moviemasher.Media.Media // called for each 'media' tag
	{
		var media_ob : com.moviemasher.Media.Media = com.moviemasher.Media.Media.fromXML(node);
		
		if (media_ob.isModular())
		{
			requestConfiguration(node.attributes.config); // themes, transitions and effects sometimes load media
			var z = node.childNodes.length;
			for (var i = 0; i < z; i++)
			{
				if (node.childNodes[i].nodeName == 'media') __mediaParse(node.childNodes[i]); // recurse down
			}	
		}
		return media_ob;
	}
	
	private function __mashParse(node : XMLNode) // called for each 'mash' tag
	{
		__includeConfig(node.attributes); // mashes can load config files
		__mashes.addItem(node);//.cloneNode(true));
		
	}

	private function __optionParse(node : XMLNode) // called for each 'option' tag
	{
		var a : Array;
		switch (node.attributes.type)
		{
			case 'font':
			{
				com.moviemasher.Manager.FontManager.addOption(node.attributes);
				break;
			}
			case 'server':
			{
				com.moviemasher.Manager.LoadManager.addOption(node.attributes);
				break;
			}
			default:
			/*
			case 'video':
			case 'audio':
			case 'image':
			case 'transition':
			case 'effect':
			case 'theme':
			case 'mash':
			case 'clip':
			*/
			{
				for (var attribute in node.attributes)
				{
					if (attribute == 'type') continue;
					if (attribute == 'attributes')
					{
						a = node.attributes.attributes.split(',');
						var z = a.length;
						if (z)
						{
							for (var i = 0; i < z; i++)
							{
								options[node.attributes.type].dataFields[a[i]] = true;
							}							
						}
					}
					else 
					{
						if (options[node.attributes.type] == undefined) options[node.attributes.type] = {};
						options[node.attributes.type][attribute] = com.moviemasher.Utility.XMLUtility.flashValue(node.attributes[attribute]);
					}
				}
				break;
			}
		}		
	}
	
	
	
	private function __panelsParse(node : XMLNode) // called for each 'panels' tag
	{
		
		var panel_node = XMLNode;
		var y : Number;
		var z : Number = node.childNodes.length;
		var x : Number;
		var v : Number;
		var bar : Object;
		var panel : Object;
		var control: Object;
		var add_to_panels : Boolean = ! __panels.length;
		var xml_node : XMLNode;
		for (var i = 0; i < z; i++)
		{
			panel_node = node.childNodes[i];
			if (! _global.com.moviemasher.Control.Debug.isFalse(panel_node.nodeName == 'panel', "Tag '" + panel_node.nodeName + "' not allowed in tag 'panels'"))
			{
				panel = com.moviemasher.Utility.XMLUtility.data(panel_node);
				y = panel.bar.length;
						
				for (var j = 0; j < y; j++)
				{
					bar = panel.bar[j];
					x = bar.control.length;
					for (var k = 0; k < x; k++)
					{
						control = bar.control[k];
						control.items = [];
						if (control.config.length) requestConfiguration(control, true); // doesn't force loading
						
						
						v = control.media.length;
						if (v)
						{
							for (var l = 0; l < v; l++)
							{
								xml_node = new XMLNode();
								for (var k in control.media[l])
								{
									xml_node.attributes[k] = control.media[l][k];
								}
								
								control.items.push(__mediaParse(xml_node));
							}
						}
					}
				}
				if (add_to_panels) __panels.push(panel);
			}
		}
	}

	private function __moviemasherParse(mm_node : XMLNode) // called for first 'panels' tag only
	{
	
		var y : Number;
		var node : XMLNode;
		var media : Array; // list of media items created from tags just inside 'moviemasher' tags
		var result;
		var results : Array = [];
		
		
		mm_node.attributes.lazy = false; // 'moviemasher' tag has no 'lazy' attribute
		y = mm_node.childNodes.length;
		for (var j = 0; j < y; j++)
		{
			node = mm_node.childNodes[j];
			result = this['__' + node.nodeName + 'Parse'](node);
			
			if (result)
			{
				if (node.nodeName == 'moviemasher') results = results.concat(result);
				else results.push(result);
			}
		}
		__includeConfig(mm_node.attributes);
		setFPS(); // in case options were changed
		
		return results;
	}
	
	
	private function __configDidLoad(x, call_back) // send XML with one or more 'moviemasher' tags 
	{
		
		__loadingThings--;
		
		var mm_node : XMLNode = com.moviemasher.Utility.XMLUtility.findNode(x, 'moviemasher');
		if (! _global.com.moviemasher.Control.Debug.isFalse(Boolean(mm_node), "No 'moviemasher' tag in " + x.mm_url))
		{
			var results : Array = __moviemasherParse(mm_node);
			if (! __loadingThings) 
			{
				if (! __didCreatePanels)
				{
					//_global.com.moviemasher.Control.Debug.msg('Configuration loaded');
					__didCreatePanels = true;
					

					__createPanels();
				}
			}
			if (call_back) call_back.back({media: results});
			return results;
		}
		
	}
	
	

	private function __includeConfig(attributes : Object, call_back : com.moviemasher.Core.Callback) : Boolean
	{
		
		var safe_key : String;
		var loading : Boolean = false;
		if (attributes.config.length) // url specified
		{
			var url = basedURL(attributes.config);
			safe_key = _global.com.moviemasher.Utility.StringUtility.safeKey(url);
			if (! options.loadedURLs[safe_key]) // it has not yet been requested
			{
				if (! attributes.lazy) // needs to be preloaded (all 'moviemasher' tags)
				{
					options.loadedURLs[safe_key] = true;
					__loadingThings ++;
					
					com.moviemasher.Utility.LoadUtility.cgi(com.moviemasher.Core.Callback.factory('__configDidLoad', this, call_back), url);
					loading = true;
				}
			}
		}
		return loading;
	}
	private function __mediaDidLoad(results, config : Object, call_back : com.moviemasher.Core.Callback)
	{
		
		var media = results.media;
		var z = media.length;
		
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				config.items.push(media[i]);
			}
			//_global.com.moviemasher.Control.Debug.msg('added ' + z + ' to make ' + config.items.length);
			config.items.dispatchEvent({type: 'modelChanged', eventType: 'updateAll'});
		}
		if (call_back) call_back.back(results);
	}	
		
	private function __createPanels()
	{
		_global.root.anim_mc.mc.setProgress(70);
		com.moviemasher.Manager.LoadManager.setPaths(__base, __swfBase, options.module.remote);
		
		var config;
		var i : Number, z : Number;
		z = __panels.length;
		
		for (i = 0; i < z; i++)
		{
			// instance each panel from parsed config
			config = __panels[i];
			config.panel = __createPanel(config);
		}
		if (! __loadingThings) __swfsDidLoad();
	}
	
	private function __createPanel(ob : Object)
	{
		var highest_depth = getNextHighestDepth();
		//_global.com.moviemasher.Control.Debug.msg('panel depth = ' + highest_depth);
		
		var panel : com.moviemasher.Core.Panel; 
		var clip_name = 'symbol_panel_' + highest_depth + '_mc';
			
		attachMovie('Panel', clip_name, highest_depth, {config: ob});
		panel = this[clip_name];
		panel.callControls('loadControlSource', panel);

		if (panel.isLoading())
		{
			__loadingThings ++;
			panel.addEventListener('swfComplete', this);
		}
		return panel;
	}
	
	
	private function __swfsDidLoad() // sent once when all the swfs needed by panels have loaded
	{
		_global.root.anim_mc.mc.setProgress(95);

		var panel : MovieClip;
		var i : Number, z : Number;
		z = __panels.length;
		_global.root.msg = '__swfsDidLoad';
		
		//_global.com.moviemasher.Control.Debug.msg('instanceControl');
		for (i = 0; i < z; i++)
		{
			// instance all the controls in panel
			__panels[i].panel.callControls('instanceControl', __panels[i].panel);
		}
		//_global.com.moviemasher.Control.Debug.msg('targetControl');
		for (i = 0; i < z; i++)
		{
			// have panel set targets for its controls
			__panels[i].panel.callControls('targetControl', __panels[i].panel);
		}
		//_global.com.moviemasher.Control.Debug.msg('initBindings');
		for (i = 0; i < z; i++)
		{
			// tell each control its target exists
			__panels[i].panel.callControls('initBindings', __panels[i].panel);
		}
		//_global.com.moviemasher.Control.Debug.msg('initControl');
		for (i = 0; i < z; i++)
		{
			panel = __panels[i].panel;
			panel.callControls('initControl', panel);
		
			if (panel.isLoading())
			{
				__loadingThings ++;
				panel.addEventListener('controlsComplete', this);
			}
		}
		if (! __loadingThings) __controlsDidLoad();
	}
	
	
	private function __controlsDidLoad() // sent once when all the control graphics in panels have loaded
	{
		_global.root.msg = '__controlsDidLoad';
		
		var z = __panels.length;
		var panel : MovieClip;
		//_global.com.moviemasher.Control.Debug.msg('initSize');
		for (var i = 0; i < z; i++)
		{
			__panels[i].panel.callControls('initSize');
		}
		//_global.com.moviemasher.Control.Debug.msg('sizeControls');
		for (var i = 0; i < z; i++)
		{
			__panels[i].panel.sizeControls();
		}
		//_global.com.moviemasher.Control.Debug.msg('selectControls');
		for (var i = 0; i < z; i++)
		{
			panel = __panels[i].panel;
			panel.selectControls();
		}
		_global.root.anim_mc.removeMovieClip();
		if (! Key.isDown(Key.SHIFT)) 
		{
			var lso : SharedObject = SharedObject.getLocal(_global.com.moviemasher.Utility.StringUtility.safeKey(options.mash.id));
			if (lso.data.mash.length) 
			{
				var mash_xml = new XML();
				mash_xml.parseXML(lso.data.mash);
				mash_xml = mash_xml.firstChild;
				__mashes.addItemAt(0, mash_xml);
			}
		}
		
		z = __mashes.length;
		if (z) 
		{
			var safe_key;
			var did_mashes = {};
			var new_mashes = [];
			var new_mash;
			for (var i = 0; i < z; i++)
			{
				new_mash = __mashes[i];
				//_global.com.moviemasher.Control.Debug.msg('reading in ' + new_mash.attributes.id);
				
				new_mash = com.moviemasher.Mash.Mash.fromXML(new_mash);
				safe_key = _global.com.moviemasher.Utility.StringUtility.safeKey(new_mash.getValue('id'));
				if (! did_mashes[safe_key])
				{
					did_mashes[safe_key] = true;
					new_mashes.push(new_mash);
				}
			}
			__mashes = new_mashes;
		}
		z = __mashes.length;
		if (z) mash = __mashes[0];
		else newMash(); 
		setInterval(this, '__flushMonitor', 5000);
	}
	/** Object with width and height keys populated by player or mash dimensions */
	private function __optionDimensions() : Object 
	{
		var dims = {};
		if (com.moviemasher.Core.Panel.controls.player)
		{
			dims.width = com.moviemasher.Core.Panel.controls.player.getValue('width');
			dims.height = com.moviemasher.Core.Panel.controls.player.getValue('height');
		}
		else dims = options.mash;
		
		return dims;
	}

}


