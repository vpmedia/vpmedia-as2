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



/** Abstract base class for all icon based controls.
*/
class com.moviemasher.Control.ControlIcon extends com.moviemasher.Control.Control
{
	
// PUBLIC INSTANCE PROPERTIES


/** Boolean determines whether or not the control can be clicked.
If not, the disicon graphic is used to draw the control.
The canDisable property must return true in order for this property to have an effect.
*/
	function get enabled() : Boolean { return __enabled; }
	function set enabled(b : Boolean)
	{
		if (__enabled != b)
		{
			__enabled = b;
			__update();
		}
	}
	
/** Boolean determines if this control is part of a selection group and is selected.
If so the selicon graphic is used to draw the control. Setting this property will
deselect the currently selected control.
*/
	function get selected() : Boolean { return __selected; }
	function set selected(b : Boolean)
	{
		if (__selected != b)
		{
			
			__selected = b;
			if (__selected && config.selection.length)
			{
				if (__selectedButtons[config.selection]) __selectedButtons[config.selection].selected = false;
				__selectedButtons[config.selection] = this;
			}
			__update();
		}
	}


// PUBLIC INSTANCE METHODS

	function createChildren() : Void
	{
		if (! __btns_mc) createEmptyMovieClip('__btns_mc', getNextHighestDepth());
		if (__bindBtn) __bindClip(__btns_mc);
		if (config.icon.length) __createIcon(__btns_mc, 'icon_mc', config.icon);
		if (config.overicon.length) __createIcon(__btns_mc, 'overicon_mc', config.overicon, true);
		if (config.disicon.length) __createIcon(__btns_mc, 'disicon_mc', config.disicon, true);
	
	}


	
	function initSize(dont_use_icon : Boolean) : Void
	{
		super.initSize();		
		if (! (config.width && config.height))
		{
			if ((! dont_use_icon) && config.icon.length) 
			{
				__clipBitmap(__btns_mc.icon_mc, config.icon, config.width, config.height);
				config[__dimName('', 'width')] = __btns_mc.icon_mc[__dimName('_', 'width')];
			}
		}
	}
	
	// one of my targets has changed a property
	function propertyChange(event : Object) : Void
	{
		
		if (__targets[event.property] == event.target)
		{
			if (config.selection.length) selected = (config[event.property] == event.value);
		}
	}
	
/** Simulate a click on this control. */
	function select() : Void
	{
		__release();
	}
	
	function setSize(w, h)
	{
		var h_prop = __dimName('', 'height');
		
		__iconSize = {width: 0, height: 0};
		__iconSize[h_prop] = config[h_prop];
		
		super.setSize(w, h);
	}

	function size() : Void
	{
		super.size();
	
		if (config.icon.length) 
		{
			__clipBitmap(__btns_mc.icon_mc, config.icon);
			if (config.overicon.length) __clipBitmap(__btns_mc.overicon_mc, config.overicon);
			if (config.disicon.length) __clipBitmap(__btns_mc.disicon_mc, config.disicon);
		}
		__sizeColor();
		__update();
		
	}
	
	
	
	
// PRIVATE CLASS PROPERTIES	
	
	private static var __selectedButtons : Object = {};



// PRIVATE INSTANCE PROPERTIES	

	private var __btns_mc : MovieClip;
	private var __enabled : Boolean = true;
	private var __iconSize : Object;
	private var __selected : Boolean = false;
	private var __bindBtn : Boolean = true;

// PRIVATE INSTANCE METHODS	

	private function ControlIcon()
	{
		if (config.angle == undefined) config.angle = 90;
		if (config.border == undefined) config.border = 0;
		if (config.bordercolor == undefined) config.bordercolor = 0;
		if (config.disicon.length) __canDisable = true;
		if (config.grad == undefined) config.grad = 0;
		
	}	
	
	private function __bindClip(clip : MovieClip)
	{
		clip.mmOwner = this;
		clip.onRollOver = function() { this.mmOwner.__rollOver(this); }
		clip.onRollOut = function() { this.mmOwner.__rollOut(this); }
		clip.onRelease = function() { this.mmOwner.__release(this); }
		clip.onReleaseOutside = function() { this.mmOwner.__releaseOutside(this); }
		clip.onPress = function() { this.mmOwner.__press(this); }
		clip.useHandCursor = false;
	}
	
	
	private function __cacheDidLoad()
	{
		__loadingThings--;
		if (! __loadingThings) __graphicsDidLoad();
	}

	private function __clipBitmap(clip : MovieClip, url : String, w : Number, h: Number)
	{
		if (w == undefined) w = __iconSize.width;
		if (h == undefined) h = __iconSize.height;
		
			
		var bm = _global.com.moviemasher.Manager.LoadManager.cachedBitmap(url, w, h);
		if (bm)
		{
			clip.attachBitmap(bm, 100);
		}
	}
	
	private function __createIcon(clip, name, path, hide)
	{
		if (! clip[name]) 
		{
			clip.createEmptyMovieClip(name, clip.getNextHighestDepth(), {_visible: (! hide)});
			
			
			var bm = _global.com.moviemasher.Manager.LoadManager.cachedBitmap(path, config.width, config.height);
			if (! bm) 
			{
				__loadingThings ++;
				_global.com.moviemasher.Manager.LoadManager.cacheBitmap(path, _global.com.moviemasher.Core.Callback.factory('__cacheDidLoad', this));
			}
		}
	}
	private function __dispatchPropertyChanged() : Void
	{
		dispatchEvent({type: 'propertyChanged', property: __property, value: config[__property]});
	}
	private function __graphicsDidLoad() : Void
	{
		dispatchEvent({type: 'loadingComplete'});
	}

	private function __press(mc : MovieClip) : Void
	{
	}
	
	
	private function __release(mc : MovieClip) : Void
	{
		
		if (! __enabled) return;
		if ((! __selected) && config.selection.length) selected = true;
		if (__property && ((! config.selection.length) || __selected)) 
		{
			__dispatchPropertyChanged();
		//	dispatchEvent({type: 'propertyChanged', property: __property, value: config[__property]});
		}
	}
	
	private function __releaseOutside(mc : MovieClip) : Void
	{
		if (! __enabled) return;
		__rollOut(mc);
	}


	private function __roll(tf : Boolean, prefix : String) //: Boolean
	{
		if (prefix == undefined) prefix = '';
		if (! enabled) tf = false;
		else if (! __btns_mc[prefix + 'icon_mc']._visible) tf = false;
		
		
		if (__btns_mc[prefix + 'overicon_mc']) __btns_mc[prefix + 'overicon_mc']._visible = tf;
	}
	private function __rollOut(mc : MovieClip)
	{
		if (! __enabled) return;
		__roll(selected);
	}

	private function __rollOver(mc : MovieClip)
	{
		if (_global.app.dragging) return;
		if (! __enabled) return;
		__roll(! selected);
	}
	private function __sizeColor() 
	{
		if (config.color != undefined)
		{
			var c = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.color);
			var my_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(config.bar.control, config);
			var x_pos = 0
			var y_pos = 0;
			var w = __width;
			var h = __height;
			
			if (config.horizontal)
			{
				y_pos -= config.bar.padding;
				h += config.bar.padding * 2;
				
				if ((my_index == 0))
				{
					w += config.bar.padding;
					x_pos -= config.bar.padding;
				}
				if (my_index == (config.bar.control.length - 1))
				{
					w += config.bar.padding;
				}
			}
			
			clear();
			if (config.border)
			{
				_global.com.moviemasher.Utility.DrawUtility.plot(this, x_pos, y_pos, w, h, _global.com.moviemasher.Utility.DrawUtility.hexColor(config.bordercolor))
				x_pos += config.border;
				y_pos += config.border;
				w -= (2 * config.border);
				h -= (2 * config.border);
			}
			
			if (config.grad)
			{
				c = _global.com.moviemasher.Utility.DrawUtility.buffedFill(w, h, c, config.grad, config.angle);
			}
			_global.com.moviemasher.Utility.DrawUtility.plot(this, x_pos, y_pos, w, h, c);
		}
	}

	private function __update(prefix : String)
	{
		if (prefix == undefined) prefix = '';
		if (__btns_mc[prefix + 'disicon_mc']) 
		{
			__btns_mc[prefix + 'disicon_mc']._visible = ! enabled;
			__btns_mc[prefix + 'icon_mc']._visible = enabled;
		}
		__roll(__selected || hitTest(_root._xmouse, _root._ymouse), prefix);
		if (selected && config.config.length)
		{
			 _global.app.requestConfiguration(config);
		}
	}
	
	



		
}