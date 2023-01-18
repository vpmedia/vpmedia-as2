import com.senocular.events.ButtonEvent;

/**
 * The ButtonEventHandler class allows for timeline-based instances
 * (MovieClips) to receive button events and allows for those events to
 * bubble up to parent clips. This is contrary to normal button event
 * behavior (Buttons and MovieClips) which starts at the parent clip, or the
 * first parent clip with any kind of button event assigned to it, and prevents
 * any child clips from receiving any button events at all. 
 * A list of all supported events are as follows:
 *
 * <ul>
 * <li>onPress			</li>
 * <li>onRelease		</li>
 * <li>onReleaseOutside	</li>
 * <li>onRollOver		</li>
 * <li>onRollOut		</li>
 * <li>onDragOver		</li>
 * <li>onDragOut		</li>
 * <li>onMouseWithin	</li>
 * </ul>
 *
 * ButtonEventHandler uses onEnterFrame and hitTest to determine what events are fired and
 * when. This allows it to bypass the restriction of normal button event handling, however,
 * because of this, it is also more CPU intensive than normal button events.
 * Some differences between using ButtonEventHandler and normal button event handers:
 *
 * <ul>
 * <li>Additional onMouseWithin event with ButtonEventHandler</li>
 * <li>Events can bubble up into parent movie clips as opposed to being stopped as they are with normal buttons</li>
 * <li>"Sequential" events are not called in order of operation but rather follow the order of movie clip precedence.
 * For example, rolling onto a child clip from a parent clip will always call the onRollOver for
 * the child clip before the onRollOut for the parent because the child clip has precedence despite the
 * fact that technically the onRollOut happened before the onRollOver</li>
 * <li>No finger cursor is given to movie clips using these events. If you want, you can add a normal null button
 * event for this</li>
 * <li>onReleaseOutside is always called for movie clips when the mouse is released over an area not within the
 * movie clip clicked, even if released over an movie clip whose button event object's trackAsMenu property 
 * is set to true</li>
 * <li>onDragOver and onDragOut is called when the mouse is down has pressed an initialized movie clip, otherwise
 * onRollOver and onRollOut is called</li>
 * </ul>
 * To enable a movie clip to receive events from ButtonEventHandler, you must first initialize it with 
 * ButtonEventHandler.initialize (note that movie clips with child clips that have already been initialized
 * will automatically be initialized themselves). The initialize method returns a ButtonEvent instance which is
 * used to handle events sent managed by ButtonEventHandler. Using that instance's addEventListener method, 
 * you can register objects to receive events detected by ButtonEventHandler relating to the movie clip
 * initialized. The ButtonEvent object returned from initialization is automatically set as a
 * listener to itself (and each event recognized by ButtonEventHandler). The event object passed to 
 * listeners for those events will be the respective ButtonEvent instance.
 * @author Trevor McCauley
 * @link http://www.senocular.com
 * @version 0.9.7
 * @requires com.senocular.events.ButtonEvent
 * @usage myButtonEvent:ButtonEvent = ButtonEventHandler.initialize(movie:MovieClip);
 * @example <pre class="code">
 * // Example 1: Using a basic event handler from a ButtonEvent object
 * var my_mcEvent:ButtonEvent = ButtonEventHandler.initialize(my_mc);
 * my_mcEvent.onPress = function(event:ButtonEvent){
 * 	// my_mc.gotoAndStop("_down");
 * 	event.target.gotoAndStop("_down");
 * 	// optional; prevents onPress from being called for parents
 * 	event.stopPropagation(); 
 * }
 * &nbsp;
 * // Example 2: Using handleEvent with an initialized instance
 * // (this can also be used on a ButtonEvent object)
 * ButtonEventHandler.initialize(my_mc);
 * my_mc.handleEvent = function(event:ButtonEvent){
 * 	switch(event.type){
 * 		case "onPress":
 * 			// my_mc.gotoAndStop("_down");
 * 			this.gotoAndStop("_down");
 * 			// optional; prevents onPress from being called for parents
 * 			event.stopPropagation();
 * 			break;
 * 		case "onRelease":
 * 			// my_mc.gotoAndStop("_up");
 * 			this.gotoAndStop("_up");
 * 			break;
 * 	}
 * }
 * </pre>
 * Note that handleEvent can also be used with my_mc's associated ButtonEvent instance,
 * though be cautious of the fact that the scope of the function would change from that
 * of the movie clip to that of the ButtonEvent instance.
 */
class com.senocular.events.ButtonEventHandler {

	// VARIABLES
	// public variables
	/**
	 * Determines whether or not arrangement for handled movie clips
	 * is automatically updated every frame. If depths are altered for
	 * movie clips receiving events, this should be kept false.
	 * @usage ButtonEventHandler.autoUpdateArrangement = value:Boolean
	 */
	public static var autoUpdateArrangement:Boolean	= false;
	/**
	 * Determines whether or not overlapping prevents events for objects in
	 * the same timeline (no parent/child relationships) from triggering. If
	 * true, the behavior is like that of normal Flash buttons where buttons
	 * above other buttons, prevent the buttons below from receiving events.
	 * @usage ButtonEventHandler.overlapBlocksEvents = value:Boolean
	 * @see autoUpdateArrangement
	 */
	public static var overlapBlocksEvents:Boolean	= true;


	// private variables
	private static var isMouseDown:Boolean			= false;
	private static var children:Array				= new Array();
	private static var stoppedOverlapping:Object		= null;
	private static var stoppedEvents:Object			= new Object();
	private static var currentTargetEvents:Object	= new Object();
	
	
	// METHODS
	private static function classinit(Void):Void {
		var classObject:Object = ButtonEventHandler;
		mx.transitions.OnEnterFrameBeacon.init();
		MovieClip.addListener(classObject);
		Mouse.addListener(classObject);
		AsBroadcaster.initialize(classObject);
		classinit = null;
	}
	// public methods
	/**
	 * Initializes a target timeline instance (MovieClip) to be registered for receiving events
	 * from the ButtonEventHandler class. When initialized, the target as well as all its parents are 
	 * initialized too, if not already. The returned ButtonEvent object can be used to handle
	 * received events.
	 * @usage event:ButtonEvent = ButtonEventHandler.initialize(target:MovieClip);
	 * @param target Movie clip which is to receive events from
	 * ButtonEventHandler. This movie clip needs to be detectable with hitTest.
	 * @return ButtonEvent object associated with the target movie clip passed. This is the same
	 * object sent to event handlers when they are called.
	 */
	public static function initialize(target:Object):ButtonEvent {
		if (classinit) classinit();
		var foundObject:Object = findInstance("target", target);
		if (foundObject) return foundObject.instance;
		var instance:ButtonEvent = new ButtonEvent(target);
		if (target._parent){
			var parentInstance:ButtonEvent = getEventObject(target._parent);
			parentInstance.children.push(instance);
		}else{
			children.push(instance);
		}
		updateArrangement();
		return instance;
	}
	
	/**
	 * Removes the target movie clip from initialization preventing from receiving further events
	 * from ButtonEventHandler.  Any child movie clips are removed along with target.
	 * @usage success:Boolean = ButtonEventHandler.initialize(target:MovieClip);
	 * @param target Movie clip which is to be removed from receiving events from
	 * ButtonEventHandler.
	 * @return True or false depending on whether or not the removal was successful.
	 */
	public static function uninitialize(target:Object):Boolean {
		var foundObject:Object = findInstance("target", target);
		if (foundObject){
			foundObject.instances.splice(foundObject.index, 1);
			return true;
		}
		return false;
	}
	
	/**
	 * Returns an event object associated with the target movie clip.  If no ButtonEvent is associated with
	 * the target, the target will be initialized and a new ButtonEvent object will be created and returned.
	 * @usage event:ButtonEvent = ButtonEventHandler.getEventObject(movie:MovieClip);
	 * @param target Movie clip to get a ButtonEvent object for
	 * @return ButtonEvent object associated with the target movie clip passed. This is the same
	 * object sent to event handlers when they are called.
	 */
	public static function getEventObject(target:Object):ButtonEvent {
		return initialize(target);
	}

	/**
	 * Updates the arrangement and precedence of movie clips handled by
	 * ButtonEventHandler. This will automatically be called every frame
	 * if autoUpdateArrangement is true. You would only need to call this if
	 * autoUpdateArrangement is false and you've altered the depths of any movie clips
	 * receiving events from ButtonEventHandler.
	 * @usage ButtonEventHandler.updateArrangement();
	 * @param instances Optional parameter specifying which movie clips are
	 * to be arranged. Only used internally within the class.
	 * @see autoUpdateArrangement
	 */
	public static function updateArrangement(instances:Array):Void {
		if (instances == undefined) instances = children;
		var n:Number = instances.length;
		var i:Number;
		var instance:ButtonEvent;
		for (i=0; i<n; i++){
			instance = instances[i];
			if (instance.children.length) updateArrangement(instance.children);
			instance.updateDepth();
		}
		instances.sortOn("depth");
	}
	
	// public for ButtonEvent
	public static function stopPropagation(event:String):Void {
		stoppedEvents[event] = true;
	}
	
	// private methods
	// instances of ButtonEventHandler not made
	private function ButtonEventHandler(){}
	
	private static function sendEvent(event:String, instance:ButtonEvent){
		if (!currentTargetEvents[event]) currentTargetEvents[event] = instance;
		if (!stoppedEvents[event]) instance.sendEvent(event, currentTargetEvents[event]);
	}
	
	private static function initHandleEvents(Void):Void {
		isMouseDown = Key.isDown(1);
		stoppedOverlapping = null;
		currentTargetEvents = new Object();
		if (autoUpdateArrangement) updateArrangement();
	}
	private static function evaluateAllStates(additionalEvent:String, instances:Array):Void {
		if (instances == undefined) instances = children;
		var n:Number = instances.length;
		var i:Number;
		var instance:ButtonEvent;
		for (i=0; i<n; i++){
			instance = instances[i];
			if (!instance.target.hitTest){ // soft reference, check for hitTest method for removal
				instances.splice(i, 1);
				i--;
				break;
			}
			if (instance.children.length) evaluateAllStates(additionalEvent, instance.children);
			else stoppedEvents = new Object();
			evaluateInstanceStates(instance, additionalEvent);
		}
	}
	private static function evaluateInstanceStates(instance:ButtonEvent, additionalEvent:String):Void {
		var isMouseWithin:Boolean = (!stoppedEvents["onMouseWithin"] && (!stoppedOverlapping || stoppedOverlapping[String(instance.target)]) ) ? instance.mouseHitTest() : false;
		var pressing:Object = findInstance("pressed", true);
		if (!pressing || (instance.pressed || instance.trackAsMenu)){
			if (isMouseWithin != instance.mouseWithin){
				if (instance.mouseWithin = isMouseWithin){
					if (isMouseDown && pressing) sendEvent("onDragOver", instance); 
					else sendEvent("onRollOver", instance);
				}else{
					if (isMouseDown && pressing) sendEvent("onDragOut", instance); 
					else sendEvent("onRollOut", instance);
				}
			}
			if (instance.mouseWithin){
				sendEvent("onMouseWithin", instance);
				if ((overlapBlocksEvents || instance.overlapBlocksEvents) && !stoppedOverlapping) {
					stoppedOverlapping = new Object();
					var currTarget:Object = instance.target;
					while (currTarget = currTarget._parent)  stoppedOverlapping[String(currTarget)] = true; // allow parents to pass through overlap
				}
			}
		}
		switch (additionalEvent){
			case "onMouseDown":
				if (instance.pressed = instance.mouseWithin) sendEvent("onPress", instance);
				break;
			case "onMouseUp":
				if (instance.pressed){
					if (instance.mouseWithin) sendEvent("onRelease", instance);
					else sendEvent("onReleaseOutside", instance);
					instance.pressed = false;
				}else if (instance.mouseWithin && instance.trackAsMenu) sendEvent("onRelease", instance);
				break;
		}
	}
	private static function findInstance(property:String, value:Object, instances:Array):Object {
		if (instances == undefined) instances = children;
		var n:Number = instances.length;
		var i:Number;
		var foundObject:Object;
		var instance:ButtonEvent;
		for (i=0; i<n; i++){
			instance = instances[i];
			if (instance.children){
				foundObject = findInstance(property, value, instance.children);
				if (foundObject) return foundObject;
			}
			if (instance[property] == value) {
				return {instance:instance, instances:instances, index:i};
			}
		}
		return false;
	}
	
	// EVENT HANDLERS
	private static function onEnterFrame(){
		initHandleEvents();
		evaluateAllStates();
	}
	private static function onMouseDown(){
		initHandleEvents();
		evaluateAllStates("onMouseDown");
	}
	private static function onMouseUp(){
		initHandleEvents();
		evaluateAllStates("onMouseUp");
	}
} 