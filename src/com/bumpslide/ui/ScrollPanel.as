 /**
 * Base class for scrolling content panels.  
 * Attaches content and scroll bar and handles masking and size updates.
 * 
 * To use, extend this class and define _contentPath.  
 * Or, instantiate and set contentPath.
 * 
 * Content clip should implement setSize (w,h) and  optionally getScrollHeight()
 * if scrollable height is something other than the clip _height property.
 * 
 * Author: 
 * David Knape
 */

import com.bumpslide.util.*;
import com.bumpslide.ui.ClipScroller;

class com.bumpslide.ui.ScrollPanel extends MovieClip {
	
	// outer bounds including padding
	var height;
	var width;
	
	// space for content and scrollbar (height and width minus the padding)
	var contentWidth; 
	var contentHeight; 
	
	var bg_mc; 			// optional background clip sized to match panel size
	var mask_mc;		// mask for holder_mc
	var holder_mc;		// content holder
	var content_mc; 	// reference to clip inside of holder_mc
	var scroll_mc:ClipScroller;	// scrollbar
	
	private var _contentLevel : Number = 0;
	private var _contentPath = null;
	private var _scrollbarLinkage = 'm_clip_scroller';
	private var _scrollEnabled:Boolean = true;
	
	var paddingTop = 0;
	var paddingBottom = 0;
	var paddingLeft = 0;
	var paddingRight = 0;
	var paddingMid = 2;  // space between scrollbar and content

	function ScrollPanel() {
		
		// init height/width
		height = height==null ? _height : height;
		width = width==null ? _width : width;
		_visible = false;
		_xscale = _yscale = 100;

		// hide until we have content
		_visible = false;
		
		// load content if we have it
		if(_contentPath!=null) reset();
			
	}
	
	// backwards compatability, damn it,
	function get content_clip () : MovieClip { return content_mc; }
	
	function scrollReset() {
//		Debug.trace('ScrollerReset');
		scroll_mc.reset();
	}
	
	function reset() {	
		delete onEnterFrame;
		//if(content_mc!=undefined) 
		content_mc.removeMovieClip();		
		this['holder_mc'+_contentLevel].removeMovieClip();		
		_contentLevel = (_contentLevel+1)%2;
		attachContent();
		onEnterFrame = _init;
	}
	
	function attachContent() {
		
		// create content holder
		holder_mc = createEmptyMovieClip('holder_mc'+_contentLevel, _contentLevel);
		
		// create Mask
		createEmptyMovieClip('mask_mc', 2);
		Draw.fill(mask_mc, 100, 100, 0x00ffff, 50);
		holder_mc.setMask( mask_mc );
		
		holder_mc._y = mask_mc._y = paddingTop;
		holder_mc._x = mask_mc._x = paddingLeft;
		content_mc = holder_mc.attachMovie(_contentPath, 'content'+_contentLevel, _contentLevel, {parentPanel: this});
	}
	
	function _init() {
		
		delete onEnterFrame;
		
//		Debug.trace('[ScrollPanel] _init - ('+_contentPath+') at '+holder_mc);
	
		if(scrollEnabled) scroll_mc.init( mask_mc, holder_mc );			
		
		_visible = true;		
		init();		
		update();
	}
	
	// for subclasses
	function init() {
		
	}
	
	function hide() {
		delete onEnterFrame;
		_visible = false;
	}
	
	function get actualHeight () {
		return Math.round( (scroll_mc._visible) ? height : content_mc._height );
	}
	

	function set contentPath (path:String) {
		if(path!=_contentPath) {
			_contentPath = path;
			reset();
		}
	}
	
	function get contentPath () : String {
		return _contentPath;
	}
	
	public function get scrollEnabled():Boolean
	{
		return _scrollEnabled;
	}
	
	public function set scrollEnabled( val:Boolean ):Void
	{
		_scrollEnabled = val;
		update();
	}
	
	
	function setSize(w,h) {
		
		//Debug.trace( '[Panel] setSize '+arguments);
		height = Math.round(h==null ? height : h);	
		width = Math.round(w==null ? width : w);
		
		contentHeight = height - paddingTop - paddingBottom;
		contentWidth = width - paddingLeft - paddingRight;
		
		//com.secondstory.Debug.traceObj( this, false, 'setSize' );
		update();
		onSizeChange();
	}
	
	function update() {		

		// amount we have to subtract from content width to compensate for scrollbar
		var scrollBarWidth = scrollEnabled? Math.round( scroll_mc._width + paddingMid ) : 0;
		
		// update mask size
		mask_mc._height = contentHeight;
		mask_mc._width = contentWidth - scrollBarWidth;
		
		if(bg_mc) {
			bg_mc._width = width;
			bg_mc._height = height;
		}
		// update content size
		content_mc.setSize( contentWidth - scrollBarWidth, contentHeight);
		
		// update scrollbar position and height
		if(scrollEnabled) updateScroller();
	}
	
	// this is really just separate for the sake of override
	function updateScroller() {
		
		scroll_mc._y = paddingTop;
		scroll_mc._x = width - paddingRight - scroll_mc._width;				
		scroll_mc.setHeight( contentHeight );	
				
		// if scrollbar not necessary, fill content to far edge
		if(!scroll_mc._visible) {
			content_mc.setSize( contentWidth, contentHeight);
			mask_mc._width = contentWidth;			
		}
	}
	
	
	function onSizeChange() {
			
		// subclass specific stuff goes here.
		
		
	}

	
	
	function getContentScrollHeight() {
		return content_mc.getScrollHeight();
	}
	
	
	
	
}