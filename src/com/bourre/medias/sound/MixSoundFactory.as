/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code MixSoundFactory} extends {@link SoundFactory} class adding volume, pan and gain 
 * controls for sound. 
 * 
 * <p>Example
 * <code>
 *   function onSoundComplete( e : IEvent ) : Void {
 *     trace("play again");
 *   }
 *   
 *   var sf : MixSoundFactory = new MixSoundFactory();
 *   sf.addEventListener( MixSoundFactory.onSoundCompleteEVENT, this);
 *   sf.addSound("sound_1");
 *   sf.setGain("sound_1", 50);
 *   sf.setPan(-50);
 *   
 *   sf.playSoundLoop("sound_1");
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.Delegate;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.medias.sound.SoundFactory;

class com.bourre.medias.sound.MixSoundFactory 
	extends SoundFactory
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _nVolume:Number;
	private var _nPan:Number;
	private var _oGain:Object;
	
	
	//-------------------------------------------------------------------------
	// Events definition
	//-------------------------------------------------------------------------
	
	/** Broadcast when a sound finishes playing. **/
	[Event("onSoundLoad")]
	public static var onSoundCompleteEVENT:EventType = new EventType("onSoundComplete");


	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code MixSoundFactory} instance.
	 */
	public function MixSoundFactory() 
	{
		super();
		
		_nVolume = 127;
		_nPan =0;
		_oGain = new Object();
	}
	
	/**
	 * Plays passed-in {@code sID} identifier sound in loop mode.
	 * 
	 * <p>Overrides {@link SoundFactory#playSoundLoop} method adding event support when sound 
	 * finishes playing.
	 * {@code MixSoundFactory} broadcast {@link #onSoundCompleteEVENT} 
	 * 
	 * <p>Example
	 * <code>
	 *   function onSoundComplete( e : IEvent ) : Void {
	 *     trace("play again");
	 *   }
	 *   
	 *   var sf : MixSoundFactory = new MixSoundFactory();
	 *   sf.addSound("sound_1");
	 *   sf.addEventListener( MixSoundFactory.onSoundCompleteEVENT, this);
	 *   sf.playSoundLoop("sound_1");
	 * </code>
	 */
	public function playSoundLoop(sID:String) : Void
	{
		var snd:Sound = getSound( sID );
		snd.onSoundComplete = Delegate.create(this, _onSoundLoop, snd);
		snd.start(0, 1);
	}
	
	/**
	 * Removes {@code Sound} instance stored under passed-in 
	 * {@code sID} identifier from factory.
	 * 
	 * <p>Overrides {@link SoundFactory#removeSound} method, removing 
	 * {@code sID} sound from {@code gain} list. 
	 *  
	 * <p>Example
	 * <code>
	 *   var sf : MixSoundFactory = new MixSoundFactory();
	 *   sf.addSound("sound_1");
	 *   sf.removeSound("sound_1");
	 * </code>
	 */
	public function removeSound(sID:String) : Void
	{
		super.removeSound(sID);
		delete _oGain[sID];
	}
	
	/**
	 * Adds new sound to factory.
	 * 
	 * <p>Overrides {@link SoundFactory#removeSound} method, adding 
	 * {@code sID} sound in {@code gain} list. 
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : MixSoundFactory = new MixSoundFactory();
	 *   sf.addSound("sound_1");
	 *   sf.addSound("sound_2");
	 * </code>
	 * 
	 * @param linkageID Sound identifier in swf file
	 * 
	 * @return {@code String} sound identifier 
	 */
	public function addSound(linkageID:String) : String
	{
		if (!_bIsInitialized) _init();
		_oSounds[ linkageID ] = _makeSound(linkageID, _nDepth);
		
		_oGain[ linkageID ] = 90;
		_adjustVolume( linkageID );
		
		_nDepth++;
		return linkageID;
	}
	
	/**
	 * Defines {@code gain} value for passed-in {@code sID} sound.
	 * 
	 * <p>{@code nGain} should be between 0 and 127.
	 * 
	 * @param sID Sound id stored in factory
	 * @param nGain {@code Number} value
	 */
	public function setGain(sID:String, nGain:Number) : Void
	{
		if (nGain > 127) nGain = 127;
		if (nGain < 0) nGain = 0;
		_oGain[sID] = nGain;
		
		_adjustVolume(sID);
	}
	
	/**
	 * Defines {@code gain} value for all stored sounds.
	 * 
	 * <p>{@code nGain} should be between 0 and 127.
	 * 
	 * @param nGain {@code Number} value
	 */
	public function setAllGain(nGain:Number) : Void
	{
		if (nGain > 127) nGain = 127;
		if (nGain < 0) nGain = 0;
		for (var sID in _oSounds)
		{
			_oGain[sID] = nGain;
			_adjustVolume( sID );
		}
	}
	
	/**
	 * Returns defined {@code gain} for passed-in {@code sID} sound id.
	 * 
	 * @param sID Sound id.
	 * 
	 * @return {@code Number} value
	 */
	public function getGain(sID:String) : Number
	{
		return _oGain[sID];
	}
	
	/**
	 * Defines volume value for all sounds list.
	 * 
	 * <p>{@code n} should be between 0 and 100.
	 * 
	 * @param n {@code Number} value
	 */
	public function setVolume(n:Number) : Void
	{
		if (n > 100) n = 100;
		if (n < 0) n = 0;

		_nVolume = n;
		for (var sID:String in _oSounds) _adjustVolume( sID );
	}
	
	/**
	 * Defines pan value for all sounds list.
	 * 
	 * <p>{@code n} should be between -100 and 100.
	 * 
	 * @param n {@code Number} value
	 */
	public function setPan(n:Number) : Void
	{
		if (n > 100) n = 100;
		if (n < -100) n = -100;

		_nPan = n;
		for (var sID in _oSounds) _oSounds[ sID ].setPan(_nPan);
	}
	
	/**
	 * Returns volume value.
	 * 
	 * @return {@code Number} value
	 */
	public function getVolume() : Number
	{
		return _nVolume;
	}
	
	/**
	 * Returns pan value.
	 * 
	 * @return {@code Number} value
	 */
	public function getPan() : Number
	{
		return _nPan;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function _onSoundLoop(snd:Sound) : Void
	{
		snd.start(0, 1);
		_fireOnSoundComplete();
	}
	
	private function _fireOnSoundComplete() : Void
	{
		_oEB.broadcastEvent( new BasicEvent(onSoundCompleteEVENT) );
	}
	
	private function _adjustVolume(sID:String) : Void
	{
		var v:Number = _calculVolume( getGain(sID) );
		getSound(sID).setVolume( v );
	}
	
	private function _calculVolume(nGain:Number): Number
	{
		return (nGain / 100) * _nVolume;
	}
}