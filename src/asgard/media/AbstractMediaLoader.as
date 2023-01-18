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

import asgard.events.MediaEvent;
import asgard.events.MediaEventType;
import asgard.media.IMediaLoader;
import asgard.net.AbstractLoader;

import vegas.errors.IllegalArgumentError;
import vegas.events.Delegate;
import vegas.events.TimerEvent;
import vegas.util.FrameTimer;

/**
 * This class simplify the implementation of the IMediaLoader interface.
 * @author eKameleon
 * @see SoundLoader
 * @see VideoLoader
 */
class asgard.media.AbstractMediaLoader extends AbstractLoader implements IMediaLoader 
{
	
	/**
	 * Creates a new AbstractMediaLoader instance.
	 * @param mcTarget the target of the IMediaLoader.
	 * @param sName the name of the IMediaLoader.
	 */
	private function AbstractMediaLoader( mcTarget:MovieClip , sName:String) 
	{
		
		super();
		
		if (!mcTarget) 
		{
			throw new IllegalArgumentError(this + " 'mcTarget' argument in constructor is undefined.") ;
		}
		
		_mcTarget = mcTarget ;
		
		setName(sName) ;
		
		_oSound = new Sound(_mcTarget) ;
		
		_timer = new FrameTimer(24) ;
		_timer.addEventListener(TimerEvent.TIMER, new Delegate(this, onProgress));
		

		
	}

	/**
	 * Returns the duration of the media.
	 * @return the duration of the media.
	 */
	public function get duration():Number 
	{
		return getDuration() ;	
	}

	/**
	 * (read-write) Returns the position of the media.
	 * @return the position of the media.
	 */
	public function get position():Number 
	{
		return getPosition() ;	
	}

	/**
	 * (read-write) Sets the position of the media.
	 */
	public function set position(n:Number):Void 
	{
		setPosition(n) ;	
	}

	/**
	 * (read-write) Returns the volume of the media.
	 * @return the volume of the media.
	 */
	public function get volume():Number 
	{
		return getVolume() ;	
	}

	/**
	 * (read-write) Sets the position of the media.
	 */
	public function set volume(n:Number):Void 
	{
		setVolume(n) ;	
	}

	/**
	 * Returns the duration of the media.
	 * overrides this method.
	 * @return the duration of the media.
	 */
	public function getDuration():Number 
	{
		return null ;
	}
	
	/**
	 * Returns the position of the media.
	 * override this method.
	 * @return the position of the media.
	 */
	public function getPosition():Number 
	{
		return null ;
	}

	/**
	 * Returns the sound's media reference.
	 * @return the sound's media reference.
	 */
	public function getSound():Sound 
	{
		return _oSound ;
	}

	/**
	 * Returns the volume of the media.
	 * @return the volume of the media.
	 */
	public function getVolume():Number 
	{
		return getSound().getVolume() ;
	}
		
	/**
	 * Init the internal event reference.
	 */
	public function initEvent():Void 
	{
		_e = new MediaEvent(null, this) ;
	}

	/**
	 * Returns {@code true} if the media auto play.
	 * @return {@code true} if the media auto play.
	 */
	public function isAutoPlay():Boolean 
	{
		return _isAutoPlay ;
	}

	/**
	 * Returns {@code true} if the media is loaded.
	 * @return {@code true} if the media is loaded.
	 */
	public function isLoaded():Boolean 
	{
		return _isLoaded ;	
	}

	/**
	 * Returns {@code true} if the media loop.
	 * @return {@code true} if the media loop.
	 */
	public function isLoop():Boolean 
	{
		return _isLoop ;	
	}
	
	/**
	 * Returns {@code true} if the media is playing.
	 * @return {@code true} if the media is playing.
	 */
	public function isPlaying():Boolean 
	{
		return _isPlaying ;
	}

	/**
	 * Returns {@code true} if the media is resumed.
	 * @return {@code true} if the media is resumed.
	 */
	public function isResumed():Boolean 
	{
		return _isResumed ;	
	}

	/**
	 * Notify the media progress.
	 */
	public function onProgress(ev:TimerEvent):Void 
	{
		notifyEvent( MediaEventType.MEDIA_PROGRESS ) ;
	}

	/**
	 * Pause the media.
	 * override this method 
	 */
	public function pause():Void {
		//
	}

	/**
	 * Play the media.
	 * override this method 
	 */
	public function play():Void 
	{
		//
	}
	
	/**
	 * Sets the state of the auto play value for the loader.
	 */
	public function setAutoPlay(b:Boolean):Void 
	{
		_isAutoPlay = b ;
	}

	/**
	 * Sets if the loader is loaded.
	 */
	public function setLoaded(b:Boolean):Void
	{
		_isLoaded = b ;	
	}

	/**
	 * Sets the loop activity of the loader.
	 */
	public function setLoop(b:Boolean):Void 
	{
		_isLoop = b ;	
	}

	/**
	 * Sets the play activity of the loader.
	 */
	public function setPlaying(b:Boolean):Void 
	{
		_isPlaying = b ;
	}

	/**
	 * Set the position of the loader.
	 * override this method 
	 */
	public function setPosition(time:Number):Void 
	{
		// 
	}
	
	/**
	 * Sets the resumed value of the loader.
	 */
	public function setResumed(b:Boolean):Void 
	{
		_isResumed = b ;
	}
	
	/**
	 * Sets the volume of the media loader.
	 */
	public function setVolume(n:Number):Void 
	{
		getSound().setVolume(n) ;
	}

	/**
	 * Start the timer progress of the loader.
	 */
	public function startProgress():Void 
	{
		_timer.start() ;
		setPlaying(true) ;
	}
	
	/**
	 * Stop the loader.
	 * override this method 
	 */
	public function stop():Void 
	{
		
	}

	/**
	 * Stop the timer progress of the loader.
	 */
	public function stopProgress():Void 
	{
		_stopLoadProgress() ;
		_timer.stop() ;
		setPlaying(false) ;
	}

	
	private var _e:MediaEvent = null ;
	
	private var _isAutoPlay:Boolean = false ;

	private var _isLoaded:Boolean = false ;

	private var _isLoop:Boolean = false ;

	private var _isPlaying:Boolean = false ;

	private var _isResumed:Boolean = false ;

	private var _mcTarget:MovieClip = null ;

	private var _oSound:Sound ;

	private var _timer:FrameTimer ;

}