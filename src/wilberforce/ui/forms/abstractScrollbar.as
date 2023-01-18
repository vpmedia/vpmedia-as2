/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Simon Oliver
 * @version 1.0
 */

// Classes From PixLib
import com.bourre.events.EventType;
import com.bourre.events.BasicEvent;
import com.bourre.commands.Delegate;
import com.bourre.events.EventBroadcaster;

/**
* abstractScrollBar - standard UI component. Designed to be easy to modify and extend with specific implementations
* 
* TODO - Add scrollWheel support
*/
class wilberforce.ui.forms.abstractScrollbar {
	
	private var _height:Number;
	
	// The visual elements
	private var _scrollbarTrack:MovieClip;
	private var _scrollbarWidget:MovieClip;
	private var _scrollTrackBottomButton:MovieClip;
	private var _scrollTrackTopButton:MovieClip;
	
	private var _visiblePageHeight:Number;
	private var _totalPageHeight:Number;
	private var _currentScrollValue:Number;
	
	private var _oEB:EventBroadcaster;
	
	private var _miny:Number;
	private var _maxy:Number;
	
	private var initialYposition:Number;
	private var initialPressY:Number;
	private var _container:MovieClip;
	
	static public var SCROLLBAR_TRACK_ATTACHNAME:String="scrollbarTrack";
	
	static public var SCROLLBAR_WIDGET_TOP_ATTACHNAME:String="scrollbarWidgetTop";
	static public var SCROLLBAR_WIDGET_MIDDLE_ATTACHNAME:String="scrollbarWidgetMiddle";
	static public var SCROLLBAR_WIDGET_BOTTOM_ATTACHNAME:String="scrollbarWidgetBottom";
	
	static public var SCROLLBAR_TRACK_BUTTON_TOP_ATTACHNAME:String="scrollTrackButtonTop";
	static public var SCROLLBAR_TRACK_BUTTON_BOTTOM_ATTACHNAME:String="scrollTrackButtonBottom";
	
	private static var SCROLL_VALUE_CHANGED_EVENT : EventType =  new EventType( "onScroll" );
		
	/** Constructor. Passed a container */
	function abstractScrollbar(container:MovieClip,scrollBarHeight:Number) {
		
		_container=container;		
		_oEB = new EventBroadcaster( this );		
		_init(scrollBarHeight);
	}
	
	private function _init(scrollBarHeight:Number):Void
	{
		
		// Create the new assets		
		_scrollbarTrack=_container.attachMovie(SCROLLBAR_TRACK_ATTACHNAME,"scrollbarTrack",_container.getNextHighestDepth());
		_scrollTrackTopButton=_container.attachMovie(SCROLLBAR_TRACK_BUTTON_TOP_ATTACHNAME,"scrollbarTrackTopButton",_container.getNextHighestDepth());
		_scrollTrackBottomButton=_container.attachMovie(SCROLLBAR_TRACK_BUTTON_BOTTOM_ATTACHNAME,"scrollbarTrackBottomButton",_container.getNextHighestDepth());
		
		
		_scrollbarWidget=_container.createEmptyMovieClip("scrollbarWidget",_container.getNextHighestDepth());//_container._scrollbarWidget;
		
		_scrollbarWidget.attachMovie(SCROLLBAR_WIDGET_TOP_ATTACHNAME,"_scrollbarWidgetTop",_scrollbarWidget.getNextHighestDepth());
		_scrollbarWidget.attachMovie(SCROLLBAR_WIDGET_MIDDLE_ATTACHNAME,"_scrollbarWidgetMiddle",_scrollbarWidget.getNextHighestDepth());
		_scrollbarWidget.attachMovie(SCROLLBAR_WIDGET_BOTTOM_ATTACHNAME,"_scrollbarWidgetBottom",_scrollbarWidget.getNextHighestDepth());
		
		_scrollbarWidget._scrollbarWidgetMiddle._y=_scrollbarWidget._scrollbarWidgetTop._height;
		
		//trace("Added _scrollbarTrack "+_scrollbarTrack);
		
		//_scrollbarWidgetBottom
	//_scrollbarWidgetTop
	//_scrollbarWidgetMiddle
		
		setHeight(scrollBarHeight);
		
		// Set up the actions		
		_scrollbarTrack.onPress=Delegate.create(this,trackClicked);
				
		_scrollbarWidget.onPress=Delegate.create(this,scrollBarWidgetPressed);				
		_scrollbarWidget.onRelease=_scrollbarWidget.onReleaseOutside=Delegate.create(this,scrollBarWidgetReleased);
						
		_scrollTrackTopButton.onPress=_scrollTrackTopButton.onReleaseOutside=Delegate.create(this,incrementValue,-1);
		_scrollTrackBottomButton.onPress=_scrollTrackBottomButton.onReleaseOutside=Delegate.create(this,incrementValue,1);
		
		_currentScrollValue=0;
	}
	
	public function trackClicked()
	{
		if (_container._ymouse<_container._scrollbarWidget._y) {
			incrementValue(-_visiblePageHeight);
			
		}
		else {
			incrementValue(_visiblePageHeight);			
		}
	}
	
	public function scrollBarWidgetPressed()
	{
		//trace("Pressed1 "+_miny+","+_maxy)
		if (_miny==_maxy) return;
	
		//trace("Pressed");
		initialPressY=_container._ymouse;
		initialYposition=_scrollbarWidget._y;
		
		_scrollbarWidget.onMouseMove=Delegate.create(this,scrollBarWidgetMoved);
	}
	
	public function scrollBarWidgetMoved(Void):Void
	{	
		
		var dy:Number=_container._ymouse-initialPressY;
		//trace("Moved "+dy);
		_scrollbarWidget._y=initialYposition+dy;
		
		_scrollbarWidget._y=Math.max(_scrollbarWidget._y,_miny);
		_scrollbarWidget._y=Math.min(_scrollbarWidget._y,_maxy);
		
		notifyMove();		
	}
	
	public function scrollBarWidgetReleased(Void):Void
	{
		_scrollbarWidget.onMouseMove=null;
	}
	
	/** Increments the current scroll value  */
	public function incrementValue(tValue:Number) {
		
		var _newValue:Number=_currentScrollValue+=tValue;
		
		if (_newValue>(_totalPageHeight-_visiblePageHeight)) _newValue=(_totalPageHeight-_visiblePageHeight);
		if (_newValue<0) _newValue=0;

		
		if (_newValue!=_currentScrollValue)				
		{
			trace("Old "+_currentScrollValue+" new "+_newValue);
			_currentScrollValue=_newValue;
			// Total page height small, visible page height
			setValue(_currentScrollValue);
	//		trace("Increment value "+tValue+" - now "+_currentScrollValue)
			
			sendChangeEvent();
		}
	}
	
	/** Resize the height of the scrollbar
	* @param tHeight The new height of the scrollbar
	*/
	public function setHeight(tHeight:Number) {
		
		_height=tHeight;
		
		// Reposition everything properly
		_scrollTrackTopButton._y=0;
		_scrollbarTrack._y=_scrollTrackTopButton._height;
		_scrollbarTrack._height=tHeight-_scrollTrackTopButton._height-_scrollTrackBottomButton._height;
				
		_miny=_scrollbarTrack._y;
		_maxy=_scrollbarTrack._y+_scrollbarTrack._height-_scrollbarWidget._height;
		
		
//		trace("Resize setting _maxy "+_maxy)
		_scrollTrackBottomButton._y=_scrollbarTrack._height+_scrollbarTrack._y;
		
		// Reset the scrollwheel thing
		//setProperties(_visiblePageHeight,_totalPageHeight);
	}
	
	/** Increments the current scroll value by relative y position
	* @param tValue The y change
	*/
	function scrollBy(tValue:Number) {
		// Work out a percentage of the scroll
		var ty=-_scrollbarTrack._height*(tValue/_totalPageHeight);
		
		_scrollbarWidget._y+=ty;
		if (_scrollbarWidget._y<_miny) _scrollbarWidget._y=_miny;
		if (_scrollbarWidget._y>_maxy) _scrollbarWidget._y=_maxy;
		notifyMove();
	}
	
	/** Sets the current scroll value
	* @param tValue The new scroll value
	*/
	function setValue(tValue:Number) {
		_currentScrollValue=tValue;
		
		//var ty=_scrollbarTrack._y+_scrollbarTrack._height*(tValue/(_totalPageHeight-);
		var percentScroll=tValue/(_totalPageHeight-_visiblePageHeight);
//		trace("percentScroll "+percentScroll)
		var ty=_miny+(_maxy-_miny)*percentScroll;
		
				
		_scrollbarWidget._y=ty;
		if (_scrollbarWidget._y<_miny) _scrollbarWidget._y=_miny;
		if (_scrollbarWidget._y>_maxy) _scrollbarWidget._y=_maxy;
		//notifyMove();
	}
	
	/** Called when the scroll bar moves */
	function notifyMove() {
		var _newValue:Number=Math.round((_totalPageHeight-_visiblePageHeight)*((_scrollbarWidget._y-_miny)/(_maxy-_miny)));	
		if (_currentScrollValue!=_newValue) {
			_currentScrollValue=_newValue;
			sendChangeEvent();
		}
		
	}
	/** Sends the scroll bar moved event to all listeners */
	function sendChangeEvent() {		
		_oEB.broadcastEvent( new BasicEvent( SCROLL_VALUE_CHANGED_EVENT,_currentScrollValue ) );
	}
	
	
	/**
	* Sets the properties of the scrollBar
	* @param tVisiblePageHeight The number of items visible on each page
	* @param tTotalPageHeight The total number of items
	*/	
	function setProperties(tVisiblePageHeight:Number,tTotalPageHeight:Number) {
		
		_visiblePageHeight=tVisiblePageHeight;
		_totalPageHeight=tTotalPageHeight;
		
		//trace("PERCENT IS "+(_visiblePageHeight/_totalPageHeight))
		//_scrollbarWidget._y=_miny;
		_scrollbarWidget._scrollbarWidgetMiddle._height=_scrollbarTrack._height*(_visiblePageHeight/_totalPageHeight)
		
		var tMaxMiddleHeight=_scrollbarTrack._height-_scrollbarWidget._scrollbarWidgetBottom._height-_scrollbarWidget._scrollbarWidgetTop._height;
		//trace("MAX MIDDLE HEIGHT "+tMaxMiddleHeight+" COMPARED TO "+_scrollbarWidget._scrollbarWidgetMiddle._height)
		//trace("A "+scrollbarTrack._height+" B "+_scrollbarWidget._scrollbarWidgetBottom._height+" C "+_scrollbarWidget._scrollbarWidgetTop._height)
		
		_scrollbarWidget._scrollbarWidgetBottom._y=_scrollbarWidget._scrollbarWidgetMiddle._height+_scrollbarWidget._scrollbarWidgetMiddle._y;
		
		if (_scrollbarWidget._scrollbarWidgetMiddle._height>tMaxMiddleHeight) {
			_scrollbarWidget._scrollbarWidgetMiddle._height=tMaxMiddleHeight;
			_maxy=_miny;
			// Reposition bottom again
			_scrollbarWidget._scrollbarWidgetBottom._y=_scrollbarWidget._scrollbarWidgetMiddle._height+_scrollbarWidget._scrollbarWidgetMiddle._y;
			//trace("setProperties A setting _maxy "+_maxy)
		//	_scrollbarWidget.disabled=true;
		}
		else {
		
			_maxy=_scrollbarTrack._y+_scrollbarTrack._height-_scrollbarWidget._height;
			//trace("setProperties B setting _maxy "+_maxy)
			
		}
		
		
		setValue(0);
		//_currentScrollValue=0;
	}
		
	public function addListener(listeningObject)
	{
		_oEB.addListener(listeningObject);
	}
	public function removeListener(listeningObject)
	{
		_oEB.removeListener(listeningObject);
	}
}