/**
 * com.sekati.log.Console
 * @version 1.3.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.StageDisplay;
import com.sekati.events.Dispatcher;
import com.sekati.events.Event;
import com.sekati.log.ConsoleFPSMonitor;
import com.sekati.log.ConsoleItem;
import com.sekati.log.ConsoleStyle;
import com.sekati.log.LCBinding;
import com.sekati.log.LogEvent;
import com.sekati.math.MathBase;
import com.sekati.ui.ContextualMenu;
import com.sekati.ui.Scroll;
import com.sekati.utils.ClassUtils; 
import com.sekati.utils.Delegate;

/**
 * UI Console for attaching or connecting too
 */
class com.sekati.log.Console {

	// core console props
	private static var _instance:Console;
	private var _this:Console;
	private var _cs:ConsoleStyle;
	private var _style:Object;
	// ui props
	private var _console:MovieClip;
	private var _bg:MovieClip;
	private var _head:MovieClip;
	private var _headBg:MovieClip;
	private var _headTf:TextField;
	private var _fps:MovieClip;
	private var _holder:MovieClip;
	private var _list:MovieClip;
	private var _mask:MovieClip;
	private var _scroll:Scroll;
	private var _cmenu:ContextualMenu;
	private var _gutter:MovieClip;
	private var _bar:MovieClip;
	private var _resizer:MovieClip;
	private var _metaItem:MovieClip;
	// manager props
	private var _isEnabled:Boolean;
	private var _logItems:Array;
	private var _logIndex:Number;
	private var _items:Array;

	/**
	 * Singleton Private Constructor
	 */
	private function Console() {
		_this = this;
		_isEnabled = true;
		_items = new Array( );
		_cs = ConsoleStyle.getInstance( );
		_style = _cs.CSS;
		Dispatcher.$.addEventListener( LogEvent.onLogEVENT, Delegate.create( _this, onLogEvent ) );
		Dispatcher.$.addEventListener( StageDisplay.onStageResizeEVENT, Delegate.create( _this, onStageResize ) );
		LCBinding.connect( Delegate.create( _this, addItem ) );
		createUI( );
	}

	/**
	 * Singleton Accessor
	 * @return Console
	 */	
	public static function getInstance():Console {
		if (!_instance) _instance = new Console( );
		return _instance;
	}

	/**
	 * shorthand singleton accessor getter
	 */
	public static function get $():Console {
		return Console.getInstance( );	
	}

	/**
	 * Create the core Console UI
	 */
	private function createUI():Void {
		_console = _cs.createClip( _level0, _style.console );
		_console._x = _style.console.x;
		_console._y = _style.console.y;
		//_console._quality = "LOW";
		_bg = _cs.createStyledRectangle( _console, _style.console.bg );
		
		_head = _cs.createClip( _console, _style.console.head );
		_headBg = _cs.createStyledRectangle( _head, _style.console.head.bg );
		_headTf = _cs.createStyledTextField( _head, _style.console.head.textfields.head );
		
		// create ConsoleFPSMonitor
		_fps = ClassUtils.createEmptyMovieClip( com.sekati.log.ConsoleFPSMonitor, _head, _style.console.head.fps.n, {_x:_style.console.head.fps.x, _y:_style.console.head.fps.y} );		
		
		// create core ui clip holders
		_holder = _cs.createPositionClip( _console, _style.console.holder );
		_list = _cs.createPositionClip( _holder, _style.console.holder.list );
		
		// create core ui clip shapes
		_mask = _cs.createStyledRectangle( _holder, _style.console.holder.mask );
		_gutter = _cs.createStyledRectangle( _holder, _style.console.holder.gutter );
		_gutter.cacheAsBitmap = true;
		_bar = _cs.createStyledRectangle( _holder, _style.console.holder.bar );
		_bar.cacheAsBitmap = true;
		_bar._visible = false;
		
		// create resizer
		_resizer = _cs.createStyledTriangle( _console, _style.console.resizer );
	
		// create the meta item
		_metaItem = ClassUtils.createEmptyMovieClip( com.sekati.log.ConsoleItem, _list, "metaItem", {_x:0, _y:0, _data:{_isMeta:true}} );
		_items.push( _metaItem );	
	
		// set masking & initialize _scroll
		_list.setMask( _mask );
		_scroll = new Scroll( "_y", _list, _mask, _gutter, _bar, true, true, true, true, _list );
		
		// initialize contextMenu
		_cmenu = new ContextualMenu( _console );
		var cb:Function = function():Void {
			getURL( _style.console.head.textfields.head.url, "_blank" );	
		};
		_cmenu.addItem( _style.console.head.textfields.head.t, Delegate.create( this, cb ), true );
		_cmenu.addItem( "Pause Console", Delegate.create( this, toggleLogEnable ), true );
		_cmenu.addItem( "Copy Console Log", Delegate.create( this, toClipboard ), true );
		_cmenu.addItem( "Clear Console Log", Delegate.create( this, reset ), false );
		_cmenu.addItem( "Minimize Console", Delegate.create( this, resize, _style.console.minW, _style.console.minH ), true );
		_cmenu.addItem( "Maximize Console", Delegate.create( this, resize, _style.console.maxW, _style.console.maxH ), false );
		// events
		if(_style.console.head.isDraggable == true) {
			_head.onPress = Delegate.create( _console, startDrag, false, _style.console.x, _style.console.y, _style.console.maxW, _style.console.maxH );
			_head.onRelease = _head.onReleaseOutside = Delegate.create( _console, stopDrag );
			_resizer.onPress = Delegate.create( this, resizer_onPress );
			_resizer.onRelease = _resizer.onReleaseOutside = Delegate.create( this, resizer_onRelease );
		} else {
			_resizer._visible = false;	
		}
		// resize console to fit swf
		resize( Stage.width - _style.console.x * 4, Stage.height - _style.console.y * 4 );
	}

	/**
	 * Resizing methods
	 */
	private function resizer_onPress():Void {
		//_resizer.startDrag (false, (_console._x+_style.console.minW), (_console._y+_style.console.minH), Stage.width-50, Stage.height-50);
		_resizer.startDrag( false, (_console._x + _style.console.minW), (_console._y + _style.console.minH), _style.console.maxW, _style.console.maxH );
	}

	private function resizer_onRelease():Void {
		_resizer.stopDrag( );
		resize( );
	}

	/**
	 * Resize the Console UI.
	 * @param nw (Number) optional new width
	 * @param nh (Number) optional new height
	 * @return Void
	 */
	public function resize(nw:Number, nh:Number):Void {
		var _w:Number = (!nw) ? int( _console._xmouse ) : nw;
		var _h:Number = (!nh) ? int( _console._ymouse ) : nh;
		
		// add constraints to sanitize resizing
		var w:Number = MathBase.constrain( _w, _style.console.minW, _style.console.maxW );
		var h:Number = MathBase.constrain( _h, _style.console.minH, _style.console.maxH );
		
		// new mask width/height
		var mw:Number = w - 11;
		var mh:Number = h - _cs.IH;
		
		// _bg		
		_bg._width = w;
		_bg._height = h;
		
		// resizer
		_resizer._x = _bg._width - _resizer._width;
		_resizer._y = _bg._height - _resizer._height;		
		
		// _head
		_headBg._width = w;
		_fps._x = w - 120;
		
		// _mask
		_mask._width = mw;
		_mask._height = mh;		
		
		// _gutter, _bar, update _scroll
		_gutter._x = (_bg._width - _gutter._width);
		_gutter._height = (_bg._height - _headBg._height);
		_bar._x = _gutter._x;
		
		// dispatch new itemWidth to all ConsoleItems
		for(var i:Number = 0; i < _items.length ; i++) {
			resizeConsoleItem( i, mw );
		}
		_scroll.slideScroller( _gutter._height, 0 );
	}

	private function resizeConsoleItem(itemIndex:Number, w:Number):Void {
		var item:MovieClip = _items[itemIndex];
		
		// resize
		item._bg._width = w;
		item._line._width = w;
		item._messageTf._width = w - 239;
		item._benchmarkTf._x = item._messageTf._x + item._messageTf._width + 6;
		
		// realign
		var tallestTf:TextField = (item._messageTf._height > item._originTf._height) ? item._messageTf : item._originTf;
		item._bg._height = tallestTf._height;
		item._line._y = tallestTf._height;	
		
		// reposition
		var prevItem:MovieClip = _items[itemIndex - 1];
		if(prevItem) {
			item._y = prevItem._y + prevItem._height;
		}
		
		// reset _style for future items
		var _istyle:Object = _cs.CSS.item;
		_istyle.bg.w = w;
		_istyle.line.w = w;
		_istyle.textfields.message.w = item._messageTf._width;
		_istyle.textfields.benchmark.x = item._benchmarkTf._x;
	}	

	/**
	 * Add and return a new ConsoleItem
	 * @param data (Object) ConsoleItem._data = {id:Number, type:String, origin:String, message:String, benchmark:Number, _isMeta:Boolean}
	 * @return 	MovieClip
	 */
	public function addItem(data:Object):MovieClip {
		if(_isEnabled) {
			// reset when new swf is presented
			if(data.id == 0) {
				reset( );
				return;	
			}
			var item:MovieClip = ClassUtils.createEmptyMovieClip( com.sekati.log.ConsoleItem, _list, "consoleItem_" + data.id, {_x:0, _y:_list._height, _data:data} );
			updateScroll( item );
			_items.push( item );
			return item;
		}
	}

	/**
	 * Update the {@link Scroll} to the last added item if we are not mousing the area.
	 * @param item (MovieClip) last added item
	 * @return Void
	 */
	public function updateScroll(item:MovieClip):Void {
		_global['setTimeout']( _scroll, 'slideContent', 50, item._y + item._height, 0.2 );
		if(!_scroll.isDragging( ) && !_scroll.isMouseInArea( ) && !_console.hitTest( _level0._xmouse, _level0._ymouse, false )) {
			_global['setTimeout']( _scroll, 'slideContent', 50, item._y + item._height, 0.2 );
		}
	}

	/**
	 * Handle events from Logger and parse them to addItem
	 * @param eventObj (Event)
	 * @return Void
	 */
	 
	private function onLogEvent(eventObj:Event):Void {
		if (_isEnabled) {
			//trace ("eventObj{target:" + eventObj.target + ",type:" + eventObj.type + ",message:" + eventObj.data.message + "};");
			addItem( eventObj.data );
		}
	}

	/**
	 * Handle Stage resize events
	 * @param eventObj (Event)
	 * @return Void
	 */
	private function onStageResize(eventObj:Event):Void {
		_style.console.maxW = Stage.width, 
		_style.console.maxH = Stage.height;
		resize( Stage.width, Stage.height );
	}

	/**
	 * Toggle Logger.enabled and contextual menu.
	 * @return Void
	 */
	private function toggleLogEnable():Void {
		if(_isEnabled) {
			_isEnabled = false;
			_cmenu.editItem( "Pause Console", "Resume Console", Delegate.create( this, toggleLogEnable ) );
		} else {
			_isEnabled = true;
			_cmenu.editItem( "Resume Console", "Pause Console", Delegate.create( this, toggleLogEnable ) );
		}
	}

	/**
	 * Select all item _data and put it in clipboard
	 * @return Void
	 */
	public function toClipboard():Void {
		System.setClipboard( toString( ) );
	}

	/**
	 * Return Console string data 
	 * @return String
	 */
	public function toString():String {
		var o:String = _style.console.head.textfields.head.t + "\t" + _fps.toString( ) + "\n";
		for (var i:Number = 0; i < _items.length ; i++) {
			o += "\n" + _items[i].toString( );
		}
		return o;	
	}

	public function reset():Void {
		for(var i:Number = 0; i < _items.length ; i++) {
			_items[i].destroy( );	
		}
		_items = [];
	}

	/**
	 * Clean and destroy
	 * @return Void
	 */
	public function destroy():Void {
		Dispatcher.$.removeEventListener( LogEvent.onLogEVENT, Delegate.create( _this, onLogEvent ) );
		Dispatcher.$.removeEventListener( StageDisplay.onStageResizeEVENT, Delegate.create( _this, onStageResize ) );
		LCBinding.disconnect( );
		_fps.destroy( );
	}
}