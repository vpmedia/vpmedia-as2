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

import asgard.events.SoundModelEvent;
import asgard.media.SoundModel;

import pegas.maths.Range;

import vegas.data.map.HashMap;
import vegas.errors.UnsupportedOperation;
import vegas.errors.Warning;
import vegas.events.Delegate;
import vegas.util.ConstructorUtil;

// TODO add events with setGain, setVolume and setPan methods !
// TODO test volume, gain etc.

/**
 * Sound library to register all sounds in an application.
 * <p>To load external "mp3" files using {@code loadSound} method.</p>
 * <p><b>Example :</b></p>
 * <p>
 * {@code
 * import asgard.events.SoundModelEvent ;
 * import asgard.media.SoundLibrary ;
 * import vegas.events.Delegate ;
 * 
 * var debug:Function = function ( e:SoundModelEvent ):Void
 * {
 *     var type:String = e.getType() ;
 *	   var id:String = e.getID() ;
 *	   var library:SoundLibrary = SoundLibrary(e.getModel()) ;
 *	   var sound:Sound = e.getSound() ;
 *	   
 *	   var message:String = "> " + library ;
 *	   message += " " + type ;
 *	   if (id != null)
 *	   {
 *		    message += ", id:" + id ;
 *	   }
 *	   if (sound != null)
 *	   {
 *		    message += ", sound:" + sound ;
 *	   }
 *	   trace( message ) ;
 * }
 *
 * var lib:SoundLibrary = new SoundLibrary() ;
 * lib.addGlobalEventListener( new Delegate(this, debug) ) ;
 *
 * lib.addSound( "sound_1" ) ;
 * lib.addSound( "sound_2" ) ;
 *
 * lib.addSounds( ["sound_1", "sound_2"] ) ;
 *
 * trace("> " + lib + " size : " + lib.size()) ;
 *
 * Key.addListener(this) ;
 *
 * onKeyDown = function()
 * {
 *     var code:Number = Key.getCode() ;
 *     switch ( code )
 *     {
 *	        case Key.UP : 
 *		    {
 *   			lib.getSound( "sound_1" ).start() ;
 *			    break ;
 *		    }
 *		    case Key.DOWN : 
 *		    {
 *			    lib.getSound( "sound_2" ).start() ;
 *			    break ;
 *		    }
 *		    case Key.SPACE :
 *		    {
 *			    lib.toggle() ;
 *			    break ;
 *		    }
 *	    }
 * }
 *
 * trace("> Press Key.SPACE to disable/enable the library.") ;
 * trace("> Press Key.UP to start the sound_1 sound.") ;
 * trace("> Press Key.DOWN to start the sound_2 sound.") ;
 * }
 * </p>
 * @author eKameleon
 */
class asgard.media.SoundLibrary extends SoundModel 
{
	
	/**
	 * Creates a new SoundLibrary 
	 */
	function SoundLibrary() 
	{
		super();
		throw new UnsupportedOperation( ConstructorUtil.getPath(this) + " is depreciated. You must use the andromeda.media.SoundLibrary class.") ;
		_mGain = new HashMap() ;
	}

	/**
	 * The default gain of all sounds the first time in the library.
	 */
	static public var DEFAULT_GAIN:Number = 90 ;

	/**
	 * The range of all gains in the sound library.
	 */
	static public var RANGE_GAIN:Range = new Range(0, 127) ;

	/**
	 * The range of all pans in the sound library.
	 */
	static public var RANGE_PAN:Range = new Range(-100, 100) ;

	/**
	 * Adds new sound in the model.
	 * <p>If the id already exist in the model, the current sound is remove in the model before the new sound must be inserted in the model</p>
	 * <p>Example
	 * {@code
	 *   var sLib:SoundLibrary = new SoundLibrary();
	 *   sLib.addSound( "sound_1" );
	 *   sLib.addSound( "sound_2" );
	 * }
	 * </p>
	 * @param id Sound identifier in swf file.
	 * @param sound Sound reference.
	 * 
	 * @return {@code String} sound identifier 
	 * @throws ArgumentsError if the specified id and sound are 'null' or 'undefined'.
	 */
	public function addSound( id:String )
	{
		if (!isInit())
		{
			initialize() ;
		}
		var sound:Sound = _createSound(id) ;
		_mGain.put(id, DEFAULT_GAIN) ;
		_setVolume( id ) ;
		return super.addSound( id , sound ) ;
	}

	/**
	 * Adds sounds id list to the the library.
	 * <p>Example
	 * {@code
	 *   var sLib:SoundLibrary = new SoundLibrary();
	 *   var aSoundList:Array = ["sound_1", "sound_2"] ;
	 *   sLib.addSounds( aSoundList );
	 * }
	 * </p>
	 * 
	 * @param list an {@code Array} Sounds ID list.
	 */
	public function addSounds( list:Array) : Void
	{
		var l:Number = list.length;
		for (var i:Number=0; i<l ; i++) 
		{
			addSound( list[i] );
		}
	}

	/**
	 * Clear all sounds in the model.
	 */
	public function clear() : Void
	{
		release() ;
		_mGain.clear() ;
		super.clear() ;
	}
	
	/**
	 * Returns defined gain for passed-in 'id' sound of this library.
	 * @param id the Sound 'id'.
	 * @return the value of the gain of the specific sound.
	 */
	public function getGain( id:String ):Number
	{
		return _mGain.get(id) ;
	}

	/**
	 * Returns the value of the pan of all sounds in the library.
	 * @return the value of the pan of all sounds in the library.
	 */
	public function getPan() : Number
	{
		return _nPan;
	}

	/**
	 * Returns the volume percent value of this library.
	 * @return the volume percent value of this library.
	 */
	public function getVolume():Number
	{
		return _nVolume;
	}	

	/**
	 * Initialize the library.
	 */
	public function initialize( target:MovieClip ):Void
	{
		_nDepth = 0 ;
		_isInit = true ;
		_container = (target == null) ? _level0.createEmptyMovieClip("__mcSound__", 65535) : target ;
	}
	
	/**
	 * Returns {@code true} if the library is initialized.
	 */
	public function isInit():Boolean
	{
		return _isInit ;	
	}

	/**
	 * Loads and attach in the library a new external Sound.
	 * @param sURL the string representation of the url of the external sound.
	 * @param id the identifier of the sound, if this parameter is null the loadSound method try to use the name of the external file to defined the id value.
	 * @return {@code String} sound identifier 
	 */
	public function loadSound(sURL:String, id:String):String
	{
		if (!isInit())
		{
			initialize() ;
		}
		
		if ( id == null )
		{
			id = sURL.substring( sURL.lastIndexOf("/") + 1 , sURL.lastIndexOf(".") ) ;
		}
		
		if (id != null && id.length > 0)
		{
			var sound:Sound = _createSound( id, sURL);
			super.addSound( id , sound ) ;
			return id ;
		}
		else
		{
			throw new Warning( this + " loadSound method failed, the specified id not must be 'null' or 'undefined' or a empty string." ) ;
		}
	}

	/**
	 * Release the library and remove the sound container.
	 */
	public function release():Void
	{
		_isInit = false ;
		_container.removeMovieClip() ;
	}

	/**
	 * Removes a sound in the model.
	 * 
	 * <p>Example
	 * {@code
	 *   var sLib:SoundLibrary = new SoundLibrary();
	 *   sLib.addSound( "sound_1" );
	 *   sLib.removeSound( "sound_1" );
	 * }
	 * 
	 * @param id Sound identifier in swf file.
	 * 
	 * @return {@code null} if the model don't contains the specified id. 
	 * @throws ArgumentsError if the specified id is 'null' or 'undefined'.
	 */
	public function removeSound( id:String ):Void
	{
		if ( containsByID(id) )
		{
			_removeSound(id) ;
			_mGain.remove(id) ;
			super.removeSound( id ) ;
		}
	}

	/**
	 * Defines {@code gain} value for all registered sounds.
	 * @param nGain a number between 0 and 127.
	 */
	public function setAllGain(nGain:Number) : Void
	{
		nGain = RANGE_GAIN.clamp(nGain) ;
		var ar:Array = _mGain.getKeys() ;
		var len:Number = ar.size() ;
		while( --len > -1 )
		{
			var id:String = ar[len] ;
			_mGain.put( id , nGain ) ;
			_setVolume( id ) ;
		}
	}

	/**
	 * Sets the gain value for passed-in id sound.
	 * @param id the identifier of the sound in the library if exist.
	 * @param nGain a number between 0 and 127.
	 */
	public function setGain( id:String, nGain:Number ):Void
	{
		if (containsByID(id))
		{
			nGain = RANGE_GAIN.clamp(nGain) ;
			_map.put(id, nGain) ;
			_setVolume( id );
		}
	}

	/**
	 * Sets the pan value for all sounds list.
	 * @param nPan a number between -100 and 100.
	 */
	public function setPan(nPan:Number) : Void
	{
		_nPan = RANGE_PAN.clamp(nPan) ;
		var ar:Array = toArray() ;
		var len:Number = ar.size() ;
		while( --len > -1 )
		{
			Sound(ar[len]).setPan(_nPan) ;
		}
	}

	/**
	 * Sets the volume value for all sounds in the library.
	 * @param value a number between 0 and 100.
	 */
	public function setVolume( value:Number) : Void
	{
		value = Range.PERCENT_RANGE.clamp(value) ;
		_nVolume = value ;
		var ar:Array = _mGain.getKeys() ;
		var len:Number = ar.size() ;
		while( --len > -1 )
		{
			_setVolume( ar[len] );
		}
	}
	
	/**
	 * The internal movieclip reference to control all sounds in this library.
	 */
	private var _container:MovieClip ;

	/**
	 * Internal boolean to defined if the library is init or not.
	 */
	private var _isInit:Boolean = false ;

	/**
	 * The internal HashMap to control all gains in the sound library.
	 */	
	private var _mGain:HashMap ;

	/**
	 * Internal depth value to creates all movieclip containers for all sounds in the library.
	 */
	private var _nDepth:Number ;

	/**
	 * Internal pan value of all sounds.
	 */
	private var _nPan:Number = 0 ;

	/**
	 * Internal volume value of all sounds.
	 */
	private var _nVolume:Number = 127 ;

	/**
	 * Calculate the volume value of a sound with a specific gain.
	 */
	private function _calculateGainVolume( nGain:Number ):Number
	{
		return ( nGain / 100 ) * _nVolume ;
	}

	/**
	 * Creates a new sound in the library.
	 */
	private function _createSound( id:String, sURL:String):Sound
	{
		var target:MovieClip = _container.createEmptyMovieClip("sound_" + id, _nDepth++);
		var sound:Sound = new Sound( target ) ;
		
		var eComplete = new SoundModelEvent( SoundModelEvent.COMPLETE_SOUND , this, id, sound ) ;
		sound.onSoundComplete = Delegate.create(this, notifyChanged, eComplete) ;
		
		var eID3      = new SoundModelEvent( SoundModelEvent.ID3_SOUND , this, id, sound ) ;
		sound.onID3 = Delegate.create(this, notifyChanged, eID3) ;
		
		var eLoad     = new SoundModelEvent( SoundModelEvent.LOAD_SOUND, this, id, sound , sURL) ;
		sound.onLoad = Delegate.create(this, _fireLoadEvent, eLoad) ;
		
		if (sURL)
		{
			sound.loadSound(sURL, false);

		} else
		{
			sound.attachSound( id );
		}
		
		return sound ;
	}
	
	/**
	 * Dispatch the SoundModelEvent with the type LOAD_SOUND
	 */
	private function _fireLoadEvent( success:Boolean , e:SoundModelEvent ):Void
	{
		e.success = success ;
		notifyChanged( e ) ;
	}

	/**
	 * Removes a sound in the library.
	 */
	private function _removeSound( id:String ):Void
	{
		MovieClip(_container["sound_" + id]).removeMovieClip() ;
	}
	
	/**
	 * Set the volume of a specific sound with the id key in the library.
	 */
	private function _setVolume( id:String ):Void
	{
		getSound( id ).setVolume( _calculateGainVolume( getGain( id ) ) );
	}
	

}