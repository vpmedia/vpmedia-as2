/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- Pause

	AUTHOR

		Name : Pause
		Package : neo.process
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		new Pause(duration:Number, seconds:Boolean) ;

	PROPERTY SUMMARY
	
		- duration:Number [R/W]
		
		- useSeconds:Boolean

	METHOD SUMMARY
	
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- addListener (oL, f:Function):Void ;
		
		- clone():Pause
		
		- execute( e: IEvent )
		
		- getDuration():Number
		
		- notifyFinished():Void 
		
		- notifyStarted():Void 
		
		- removeEventListener(e:EventType, oL):Void ;
	
		- removeListener(oL):Void ;
		
		- setDuration(duration:Number):Void
		
		- start():Void
		
		- stop():Void
		
		- toSource():String
		
		- toString():String
	
	EVENT SUMMARY
	
		- ActionEventType.FINISHED
		
		- ActionEventType.STARTED
	
	INHERIT
	
		Object 
			|
			AbstractAction
				|
				Pause

	IMPLEMENTS
	
		Command, IAction, ICloneable, IFormattable

----------  */

import com.bourre.core.HashCodeFactory;

import neo.events.TimerEventType;
import neo.process.AbstractAction;
import neo.util.factory.PropertyFactory;
import neo.util.Timer;

class neo.process.Pause extends AbstractAction {

	// ----o Constructor
	
	public function Pause(duration:Number, seconds:Boolean) {
		setDuration(duration) ;
		useSeconds = seconds ;
		_timer = new Timer() ;
		_timer.setRepeatCount(1) ;
		_timer.addEventListener(TimerEventType.TIMER, this, notifyFinished) ;
	}
	
	// ----o Public Properties
	
	public var duration:Number ; // [RW]
	public var useSeconds:Boolean ;
	
	// ----o Public Methods
	
	public function clone() {
		return new Pause(_duration, useSeconds) ;
	}
	
	public function execute():Void {
		if (_timer.running) return ;
		notifyStarted() ;
		_timer.setDelay(getDuration()) ;
		_timer.start() ;
	}
	
	public function getDuration():Number {
		var d:Number = _duration ;
		if (useSeconds) d = Math.round(d * 1000) ;
		return d ;
	}
	
	public function start():Void {
		execute() ;
	}

	public function stop():Void {
		notifyStarted() ;
		if (_timer.running) {
			_timer.stop() ;
			notifyFinished() ;	
		}
	}

	public function setDuration(duration:Number):Void {
		_duration = (isNaN(duration) && duration < 0) ? 0 : duration ;
	}

	public function toString():String {
		return "[Pause : " + HashCodeFactory.getKey( this ) + ", " + getDuration() + (useSeconds ? "s" : "ms") + "]" ;
	}

	// ----o Virtual Properties
	
	static private var __DURATION__:Boolean = PropertyFactory.create(Pause, "duration", true) ;
	
	// ----o Private Properties

	private var _duration:Number ;
	private var _timer:Timer ;

}

