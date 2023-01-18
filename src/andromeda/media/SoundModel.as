/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.events.SoundModelEvent;
import andromeda.model.AbstractModel;

import vegas.data.map.HashMap;
import vegas.errors.ArgumentsError;

/**
 * Sound model to manage sounds.
 * @author eKameleon
 * @version 1.0.0.0
 */
class andromeda.media.SoundModel extends AbstractModel 
{
	
	/**
	 * Creates a new SoundModel instance.
	 * @param id the id of the model.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function SoundModel( id , bGlobal:Boolean , sChannel:String ) 
	{
		super( id, bGlobal , sChannel ) ;
		initEvent() ;
		_bIsOn = true ;
		_map = new HashMap() ;
	}
	
	/**
	 * Adds new sound in the model.
	 * <p>If the id already exist in the model, the current sound is remove in the model before the new sound must be inserted in the model</p>
	 * <p>Example
	 * {@code
	 *   var sModel:SoundModel = new SoundModel();
	 *   sModel.addSound( "sound_1", new Sound(mc1) );
	 *   sModel.addSound( "sound_2", new Sound(mc2) );
	 * }
	 * </p>
	 * @param id Sound identifier in swf file.
	 * @param sound Sound reference.
	 * 
	 * @return {@code String} sound identifier 
	 * @throws ArgumentsError if the specified id and sound are 'null' or 'undefined'.
	 */
	public function addSound( id:String, sound:Sound )
	{
		if (id != null && sound != null)
		{
			
			if (_map.containsKey(id))
			{
				removeSound(id) ;
			}
			
			var r = _map.put(id, sound) ;
			// Reflexion of the sound object.
			sound.toString = function():String
			{
				return "[Sound:'" + id + "']" ;
			} ;
			notifyAddSound(id, sound) ;
			return id  ;
		}
		else
		{
			throw new ArgumentsError ( this + " addSound method failed, the specified id and sound not must be 'null' or 'undefined'." ) ;
			return null ;
		}
	}

	/**
	 * Clear all sounds in the model.
	 */
	public function clear() : Void
	{
		_map.clear() ;
		notifyClearSound() ;
	}

	/**
	 * Returns {@code true} if the model contains the specified 'id'.
	 * @return {@code true} if the model contains the specified 'id'.
	 */
	public function containsByID( id:String ):Boolean
	{
		return _map.containsKey(id) ;
	}

	/**
	 * Returns {@code true} if the model contains the specified Sound reference.
	 * @return {@code true} if the model contains the specified Sound reference.
	 */
	public function containsBySound( s:Sound ):Boolean
	{
		return _map.containsValue(s) ;
	}

	/**
	 * Disabled sound playing mode. (stop all sounds in the model if the model isn't empty)
	 */
	public function disable():Void 
	{ 
		_bIsOn = false;
		var aSounds:Array = toArray() ;
		var size:Number = aSounds.length ;
		if (size > 0)
		{
			while (--size > -1)
			{
				aSounds[ size ].stop();
			}
		}
		notifyDisableSound() ;
	}

	/**
	 * Enabled sound playing mode.
	 */
	public function enable() : Void 
	{ 
		_bIsOn = true;
		notifyEnableSound() ; 
	}

	/**
	 * Returns the event name invoqued in the notifyAddSound method.
	 * @return the event name invoqued in the notifyAddSound method.
	 */
	public function getAddSoundModelEventType():String 
	{
		return _eAdd.getType() ;
	}

	/**
	 * Returns the event name invoqued in the notifyClearSound method.
	 * @return the event name invoqued in the notifyClearSound method.
	 */
	public function getClearSoundModelEventType():String 
	{
		return _eClear.getType() ;
	}

	/**
	 * Returns the event name invoqued in the notifyDisableSound method.
	 * @return the event name invoqued in the notifyDisableSound method.
	 */
	public function getDisableSoundModelEventType():String 
	{
		return _eDisabled.getType() ;
	}

	/**
	 * Returns the event name invoqued in the notifyEnableSound method.
	 * @return the event name invoqued in the notifyEnableSound method.
	 */
	public function getEnableSoundModelEventType():String 
	{
		return _eEnabled.getType() ;
	}
	
	/**
	 * Returns the event name invoqued in the notifyRemoveSound method.
	 * @return the event name invoqued in the notifyRemoveSound method.
	 */
	public function getRemoveSoundModelEventType():String 
	{
		return _eRemove.getType() ;
	}

	/**
	 * Returns {@code Sound} instance register in the model.
	 * 
	 * id the identifier of the sound in the model.
	 * 
	 * <p>Example
	 * {@code
	 *   var sModel:SoundModel = new SoundModel();
	 *   sModel.addSound( "sound_1", new Sound(mc1) );
	 *   
	 *   var currentSound:Sound = sModel.getSound( "sound_1" );
	 * }
	 * 
	 * @return {@code Sound} instance. If no sound is found, an empty 
	 * {@code Sound} is returned.
	 */
	public function getSound( id:String ):Sound 
	{ 
		return _bIsOn ? _map.get(id) : null ;
	}

	/**
	 * Init the internal events of this model.
	 */
	public function initEvent():Void 
	{
		_eAdd      = new SoundModelEvent( SoundModelEvent.ADD_SOUND , this ) ;
		_eClear    = new SoundModelEvent( SoundModelEvent.CLEAR_SOUND , this ) ;
		_eDisabled = new SoundModelEvent( SoundModelEvent.DISABLE_SOUNDS , this ) ;
		_eEnabled  = new SoundModelEvent( SoundModelEvent.ENABLE_SOUNDS , this ) ;
		_eRemove   = new SoundModelEvent( SoundModelEvent.REMOVE_SOUND , this ) ;
	}
	
	/**
	 * Returns {@code true} if the model is empty.
	 * @return {@code true} if the model is empty.
	 */
	public function isEmpty():Boolean
	{
		return _map.isEmpty() ;
	}

	/**
	 * Returns {@code true} if the playing mode of the model is on.
	 * @return {@code true} if the playing mode of the model is on.
	 */
	public function get isOn() : Boolean 
	{ 
		return _bIsOn; 
	}

	/**
	 * Notify a SoundModelEvent when a new sound is added in the model.
	 * @param id The link id of the sound.
	 * @param sound The Sound reference.
	 */
	public function notifyAddSound( id:String, sound:Sound ):Void
	{
		_eAdd.setID(id) ;
		_eAdd.setSound( sound ) ;
		dispatchEvent(_eAdd) ;	
	}

	/**
	 * Notify a SoundModelEvent if the model is clear.
	 */
	public function notifyClearSound():Void
	{
		dispatchEvent( _eClear ) ;	
	}
	
	/**
	 * Notify a SoundModelEvent if the model is enabled.
	 */
	public function notifyEnableSound():Void
	{
		dispatchEvent( _eEnabled ) ;	
	}
	
	/**
	 * Notify a SoundModelEvent if the model is disabled.
	 */
	public function notifyDisableSound():Void
	{
		dispatchEvent( _eDisabled ) ;	
	}

	/**
	 * Notify a SoundModelEvent when a new sound is removed in the model.
	 * @param id The link id of the sound.
	 * @param sound The Sound reference.
	 */
	public function notifyRemoveSound( id:String, sound:Sound ):Void
	{
		_eRemove.setID(id) ;
		_eRemove.setSound( sound ) ;
		dispatchEvent( _eRemove ) ;	
	}

	/**
	 * Removes a sound in the model.
	 * 
	 * <p>Example
	 * {@code
	 *   var sModel:SoundModel = new SoundModel();
	 *   sModel.addSound( "sound_1", new Sound(mc1) );
	 *   sModel.removeSound( "sound_1" );
	 * }
	 * 
	 * @param id Sound identifier in swf file.
	 * 
	 * @return {@code null} if the model don't contains the specified id. 
	 * @throws ArgumentsError if the specified id is 'null' or 'undefined'.
	 */
	public function removeSound( id:String )
	{
		if (id == null)
		{
			throw new ArgumentsError( this + " addSound method failed, the specified id and sound not must be 'null' or 'undefined'." ) ;
		}
		else if (_map.containsKey(id) )
		{
			var sound:Sound = _map.get(id) ;
			var r = _map.remove(id) ;
			notifyRemoveSound(id, sound) ;
			return r ;
		}
		else
		{
			return null ;
		}
	}
	
	/**
	 * Sets the event name invoqued in the notifyAddSound method.
	 */
	public function setAddSoundModelEventType( type:String ):Void 
	{
		_eAdd.setType( type ) ;
	}

	/**
	 * Sets the event name invoqued in the notifyClearSound method.
	 */
	public function setClearSoundModelEventType( type:String ):Void 
	{
		_eClear.setType( type ) ;
	}

	/**
	 * Sets the event name invoqued in the notifyDisableSound method.
	 */
	public function setDisableSoundModelEventType( type:String ):Void 
	{
		_eDisabled.setType( type ) ;
	}

	/**
	 * Sets the event name invoqued in the notifyEnableSound method.
	 */
	public function setEnableSoundModelEventType( type:String ):Void 
	{
		_eEnabled.setType( type ) ;
	}
	
	/**
	 * Sets the event name invoqued in the notifyRemoveSound method.
	 */
	public function setRemoveSoundModelEventType( type:String ):Void 
	{
		_eRemove.setType( type ) ;
	}
	
	/**
	 * Returns the number of Sounds in the model.
	 * @return the number of Sounds in the model.
	 */
	public function size():Number
	{
		return _map.size() ;
	}

	/**
	 * Returns an array representation of all sounds in the model.
	 */
	public function toArray():Array
	{
		return _map.getValues() ;
	}

	/**
	 * Toggles the sound playing mode.
	 */
	public function toggle() : Void 
	{ 
		if (_bIsOn)
		{
			disable();
		} 
		else
		{
			enable();
		}
	}

	/**
	 * This boolean defined if the getSound method return a sound reference or not.
	 */
	private var _bIsOn:Boolean ;

	private var _eAdd:SoundModelEvent ;
	
	private var _eClear:SoundModelEvent ;
	
	private var _eDisabled:SoundModelEvent ;
	
	private var _eEnabled:SoundModelEvent ;
	
	private var _eRemove:SoundModelEvent ;

	/**
	 * Internal hashmap.
	 */
	private var _map:HashMap ;


}