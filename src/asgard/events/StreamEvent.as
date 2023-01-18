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

import asgard.net.NetServerInfo;
import asgard.net.Stream;

import vegas.events.BasicEvent;

/**
 * The StreamEvent are dispatched when a Stream object dispatch events. 
 * @author ekameleon
 */
class asgard.events.StreamEvent extends BasicEvent 
{

	/**
	 * Creates a new StreamEvent instance.
	 * @param type the string type of the instance. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */	
	public function StreamEvent(type:String, stream:Stream, target, context, bubbles : Boolean, eventPhase : Number, time : Number, stop : Number) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop);
	}
	
	/**
	 * The name of the event when the audio activity of the stream change.
	 */
	static public var AUDIO_ACTIVITY_UPDATE:String = "onAudioActivityUpdate" ;
	
	/**
	 * The name of the event when the status of the object change.
	 */
	static public var NET_STATUS:String = "onStatus" ;

	/**
	 * Returns the NetServerInfo reference of this event.
	 * @return the NetServerInfo reference of this event.
	 */
	public function getInfo():NetServerInfo 
	{
		return _info ;	
	}

	/**
	 * Returns the Stream reference of this event.
	 * @return the Stream reference of this event.
	 */
	public function getStream():Stream
	{
		return _stream ;
	}
	
	/**
	 * Sets the NetServerInfo reference of this event.
	 * @param oInfo the info {@code Object} used to define the NetServerInfo reference.
	 */
	public function setInfo( oInfo ):Void 
	{
		if (oInfo instanceof NetServerInfo) 
		{
			_info = oInfo ;
		} 
		else if (typeof(oInfo) == "object") 
		{
			_info = new NetServerInfo(oInfo) ;	
		} 	
		else
		{
			_info = null ;
		}
	}

	/**
	 * Returns the Stream reference of this event.
	 * @return the Stream reference of this event.
	 */
	public function setStream( stream:Stream ):Void
	{
		_stream = stream ;
	}

	private var _info:NetServerInfo ;

	private var _stream:Stream ;

}