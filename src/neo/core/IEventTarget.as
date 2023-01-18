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

/* ------- IEventTarget[Interface]

	AUTHOR

		Name : IEventTarget
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
		
		- dispatchEvent(o:Object):Void
		
		- removeEventListener(e:EventType, oL):Void
		
		- removeListener(oL):Void

----------  */

import com.bourre.events.EventType;
import com.bourre.events.IEvent;

interface neo.core.IEventTarget {

	function addEventListener(e:EventType, oL, f:Function):Void ;
	
	function addListener (oL, f:Function):Void ;
	
	function broadcastEvent(e:IEvent):Void ;
	
	function dispatchEvent(o:Object):Void ;
	
	function removeEventListener(e:EventType, oL):Void ;
	
	function removeListener(oL):Void ;
	
}