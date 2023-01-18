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

import asgard.media.CuePoint;

import vegas.events.BasicEvent;

/**
 * This event contains a CuePoint reference.
 * @author eKameleon
 */
class asgard.events.CuePointEvent extends BasicEvent 
{

	/**
	 * Creates a new CuePointEvent instance.
	 * @param type the string type of the instance. 
	 * @param target the target of the event.
	 * @param oInfo the cuepoint info primitive object.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */	
	public function CuePointEvent( type:String, target, oInfo, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number ) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop);
		setCuePoint(oInfo) ;
	}

	/**
	 * The name of the event when a new cue point info is notifyed.
	 */
	static public var INFO:String = "onCuePointInfo" ;

	/**
	 * Returns the CuePoint of this event.
	 * @return the CuePoint of this event.
	 */
	public function getCuePoint():CuePoint
	{
		return _cp ;	
	}
	
	/**
	 * Returns the name of the CuePoint.
	 * @return the name of the CuePoint.
	 */
	public function getName():String
	{
		return _cp.name ;
	}
	
	/**
	 * Returns the time value of the CuePoint.
	 * @return the time value of the CuePoint.
	 */
	public function getTime():String
	{
		return _cp.time ;
	}
	
	/**
	 * Returns the type value of the CuePoint.
	 * @return the type value of the CuePoint.
	 */
	public function getType():String
	{
		return _cp.type ;
	}

	/**
	 * Sets the CuePoint of this event.
	 */
	public function setCuePoint( o ):Void
	{
		_cp = new CuePoint(o) ;	
	}

	private var _cp ;

}