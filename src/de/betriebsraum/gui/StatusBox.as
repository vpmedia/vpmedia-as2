/*
	Group: General Information

	Note: Author
	
	Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de

	Note: About the StatusBox Class
	
	The StatusBox was created primarily for getting some kind of universal popup
	when dealing with dynamic flash applications (flash remoting, flash with php,
	xml etc.) or any other application where you want to keep the user informed
	about what's going on ;). 
	You can use it for displaying messages with different button arrangements/
	handler functions and displaying loading progress.
	
	An important point is that you are completely free in design of the StatusBox.
	Just skin and position the elements in the library to your liking.
	(No fancy skinning and styling-apis needed as in the mm components...;).
	
	I consciously don't provide any resizing methods because normally you want to
	make one nice popup which you reuse all over the application and if you want
	a completely different looking popup just create a new instance...
	So, when using the configuration method for the buttons, only the x-axis is
	respected, i.e. you can arrange the elements in y as you like.
	
	I've provided getter-methods for all elements, so you can get references to 
	all movieclips and manipulate them as you like (e.g. it's no problem to 
	integrate all your cool looking, heavy scripted preloading animations...;)
	or assigning stylesheets to the textfields.
	
	Note that i grouped the methods in methods which should be called before 
	creation of the StatusBox (for configuration purposes) and in methods that 
	should be called after creation (e.g. to overwrite handlers functions...etc.)
	Please also read the notes to the constructor and the create-method!	
	Have fun!	
*/


import mx.transitions.Tween;
import mx.events.EventDispatcher;
import mx.utils.Delegate;


class de.betriebsraum.gui.StatusBox {
	
	public var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	
	
	private var target_mc:MovieClip;
	private var container_mc:MovieClip;
	private var containerDepth:Number;
	private var boxID:String;
	private var box_mc:MovieClip;
	private var modal_mc:MovieClip;
	
	private var title_txt:TextField;
	private var message_txt:TextField;
	private var status_txt:TextField;
	private var bg_mc:MovieClip;
	private var drag_mc:MovieClip;
	private var ok_mc:MovieClip;
	private var cancel_mc:MovieClip;
	private var close_mc:MovieClip;
	private var icon_mc:MovieClip;
	private var load_mc:MovieClip;	

	private var xOffset:Number;
	private var yOffset:Number;
	
	private var position:Boolean;
	private var _x:Number;
	private var _y:Number;
	
	private var modal:Boolean;
	private var modalColor:Number;
	private var modalAlpha:Number;	
	
	private var fading:Boolean;	
	private var startFade:Number;
	private var endFade:Number;
	private var fadeSpeed:Number;
	private var fadeType:String;

	public var _okLabel:String;
	public var _cancelLabel:String;
	private var buttonAlignment:String;
	private var buttonMargins:Number;
	private var buttonDistance:Number;	
	
	private var defaultOkHandler:Function;
	private var defaultCancelHandler:Function;
	private var defaultCloseHandler:Function;
	private var defaultHandlerType:String;
	private var _autoDestroy:Boolean;
	
	
	// Group: Constructor
	
	/*
		Constructor: StatusBox
		Creates a new StatusBox instance.

		Parameters:
	
		id 					- Linkage id of mc_statusBox.
		target				- Target to which the StatusBox is attached.
		depth				- The depth in target on which to attach the StatusBox.
		xOffset (optional) 	- Defines how many pixels the StatusBox should be offset from the center in the 
							  x direction.
		yOffset (optional) 	- Defines how many pixels the StatusBox should be offset from the center in the 
							  y direction.	
		
		Notes:
		
		- 	For full features mc_statusBox must contain the following elements: title_txt, message_txt, 
			status_txt, bg_mc, drag_mc, ok_mc, cancel_mc, close_mc, icon_mc, load_mc. If you don't need/want
			a specific feature, just delete the corresponding movieclip! (e.g. if you don't want dragging,
			just delete the invisible drag_mc).
		
		- 	By default the StatusBox is centered on the stage (because that's probably the most common use 
			for a StatusBox). By specifying an x-/yOffset value you can move the StatusBox off the center, 
			e.g. to move it a little bit up in the y-direction (often the exact center seems to be a bit to 
			low...). If you want to position it exactly, you can use <setPositionProps> or <move>.
			
	*/
	public function StatusBox(id:String, target:MovieClip, depth:Number, xOffset:Number, yOffset:Number) {
		
		EventDispatcher.initialize(this);		
		
		boxID = id;
		target_mc = target;
		containerDepth = depth;
		
		this.xOffset = (xOffset != undefined) ? xOffset : 0;
		this.yOffset = (yOffset != undefined) ? yOffset : 0;
		
		setPositionProps(null);
		setModalProps(0, 0xFFFFFF);		
		setFadingProps(null);		
		setButtonProps(null);
		setDefaultHandler(null);
		
		_autoDestroy = true;
		
	}
	
	
	/***************************************************************************
	// PRIVATE METHODS (NOT DOCUMENTED)
	***************************************************************************/
	private function createMainContainer():Void {	
		
		container_mc = target_mc.createEmptyMovieClip("container_mc" + containerDepth, containerDepth);
		container_mc._x = 0;
		container_mc._y = 0;
		
	}
	
	
	private function convertCoordinates(mc:MovieClip):Object {
		
		var point:Object = {x:mc._x, y:mc._y};
		mc.localToGlobal(point);	
		
		point.x = (point.x/point.x == 1) ? -point.x : point.x;
		point.y = (point.y/point.y == 1) ? -point.y : point.y;
		
		return point;
		
	}
	
	
	private function initializeElements():Void {		
	
		box_mc = container_mc.attachMovie(boxID, "box_mc", 1);
		
		title_txt = box_mc.title_txt;
		message_txt = box_mc.message_txt;
		status_txt = box_mc.status_txt;
		bg_mc = box_mc.bg_mc;
		drag_mc = box_mc.drag_mc;
		ok_mc = box_mc.ok_mc;
		cancel_mc = box_mc.cancel_mc;
		close_mc = box_mc.close_mc;
		icon_mc = box_mc.icon_mc;
		load_mc = box_mc.load_mc;	
		
		if (position) {			
			move(_x, _y);			
		} else {			
			var stageCenterX:Number = Math.round((Stage.width /2) - (bg_mc._width /2) + xOffset);
			var stageCenterY:Number = Math.round((Stage.height/2) - (bg_mc._height/2) + yOffset);			
			var point:Object = convertCoordinates(box_mc);			
			move(point.x + stageCenterX, point.y + stageCenterY);
		}	
		
		if (modal) createModalArea();		
		if (fading) var fadeTween:Tween = new Tween(this[fadeType+"_mc"], "_alpha", mx.transitions.easing.Regular.easeOut, startFade, endFade, fadeSpeed, true);
		
	}
	
	
	private function createModalArea():Void {
		
		modal_mc = container_mc.createEmptyMovieClip("modal_mc", 0);				
		
		var point:Object = convertCoordinates(modal_mc);
		modal_mc._x = point.x;
		modal_mc._y = point.y;

		modal_mc.moveTo(0, 0);
		modal_mc.beginFill(modalColor, modalAlpha);  
		modal_mc.lineTo(Stage.width, 0);
		modal_mc.lineTo(Stage.width, Stage.height);
		modal_mc.lineTo(0, Stage.height);
		modal_mc.lineTo(0, 0);
		modal_mc.endFill();
		
		modal_mc.onRollOver = function():Void { };
		modal_mc.useHandCursor = false;
		
	}
	
	
	private function setupElements(mode:Array, custIconLabel:String):Void {
		
		hideElements();
		var thisIconLabel:String;
		
		if (mode != undefined && mode[0] !== mode[1]) {						
						
			if (mode.length == 1) {	
			
				this[mode[0]+"_mc"]._visible = true;
				if (mode[0] !== "load") {
					alignOne(this[mode[0]+"_mc"], bg_mc, buttonAlignment, buttonMargins);
				}
				
				thisIconLabel = mode[0];
								
			} else if (mode.length == 2) {
				
				this[mode[0]+"_mc"]._visible = true;
				this[mode[1]+"_mc"]._visible = true;
				
				if (mode[0] == "load") {					
					alignOne(this[mode[1]+"_mc"], bg_mc, buttonAlignment, buttonMargins);
				} else if (mode[1] == "load") {
					alignOne(this[mode[0]+"_mc"], bg_mc, buttonAlignment, buttonMargins);					
				} else {				
					alignTwo(this[mode[0]+"_mc"], this[mode[1]+"_mc"], bg_mc, buttonAlignment, buttonMargins, buttonDistance);
				}
				
				thisIconLabel = mode[0] + mode[1];
			
			}				
			
			setBoxIcon((custIconLabel == undefined) ? thisIconLabel : custIconLabel);
			
		} else {		
			setBoxIcon(custIconLabel ? custIconLabel : "none");		
		}		
				
		initializeButtons();
		enableBoxDragging();
		
	}
	
	
	private function hideElements():Void {
		
		ok_mc._visible = false;
		cancel_mc._visible = false;
		load_mc._visible = false;
		
	}
	
	
	private function alignOne(mc:MovieClip, target:MovieClip, alignment:String, offset:Number):Void {	
	
		switch (alignment) {
			
			case "left":
				mc._x = offset;	
				break;			
			case "center":		
				mc._x = Math.round(target._width/2 - mc._width/2);
				break;				
			case "right":
				mc._x = target._width - offset - mc._width;
				break;
			
		}			
		
	}
	
	
	private function alignTwo(mc1:MovieClip, mc2:MovieClip, target:MovieClip, alignment:String, offset:Number, distance:Number):Void {
		
		switch (alignment) {
			
			case "left":
				mc1._x = offset;
				mc2._x = mc1._x + mc1._width + distance;
				break;			
			case "center":		
				mc1._x = Math.round(target._width/2 - mc1._width/2 - mc1._width/2 - distance/2);
				mc2._x = Math.round(target._width/2 - mc2._width/2 + mc2._width/2 + distance/2);
				break;			
			case "right":
				mc1._x = target._width - offset - mc2._width - distance - mc1._width;
				mc2._x = target._width - offset - mc2._width;
				break;
			
		}		
		
	}
	
	
	private function setBoxIcon(label:String):Void {		
		icon_mc.gotoAndStop(label);		
	}
	
	
	private function initializeButtons():Void {
		
		ok_mc.label_txt.text = _okLabel;
		cancel_mc.label_txt.text = _cancelLabel;		
		
		setOkHandler(defaultOkHandler ? defaultOkHandler : null);
		setCancelHandler(defaultCancelHandler ? defaultCancelHandler : null);
		setCloseHandler(defaultCloseHandler ? defaultCloseHandler : null);
		
	}
	
	
	private function setButtonHandler(handler:Function, scope:Object, args:Array, mc:MovieClip):Void {
		
		mc[defaultHandlerType] = null;
		var me:StatusBox = this;
		
		var ok:String = okLabel;
		var cancel:String = cancelLabel;
		mc.onRollOver = function() {			
			this.label_txt.text = (mc == me.okButton) ? ok : cancel;
		};
		
		mc.onRollOut = mc.onRollOver;
		mc.onPress = mc.onRollOver;
		mc.onRelease = mc.onRollOver;		
		mc.onReleaseOutside = mc.onRollOver;
		mc.onDragOut = mc.onRollOver;
		mc.onDragOver = mc.onRollOver;
		
		mc[defaultHandlerType] = function() {
			
			this.label_txt.text = (mc == me.okButton) ? ok : cancel;		
		
			if (handler != null) {	
				handler.apply(scope, args);
				if (me.autoDestroy) me.destroy();		
			} else {
				me.destroy();
			}
			
		};
		
	}
	
	
	private function enableBoxDragging():Void {		
	
		drag_mc.onPress = Delegate.create(this, startDragging);		
		drag_mc.onRelease = Delegate.create(this, stopDragging);	
		drag_mc.onReleaseOutside = drag_mc.onRelease;		
		
		drag_mc.useHandCursor = false;
	
	}	
	
	
	private function startDragging():Void {
		box_mc.startDrag(false, 0, 0, Stage.width-bg_mc._width, Stage.height-bg_mc._height);
	}
	
	private function stopDragging():Void {
		box_mc.stopDrag();
	}
	
	
	/***************************************************************************
	// PUBLIC METHODS
	***************************************************************************/
	
	// Group: Call these methods BEFORE creation
	
	/*
		Function: setDefaultHandler	
		Sets default handler-functions for all buttons.
		
		Parameters:
		
		defaultOkHandler (optional) 	- Sets a new default handler-function for the ok-button.
		defaultCancelHandler (optional)	- Sets a new default handler-function for the cancel-button.
		defaultCloseHandler (optional)	- Sets a new default handler-function for the close-button.
		defaultHandlerType (optional)	- Handler type, e.g. "onPress", default is "onRelease".
		
		Notes:
		
		-	The functions you define here are automatically assigned to the buttons everytime a StatusBox
			is created. 
			By using e.g. <setOkHandler> you can overwrite the default ok-handler after creation.
		- 	If you don't define any default handler-functions the StatusBox is destroyed when you click a
			button.
		-	All parameters are optional, i.e. pass in null for the button you don't want a 
			default handler-function assigned.
	*/
	public function setDefaultHandler(defaultOkHandler:Function, defaultCancelHandler:Function, defaultCloseHandler:Function, defaultHandlerType:String):Void {
		
		this.defaultOkHandler = defaultOkHandler;
		this.defaultCancelHandler = defaultCancelHandler;
		this.defaultCloseHandler = defaultCloseHandler;
		this.defaultHandlerType	= defaultHandlerType;
		
		if (defaultHandlerType == undefined) this.defaultHandlerType = "onRelease";
		
	}
	
	
	/*
		Function: setPositionProps
		Sets the position where a StatusBox should be created. (in relation to the target specified in the 
															    constructor.)
		
		Parameters:
		
		x - x-Position.
		y - y-Position.
		
		Notes:
		
		- 	This method must be called before a StatusBox is created. 
		- 	When this method was called, every time you create a StatusBox it is positioned at the
			coordinates you have defined.
		- 	You can disable this method again by passing in null as a parameter.
	*/
	public function setPositionProps(x:Number, y:Number):Void {
		
		if (x == null) {
			position = false;			
		} else {
			position = true;
			this._x = x;
			this._y = y;	
		}			
		
	}	
	
	
	/*
		Function: setModalProps
		Sets the alpha and color of the modal area.
		
		Parameters:
		
		modalColor - Color of the modal area.
		modalAlpha - Alpha value of the modal area.		
		
		Notes:
		
		-	A modal area means that you can't interact with other elements on the screen as long as a
			StatusBox is active (so the user has to first click a button to go on...).
		- 	The default values are: color: 0xFFFFFF, alpha: 0
		- 	This method must be called before a StatusBox is created. 
		- 	When this method was called, every time you create a StatusBox the properties you have defined
			are used.
		- 	You can disable the modal area again by passing in null as a parameter.		
	*/
	public function setModalProps(modalColor:Number, modalAlpha:Number):Void {
							   
		if (modalAlpha == null) {
			modal = false;			
		} else {
			modal = true;
			this.modalColor = modalColor;
			this.modalAlpha = modalAlpha;			
		}
		
	}
	
	
	/*
		Function: setFadingProps
		Sets the fading behaviour of a StatusBox.
		
		Parameters:
		
		startFade 		- Start alpha value.
		endFade 		- End alpha value.
		fadeSpeed		- Duration in seconds.
		fadeType		- Possible values: "container" (fades box and modal area), "box" (fades box only), "modal" (fades modal area only)
		
		Notes:
		
		-	By default no fading is active.
		- 	This method must be called before a StatusBox is created. 
		- 	When this method was called, every time you create a StatusBox the properties you have defined
			are used.
		- 	You can disable fading again by passing in null as a parameter.		
	*/
	public function setFadingProps(startFade:Number, endFade:Number, fadeSpeed:Number, fadeType:String):Void {
 
		if (startFade == null) {			
			fading = false;			
		} else {
			fading = true;
			this.startFade = startFade;	
			this.endFade = endFade;			
			this.fadeSpeed = fadeSpeed;
			this.fadeType = fadeType;
		}
		
	}
	
	
	/*
		Function: setButtonProps
		Sets the labels, alignment, margins and distance of the buttons.
		
		Parameters:
		
		okLabel 		- Label of the ok-Button.
		cancelLabel 	- Label of the cancel-Button.
		buttonAlignment	- Alignment of the button(s): "left", "right", "center".
		buttonMargins	- Distance from the sides of mc_bg.
		buttonDistance	- Distance between the buttons.
		
		Notes:
		
		-	Default values are: No labels for the buttons, buttonAlignment: "center", buttonMargins: 10, 
			buttonDistance: 10.
		-	Only the x-axis is respected so that you are free in design (move the buttons in y wherever
			you want them).
		- 	This method must be called before a StatusBox is created. 
		- 	When this method was called, every time you create a StatusBox the properties you have defined
			are used.
		- 	You can restore the default values again by passing in null as a parameter.		
	*/
	public function setButtonProps(okLabel:String, cancelLabel:String, buttonAlignment:String, buttonMargins:Number, buttonDistance:Number):Void {
		
		if (okLabel == null) {
			this._okLabel = "";
			this._cancelLabel = "";
			this.buttonAlignment = "center";
			this.buttonMargins = 10;
			this.buttonDistance = 10;			
		} else {	
			this._okLabel = okLabel;
			this._cancelLabel = cancelLabel;
			this.buttonAlignment = buttonAlignment;
			this.buttonMargins = buttonMargins;
			this.buttonDistance = buttonDistance;	
		}
		
	}
	
	
	// Group: Creation
	
	/* 
		Function: create
		Creates a StatusBox.
		
		Parameters:
		
		title 						- The title to be displayed.
		message 					- The message to be displayed.
		mode (optional) 			- An array of buttons to be displayed (order matters!).
		custIconLabel (optional)	- The custom label to be displayed (if you have created custom labels 
									  in the mc_icon).
		
		Notes:
		
		-	You can manipulate the depth after creation by swapping the depth directly on the 
			<containerClip> or by using <setOnTop>.
			
		-	Possible mode-arrays are: ["ok"], ["cancel"], ["ok", "cancel"], ["cancel", "ok"], ["load"], 
			["ok", "load"], ["cancel, "load"]. If you don't define a mode-array, no buttons are displayed. 
			You can use that in conjunction with <close>, e.g. to display a message x seconds...
			
		- 	If one of the strings is "load", the loadingClip is displayed and the message is put into the
			status_txt instead of messsage_txt (so you can format the progress messages differently).
		
		- 	If you don't define a custIconLabel, the corresponding frame in mc_icon is used (by default a
			label for every combination of buttons exists, you can add as many custom labels as you want).
		
		Tip:
		
		If you need a third button for a specific situation consider to divert the close-button from its
		intended use...
	*/	
	public function create(title:String, message:String, mode:Array, custIconLabel:String):Void {		

		destroy();		
		createMainContainer();		
		initializeElements();			
		setupElements(mode, custIconLabel);			
		
		title_txt.text = title;		
		if (mode[0] == "load" || mode[1] == "load") {
			status_txt.text = message;
		} else {
			message_txt.text = message;
		}
		
	}	
		
	
	// Group: Call these methods AFTER creation
		
	/*
		Function: destroy		
		Removes a StatusBox. (By default the StatusBox is removed when you click a button.)
	*/
	public function destroy():Void {		
		container_mc.removeMovieClip();		
	}
	
	
	/*
		Function: close		
		Destroys a StatusBox after x seconds.
		
		Parameters:
		
		seconds - Seconds to pass for the StatusBox to be destroyed.	
		
		Note:
		
		Fires an <onClose> event.
	*/
	public function close(seconds:Number):Void {
		
		var refObj:StatusBox = this;		
		var startTime:Number = getTimer();
		
		container_mc.onEnterFrame = function() {
			if (getTimer() > (startTime+(seconds*1000))) {
				delete this.onEnterFrame;
				this.removeMovieClip();
				refObj.dispatchEvent({target:refObj, type:"onClose"});
			}
		};	
		
	}
	
	
	/*
		Function: show		
		Shows a StatusBox again when it was hidden by <hide>.	
	*/
	public function show():Void {		
		container_mc._visible = true;		
	}	
	
	
	/*
		Function: hide	
		Hides a StatusBox.
		
		Note:
		The StatusBox isn't actually removed, it's just hidden.
	*/
	public function hide():Void {		
		container_mc._visible = false;		
	}
	
	
	/*
		Function: move	
		Moves a StatusBox to a new position. (in relation to the target specified in the constructor.)
		
		Parameters:
		
		x - New x-Position.
		y - New y-Position.
	*/
	public function move(x:Number, y:Number):Void {
		
		box_mc._x = x;
		box_mc._y = y;		
		
	}
	
	
	/*
		Function: setOnTop	
		Sets the StatusBox on top of all other elements.
	*/
	public function setOnTop():Void {		
		container_mc.swapDepths(target_mc.getNextHighestDepth());		
	}
	
	
	/*
		Function: setOkHandler	
		Sets a new handler function for the ok-button.
		
		Parameters:
		
		handler - Custom function that is called when you press the ok-button.
		scope - The scope where the handler function is called (e.g. this)
		
		Note:
		
		Additional arguments can be passed to the handler function, e.g. setOkHandler(okHandler, this, "test", myVar)
	*/
	public function setOkHandler(handler:Function, scope:Object):Void {
		setButtonHandler(handler, scope, arguments.slice(2), ok_mc);
	}
	
	
	/*
		Function: setCancelHandler	
		Sets a new handler function for the cancel-button.
		
		Parameters:
		
		handler - Custom function that should be called when you press the cancel-button.
		scope - The scope where the handler function is called (e.g. this)
		
		Note:
		
		Additional arguments can be passed to the handler function, e.g. setCancelHandler(cancelHandler, this, "test", myVar)
	*/
	public function setCancelHandler(handler:Function, scope:Object):Void {	
		setButtonHandler(handler, scope, arguments.slice(2), cancel_mc);		
	}
	
	
	/*
		Function: setCloseHandler	
		Sets a new handler function for the close-button.
		
		Parameters:
		
		handler - Custom function that should be called when you press the close-button.
		scope - The scope where the handler function is called (e.g. this)
		
		Note:
		
		Additional arguments can be passed to the handler function, e.g. setCloseHandler(closeHandler, this, "test", myVar)
		
		If you want to use the close button for another purpose, feel free to do so.
		(e.g. you may want to give it a textfield and reference it through the <closeButton>-getter.)
		
	*/
	public function setCloseHandler(handler:Function, scope:Object):Void {	
		setButtonHandler(handler, scope, arguments.slice(2), close_mc);
	}
	
	
	
	
	/***************************************************************************
	// GETTER/SETTER
	***************************************************************************/
	
	// Group: Getter/Setter
	
	/*
		Property: title
		Gets/Sets the title.	
	*/
	public function get title():String {		
		return title_txt.text;		
	}
	
	public function set title(newTitle:String):Void {		
		title_txt.text = newTitle;		
	}	
	
	
	/*
		Property: message
		Gets/Sets the message.	
	*/	
	public function get message():String {		
		return message_txt.text;		
	}
	
	public function set message(newMessage:String):Void {	
		message_txt.text = newMessage;						
	}	
	
	
	/*
		Property: status
		Gets/Sets the status (displayed when one of the button modes is "load").
	*/
	public function get status():String {		
		return status_txt.text;		
	}
	
	public function set status(newStatus:String):Void {		
		status_txt.text = newStatus;		
	}	
	
	
	/*
		Property: autoDestroy
		Gets/Sets autoDestroy (when set to true the Statusbox is automatically destroyed after a custom
							   handler function is called).
		Default value: true
	*/	
	public function get autoDestroy():Boolean {		
		return _autoDestroy;		
	}
	
	public function set autoDestroy(mode:Boolean):Void {		
		_autoDestroy = mode;		
	}
	
	
	/*
		Property: okLabel
		Gets/Sets the label of the ok-button.
	*/
	public function get okLabel():String {
		return ok_mc.label_txt.text;
	}
	
	public function set okLabel(newOkLabel:String):Void {
		
		_okLabel = newOkLabel;
		ok_mc.label_txt.text =  newOkLabel;
		
	}
	
	
	/*
		Property: cancelLabel
		Gets/Sets the label of the cancel-button.
	*/
	public function get cancelLabel():String {		
		return cancel_mc.label_txt.text;
	}	
	
	public function set cancelLabel(newCancelLabel:String):Void {
		
		_cancelLabel = newCancelLabel;
		cancel_mc.label_txt.text = newCancelLabel;
		
	}	
	
	
	/***************************************************************************
	// READ-ONLY GETTER
	***************************************************************************/
	
	// Group: Read-Only Getter
	
	/*
		Property: x
		Gets the x-Position.	
	*/
	public function get x():Number {		
		return box_mc._x;	
	}
	
	/*
		Property: y
		Gets the y-Position.	
	*/
	public function get y():Number {		
		return box_mc._y;	
	}
	
	/*
		Property: width
		Gets the width.	
	*/
	public function get width():Number {		
		return bg_mc._width;	
	}
	
	/*
		Property: height
		Gets the height.	
	*/
	public function get height():Number {		
		return bg_mc._height;	
	}
	
	/*
		Property: containerClip
		Gets a reference to the containerClip (holds the modalClip and the boxClip).
	*/
	public function get containerClip():MovieClip {
		return container_mc;		
	}
	
	/*
		Property: modalClip
		Gets a reference to the modalClip.
	*/
	public function get modalClip():MovieClip {
		return modal_mc;
	}
	
	/*
		Property: boxClip
		Gets a reference to the boxClip (holds all StatusBox elements).
	*/
	public function get boxClip():MovieClip {
		return box_mc;		
	}
	
	/*
		Property: bgClip
		Gets a reference to the bgClip.
	*/
	public function get bgClip():MovieClip {
		return bg_mc;		
	}
	
	/*
		Property: dragClip
		Gets a reference to the dragClip.
	*/
	public function get dragClip():MovieClip {
		return drag_mc;		
	}
	
	/*
		Property: titleField
		Gets a reference to the titleField.
	*/
	public function get titleField():TextField {
		return title_txt;		
	}		
	
	/*
		Property: messageField
		Gets a reference to the messageField.
	*/
	public function get messageField():TextField {
		return message_txt;		
	}	
	
	/*
		Property: statusField
		Gets a reference to the statusField.
	*/
	public function get statusField():TextField {
		return status_txt;		
	}	
	
	/*
		Property: okButton
		Gets a reference to the okButton.
	*/
	public function get okButton():MovieClip {
		return ok_mc;
	}
	
	/*
		Property: cancelButton
		Gets a reference to the cancelButton.
	*/
	public function get cancelButton():MovieClip {
		return cancel_mc;
	}		
	
	/*
		Property: closeButton
		Gets a reference to the closeButton.
	*/
	public function get closeButton():MovieClip {
		return close_mc;
	}	
	
	/*
		Property: iconClip
		Gets a reference to the iconClip.
	*/
	public function get iconClip():MovieClip {	
		return icon_mc;
	}
	
	/*
		Property: loadClip
		Gets a reference to the loadClip.
	*/
	public function get loadClip():MovieClip {	
		return load_mc;
	}
	
	
	/***************************************************************************
	// EVENTS
	***************************************************************************/
	
	// Group: Events
	
	/*
		Event: onClose	
		Fired by <close> when a StatusBox is destroyed.
	*/
	
	
}