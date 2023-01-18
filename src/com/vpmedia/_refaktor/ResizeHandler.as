import mx.core.UIObject;
import mx.utils.Delegate;
import CursorManager;
/*
 	Class: ResizeHandler

Creates a resize handler in a parent component (based on v2 MM framework) that handles all resize logic.

Author:
Carlos Rovira - carlos.rovira@lycos.es

<http://www.carlosrovira.com>

Many thanks to Manish Jethani for his inspirational post
entitled "Resizable TitleWindow in Flex" at http://manish.revise.org/2005/04/resizable-titlewindow-in-flex.html

Package:
com.carlosrovira.controls

Usage:

// --- Imports the class in the parent component
import com.carlosrovira.controls.ResizeHandler;

// --- Create as many resize handlers as you need (all resize logic is self managed by the handler)
ResizeHandler.createResizeHandler(this, ResizeHandler.TL);
ResizeHandler.createResizeHandler(this, ResizeHandler.T);
ResizeHandler.createResizeHandler(this, ResizeHandler.TR);
ResizeHandler.createResizeHandler(this, ResizeHandler.R);
ResizeHandler.createResizeHandler(this, ResizeHandler.BR);
ResizeHandler.createResizeHandler(this, ResizeHandler.B);
ResizeHandler.createResizeHandler(this, ResizeHandler.BL);
ResizeHandler.createResizeHandler(this, ResizeHandler.L);

Custom Events:

// --- Parent object (viewRef) is added automaticaly as a Listener
resizeHandlerPressed : Fired when resize handler is pressed
resizeHandlerReleased : Fired when resize handler is released

Listen to parent "resize" events.

parent could dispatch "revealHandler" and "hideHandler" to disable handler

Notes:

Use minWidth and minHeight (or setMinWidth and setMinHeight)to define the minimun width & height
// --- Sets min Width & Height
minWidth = 80;
minHeight = 80;

If you need other thickness or offset you can pass as params
ResizeHandler.createResizeHandler(this, ResizeHandler.BL, 3, 3);

See Also:

    <CursorManager>
*/
class ResizeHandler extends UIObject {
	static var symbolName:String = "ResizeHandler";
	static var symbolOwner:Object = ResizeHandler;
	var className:String = "ResizeHandler";
	public static var TL:Number = 1;
	public static var T:Number = 2;
	public static var TR:Number = 3;
	public static var R:Number = 4;
	public static var BR:Number = 5;
	public static var B:Number = 6;
	public static var BL:Number = 7;
	public static var L:Number = 8;
	private var cursorId:Number = null;
	private var regX:Number;
	private var regY:Number;
	private var xOffset:Number;
	private var yOffset:Number;
	private var __xM:Number;
	public function get xM ():Number {
		return viewRef._xmouse;
	}
	private var __yM:Number;
	public function get yM ():Number {
		return viewRef._ymouse;
	}
	private var __xP:Number;
	public function get xP ():Number {
		return viewRef.x;
	}
	private var __yP:Number;
	public function get yP ():Number {
		return viewRef.y;
	}
	private var __wP:Number;
	public function get wP ():Number {
		return viewRef.width;
	}
	private var __hP:Number;
	public function get hP ():Number {
		return viewRef.height;
	}
	private var __mWP:Number;
	public function get mWP ():Number {
		return viewRef.minWidth;
	}
	private var __mHP:Number;
	public function get mHP ():Number {
		return viewRef.minHeight;
	}
	// --- viewRef
	private var __viewRef:Object;
	public function get viewRef ():Object {
		return __viewRef;
	}
	public function set viewRef (value:Object):Void {
		__viewRef = value;
	}
	// --- location
	private var __location:Number;
	public function get location ():Number {
		return __location;
	}
	public function set location (value:Number):Void {
		__location = value;
	}
	// --- edgeRange
	private var __edgeRange:Number = 4;
	public function get edgeRange ():Number {
		return __edgeRange;
	}
	public function set edgeRange (value:Number):Void {
		__edgeRange = value;
	}
	// --- offset
	private var __offset:Number = 0;
	public function get offset ():Number {
		return __offset;
	}
	public function set offset (value:Number):Void {
		__offset = value;
	}
	private function init ():Void {
		super.init ();
		_alpha = 0;
		onRollOver = Delegate.create (this, rollOverHandler);
		onRollOut = Delegate.create (this, rollOutHandler);
		onPress = Delegate.create (this, pressResizeHandler);
		onRelease = Delegate.create (this, releaseResizeHandler);
		onReleaseOutside = Delegate.create (this, releaseOutsideResizeHandler);
		addEventListener ("resizeHandlerPressed", viewRef);
		addEventListener ("resizeHandlerReleased", viewRef);
		viewRef.addEventListener ("resize", this);
		viewRef.addEventListener ("revealHandler", this);
		viewRef.addEventListener ("hideHandler", this);
		doLater (this, "locateHandler");
		doLater (this, "sizeHandler");
	}
	// --- Use this helper method to create the handler
	public static function createResizeHandler (parent:UIObject, location:Number, edgeRange:Number, offset:Number):ResizeHandler {
		if (edgeRange == undefined) {
			edgeRange = 4;
		}
		if (offset == undefined) {
			offset = 0;
		}
		var initObj:Object = {viewRef:parent, location:location, edgeRange:edgeRange, offset:offset};
		return ResizeHandler (parent.createClassObject (ResizeHandler, location.toString (), parent.getNextHighestDepth (), initObj));
	}
	// --- Roll over handler -> show resize cursor
	private function rollOverHandler ():Void {
		switch (location) {
		case ResizeHandler.TL :
			showResizeHandle ("diagonalBR");
			break;
		case ResizeHandler.T :
			showResizeHandle ("vertical");
			break;
		case ResizeHandler.TR :
			showResizeHandle ("diagonalBL");
			break;
		case ResizeHandler.R :
			showResizeHandle ("horizontal");
			break;
		case ResizeHandler.BR :
			showResizeHandle ("diagonalBR");
			break;
		case ResizeHandler.B :
			showResizeHandle ("vertical");
			break;
		case ResizeHandler.BL :
			showResizeHandle ("diagonalBL");
			break;
		case ResizeHandler.L :
			showResizeHandle ("horizontal");
			break;
		}
	}
	// --- Roll out handler -> remove resize cursor
	private function rollOutHandler ():Void {
		removeCursor (cursorId);
		cursorId = null;
	}
	// --- Press handler -> put component in top z-index and start moving/resizing
	private function pressResizeHandler ():Void {
		regX = xM;
		regY = yM;
		dispatchEvent ({type:"resizeHandlerPressed"});
		onMouseMove = mouseMoveResizeHandler;
	}
	// --- Stop moving/resizing (but don't remove current cursor!!!)
	private function releaseResizeHandler ():Void {
		dispatchEvent ({type:"resizeHandlerReleased"});
		delete onMouseMove;
	}
	// --- stop moving/resizing and remove current cursor
	private function releaseOutsideResizeHandler ():Void {
		delete onMouseMove;
		removeCursor (cursorId);
		cursorId = null;
	}
	// --- Moving/resizing logic based on v2 methods : setSize and move
	private function mouseMoveResizeHandler ():Void {
		xOffset = xM - regX;
		yOffset = yM - regY;
		switch (location) {
		case ResizeHandler.TL :
			if (wP - xM >= mWP) {
				viewRef.move (xP + xOffset, yP);
				viewRef.setSize (wP - xOffset, hP);
			}
			if (hP - yM >= mHP) {
				viewRef.move (xP, yP + yOffset);
				viewRef.setSize (wP, hP - yOffset);
			}
			break;
		case ResizeHandler.T :
			if (hP - yM >= mHP) {
				viewRef.move (xP, yP + yOffset);
				viewRef.setSize (wP, hP - yOffset);
			}
			break;
		case ResizeHandler.TR :
			if (xM >= mWP) {
				viewRef.setSize (wP + xOffset, hP);
			}
			if (hP - yM >= mHP) {
				viewRef.move (xP, yP + yOffset);
				viewRef.setSize (wP, hP - yOffset);
			}
			break;
		case ResizeHandler.R :
			if (xM >= mWP) {
				viewRef.setSize (wP + xOffset, hP);
			}
			break;
		case ResizeHandler.BR :
			if (xM >= mWP) {
				viewRef.setSize (wP + xOffset, hP);
			}
			if (yM >= mHP) {
				viewRef.setSize (wP, hP + yOffset);
			}
			break;
		case ResizeHandler.B :
			if (yM >= mHP) {
				viewRef.setSize (wP, hP + yOffset);
			}
			break;
		case ResizeHandler.BL :
			if (wP - xM >= mWP) {
				viewRef.move (xP + xOffset, yP);
				viewRef.setSize (wP - xOffset, hP);
			}
			if (yM >= mHP) {
				viewRef.setSize (wP, hP + yOffset);
			}
			break;
		case ResizeHandler.L :
			if (wP - xM >= mWP) {
				viewRef.move (xP + xOffset, yP);
				viewRef.setSize (wP - xOffset, hP);
			}
			break;
		}
		regX = xM;
		regY = yM;
		updateAfterEvent ();
	}
	// --- CursorManager proxy functions
	private function showResizeHandle (orientation:String):Void {
		if (cursorId == null) {
			switch (orientation) {
			case "vertical" :
				cursorId = setCursor ("vResizeCursor");
				break;
			case "horizontal" :
				cursorId = setCursor ("hResizeCursor");
				break;
			case "diagonalBR" :
				cursorId = setCursor ("dBRResizeCursor");
				break;
			case "diagonalBL" :
				cursorId = setCursor ("dBLResizeCursor");
				break;
			}
		}
	}
	private function setCursor (cursorSkin:String):Number {
		return CursorManager.getCursorManager ().setCursor (cursorSkin);
	}
	private function removeCursor (cursorId:Number):Void {
		CursorManager.getCursorManager ().removeCursor (cursorId);
	}
	// --- Updates hanlder's position
	private function locateHandler ():Void {
		switch (location) {
		case ResizeHandler.TL :
			move (-edgeRange + offset, -edgeRange + offset);
			break;
		case ResizeHandler.T :
			move (edgeRange + offset, -edgeRange + offset);
			break;
		case ResizeHandler.TR :
			move (wP - edgeRange - offset, -edgeRange + offset);
			break;
		case ResizeHandler.R :
			move (wP - edgeRange - offset, edgeRange + offset);
			break;
		case ResizeHandler.BR :
			move (wP - edgeRange - offset, hP - edgeRange - offset);
			break;
		case ResizeHandler.B :
			move (edgeRange + offset, hP - edgeRange - offset);
			break;
		case ResizeHandler.BL :
			move (-edgeRange + offset, hP - edgeRange - offset);
			break;
		case ResizeHandler.L :
			move (-edgeRange + offset, edgeRange + offset);
			break;
		}
	}
	// --- Updates handler's size
	private function sizeHandler ():Void {
		switch (location) {
		case ResizeHandler.TL :
			setSize (2 * edgeRange, 2 * edgeRange);
			break;
		case ResizeHandler.T :
			setSize (wP - 2 * edgeRange - 2 * offset, 2 * edgeRange);
			break;
		case ResizeHandler.TR :
			setSize (2 * edgeRange, 2 * edgeRange);
			break;
		case ResizeHandler.R :
			setSize (2 * edgeRange, hP - 2 * edgeRange - 2 * offset);
			break;
		case ResizeHandler.BR :
			setSize (2 * edgeRange, 2 * edgeRange);
			break;
		case ResizeHandler.B :
			setSize (wP - 2 * edgeRange - 2 * offset, 2 * edgeRange);
			break;
		case ResizeHandler.BL :
			setSize (2 * edgeRange, 2 * edgeRange);
			break;
		case ResizeHandler.L :
			setSize (2 * edgeRange, hP - 2 * edgeRange - 2 * offset);
			break;
		}
	}
	// --- Event handlers for parent events
	private function resize ():Void {
		// --- Updates hanlder's position
		locateHandler ();
		// --- Updates handler's size
		sizeHandler ();
	}
	private function revealHandler ():Void {
		setVisible (true);
	}
	private function hideHandler ():Void {
		setVisible (false);
	}
}
