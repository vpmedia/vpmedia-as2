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

/* ------- ITimer [Interface]

	AUTHOR

		Name : ITimer
		Package : neo.core
		Version : 1.0.0.0
		Date :  20056-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
	

		- addEventListener(e:EventType, oL, f:Function):Void

		

		- addListener (oL, f:Function):Void

		

		- broadcastEvent(e:IEvent):Void

		

		- clear():Void
		

		- dispatchEvent(o:Object):Void

		

		- getDelay():Number
		
		- getRepeatCount():Number


		- removeEventListener(e:EventType, oL):Void

		

		- removeListener(oL):Void

		
		- restart()
		
			Restarts the timer. The timer is stopped, and then started.
		

		- run()
		

		- setDelay(n:Number)
		
		- setRepeatCount(n:Number)
		
		- start()
		
			Starts the timer, if it is not already running.
		
		- stop()
		
			Stops the timer.

----------  */


import neo.core.IEventTarget;


interface neo.core.ITimer extends IEventTarget {

	function clear():Void ;

	function getDelay():Number ;

	function getRepeatCount():Number ;

	function restart(noEvent:Boolean):Void ;


	function run():Void ;


	function start():Void ;

	function setDelay(n:Number):Void ;

	function setRepeatCount(n:Number):Void ;
	
	function stop():Void ;
	
}