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



/*

This code appears on frame 5 of core/moviemasher.fla

*/


function init()
{
	stop();
	
	
	// override these parameters if set in the HTML
	Stage.align = 'TL';
	Stage.scaleMode = 'noscale';
	Stage.showMenu = false;
	
	// store reference to real root and its URL
	_global.root = this;
	if (_global.root.base == undefined) _global.root.base = '';
	_global.root.swfBase = com.moviemasher.Utility.StringUtility.pathFromURL(_global.root._url);
	
	
	// if preloader wasn't defined we'll use core/preloader.swf
	if (_global.root.preloader == undefined) _global.root.preloader = _global.root.swfBase + 'preloader.swf';
	
	// we won't load a preloader if parameter has been defined empty
	if (_global.root.preloader.length)
	{
		createEmptyMovieClip('anim_mc', 1);
		anim_mc.createEmptyMovieClip('mc', 1);
		
		var mcl = new MovieClipLoader();
		mcl.onLoadInit = function(mc : MovieClip)
		{
			mc._parent.onResize = function()
			{
				this._x = Math.round((Stage.width - this._width) / 2);
				this._y = Math.round((Stage.height - this._height) / 2);
				this._visible = ! ((this._x < 0) || (this._y < 0));
			}
		
			// Have stage alert anim clip when resized
			Stage.addListener(mc._parent);
			mc._parent.onResize();
		}
		System.security.allowDomain(_global.root.preloader);
		mcl.loadClip(_global.root.preloader, anim_mc.mc);
	}
	// load player by number so it can use buggy flash ComboBox
	loadMovieNum(_global.root.swfBase + 'player.swf', 2);
	
}

init();


