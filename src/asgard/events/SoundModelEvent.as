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

import asgard.media.SoundModel;

import vegas.events.ModelChangedEvent;

/**
 * The SoundModelEvent class.
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.events.SoundModelEvent extends ModelChangedEvent
{

	/**
	 * Creates a new SoundModelEvent instance.
	 */	
	public function SoundModelEvent(type:String, model:SoundModel, id:String, sound:Sound, url:String) 
	{
		super(type);
		_id    = id ;
		_model = model ;
		_sound = sound ;
		_url   = url ; 
	}

	/**
	 * The name of the SoundModelEvent when a new Sound is added in a SoundModel instance.
	 */
	static public var ADD_SOUND:String = "onAddSound" ;

	/**
	 * The name of the SoundModelEvent when all the sounds in the SoundModel are removed.
	 */
	static public var CLEAR_SOUND:String = "onClearSound" ;

	/**
	 * The type of the event when the sound is complete.
	 */
	static public var COMPLETE_SOUND:String = "onCompleteSound" ;

	/**
	 * The type of the event when all sounds are enabled in the model.
	 */
	static public var ENABLE_SOUNDS:String = "onEnabledSounds" ;

	/**
	 * The type of the event when all sounds are disabled in the model.
	 */
	static public var DISABLE_SOUNDS:String = "onDisabledSounds" ;
	
	/**
	 * The type of the event when a sound id3 is notify.
	 */
	static public var ID3_SOUND:String = "onID3Sound" ; 
	
	/**
	 * The type of the event when a sound is loading.
	 */
	static public var LOAD_SOUND:String = "onLoadSound" ; 

	/**
	 * The name of the SoundModelEvent when a Sound is removed in a SoundModel instance.
	 */
	static public var REMOVE_SOUND:String = "onRemoveSound" ; 

	/**
	 * The success boolean value if the SoundModelEvent type is 'LOAD_SOUND'.
	 */
	public var success:Boolean = null ;

	/**
	 * Returns the id of the sound reference.
	 * @return the id of the sound reference.
	 */
	public function getID():String
	{
		return _id ;	
	}

	/**
	 * Returns the model reference of this event.
	 * @return the model reference of this event.
	 */
	public function getModel():SoundModel
	{
		return _model ;	
	}
	
	/**
	 * Returns the sound reference.
	 * @return the sound reference.
	 */
	public function getSound():Sound
	{
		return _sound ;	
	}
	
	/**
	 * Returns the url of the sound reference if this sound is an external sound.
	 * @return the url of the sound reference if this sound is an external sound.
	 */
	public function getUrl():String
	{
		return _url ;	
	}

	/**
	 * Sets the id of the sound reference.
	 */
	public function setID( sID:String ):Void
	{
		_id = sID ;	
	}

	/**
	 * Sets the model reference of this event.
	 */
	public function setModel( model:SoundModel ):Void
	{
		_model = model ;	
	}

	/**
	 * Sets the sound reference.
	 */
	public function setSound( s:Sound ):Void
	{
		_sound = s ;	
	}

	/**
	 * Sets the url of the sound reference if this sound is an external sound.
	 */
	public function setUrl(sURL:String):Void
	{
		_url = sURL ;	
	}

	/**
	 * Id of the sound in the model.
	 */
	private var _id:String ;
	
	/**
	 * The model reference of this event.
	 */
	private var _model:SoundModel ;
	
	/**
	 * Internal Sound reference.
	 */
	private var _sound:Sound ;
	
	/**
	 * Internal url of the Sound reference.
	 */
	private var _url:String ;

}