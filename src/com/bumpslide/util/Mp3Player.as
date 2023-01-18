import com.bumpslide.events.*;
import com.bumpslide.util.*;

/**
* A simple MP3 player for use with a jukebox.
* 
* This is an event dispatcher that wraps the sound object and
* gives us some playhead controls and other helper functions.
* 
* @author David Knape
*/
class com.bumpslide.util.Mp3Player extends Dispatcher
{	
	var mDebug = true;
	var mName = "Mp3Player";

	var mSmartBuffering = false;
	
	// The sound
	private var _sound:Sound;

	// state vars
	private var _soundLoaded : Boolean = false;	
	private var _buffering : Boolean = false; //boolean indicates if we are buffering
	private var _loading : Boolean = false; // whether or not we are loading
	private var _playing : Boolean = false;
	private var _paused : Boolean = true;		
	private var _pausePosition:Number; // milliseconds (track position where we paused)
	
	// vars used in buffering/loading
	private var _bufferStartTime : Number = 0; //the getTimer() time the video was first started	
	private var _bufferPadFactor : Number = .7;
	private var _defaultDuration : Number = 60000; // default duration (for smart loading) is 1 minute	
	private var _loadProgress : Number = 0;  // 0-1	
	
	// intervals
	private var _loadingInt:Number = -1;	
	private var _playbackInt:Number = -1;
	private var _previousPosition:Number = 0;
	
	// events
	static var EVENT_ID3_LOADED : String = "onID3Loaded";
	static var EVENT_SOUND_LOADED : String = "onSoundLoaded";
	static var EVENT_SOUND_COMPLETE : String = "onSoundComplete";
	static var EVENT_PLAYHEAD_CHANGE : String = "onPlayheadChange";
	static var EVENT_PLAYSTATE_CHANGE : String = "onPlaystateChange";
	static var EVENT_BUFFERING : String = "onSoundBuffering";
	
	/**
	* Constructs a new Mp3 Player
	*/
	function Mp3Player() 
	{
		super();
		init();
	}
	
	/**
	* whether or not we are currently loading a track
	* @return boolean
	*/
	public function get loading():Boolean
	{
		return _loading;
	}
	
	/**
	* whether or not we are currently buffering a track
	* @return boolean
	*/
	public function get buffering():Boolean
	{
		if(mSmartBuffering) {
			return _buffering;
		} else {
			return playing && position==_previousPosition;
		}
	}
	
	
	/**
	* returns reference to sound object
	* @return sound object
	*/
	public function get sound():Sound
	{
		return _sound;
	}
	
	/**
	* whether or not sound file is loaded
	* @return
	*/
	public function get soundLoaded():Boolean
	{
		return _soundLoaded;
	}
	
	/**
	* whether or not the sound is playing
	* @return
	*/
	public function get playing():Boolean
	{
		return _playing;
	}
	
	/**
	* whether or not the sound is paused
	* @return
	*/
	public function get paused():Boolean
	{
		return _paused;
	}
	
	/**
	* whether or not the sound is stopped
	* @return
	*/
	public function get stopped():Boolean
	{
		return !_paused && !_playing;
	}
	
	/**
	* Returns duration of currently loaded sound (or default duration) is no sound loaded (in ms)
	* @return
	*/
	public function get duration() : Number {
		return (sound.duration==undefined || loading ) ? _defaultDuration : sound.duration;
	}
	
	public function get position () : Number {
		return (_paused) ? _pausePosition : sound.position;
	}
	
	/**
	* sets default duration for sake of smart buffering streaming audio (in ms)
	* @param	n
	*/
	public function set duration(n:Number)  {
		debug('Setting default duration to '+n);
		_defaultDuration = n;
	}
	
	/**
	* Creates a new Sound() object and subscripes to its events
	*/
	function init() : Void
	{
		destroy();
		
	}
	
	/**
	* kills the sound, and removes any lingering event listeners
	*/
	function destroy() : Void
	{
		clearInterval( _loadingInt );
		clearInterval( _playbackInt );
		
		sound.stop();
		sound.onID3 = null;
		sound.onLoad = null;
		sound.onSoundComplete = null;
		delete _sound;
		_soundLoaded = false;
		_buffering = false;
		
		dispatchEvent( new Event( EVENT_PLAYSTATE_CHANGE, this ) );
		
		removeAllListeners( EVENT_ID3_LOADED );
		removeAllListeners( EVENT_SOUND_LOADED );
		removeAllListeners( EVENT_SOUND_COMPLETE );
		removeAllListeners( EVENT_PLAYSTATE_CHANGE );
		removeAllListeners( EVENT_PLAYHEAD_CHANGE );
	}
	
	/**
	* Start streaming MP3 file
	* 
	* @param	mp3
	*/
	function load( mp3:String ) : Void
	{	
		_global._soundbuftime = 5;
		_soundLoaded = false;
		stop(); 
		
		_sound = new Sound();
		sound.onID3 = Delegate.create( this, _onID3Loaded );
		sound.onLoad = Delegate.create( this, _onSoundLoaded);
		sound.onSoundComplete = Delegate.create( this, _onSoundComplete );
		
		
		sound.loadSound( mp3, true);
		
		clearInterval( _loadingInt );
		clearInterval( _playbackInt );
		
		_playing = true;
		
		//sound.stop();
		
		if(mSmartBuffering) {
			_playing = false;
			sound.stop();
		} else {
			
			//sound.start( 0 );
		}
		
		// get timestamp for smart buffering
		_buffering = true;
		_bufferStartTime = getTimer();
		_loadProgress = 0;
		_loadingInt = setInterval( this, 'monitorLoading', 40 );		
		_playbackInt = setInterval( this, 'monitorPlayback', 500 );
		monitorLoading();
			
	}

	private var play_starttime:Number = 0;
	
	function monitorLoading() {
		
		_loading = true;
		
		var L = sound.getBytesLoaded();
		var T = sound.getBytesTotal();
		
		var pct = Math.round( L/T * 100 );
		
		if( L >= T && T > 4 ){
			clearInterval( _loadingInt );
			_loading = false;
			_buffering = false;
		}
		
		_loadProgress = L/T;
		
		if(!isNaN(_loadProgress)) {
			
			// smart buffering...
			
			//find out if we can play (have enough in buffer to play while the rest is loading)
			if( _buffering && (_loadProgress < 1 /* && _loadProgress > .15*/ ) && L && T ){
				
				var elapsedS = ( getTimer() - _bufferStartTime )/1000;
				var remainingS = ( T - L )/( L / elapsedS );
				var totalS = duration/1000;
			
				//Debug.trace("remainingS="+remainingS+"  totalS="+totalS);
				
				// we are done buffering when remaining seconds is less than totalS*_bufferPadFactor
				if( totalS && remainingS ){
					if( _buffering && remainingS < totalS*_bufferPadFactor ){						
						dispatchEvent( new Event( EVENT_BUFFERING, this, {bufferPercent:100 }) );
						_buffering = false;
						if(mSmartBuffering) play();
					}else {				
						var paddedDuration = totalS*_bufferPadFactor;
						var bufferLevel = 1 - (remainingS-paddedDuration) / remainingS; 
						//Debug.trace( "Buffering...  "+Math.ceil(bufferLevel*100)+"%" );					
						dispatchEvent( new Event( EVENT_BUFFERING, this, {bufferPercent:Math.round( bufferLevel*100) }) );
						_buffering = true;
					}					
				}
				
			}
		}
	}
	
	
	/**
	* Plays currently loaded mp3 at current pause position
	*/
	function play() {
		
		
		if(soundLoaded || !_buffering || !mSmartBuffering) {
			
			_playing = true;
			_paused = false;	
		
			debug('playing from '+(_pausePosition/1000));
			
			dispatchEvent( new Event( EVENT_PLAYSTATE_CHANGE, this ) );
				
			if(_pausePosition==0) sound.start();
			else sound.start( _pausePosition/1000 );	
			
			clearInterval( _playbackInt );
			_playbackInt = setInterval( this, 'monitorPlayback', 200 );
		}
		
	}
	
	/**
	* pauses mp3
	*/
	function pause() {
		debug('pause');
		_playing = false;
		_paused = true;
		_pausePosition = sound.position;
		sound.stop();
		dispatchEvent( new Event( EVENT_PLAYSTATE_CHANGE, this ) );
	}
	
	/**
	* stops sound playback and resets playhead to 0
	*/
	function stop() {
		sound.stop();
		sound.start(0);
		sound.stop();
		_pausePosition = 0;
		_previousPosition = 0;
		debug('stop');
		_playing = false;
		_paused = false;
		
		clearInterval( _playbackInt );
		
		dispatchEvent( new Event( EVENT_PLAYHEAD_CHANGE, this ) );
		dispatchEvent( new Event( EVENT_PLAYSTATE_CHANGE, this ) );
	}
	
	private function monitorPlayback() 
	{
		if(_buffering && mSmartBuffering || stopped) return;				
		dispatchEvent( new Event( EVENT_PLAYHEAD_CHANGE, this ) );
		_previousPosition = position;		
	}
	
	private function _onID3Loaded() 
	{
		//Debug.trace( "ID3 Loaded..." );
		//Debug.trace( sound.id3 );
		dispatchEvent( new Event( EVENT_ID3_LOADED, this, { data: sound.id3 } ) );
	}
	
	private function _onSoundLoaded() 
	{		
		_soundLoaded = true;
		_buffering = false;
		_loading = false;
		
		clearInterval( _loadingInt );
		
		//if(!_playing) play();
		
		dispatchEvent( new Event( EVENT_SOUND_LOADED, this ) );
	}
	
	private function _onSoundComplete() {
		dispatchEvent( new Event( EVENT_SOUND_COMPLETE, this ) );
		stop();		
	}
	
	
	
	
}
