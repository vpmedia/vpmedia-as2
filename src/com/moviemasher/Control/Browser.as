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



/** Panel control symbol displays a scrollable view of {@link com.moviemasher.Media.Media} objects.
TODO: item selection and editing.
*/
class com.moviemasher.Control.Browser extends com.moviemasher.Control.ControlPanel
{


// PUBLIC INSTANCE PROPERTIES
	
	
	function get dataProvider() : Object { return __dataProvider; }
	function set dataProvider(dp : Object) : Void
	{
		if (__dataProvider) __dataProvider.removeEventListener('modelChanged', this);
		__dataProvider = dp;
		if (__dataProvider) __dataProvider.addEventListener('modelChanged', this);
		modelChanged({target: __dataProvider});
	}
		
	function get mash() : Object { return __mash; }
	function set mash(new_mash : Object) : Void
	{
		__mash = new_mash;
		if (__mash) 
		{
			size();
			if (__watchedProperties.mash) dispatchEvent({type: 'propertyChange', property: 'mash', value: __mash});
			__startDrawing(1000);
		}
	}

	function get selectedItem() { return __selectedItems[__selectedItems.length - 1]; }
	function get selectedItems() { return __selectedItems; }
	function set selectedItems(a : Array)  : Void
	{
	
		var id_name : String;
		var was_selected : Object = {};
		var is_selected : Object = {};
		var z = __selectedItems.length;
		var old_length = z;
		for (var i = 0; i < z; i++)
		{
			id_name = 'id_' + __selectedItems[i].getValue('id');
			was_selected[id_name] = __selectedItems[i];
		}
		__selectedItems = a;
		
		z = __selectedItems.length;
		
		var add_selected : Array = [];
		var remove_selected : Array = [];
		for (var i = 0; i < z; i++)
		{
			id_name = 'id_' + __selectedItems[i].getValue('id');
			is_selected[id_name] = __selectedItems[i];
			if (was_selected[id_name] == undefined) add_selected.push(is_selected[id_name]);
		}
		for (var k in was_selected)
		{
			if (is_selected[k] == undefined) remove_selected.push(was_selected[k]);
		}
		if (add_selected.length) _global.com.moviemasher.Utility.MashUtility.changeValues(add_selected, 'selected', 1);
		if (remove_selected.length) _global.com.moviemasher.Utility.MashUtility.changeValues(remove_selected, 'selected', 0);	
	}

	function get vScroll() : Number { return __vScroll;}
	function set vScroll(n : Number) : Void
	{
		if (! isNaN(n))
		{
			__vScroll = n;
			if (__scrollsNeeded.v) dispatchEvent({type: 'propertyChange', size: __contentSize.vsize, property: 'vscroll', value: (__vScroll * 100) / __contentSize.height});
		}
	}

// PUBLIC INSTANCE METHODS
	
	function createChildren() : Void
	{
		super.createChildren();
		createTextField('__field_mc', getNextHighestDepth(), 0, 0, 100, 100);
		__field_mc.selectable = false;
		__field_mc._visible = false;
		
		var custom_font : Object = _global.com.moviemasher.Manager.FontManager.fontFromID(config.font);
		if (custom_font) 
		{
			if (! custom_font.hasLoaded)
			{
				_global.com.moviemasher.Manager.FontManager.requestFont(config.font, _global.com.moviemasher.Core.Callback.factory('__fontDidLoad', this))
				__loadingThings++;
			}
			else 
			{
				_global.com.moviemasher.Control.Debug.msg('Browser.createChildren ' + config.font + ' was loaded');
				custom_font = undefined;
			}
		}
		if (! custom_font) __fontDidLoad(); // sending undefined so __didLoad not called
		
	}

	
	function initSize() : Void
	{
		if (! config[(config.horizontal ? 'width' : 'height')]) __makeFlexible(config.horizontal);		
		super.initSize();
	}

	function makeConnections() : Void
	{
		super.makeConnections();
		if (__watchedProperties.items) dispatchEvent({type: 'propertyRedefined', property: 'items', defined: true, value: []});
		else __changeProperty(true, 'items', config.items);
		
	}
	
	// sent when current provider changes (lazy items probably just downloaded)
	
	function modelChanged(event : Object) : Void
	{
		switch (event.target)
		{
			case __dataProvider:
			{
				__vScrollReset();
				break;		
			}	
		}
	}
	

/** Notice that a {@link com.moviemasher.Control.BrowserPreview} object has been pressed.
@param item {@link com.moviemasher.Clip.Clip} object that's previewed.
@param mc {@link com.moviemasher.Control.BrowserPreview} MovieClip that was pressed.
*/	
	function pressedClip(item : Object, mc : MovieClip) : Void
	{
		var pt = {x: 0, y: 0};
		localToGlobal(pt);
		var offset = {};
		offset.x = mc._xmouse + (mc._width / 2);
		offset.y = mc._ymouse + (mc._height / 2);
		
		com.moviemasher.Utility.DragUtility.begin([item.clone()], {itemOffset: offset, bitmapOrigin: pt, bitmap: __itemsBitmap([item]), _x: _root._xmouse, _y: _root._ymouse});//{_x: Math.min(_xmouse, iconWidth), _y: Math.min(_ymouse, iconHeight)});
		
	}
	
	// one of my targets has changed a property
	function propertyChange(event : Object) : Void
	{
		if (__targets[event.property] == event.target)
		{
			switch(event.property)
			{
				case 'mash':
				{
					mash = event.value;
					break;
				}
			}
		}
	}

	function propertyRedefines(property : String) : Boolean
	{
		var property_redefines : Boolean = false;
		switch(property)
		{
			case 'vscroll':
			case 'hscroll':
			{
				property_redefines = true;
				break;
			}
		}
		return property_redefines;
	}
	
	function size() : Void
	{
		
		super.size();
		
		var dims = __mash.dimensions;
		
		__frameW = config.framewidth;
		
		var inner_width = (width - (2 * config.padding));
		__columns = Math.floor(inner_width / config.framewidth);
		if (((__columns * config.framewidth) + ((__columns - 1) * config.spacing)) > inner_width) __columns --;
		
		__frameH = Math.round(config.framewidth * (dims.height / dims.width));
		
		if (config.textsize && ((config.textvalign == 'above') || (config.textvalign == 'below')))
		{
			__frameH += __field_mc.textHeight + 4;
		}

		__needsResize = true;
		__vScrollReset();
		
	}
	

	
// PRIVATE INSTANCE PROPERTIES

  	private var __columns : Number;
	private var __dataProvider : Object;
	private var __field_mc;
	private var __frameH : Number;
	private var __frameW : Number;
	private var __lastLocation : Number;
	private var __list_mc : MovieClip;
	private var __mash;
	private var __needsResize : Boolean = false;
	private var __selectedItems : Array;
	private var __vScroll : Number = 0;
	
 	
// PRIVATE INSTANCE METHODS
	private function Browser()
	{
		
		if (config.attributes == undefined) config.attributes = 'moviemasher.mash';
		if (config.border == undefined) config.border = 1;
		if (config.bordercolor == undefined) config.bordercolor = 0;
		if (config.font == undefined) config.font = 'default';
		else config.font = String(config.font);
		if (config.frameborder == undefined) config.frameborder = 1;
		if (config.framebordercolor == undefined) config.framebordercolor = 0;
		if (config.framewidth == undefined) config.framewidth = 120;
		if (config.id == undefined) config.id = 'browser';
		if (config.padding == undefined) config.padding = 6;
		if (config.spacing == undefined) config.spacing = 6;
		if (config.textalign == undefined) config.textalign = 'left';
		if (config.textbackalpha == undefined) config.textbackalpha = 50;
		if (config.textbackcolor == undefined) config.textbackcolor = 'FFFFFF';
		if (config.textcolor == undefined) config.textcolor = '333333';
		if (config.textsize == undefined) config.textsize = 12;
		if (config.textvalign == undefined) config.textvalign = 'bottom';
	/*  Not used yet...
		if (config.hilite == undefined) config.hilite = 1;
		if (config.hilitecolor == undefined) config.hilitecolor = 'FFFF00';
		if (config.hilitecolor == undefined) config.textcolor = 'FFFFFF';
	*/
		__contentSize = {width: 0, height: 0};
		__drawContinuously = Boolean(config.animate);
	}
	
	private function __changeProperty(finished : Boolean, property : String, value) : Void
	{
		switch(property)
		{
			case 'items':
			{
				dataProvider = value;
				break;
			}
			case 'vscroll':
			{
				if (__scrollsNeeded.v) __scrollTo(false, Math.round((value * __contentSize.height) / 100), true);
				break;
			}
			case 'hscroll':
			{
				if (__scrollsNeeded.h) __scrollTo(true, Math.round((value * __contentSize.width) / 100), true);
				break;
			}
		}
	}
	
	
	private function __drawClips() : Void
	{
		if (! (__frameW && __frameH)) return;
		__stopDrawing();
		var new_clips = {};
		
		var x_pos : Number = config.padding;
		var y_pos : Number = config.padding - vScroll;
		var icon_height : Number = __frameH + (2 * config.border);
		var half_icon_height = icon_height / 2;
		
		var icon_width : Number = __frameW + (2 * config.border);
		var half_icon_width = icon_width / 2;
		var index : Number = 0;
		var item : Object;
		var item_name : String;
		var row_visible : Boolean;
		var provider_length = __dataProvider.length;
		
		var rows = Math.ceil(provider_length / __columns);
		var mc;
		for (var row = 0; row < rows; row++)
		{
			row_visible = ( ! ( ((y_pos + icon_height) < 0) || (y_pos > height) ) );
			//_global.com.moviemasher.Control.Debug.msg('row ' + row + ' visible = ' + row_visible);
			for (var i = 0; (i < __columns) && (index < provider_length); i++)
			{
				item = __dataProvider.getItemAt(index);
				
				index++;
				item_name = 'id_' + item.getValue('id');
				if (row_visible) 
				{
						
					if (! __createdClips[item_name])
					{
						//_global.com.moviemasher.Control.Debug.msg('create ' + item_name);
						com.moviemasher.Control.BrowserPreview.createClip(__clips_mc, item, config, this, __frameW, __frameH);
						
					}
					else 
					{
						if (__needsResize) __createdClips[item_name].setSize(__frameW, __frameH);
						__createdClips[item_name] = false;
					}
					mc = __clips_mc[item_name];
					new_clips[item_name] = mc;
					
					
					mc._x = x_pos + half_icon_width;
					mc._y = y_pos + half_icon_height;
					x_pos += icon_width + config.spacing;
					
				}
			}
			y_pos += icon_height + config.spacing;
			x_pos = config.padding;
		}
		for (var k in __createdClips)
		{
			if (__createdClips[k] && (! new_clips[k])) 
			{
				//_global.com.moviemasher.Control.Debug.msg('remove ' + k);
				__createdClips[k].clearPreview();
				
			}
		}
		
		__createdClips = new_clips;
		__needsResize = false;
		__startDrawing(1000);
		
	}
	
	
	private function __fontDidLoad(font_ob : Object) : Void
	{
		var tf = _global.com.moviemasher.Manager.FontManager.textFormat(config.font, config);
		__field_mc.embedFonts = tf.embedFonts;
		__field_mc.setNewTextFormat(tf);
		__field_mc.text = 'jk';
		if (font_ob != undefined) __didLoad(undefined, 'loadingComplete');
	}
	

	private function __shouldDraw() : Boolean
	{		
		var mash_location = __mash.getValue('location');
		var should_draw = (__lastLocation == mash_location);
		if (! should_draw) __lastLocation = mash_location;
		return should_draw;
	}
	private function __scrollTo(horizontal : Boolean, position : Number, dont_resend)
	{
		this[(dont_resend ? '__' : '') + (horizontal ? 'h' : 'v') + 'Scroll'] = position;
		__drawClips();
	}
	
	
	private function __vScrollReset()
	{
		
		if (__dataProvider == undefined) return;
		
				
		var rows = Math.ceil(__dataProvider.length / __columns);
		var item_height = __frameH + (2 * config.border);
		var content_height = config.padding * 2;
		
		content_height += (rows * item_height) + ((rows - 1) * config.spacing);
		
		var max_pos = content_height - config.height;
		__contentSize.height = max_pos;
		
		
		
		__contentSize.vsize = (config.height * 100) / content_height;
				
		var new_scroll = __vScroll;
		var scrolls_needed : Boolean = false;
		if (content_height > config.height)
		{
			scrolls_needed = true;
			if (new_scroll > max_pos) new_scroll = max_pos;
		}
		else new_scroll = 0;
		
		
		if (__scrollsNeeded.v != scrolls_needed)
		{
			__scrollsNeeded.v = scrolls_needed;
			if (__watchedProperties.vscroll) dispatchEvent({type: 'propertyRedefined', property: 'vscroll', defined: __scrollsNeeded.v});
		}
		vScroll = new_scroll;
		__drawClips();
	}


}