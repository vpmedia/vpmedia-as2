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

/* ------- FrameTimer

	AUTHOR

		Name : FrameTimer
		Package : neo.util
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	 
		Constructs a new FrameTimer object with the specified delay and repeat state.
		The timer does not start automatically, you much call the start() method to start it.

	EXAMPLE
	
		import neo.events.TimerEvent ;

		import neo.events.TimerEventType ;

		import neo.util.FrameTimer  ;

		

		function onTimer(event:TimerEvent):Void {

			trace("onTimer :: " + event.getType()) ;

		}

		

		var myTimer:FrameTimer = new FrameTimer(24, 3) ;

		myTimer.repeatCount = 5 ;

		myTimer.addListener(this, onTimer);

		myTimer.start();

				

		Key.addListener(this) ;

		onKeyDown = function () {

			myTimer.running ? myTimer.stop() : myTimer.restart() ;

		}

	PROPERTY SUMMARY
	
		- delay:Number [R/W] 
		
			The delay between timer events, in frame/seconds
		
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

				|

				FrameTimer

	IMPLEMENTS 

	

		IEventTarget, ITimer, IRunnable, IFormattable

	SEE ALSO
	
		- EventDispatcher
		- TimerEvent
		- TimerEventType

----------  */


import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IFrameListener;

import neo.events.TimerEvent;
import neo.events.TimerEventType;
import neo.util.AbstractTimer;

class neo.util.FrameTimer extends AbstractTimer implements IFrameListener {


	// ----o Construtor
	
	public function FrameTimer(delay:Number, repeatCount:Number) {
		super(delay, repeatCount) ;
	}


	// ----o Public Methods	

	/*override*/ public function clear():Void {
		FPSBeacon.getInstance().removeFrameListener(this) ;
	}


	public function onEnterFrame():Void {

		if (++_next >= _delay) {

			broadcastEvent( new TimerEvent(TimerEventType.TIMER, this) ) ;

			_next = 0 ;

			_count ++ ;

		}

		if (_repeatCount && _count >= _repeatCount) this.stop() ;

	}


	/*override*/ public function run():Void {
		FPSBeacon.getInstance().addFrameListener(this) ;
	}

	// ----o Private Properties
	
	private var _next:Number = 0 ;
	
}