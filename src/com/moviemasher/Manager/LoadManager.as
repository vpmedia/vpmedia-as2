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



import flash.display.BitmapData;

/** MovieClip symbol manages loading of SWF and graphic files. 
See {@link com.moviemasher.Utility.LoadUtility} for CGI loading.
*/

class com.moviemasher.Manager.LoadManager extends MovieClip
{

// PUBLIC CLASS METHODS

	
	static function addOption(option : Object) : Void
	{
		var safe_key : String = 'local';
		if (option.url.substr(0, 7) == 'http://') 
		{
			option.server_url = com.moviemasher.Utility.StringUtility.homeFromURL(option.url);
			option.server = com.moviemasher.Utility.StringUtility.hostFromURL(option.server_url);
			safe_key = com.moviemasher.Utility.StringUtility.safeKey(option.server_url);
			if (option.policy.length) System.security.loadPolicyFile(option.policy);
		}
		if (__instances[safe_key] == undefined) 
		{
			option.requests = [];
			option.clip = undefined;
			__instances[safe_key] = option;	
		}
		else
		{
			for (var k in option)	
			{ 
				switch (k)
				{
					case 'requests':
					case 'clip': break;
					default: __instances[safe_key][k] = option[k];
				}
			}
		}
	}
	
	
	static function cacheBitmap(url : String, callback : com.moviemasher.Core.Callback) : Void
	{
		var url_ob : Object = __serverFromURL(url);
		
		url = __basedURL(url);
		var cache_callback = com.moviemasher.Core.Callback.factory('__didCachedBitmap', __instance, {url: url, url_ob: url_ob});
		var safe_url = com.moviemasher.Utility.StringUtility.safeKey(url);
		safe_url = safe_url.split('#');
		safe_url = safe_url[0];
		
		if (url_ob.requested[safe_url] == undefined) 
		{
			
			loadBitmap(url, cache_callback, {_name: safe_url, dont_delete: true});
			
			url_ob.requested[safe_url] = [];
		}
		url_ob.requested[safe_url].push(callback);
	
		
	}

	static function cachedBitmap(url : String, width : Number, height : Number) : BitmapData
	{
		var bm : BitmapData = undefined;
		
		var url_ob : Object = __serverFromURL(url);
		
		url = __basedURL(url);
		var safe_url = com.moviemasher.Utility.StringUtility.safeKey(url);
		safe_url = safe_url.split('#');
		var anchor = safe_url[1];
		safe_url = safe_url[0];
		
		if (url_ob.clip[safe_url]) 
		{
			bm = url_ob.clip.mcScaledBitmap(safe_url, width, height, anchor);
		}
	
		return bm;
	}
	
	static function loadBitmap(url : String, callback : com.moviemasher.Core.Callback, params : Object) : Void
	{
		var url_bits = url.split('#');
		var anchor = url_bits[1];
		url = url_bits[0];
		
		var url_ob : Object = __serverFromURL(url);
		url = __basedURL(url);
		//_global.app.msg('loadBitmap ' + url);
		
		var manager_callback = com.moviemasher.Core.Callback.factory('__loadedURL', __instance, {callback_ob: callback, url: url, url_ob: url_ob});
		var request_ob : Object = {url: url, callback: manager_callback};
		if (params != undefined) request_ob.params = params;
		
		if (! url_ob.clip) // we need to first load the loader.swf
		{
			url_ob.requests.push(request_ob);
			if (url_ob.requested == undefined)
			{
				url_ob.requested = {};
				__instance.__requestLoader(url_ob);
			}
		}
		else __loadURLs([request_ob], url_ob.clip);
	
	}
	
	static function nextHighestDepth(clip : MovieClip) : Number
	{
		if (! clip.__mm_nextHighestDepth) clip.__mm_nextHighestDepth = 0;
		clip.__mm_nextHighestDepth ++;
		return clip.__mm_nextHighestDepth;
	}
	
	static function setPaths(base : String, swf : String, remote : Boolean) : Void // sent from App on startup
	{
		__base = base;
		__swfBase = swf;
		__remote = remote;
	}
	static function setUpticks(n : Number) : Void // sent from App on setFPS
	{
		__upticks = n;
	}
	
	static function swf(url : String, callback : com.moviemasher.Core.Callback, onstage : Boolean) : Void
	{
		url = __basedURL(url, true);
		
		var clip_name = com.moviemasher.Utility.StringUtility.safeKey(url);
		
		if (! __loadingQueue[clip_name])
		{
			var container = __instance._parent;
			__loadingQueue[clip_name] = {};
			__loadingQueue[clip_name].mm_callbacks = [];
			var depth = container.getNextHighestDepth();
			__loadingQueue[clip_name].url = url;
			__loadingQueue[clip_name].onstage = onstage;
			
			//_global.app.msg(container + ' ' + depth);
			container.createEmptyMovieClip(clip_name, depth);
			container[clip_name].not_loaded = true
			
			if (__remote) System.security.allowDomain(url);
			
			container[clip_name].loadMovie(url);
			
			if (! __loadingInterval) 
			{
				__loadingInterval = setInterval(__instance, '__swfInterval', 1000);
			}
		}
		__loadingQueue[clip_name].mm_callbacks.push(callback);
	}
	
	
	static function swfLoaded(url : String) : MovieClip
	{
		url = __basedURL(url, true);
			
		var clip_name = com.moviemasher.Utility.StringUtility.safeKey(url);
		var mc : MovieClip;
		if (__loadingQueue[clip_name] && __loadingQueue[clip_name].mc)
		{
			 mc = __loadingQueue[clip_name].mc;
		}
		return mc;
		
	}

	static function get instance() { return __instance; }

// PUBLIC INSTANCE METHODS

	function getDomain() : String
	{
		return com.moviemasher.Utility.StringUtility.hostFromURL(__swfBase);
	}
	
	
	function loaderDidLoad(clip : MovieClip) : Void // sent by loader.swf when first loaded
	{
		var ob = __serverFromURL(clip._url);
		if (ob)
		{
			ob.clip = clip;
			clip._visible = true;
			__loadURLs(ob.requests, clip);
			ob.requests = [];
		}
	}

// PRIVATE CLASS PROPERTIES
	
	private static var __instance : LoadManager;
	private static var __instances : Object = {}; // avoids duplicate objects for same IDs
	private static var __loadedInterval : Number = 0;
	private static var __loadedQueue : Array = [];
	private static var __loadingInterval : Number = 0;
	 static var __loadingQueue : Object = {};	
	private static var __rootDepth : Number = 100;
	private static var __base : String = '';
	private static var __swfBase : String = '';
	private static var __remote : Boolean = false;
	private static var __upticks : Number = 20;
	
// PRIVATE CLASS METHODS

/** Return full URL for relative URL using _root.base.
@param url string containing URL
@param swf boolean true to use moviemasher.swf's directory
@return string full URL
*/

	static function __basedURL(url : String, swf : Boolean) : String
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
		//_global.app.msg('LoadManager.__basedURL ' + url);
		return url;
	}

	private static function __loadURLs(requests : Array, clip : MovieClip)
	{	
		var z = requests.length;
		var request : Object;
		for (var i = 0; i < z; i++)
		{
			request = requests[i];
			clip.loadURL(request.url, request.callback, request.params);
		}
	}

	private static function __serverFromURL(url : String)
	{
		if (url.substr(0, 7) != 'http://') return __instances.local;
		
		
		var url_ob : Object = undefined;
		var ob : Object;
		for (var k in __instances)
		{
			ob = __instances[k];
		
			if (ob.server_url == url.substr(0, ob.server_url.length))
			{
				url_ob = ob;
				break;
			}
		}
		if (! url_ob) url_ob = __instances.local;
		return url_ob;
	}

	
// PRIVATE INSTANCE PROPERTIES


// PRIVATE INSTANCE METHODS
	
	
	private function LoadManager()
	{
		__instance = this;
		__instances = {};
		
	}
	
	
	// params = {callback: callback_ob, url: url, url_ob: url_ob}
	// result = {clip: mc}
	private function __didCachedBitmap(result, params)
	{
		var safe_url = com.moviemasher.Utility.StringUtility.safeKey(params.url);
		safe_url = safe_url.split('#');
		safe_url = safe_url[0];
			
		var z = params.url_ob.requested[safe_url].length;
		for (var i = 0; i < z; i++)
		{
			params.url_ob.requested[safe_url][i].back(params.url);
		}
		params.url_ob.requested[safe_url] = true;
	}
	
	private function __intervalLoadedURL()
	{
		var z = __loadedQueue.length;
		
		var i = 0;
		var d : Date = new Date();
		
		var end_time = d.getTime() + (__upticks / 2);
		var params : Object;
		var bm : BitmapData;
		var url_ob : Object;
		for (; i < z; i++)
		{
			params = __loadedQueue[i]; 
			if (params.mc.dont_delete) params.callback_ob.back({clip: params.mc});
			else
			{
				url_ob = __serverFromURL(params.url);
				var w = params.mc._width;
				var h = params.mc._height;
				bm = url_ob.clip.mcBitmap(params.mc._name);
				if (bm)
				{
					params.callback_ob.back({bitmap: bm, width: w, height: h});
					params.mc.removeMovieClip();
				}
			}
			d = new Date();
			if (d.getTime() > end_time)
			{
				i++;
				break;
			}
		}
		if (i) __loadedQueue.splice(0, i);

		if (! __loadedQueue.length)
		{
			clearInterval(__loadedInterval);
			__loadedInterval = 0;
		}
	}
	
	
	private function __loadedURL(result, params) // {callback_ob: callback_ob, url: url, url_ob: url_ob}
	{
		params.mc = result;
		__loadedQueue.push(params);
		
		if (! __loadedInterval) __loadedInterval = setInterval(this, '__intervalLoadedURL', 250);
	}


	
	private function __requestLoader(ob)
	{
		var url = __basedURL(ob.url);
		System.security.allowDomain(url);
		
		var clip_name = 'mc_loader_' + depth;
		var container = this;
		var depth = Math.max(1, container.getNextHighestDepth());
		
	//	_global.app.msg(container + ' ' + depth);
		
		container.createEmptyMovieClip(clip_name, depth);
		container[clip_name].createEmptyMovieClip('loader_mc', 1);
		container[clip_name].owner = ob;
		container[clip_name].loader_mc.owner = ob;
		
		container[clip_name].loader_mc.loadMovie(url);		
	}
	


	private function __swfInterval()
	{
		var q : Object;
		var cbs : Array;
		var mc : MovieClip;
		var clip_name : String = 'none';
		var container = _parent;
			
		for (clip_name in __loadingQueue)
		{
			q = __loadingQueue[clip_name];
			if (! q.mc)
			{
				mc = container[clip_name];
				
				if (mc && (! mc.not_loaded) && (mc._framesloaded == mc._totalframes))
				{
					
					
					if (! q.onstage) mc._y = com.moviemasher.Utility.DrawUtility.offStage;
				
					
					q.mc = mc;
					//mc.app = _global.app;
					cbs = q.mm_callbacks;
					q.mm_callbacks = undefined;
					var z = cbs.length;
					for (var i = 0; i < z; i++)
					{
						
						if (cbs[i]) cbs[i].back(mc);
					}
				}
				
			}
		}
		// check to see if they're all loaded (there might be more in queue after callbacks)
		var all_loaded : Boolean = true;
		for (clip_name in __loadingQueue)
		{
			
			q = __loadingQueue[clip_name];
			if (! q.mc)
			{
				all_loaded = false;
				break;
			}
		}
		if (all_loaded)
		{
			clearInterval(__loadingInterval);
			__loadingInterval = 0;
		}
	}


}

