import com.senocular.events.ButtonEventHandler;

/**
 * The ButtonEvent class defines event objects used by ButtonEventHandler.
 * ButtonEvent instances contain properties regarding movie clips handled by 
 * ButtonEventHandler and manages the events they receive. These instances
 * are created by ButtonEventHandler and returned from a call to
 * ButtonEventHandler.initialize.  It is also the object provided
 * to event handlers and provides information regarding the event and the
 * state of the movie clip receiving it. Other objects can be set to listen to 
 * events handled by ButtonEvent instances using addEventListener. 
 * @author Trevor McCauley
 * @link http://www.senocular.com
 * @version 0.9.7
 * @requires com.senocular.events.ButtonEventHandler
 * @usage myButtonEvent:ButtonEvent = ButtonEventHandler.initialize(myMovieClip:Object);
 * @example <pre class="code">
 * var my_mcEvent:ButtonEvent = ButtonEventHandler.initialize(my_mc);
 * my_mcEvent.onPress = function(event:ButtonEvent){
 * 	// my_mc.gotoAndStop("_down");
 * 	event.target.gotoAndStop("_down");
 * 	// optional; prevents onPress from being called for parents
 * 	event.stopPropagation();
 * }
 * </pre>
 * @see ButtonEventHandler class
 */
class com.senocular.events.ButtonEvent {
	/**
	 * A String spcifying the current event. This will be either:
	 * onPress, onRelease, onReleaseOutside, onRollOver, onRollOut, 
	 * onDragOver, onDragOut, or onMouseWithin.
	 * @usage event:String = myButtonEvent.type;
	 */
	public var type:String;
	/**
	 * The movie clip associated with this button event
	 * @usage movie:MovieClip = myButtonEvent.target;
	 * @see currentTarget
	 */
	public var target:Object;
	/**
	 * The first movie clip that initially encountered the current event.
	 * @usage movie:MovieClip = myButtonEvent.currentTarget;
	 * @see target
	 */
	public var currentTarget:Object;
	/**
	 * Specifies whether or not the mouse is within the current target.
	 * @usage movieMouseWithin:Boolean = myButtonEvent.mouseWithin;
	 */
	public var mouseWithin:Boolean = false;
	/**
	 * Specifies whether or not the mouse is down and the current
	 * target has been pressed.
	 * @usage moviePressed:Boolean = myButtonEvent.mouseWithin;
	 */
	public var pressed:Boolean = false;
	/**
	 * Determines whether or not the target will behave as a menu where
	 * it can receive events despite another movie clip having already been
	 * pressed (similar to Button and MovieClip trackAsMenu property).
	 * @usage myButtonEvent.trackAsMenu = value:Boolean;
	 */
	public var trackAsMenu:Boolean = false;
	/**
	 * Determines whether or not overlapping prevents events for objects in
	 * the same timeline (no parent/child relationships)  under the target clip
	 * for this ButtonEvent instance from triggering. If true,
	 * the behavior is like that of normal Flash buttons where buttons
	 * above other buttons, prevent the buttons below from receiving events.
	 * Note that this property only pertains when
	 * ButtonEventHandler.overlapBlocksEvents is false.
	 * @usage myButtonEvent.overlapBlocksEvents = value:Boolean
	 */
	public var overlapBlocksEvents:Boolean = false;

	// public for ButtonEventHandler
	public var depth:Number = 0;
	public var children:Array;
	
	// private
	private static var events:Array = ["onPress","onRelease","onReleaseOutside","onRollOver","onRollOut","onDragOver","onDragOut","onMouseWithin"];


	/**
	 * Used to prevent events from bubbling to parent movie clips. The event stopped
	 * is the current event as specified in this ButtonEvent's type property. This
	 * method would most commonly be used within an event handler for an event
	 * captured by ButtonEventHandler.
	 * @usage myButtonEvent.stopPropagation();
	 */
	public function stopPropagation():Void {
		ButtonEventHandler.stopPropagation(this.type);
	}
	
	// event handling
	/**
	 * Registers a listener object with this ButtonEvent instance that is
	 * broadcasting an event (from the target movie clip). 
	 * When the event occurs, the listener object or function is notified.
	 * @usage myButtonEvent.addEventListener(event:String, listener:Object);
	 * @param event A string that is the name of the event.
	 * @param listener A reference to a listener object or function to
	 * handle the event. 
	 * @return nothing.
	 */
	public function addEventListener(event:String, listener:Object):Void {}
	/**
	 * Removes a listener from receiving events from this ButtonEvent instance.
	 * @usage myButtonEvent.removeEventListener(event:String, listener:Object);
	 * @param event A string that is the name of the event.
	 * @param listener A reference to a listener object or function to
	 * handle the event. 
	 * @return nothing.
	 */
	public function removeEventListener(event:String, listener:Object):Void {}
	
	/**
	 * Define your own handleEvent handler to manage events
	 * sent to the target movie clip. The handleEvent handler can
	 * be defined to a ButtonEvent object (received from calling
	 * ButtonEventHandler.getEventObject(target)) or to the target
	 * movie clip. It will be called every time an event is triggered.
	 * @usage myButtonEvent.handleEvent = function(event:ButtonEvent){ ... };
	 * @param eventObject The current ButtonEvent event object.
	 * @return nothing.
	 */
	public function handleEvent(eventObject:ButtonEvent):Void {}
	private function dispatchEvent(event:ButtonEvent):Void {}

	// EVENTS
	/**
	 * Triggered when the mouse is pressed over a target movie clip.
	 * @usage myButtonEvent.onPress = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onPress(event:ButtonEvent):Void {}
	/**
	 * Triggered when the mouse is released over a target movie clip that was pressed.
	 * @usage myButtonEvent.onRelease = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onRelease(event:ButtonEvent):Void {}
	/**
	 * Triggered when the mouse is released over an area not above the target movie clip that was pressed.
	 * @usage myButtonEvent.onRelease = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onReleaseOutside(event:ButtonEvent):Void {}
	/**
	 * Triggered when the mouse is moves over a target movie clip.
	 * @usage myButtonEvent.onRollOver = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onRollOver(event:ButtonEvent):Void {}
	/**
	 * Triggered when the mouse is moves off a target movie clip.
	 * @usage myButtonEvent.onRollOut = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onRollOut(event:ButtonEvent):Void {}
	/**
	 * Triggered when the mouse is moves over a target movie clip that was pressed.
	 * @usage myButtonEvent.onDragOver = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onDragOver(event:ButtonEvent):Void {}
	/**
	 * Triggered when the mouse is moves off a target movie clip that was pressed.
	 * @usage myButtonEvent.onDragOut = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onDragOut(event:ButtonEvent):Void {}
	/**
	 * Triggered every frame when the mouse is over a target movie clip.
	 * @usage myButtonEvent.onMouseWithin = function(event:ButtonEvent){ ... };
	 * @param event The ButtonEvent object associated with the current target movie clip
	 */
	public function onMouseWithin(event:ButtonEvent):Void {}


	// public for ButtonEventHandler
	function ButtonEvent(target:Object){
		mx.events.EventDispatcher.initialize(this);
		this.target = target;
		this.children = new Array();
		this.updateDepth();
		for (var event:String in events){
			this.addEventListener(events[event], this);
		}
	}
	public function sendEvent(event:String, currentTarget:Object):Void {
		this.type = event;
		this.currentTarget = currentTarget;
		this.dispatchEvent(this);
	}
	public function updateDepth(Void):Void {
		this.depth = target.getDepth();
	}
	public function mouseHitTest(Void):Boolean {
		if (target.hitArea) return target.hitArea.hitTest(_root._xmouse, _root._ymouse, true);
		return target.hitTest(_root._xmouse, _root._ymouse, true);
	}
	
	// general
	public function toString(Void):String {
		return "ButtonEvent: "+this.target;
	}
	
}