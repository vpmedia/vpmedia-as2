/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.events.EventTarget;

/**
 * This interface is implemented by Timer and FrameTimer class.
 * @author eKameleon
 */
interface vegas.core.ITimer extends EventTarget 
{

	/**
	 * Clear the timer interval.
	 */
	function clear():Void ;

	/**
	 * Returns the delay of the interval.
	 */
	function getDelay():Number ;

	/**
	 * Returns the max number of intervals of time.
	 */
	function getRepeatCount():Number ;

	/**
	 * Restarts the timer. The timer is stopped, and then started.
	 */
	function restart(noEvent:Boolean):Void ;

	/**
	 * Run the command.
	 * @see IRunnable
	 */
	function run():Void ;

	/**
	 * Starts the timer if it is not already running.
	 */
	function start():Void ;

	/**
	 * Sets the delay of the interval.
	 */
	function setDelay(n:Number):Void ;

	/**
	 * Sets the max number of intervals of time.
	 */
	function setRepeatCount(n:Number):Void ;
	
	/**
	 * Stop the timer.
	 */
	function stop():Void ;
	
}