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

import vegas.events.BasicEvent;

/**
 * The SoundEvent class.
 * @author eKameleon
 */
class asgard.events.SoundEvent extends BasicEvent 
{

	/**
	 * Creates a new SoundEvent instance.
	 */	
	public function SoundEvent(type:String, sound:Sound) 
	{
		super(type);
		_sound = sound ;
	}
	
	/**
	 * The type of the event when the sound is complete.
	 */
	static public var COMPLETE:String = "onSoundComplete" ;

	/**
	 * The type of the event when a sound id3 is notify.
	 */
	static public var ID3:String = "onSoundID3" ; 
	
	/**
	 * The type of the event when a sound is loading.
	 */
	static public var LOAD:String = "onSoundLoad" ; 
	
	/**
	 * The success boolean value if the SoundEvent type is 'LOAD'.
	 */
	public var success:Boolean = null ;
	
	/**
	 * Returns the sound reference.
	 */
	public function getSound():Sound
	{
		return _sound ;	
	}
	
	/**
	 * Sets the sound reference.
	 */
	public function setSound( s:Sound ):Void
	{
		_sound = s ;	
	}
	
	/**
	 * Internal Sound reference.
	 */
	private var _sound:Sound ;

}