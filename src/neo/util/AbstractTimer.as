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

/* ------- AbstractTimer

	AUTHOR

		Name : AbstractTimer
		Package : neo.util
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- delay:Number [R/W] 
		
			The delay between timer events, in milliseconds.
		
		- repeatCount:Number [R/W]
			
			Specifies the number of repetitions. 
			If zero, the timer repeats infinitely. 
			If nonzero, the timer runs the specified number of times and then stops.
		
		- running:Boolean

	METHOD SUMMARY
	

		- addEventListener(e:EventType, oL, f:Function):Void

		

		- addListener (oL, f:Function):Void

		

		- broadcastEvent(e:IEvent):Void

		
		- clear() [override]
		

		- dispatchEvent(o:Object):Void

		
		- getDelay():Number
		
		- getRepeatCount():Number
		

		- removeAllEventListeners(type:String):Void

		

		- removeAllListeners():Void

		

		- removeEventListener(e:EventType, oL):Void

		

		- removeListener(oL):Void

		
		- restart()
		
			Restarts the timer. The timer is stopped, and then started.
		
		- run() [override]
		
		- setDelay(n:Number)
		
		- setRepeatCount(n:Number)
		
		- start()
		
			Starts the timer, if it is not already running.
		
		- stop()
		
			Stops the timer.
			

	EVENT SUMMARY
	
		TimerEvent
	
			- TimerEventType.RESTART
		
			- TimerEventType.START
		
			- TimerEventType.STOP
		
			- TimerEventType.TIMER
				A Timer object generates the timer event whenever a timer tick occurs.

	INHERIT
	
		CoreObject

			|

			AbstractTimer

	IMPLEMENTS 
	
		IEventTarget, ITimer, IRunnable, IFormattable

	SEE ALSO
	
		- EventDispatcher
		- TimerEvent
		- TimerEventType

----------  */



import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;

import neo.core.CoreObject;
import neo.core.IRunnable;
import neo.core.ITimer;
import neo.events.TimerEvent;
import neo.events.TimerEventType;
import neo.util.factory.PropertyFactory;


class neo.util.AbstractTimer extends CoreObject implements ITimer, IRunnable {

	// ----o Construtor
	
	private function AbstractTimer(d:Number, count:Number) {

		_oEB = new EventBroadcaster(this) ;
		setDelay(d);
		setRepeatCount(count) ;
	}


	// ----o Public Properties
	

	public var delay:Number ; // [RW]

	public var repeatCount:Number ; // [RW]
	public var running:Boolean = false ;
	
	// ----o Public Methods	


	public function addEventListener(e:EventType, oL, f:Function):Void {

		_oEB.addEventListener.apply(_oEB, arguments);

	}

	

	public function addListener (oL, f:Function):Void {

		_oEB.addListener.apply(_oEB, arguments);

	}

	

	public function broadcastEvent(e:IEvent) : Void {	

		_oEB.broadcastEvent(e) ;

	}


	public function clear():Void {
		// override this method
	}



	public function dispatchEvent(o:Object):Void {

		_oEB.dispatchEvent(o) ;

	}

	

	public function getDelay():Number {
		return _delay ;
	}

	public function getRepeatCount():Number {
		return _repeatCount ;
	}

	public function restart(noEvent:Boolean):Void {
		if (running) stop() ;
		running = true ;
		run() ;
		if (!noEvent) broadcastEvent( new TimerEvent( TimerEventType.RESTART, this) ) ;
	}

	public function run():Void {
		// override this method
	}


	public function removeEventListener(e:EventType, oL):Void {

		_oEB.removeEventListener(e, oL);

	}

	

	public function removeAllEventListeners(type:String):Void {

		_oEB.removeAllEventListeners(type) ;

	}

	

	public function removeAllListeners():Void {

		_oEB.removeAllListeners() ;

	}

	

	public function removeListener(oL):Void {

		_oEB.removeListener(oL) ;

	}


	public function setDelay(n:Number):Void {
		_delay = (n > 0) ? n : 0 ;

		if (running) restart() ;
	}

	public function setRepeatCount(n:Number):Void {
		_repeatCount = (n > 0) ? n : 0 ;
	}

	public function start():Void {
		if (running) return ;
		_count = 0 ;
		broadcastEvent( new TimerEvent(TimerEventType.START, this) ) ;
		restart(true) ;
	}
	
	public function stop():Void {
		running = false ;
		clear() ;
		broadcastEvent( new TimerEvent(TimerEventType.STOP, this) ) ;
	}
	

	// ----o Virtual Properties
	

	static private var __DELAY__:Boolean = PropertyFactory.create(AbstractTimer, "delay", true) ;

	static private var __REPEAT_COUNT__:Boolean = PropertyFactory.create(AbstractTimer, "repeatCount", true) ;
	
	// -----o Private Properties
	
	private var _count:Number ;
	private var _delay:Number ;
	private var _repeatCount:Number ;
	private var _oEB:EventBroadcaster ;

	
}