/**
 *  Copyright (c) 2006, David Knape and contributing authors
 *
 *  Permission is hereby granted, free of charge, to any person 
 *  obtaining a copy of this software and associated documentation 
 *  files (the "Software"), to deal in the Software without 
 *  restriction, including without limitation the rights to use, 
 *  copy, modify, merge, publish, distribute, sublicense, and/or 
 *  sell copies of the Software, and to permit persons to whom the 
 *  Software is furnished to do so, subject to the following 
 *  conditions:
 *  
 *  The above copyright notice and this permission notice shall be 
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

 import com.bumpslide.util.Delegate;

/**
 * Bumpslide UI Scrollbar
 */ 

class com.bumpslide.ui.ClipScroller extends MovieClip  {

	// Sub Clips
	//----------------
	var handle_mc; 		// the scroll indicator - constrained to dimensions of bg_mc
	var up_btn; 		// Scroll Up Button
	var down_btn; 		// Scroll Down Button
	var bg_mc;			// background rectangle in between scroll buttons

	// Clip References
	//----------------
	var content_mc;		// the content clip
	var mask_mc;		// the content mask
	
	// Config
	//----------------
	var vpad; 			// minimum y position of scroll indicator
	var hpad;			// x position of scroll indicator
	var errorFactor = 0;
	var scrollSpeed = 80;
	var scrollAmount = 17;  // number of pixels to advance with each mousewheel click
	var showBorder = true;
	var showButtons = true; 
	var tweenEnabled = true; // should we tween the content? 
	var hideWhenDisabled = true; // should we hide the scrollbar when it's not needed?
	var roundToScrollAmount = false; // should we round to nearest line (scrollAmount) when dragging handle?
	var minIndicatorHeight = 14;
	var fixedHandleHeight = false;
	
	//----------------
	
	private var contentHeight;
	private var handleMin;			
	private var handleMax;
	private var height;
	private var indicatorBounds;  // == (height - 2*vpad)
	private var indicatorHeight;	
	private var orig_x;
	private var orig_y;
	private var isDragging = false;
	private var _dragInt = -1;
	private var _scrollInt = -1;
	
	// for tweening...
	private var _tweenInt = -1;
	private var isTweening;
	var targetContentY;
	
	
	var broadcastMessage : Function;
	var removeListener : Function;
	var addListener : Function;

	function ClipScroller() {	
		height = Math.round(_height);
		_xscale = _yscale = 100;
		_visible = false;		
		AsBroadcaster.initialize( this );		
		
		// default padding around handle_mc
		vpad = handle_mc._y;
		hpad = handle_mc._x;
		
		if(up_btn==null) showButtons = false;
		
		if(!showButtons) {
			//vpad = hpad; 
			up_btn._visible = false;
			down_btn._visible = false;
		}
		
		if(mask_mc && content_mc) onEnterFrame = init;
	}
	
	function dTrace(str) {
		//com.bumpslide.util.Debug.trace( '[ClipScroller] ' + str);
	}
	
	function init( mask, content ) {
		
		delete onEnterFrame;
		
		if(mask!=null) mask_mc = mask;
		if(content!=null) content_mc = content;
		
		// we are not ready yet
		if(mask_mc==null || content_mc==null) {
			return;
		}
		
		dTrace('INIT');
		
		// save original content location for use as offset
		orig_x = content_mc._x;
		targetContentY = orig_y = content_mc._y;
			
		// delegate event handlers
		up_btn.onPress = Delegate.create(this, scrollUp);
		up_btn.onRelease = up_btn.onReleaseOutside = Delegate.create(this, scrollStop);
		
		down_btn.onPress = Delegate.create(this, scrollDown);
		down_btn.onRelease = down_btn.onReleaseOutside = Delegate.create(this, scrollStop);
		
		handle_mc.onPress = Delegate.create(this, handlePress);
		handle_mc.onRelease = handle_mc.onReleaseOutside = Delegate.create(this, handleRelease);
		
		bg_mc.onPress = Delegate.create(this, backgroundPress);
		bg_mc.onRelease = bg_mc.onReleaseOutside = Delegate.create(this, handleRelease);
		

		// Listen to onMouseWheel events
		Mouse.addListener(this);	
		
	}
	
	function onUnload() {
		Mouse.removeListener(this);
	}
	
	function setHeight (h) {
		dTrace('setHeight '+h);
		// by default, make overall height the same as mask height
		height = Math.round( (h==null) ? mask_mc._height : h);
		
		//dTrace('[scroller] ('+this+') height='+this.height);
		update();	
	}
	
	// percent scrolled based on position of content_mc
	function get percentScrolled () {
		return (content_mc._y - maxContentPosition) / (mask_mc._height - contentHeight);
	}
	
	function get minContentPosition () {
		return Math.round(mask_mc._height - contentHeight + maxContentPosition);
	}

	function get maxContentPosition () {
		return orig_y;
	}
	
	function reset() {		
		clearInterval(_dragInt);
		clearInterval(_scrollInt);
		clearInterval(_scrollInt);		
		targetContentY = content_mc._y = maxContentPosition;
		update();
	}	
		
	function update() {
		// get content height;
		// note, content height isn't always valid, so we give content clips a chance to return their proper height
		contentHeight = content_mc.getScrollHeight();
		if(contentHeight==undefined) contentHeight = content_mc.height;
		if(contentHeight==undefined) contentHeight = content_mc._height;
		
		// update indicator boundary
		indicatorBounds	= Math.round( height - 2 * vpad );
				
		// update indicator height
		if(fixedHandleHeight) {
			indicatorHeight = handle_mc._height;
		} else {
			indicatorHeight = Math.max( minIndicatorHeight, Math.min( indicatorBounds, Math.round( mask_mc._height / contentHeight * indicatorBounds)));   
		}
		
		// update View		
		updateView();
		
	}
	
	
	private function updateView() {
		
		//dTrace('updateView');
		
		// size background and move bottom button
		bg_mc._height = height - bg_mc._y*2;
		down_btn._y = height;	
				
		// Check whether or not we even need to show a scroll bar
		if (mask_mc._height > contentHeight-errorFactor) {
			enabled = false;	
			//return;
		} else {
			enabled = true;
		}
					
		if(!fixedHandleHeight) updateHandleSize();
		
		// Keep content in bounds and update handle position based on new content position
		constrainContent();
		updateHandlePosition();
		updateButtons();
	}
	
	function updateHandleSize() {
		// update handle size, visibility, and grip visibility
		handle_mc.bottom_mc._y = indicatorHeight;
		handle_mc.middle_mc._height = Math.round(indicatorHeight - handle_mc.bottom_mc._height*2);	
		handle_mc.grip_mc._y = Math.round((indicatorHeight - handle_mc.grip_mc._height) / 2);	
		handle_mc.grip_mc._visible =  (indicatorHeight > handle_mc.grip_mc._height*4);
	}
	
	var _isEnabled = false;
	
	function get enabled () {
		return _isEnabled;
	}
	
	function set enabled(isScrollBarEnabled) {
		_isEnabled = isScrollBarEnabled;
		
		// if disabled, reset content position to original root positions
		if(!_isEnabled) {
			
			targetContentY = content_mc._y = maxContentPosition;
			
			clearInterval(_dragInt);
			clearInterval(_scrollInt);
			
			stopTweening();
			
			if(hideWhenDisabled) {
				_visible = false;
			} else {
				handle_mc._visible = false;
				bg_mc.enabled = false;
				updateButtons();
			}			
		} else {
			_visible = true;
			handle_mc._visible = true;
			bg_mc.enabled = true;
		}
	}
	
	
	
	private function updateButtons() {
		up_btn.enabled = ( enabled  && (content_mc._y < maxContentPosition ));
		down_btn.enabled = ( enabled  && (content_mc._y  > minContentPosition) );		
		
		up_btn.gotoAndStop( up_btn.enabled ? 1 : 'disabled');
		down_btn.gotoAndStop( down_btn.enabled ? 1 : 'disabled');		
	}	
	
	// update content_mc position based on position of handle_mc
	private function updateContentPosition (fromHandleRelease) {	

		if ((mask_mc==null) || (content_mc==null)) { return; }
		handle_mc._y = Math.round( handle_mc._y);
		
		// percent scrolled according to handle is...
		var handle_percent_scrolled = (handle_mc._y - vpad) / (indicatorBounds-indicatorHeight);
		
		var targetY = handle_percent_scrolled * (mask_mc._height - contentHeight) + maxContentPosition
		
		dTrace('handlePercentScrolled='+handle_percent_scrolled);
		
		// if we just released handle, round it to the nearest scroll amount
		if(fromHandleRelease && roundToScrollAmount) {
			targetY = Math.round( targetY/scrollAmount ) * scrollAmount;
			if(handle_percent_scrolled == 1) targetY=minContentPosition;
		}
		
		if(tweenEnabled) {			
			targetContentY = targetY;
			startTweening(fromHandleRelease);			
		} else {
			content_mc._y 	= targetY
			constrainContent();
			updateButtons();
		}
	}
	
	// Update handle_mc position based on position of content_mc
	private function updateHandlePosition () {
				
		if(isDragging) { 
			dTrace('not updating handle because we are dragging'); return;
		}
		if ((mask_mc==null) || (content_mc==null)) { return; }
		
		dTrace('Percent Scrolled = '+percentScrolled);
		// percentScrolled comes from getter (based on position of content)
		handle_mc._y = Math.round( vpad +  percentScrolled * ( indicatorBounds-indicatorHeight ) );
		//handle_mc._x = hpad;
	

	}
	
	private function constrainContent (fromHandleDrag) {
		var cy = content_mc._y;
		
		if(mask_mc._height>contentHeight) { 
			content_mc._y = maxContentPosition; 
			broadcastMessage( 'onScrollUpdate', this);
			return; 
		}
		
		
		content_mc._y = Math.floor( Math.max( minContentPosition, Math.min(maxContentPosition, cy)));	
		
		if((content_mc._y-minContentPosition)<errorFactor) {
			content_mc._y = minContentPosition;
		}
		
		if(content_mc._y == minContentPosition || content_mc._y == maxContentPosition) {
			stopTweening();			
			clearInterval(_scrollInt);
		}		
		
		//trace( 'content_mc._y = ' + content_mc._y);
		//trace('percentScroll (content) = ' +percentScrolled);
		broadcastMessage( 'onScrollUpdate', this);
	}
		
	// scroll command given in pixel change of content position
	private function scroll(deltaPixels) {
		//trace('scroll '+deltaPixels);
		if(!enabled) return;
		if(tweenEnabled) {
			targetContentY += deltaPixels;
			// constrain target
			targetContentY = Math.floor( Math.max( minContentPosition, Math.min(maxContentPosition, targetContentY)));
			startTweening();				
		} else {			
			content_mc._y += deltaPixels;
			constrainContent();
			updateHandlePosition();
			updateButtons();
		}
		
	}	
	
	function startTweening(fromHandleRelease) {
		isTweening = true;
		clearInterval(_tweenInt);
		_tweenInt = setInterval( this, 'doTween', 30, fromHandleRelease);
		doTween(fromHandleRelease);
	}
	
	function stopTweening() {
		//trace('[scroll] stopped tweening at '+content_mc._y);
		clearInterval( _tweenInt );
		targetContentY = content_mc._y;
		isTweening = false;
	}
	
	function doTween(fromHandleRelease) {
		//dTrace('[scroll] doTween');
		if(targetContentY!=null) {
			var dy = targetContentY - content_mc._y;
			
			//trace('[scroll] targetContentY = '+targetContentY);
			//trace('[scroll] content_mc._y = '+ content_mc._y);
			//trace('[scroll] delta Y = '+dy);
			
			if(Math.abs(dy)>2) {					
				content_mc._y += dy/3;		
				//trace('[scroll] updated content_mc._y = '+ content_mc._y);
			} else {
				content_mc._y = targetContentY;
				stopTweening();
			}
			constrainContent();
			if(!fromHandleRelease) {
				updateHandlePosition();
			} 
			updateButtons();
		}
		
	}
	
	
	
	
	function backgroundPress() 
	{	
		var hMin = vpad;
		var hMax = vpad + indicatorBounds - indicatorHeight;
		
		handle_mc._y = Math.max( hMin, Math.min( hMax, _ymouse - indicatorHeight/2));
		
		handlePress();		
	}
	
	function handlePress() {	
		stopTweening();
		isDragging = true;
		var hMin = vpad;
		var hMax = vpad + indicatorBounds - indicatorHeight;
		
		handle_mc.startDrag( false, handle_mc._x, hMin, handle_mc._x, hMax);
		
		clearInterval(_dragInt);
		_dragInt = setInterval(this, 'updateContentPosition', 50, true);
		updateContentPosition();
	}
	
		
	function handleRelease () {
		isDragging = false;
		clearInterval(_dragInt);
		handle_mc.stopDrag();
		updateContentPosition(true);
	}
	
	function scrollUp() { 
		//dTrace('Scroll Up');
		clearInterval( _scrollInt );
		scroll(scrollAmount);
		_scrollInt = setInterval(this, 'scroll', scrollSpeed, scrollAmount);
	}
	
	function scrollDown() {
		//dTrace('Scroll Down');
		clearInterval( _scrollInt );
		scroll(-scrollAmount);
		_scrollInt = setInterval(this, 'scroll', scrollSpeed, -scrollAmount);
	}
	
	function scrollStop() { 
		//dTrace('Scroll Stop');
		clearInterval( _scrollInt ); 
	}
	
		
	function onMouseWheel(delta, target) {
		//trace('onMouseWheel '+delta+' ('+target+')');
		var testClip = target;
		
		// scroll number of lines equal to delta 
		var scrollDistance = delta * scrollAmount;
		
		// always scroll 1 line
		//var scrollDistance = delta/Math.abs(delta) * scrollAmount;
		
		for(var n=0; n<8; n++) {
			testClip = testClip._parent;
			if(_parent == testClip) { 
				scroll( scrollDistance );
				return;
			}
		}
	}

	
	
}