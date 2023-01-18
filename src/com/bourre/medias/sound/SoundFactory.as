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
 * {@code SoundFactory} defines data holder for {@code Sound} object managment.
 * 
 * <p>Load external "MP3" files using {@link #loadSound} method.
 * 
 * <p>Attach internal sound using {@link #addSound} or {@link #addSounds} methods.
 * 
 * <p>{@code SoundFactory} add event support with : 
 * <ul>
 *   <li>{@link #addListener}</li>
 *   <li>{@link #removeListener}</li>
 *   <li>{@link #addEventListener}</li>
 *   <li>{@link #removeEventListener}</li>
 * </ul>
 * 
 * <p>Example
 * <code>
 *   function onSoundLoad(e : IEvent) : Void {
 *   	var sID : String = e.soundID;
 *   	sf.playSoundLoop( sID );
 *   }
 *   
 *   var sf : SoundFactory = new SoundFactory();
 *   sf.addEventListener( SoundFactory.onSoundLoadEVENT, this);
 *   
 *   sf.addSound("sound_1");
 *   sf.addSound("sound_2");
 *   sf.loadSound("http://www.tweenpix.net/background_sound.mp3", "back");
 *   
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.Delegate;
import com.bourre.events.DynBasicEvent;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

class com.bourre.medias.sound.SoundFactory
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oEB:EventBroadcaster;

	private var _bIsInitialized:Boolean;
	private var _oSounds:Object;
	private var _nDepth:Number;
	private var _oContainer:MovieClip;
	private var _bIsOn:Boolean;
	private var _noSound:Sound;
	
	//-------------------------------------------------------------------------
	// Events definition
	//-------------------------------------------------------------------------
	
	/** Broadcast when external mp3 file is loaded. **/
	[Event("onSoundLoad")]
	public static var onSoundLoadEVENT:EventType = new EventType("onSoundLoad");
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code SoundFactory} instance.
	 */
	public function SoundFactory() 
	{
		_oEB = new EventBroadcaster( this );
		
		_bIsInitialized = false;
		_oSounds = new Object();
		_nDepth = 1;
		_bIsOn = true;
	}
	
	/**
	 * Adds passed-in {@code oL} listener for receiving all 
	 * {@code SoundFactory} events.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
	 *   sf.addListener( myListener );
	 * </code>
	 * 
	 * @param oL Listener object
	 */
	public function addListener(oL) : Void
	{
		_oEB.addListener(oL);
	}
	
	/**
	 * Adds passed-in {@code oL} listener for receiving passed-in 
	 * {@code t} event type.
	 * 
	 * <p>Take a look at example below to see all possible method call.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
	 *   oEB.addEventListener( SoundFactory.onSoundLoadEVENT, myListener);
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function addEventListener(e:EventType, oL) : Void
	{
		_oEB.addEventListener(e, oL);
	}
	
	/**
	 * Removes passed-in {@code oL} listener for receiving all 
	 * {@code SoundFactory} events.
	 * 
	 * <p>Example
	 * <code>
	 *   sf.removeListener( myListener );
	 * </code>
	 * 
	 * @param oL Listener object.
	 */
	public function removeListener(oL) : Void
	{
		_oEB.removeListener(oL);
	}
	
	/**
	 * Removes passed-in {@code oL} listener that suscribed for passed-in 
	 * {@code t} event.
	 * 
	 * <p>Example
	 * <code>
	 *  var sf : SoundFactory = new SoundFactory();
	 *   oEB.removeListener( SoundFactory.onSoundLoadEVENT, myListener);
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function removeEventListener(e:EventType, oL) : Void
	{
		_oEB.removeEventListener(e, oL);
	}
	
	/**
	 * Defines passed-in {@code mcTarget} as sounds container.
	 * 
	 * @param mcTarget (optional) {@code MovieClip} instance
	 */
	public function init(mcTarget:MovieClip) : Void 
	{ 
		_init(mcTarget); 
	}
	
	/**
	 * Returns {@code Sound} instance stored under passed-in 
	 * {@code sID} identifier.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
	 *   sf.addSound("sound_1");
	 *   sf.addSound("sound_2");
	 *   
	 *   var o : Sound = sf.getSound("sound_1");
	 * </code>
	 * 
	 * @return {@code Sound} instance. If no sound is found, an empty 
	 * {@code Sound} is returned.
	 */
	public function getSound(sID:String) : Sound 
	{ 
		return _bIsOn ? _oSounds[sID] : _noSound;
	}
	
	/**
	 * Plays passed-in {@code sID} identifier sound in loop mode.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
	 *   sf.addSound("sound_1");
	 *   sf.addSound("sound_2");
	 *   
	 *   sf.playSoundLoop("sound_1");
	 * </code>
	 */
	public function playSoundLoop(sID:String) : Void
	{
		getSound(sID).start(0,65535);
	}
	
	/**
	 * Loads (or attach) new sound.
	 * 
	 * <p>If not valid {@code sURL} is passed, try to find 
	 * {@code linkageID} ID in current swf file.
	 * 
	 * @return {@code String} sound identifier 
	 */
	public function loadSound(sURL:String, linkageID : String) : String
	{
		if (!_bIsInitialized) _init();
		if (!linkageID) linkageID = sURL.substring( sURL.lastIndexOf("/")+1, sURL.lastIndexOf(".") );

		_oSounds[linkageID] = _makeSound(linkageID, _nDepth, sURL);
		_nDepth++;
		return linkageID;
	}
	
	/**
	 * Removes {@code Sound} instance stored under passed-in 
	 * {@code sID} identifier from factory.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
	 *   sf.addSound("sound_1");
	 *   sf.addSound("sound_2");
	 *   
	 *   sf.removeSound("sound_1");
	 * </code>
	 */
	public function removeSound(sID:String) : Void
	{
		var mc:MovieClip = _oContainer["sound" + sID ];
		mc.removeMovieClip();
		delete _oSounds[sID];
	}
	
	/**
	 * Adds new sound to factory.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
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
		_nDepth++;
		return linkageID;
	}
	
	/**
	 * Adds sounds id list to factory.
	 * 
	 * <p>Example
	 * <code>
	 *   var sf : SoundFactory = new SoundFactory();
	 *   var aSndList : Array = new Array("sound_1", "sound_2");
	 *   
	 *   sf.addSounds( aSndList );
	 * </code>
	 * 
	 * @param a {@code Array} Sounds ID list
	 */
	public function addSounds(a:Array) : Void
	{
		var l:Number = a.length;
		for (var c:Number=0; c<l ; c++) addSound(a[c]);
	}
	
	/**
	 * Toggles "playing" mode.
	 * 
	 * <p>Uses {@link #goOn} or {@link #goOff} methods to switch 
	 * "playing" mode.
	 */
	public function toggleOnOff() : Void 
	{ 
		if (_bIsOn)
		{
			goOff();
		} else
		{
			goOn();
		}
	}
	
	/**
	 * Checks if "playing" mode is enable or not.
	 * 
	 * @return {@code true} is "playing" mode is enable, either {@code false}
	 */
	public function get isOn() : Boolean 
	{ 
		return _bIsOn; 
	}
	
	/**
	 * Turns "playing" mode on.
	 * 
	 * <p>Sounds are not automatically played.
	 */
	public function goOn() : Void 
	{ 
		_bIsOn = true; 
	}
	
	/**
	 * Turns "playing" mode off and stops all currently played sounds.
	 */
	public function goOff() : Void 
	{ 
		_bIsOn = false;
		 for (var sID:String in _oSounds) _oSounds[ sID ].stop();
	}
	
	/**
	 * Returns an {@code Array} list of stored sounds.
	 * 
	 * @return {@code Array} instance
	 */
	public function getAllSounds() : Array
	{
		var a:Array = new Array();
		for (var p:String in _oSounds) a.push( _oSounds[p] );
		return a;
	}
	
	/**
	 * Stops all sounds, clears sounds lists and reset event listeners.
	 */
	public function clear() : Void
	{
		_oEB.removeAllListeners();

		delete _oSounds;
		_oContainer.removeMovieClip();
		_bIsInitialized = false;
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
	
	private function _init(mcTarget:MovieClip) : Void
	{
		_oContainer = (mcTarget == undefined) ? _level0.createEmptyMovieClip("__snd__", 65535) : mcTarget;
		_noSound = _makeSound("", 0);
		_bIsInitialized = true;
	}
	
	private function _makeSound(sLinkageID:String, nSoundID:Number, sURL:String) : Sound
	{
		var container:MovieClip = _oContainer.createEmptyMovieClip("sound" + sLinkageID, nSoundID);
		var snd:Sound = new Sound(container);

		if (sURL)
		{
			var e:DynBasicEvent = new DynBasicEvent( SoundFactory.onSoundLoadEVENT );
			e.soundID = sLinkageID;
			e.soundURL = sURL;
			snd.onLoad = Delegate.create(this, _fireEvent, e);
			snd.loadSound(sURL, false);

		} else
		{
			snd.attachSound(sLinkageID);
		}
		return snd;
	}
	
	private function _fireEvent(b:Boolean, e:DynBasicEvent) : Void
	{
		e.success = b;
		_oEB.broadcastEvent( e );
	}
}