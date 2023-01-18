/*
* Copyright 2005 Herrlich & Ramuschkat GmbH
* 
* Name: DoubleClickDispatcher.as
* 
* $Author: DEismann $
* $Revision: 1.5 $
* $Date: 2005/04/28 07:14:41 $
* @ignore
*/

import mx.core.UIObject;

class de.richinternet.utils.DoubleClickDispatcher {
	
	public static var DOUBLECLICK_DELAY:Number = 500;
	private static var instance:DoubleClickDispatcher;
	
	private var timer:Number;
	private var lastObject:UIObject;
	
	// ----------------------------------------------------------------------------------------- //
	
	private function DoubleClickDispatcher() {
		// private constructor function
		timer = 0;
	}

	// ----------------------------------------------------------------------------------------- //
	
	public static function addObject(object:UIObject):Void {
		if (instance == undefined) instance = new DoubleClickDispatcher();
		instance.addObjectListener(object);
	}

	// ----------------------------------------------------------------------------------------- //
	
	public static function removeObject(object:UIObject):Void {
		if (instance != undefined) {
			instance.removeObjectListener(object);
		}
	}
	
	// ----------------------------------------------------------------------------------------- //
	
	private function addObjectListener(object:UIObject):Void {
		if (object instanceof UIObject) {
			// TODO: we don't really know if this UIObject dispatches 
			// a mouseDown event, but if it does, we'll catch it
			object.addEventListener("mouseDown", this);
		}
	}

	// ----------------------------------------------------------------------------------------- //
	
	private function removeObjectListener(object:UIObject):Void {
		object.removeEventListener("mouseDown", this);
	}

	// ----------------------------------------------------------------------------------------- //
	
	private function mouseDown(evt:Object):Void {
		// A double-click is triggered, if two mousedown events happen
		// within a specific timeframe on the same "source object"
		if (getTimer() - timer > DOUBLECLICK_DELAY) {
			timer = getTimer();
			lastObject = evt.target;
		} else {
			// make the object dispatch a doubleClick event
			if (lastObject == evt.target) {
				evt.target.dispatchEvent({type: "doubleClick"});
				timer = 0;
				delete lastObject;
			}
		}
	}
	
	// ----------------------------------------------------------------------------------------- //
}