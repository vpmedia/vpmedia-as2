/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.process.Pause;

import vegas.util.serialize.Serializer;

/**
 * This Action create a pause and notify an message in a process.
 */
class pegas.process.Message extends Pause 
{

	/**
	 * Creates a new Message instance.
	 */
	public function Message( msg:String, face:String, duration:Number, to:Number, seconds:Boolean ) 
	{
		super( isNaN(duration) ? 1500 : duration, seconds) ;
		this.message = msg ;
		this.face = face ;
		this.to = to ;
	}
	
	/**
	 * Determinates a value to send the message in the local application.
	 */
	static public var ME:Number = 0 ;

	/**
	 * Determinates a value to send the message to all users.
	 */
	static public var ALL:Number = 1 ;
	
	/**
	 * The message value.
	 */
	public var message:String ;

	/**
	 * An optional face value.
	 */
	public var face:String ;

	/**
	 * An optional to value.
	 */
	public var to:Number ;
	
	/**
	 * Returns a shallow copy of the object.
	 * @return a shallow copy of the object.
	 */
	public function clone() 
	{
		return new Message(message, face, _duration, to, useSeconds) ;
	}

	/**
	 * Returns the Eden string representation of the object.
	 * @return the Eden string representation of the object.
	 */
	/*override*/ public function toSource(indent:Number, indentor:String):String 
	{
		return Serializer.getSourceOf(this, [message, face, duration, to, Serializer.toSource(useSeconds) ]) ;
	}
	
	/**
	 * Returns the string representation of the object.
	 * @return the string representation of the object.
	 */
	public function toString():String 
	{
		return "[Message : " + message + "]" ;
	}

}

