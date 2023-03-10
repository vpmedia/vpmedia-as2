/*
	CASA Framework for ActionScript 2.0
	Copyright (C) 2007  CASA Framework
	http://casaframework.org
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

import org.casaframework.movieclip.DispatchableMovieClip;
import org.casaframework.util.MovieClipUtil;

/**
	Dispatches MovieClip event handler notification using {@link EventDispatcher}.
	
	@author Aaron Clinger
	@version 04/09/07
	@example
		<code>
			import org.casaframework.movieclip.EventMovieClip;
			import org.casaframework.util.MovieClipUtil;
			
			function movieClipLoad(sender_mc:MovieClip):Void {
				trace(sender_mc + " has loaded.");
			}
			
			function movieClipPress(sender_mc:MovieClip):Void {
				trace(sender_mc + " was pressed.");
			}
			
			MovieClipUtil.attachMovieRegisterClass(org.casaframework.movieclip.EventMovieClip, this, "linkageMovieClip", "event_mc");
			
			this.event_mc.addEventObserver(this, EventMovieClip.EVENT_LOAD, "movieClipLoad");
			this.event_mc.addEventObserver(this, EventMovieClip.EVENT_PRESS, "movieClipPress");
		</code>
*/

class org.casaframework.movieclip.EventMovieClip extends DispatchableMovieClip {
	public static var EVENT_DATA:String            = 'onData';
	public static var EVENT_DRAG_OUT:String        = 'onDragOut';
	public static var EVENT_DRAG_OVER:String       = 'onDragOver';
	public static var EVENT_ENTER_FRAME:String     = 'onEnterFrame';
	public static var EVENT_KEY_DOWN:String        = 'onKeyDown';
	public static var EVENT_KEY_UP:String          = 'onKeyUp';
	public static var EVENT_KILL_FOCUS:String      = 'onKillFocus';
	public static var EVENT_LOAD:String            = 'onLoad';
	public static var EVENT_MOUSE_DOWN:String      = 'onMouseDown';
	public static var EVENT_MOUSE_MOVE:String      = 'onMouseMove';
	public static var EVENT_MOUSE_UP:String        = 'onMouseUp';
	public static var EVENT_PRESS:String           = 'onPress';
	public static var EVENT_RELEASE:String         = 'onRelease';
	public static var EVENT_RELEASE_OUTSIDE:String = 'onReleaseOutside';
	public static var EVENT_ROLL_OUT:String        = 'onRollOut';
	public static var EVENT_ROLL_OVER:String       = 'onRollOver';
	public static var EVENT_SET_FOCUS:String       = 'onSetFocus';
	public static var EVENT_UNLOAD:String          = 'onUnload';
	
	
	/**
		Creates an empty instance of the EventMovieClip class. Use this instead of a traditional <code>new</code> constructor statement due to limitations of ActionScript 2.0.
		
		@param target: Location where the MovieClip should be attached.
		@param instanceName: A unique instance name for the MovieClip.
		@param depth: <strong>[optional]</strong> The depth level where the MovieClip is placed; defaults to next highest open depth.
		@param initObject: <strong>[optional]</strong> An object that contains properties with which to populate the newly attached MovieClip.
		@return Returns a reference to the created instance.
		@example <code>var myEvent_mc:EventMovieClip = EventMovieClip.create(this, "example_mc");</code>
		@usageNote If you want to extend a non empty MovieClip you can either define the ActionScript 2.0 class in the Flash IDE library or use {@link MovieClipUtil#attachMovieRegisterClass}.
	*/
	public static function create(target:MovieClip, instanceName:String, depth:Number, initObject:Object):EventMovieClip {
		return EventMovieClip(MovieClipUtil.createMovieRegisterClass('org.casaframework.movieclip.EventMovieClip', target, instanceName, depth, initObject));
	}
	
	
	private function EventMovieClip() {
		super();
		
		this.$setClassDescription('org.casaframework.movieclip.EventMovieClip');
	}
	
	/**
		@exclude
		@sends onData = function(sender_mc:MovieClip) {}
	*/
	public function onData():Void {
		this.dispatchEvent(EventMovieClip.EVENT_DATA, this);
	}
	
	/**
		@exclude
		@sends onDragOut = function(sender_mc:MovieClip) {}
	*/
	public function onDragOut():Void {
		this.dispatchEvent(EventMovieClip.EVENT_DRAG_OUT, this);
	}
	
	/**
		@exclude
		@sends onDragOver = function(sender_mc:MovieClip) {}
	*/
	public function onDragOver():Void {
		this.dispatchEvent(EventMovieClip.EVENT_DRAG_OVER, this);
	}
	
	/**
		@exclude
		@sends onEnterFrame = function(sender_mc:MovieClip) {}
	*/
	public function onEnterFrame():Void {
		this.dispatchEvent(EventMovieClip.EVENT_ENTER_FRAME, this);
	}
	
	/**
		@exclude
		@sends onKeyDown = function(sender_mc:MovieClip) {}
	*/
	public function onKeyDown():Void {
		this.dispatchEvent(EventMovieClip.EVENT_KEY_DOWN, this);
	}
	
	/**
		@exclude
		@sends onKeyUp = function(sender_mc:MovieClip) {}
	*/
	public function onKeyUp():Void {
		this.dispatchEvent(EventMovieClip.EVENT_KEY_UP, this);
	}
	
	/**
		@exclude
		@sends onKillFocus = function(sender_mc:MovieClip, newFocus:Object) {}
	*/
	public function onKillFocus(newFocus:Object):Void {
		this.dispatchEvent(EventMovieClip.EVENT_KILL_FOCUS, this, newFocus);
	}
	
	/**
		@exclude
		@sends onLoad = function(sender_mc:MovieClip) {}
	*/
	public function onLoad():Void {
		this.dispatchEvent(EventMovieClip.EVENT_LOAD, this);
	}
	
	/**
		@exclude
		@sends onMouseDown = function(sender_mc:MovieClip) {}
	*/
	public function onMouseDown():Void {
		this.dispatchEvent(EventMovieClip.EVENT_MOUSE_DOWN, this);
	}
	
	/**
		@exclude
		@sends onMouseMove = function(sender_mc:MovieClip) {}
	*/
	public function onMouseMove():Void {
		this.dispatchEvent(EventMovieClip.EVENT_MOUSE_MOVE, this);
	}
	
	/**
		@exclude
		@sends onMouseUp = function(sender_mc:MovieClip) {}
	*/
	public function onMouseUp():Void {
		this.dispatchEvent(EventMovieClip.EVENT_MOUSE_UP, this);
	}
	
	/**
		@exclude
		@sends onPress = function(sender_mc:MovieClip) {}
	*/
	public function onPress():Void {
		this.dispatchEvent(EventMovieClip.EVENT_PRESS, this);
	}
	
	/**
		@exclude
		@sends onRelease = function(sender_mc:MovieClip) {}
	*/
	public function onRelease():Void {
		this.dispatchEvent(EventMovieClip.EVENT_RELEASE, this);
	}
	
	/**
		@exclude
		@sends onReleaseOutside = function(sender_mc:MovieClip) {}
	*/
	public function onReleaseOutside():Void {
		this.dispatchEvent(EventMovieClip.EVENT_RELEASE_OUTSIDE, this);
	}
	
	/**
		@exclude
		@sends onRollOut = function(sender_mc:MovieClip) {}
	*/
	public function onRollOut():Void {
		this.dispatchEvent(EventMovieClip.EVENT_ROLL_OUT, this);
	}
	
	/**
		@exclude
		@sends onRollOver = function(sender_mc:MovieClip) {}
	*/
	public function onRollOver():Void {
		this.dispatchEvent(EventMovieClip.EVENT_ROLL_OVER, this);
	}
	
	/**
		@exclude
		@sends onSetFocus = function(sender_mc:MovieClip, oldFocus:Object) {}
	*/
	public function onSetFocus(oldFocus:Object):Void {
		this.dispatchEvent(EventMovieClip.EVENT_SET_FOCUS, this, oldFocus);
	}
	
	/**
		@exclude
		@sends onUnload = function(sender_mc:MovieClip) {}
	*/
	public function onUnload():Void {
		this.dispatchEvent(EventMovieClip.EVENT_UNLOAD, this);
	}
}