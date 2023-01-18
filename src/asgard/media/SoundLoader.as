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

import asgard.events.MediaEventType;
import asgard.media.AbstractMediaLoader;

import vegas.errors.UnsupportedOperation;
import vegas.errors.Warning;
import vegas.events.Delegate;
import vegas.util.MathsUtil;

/**
 * This loader load an external Sound in the application. 
 * @author eKameleon
 */
class asgard.media.SoundLoader extends AbstractMediaLoader 
{
	
	/**
	 * Creates a new SoundLoader instance.
	 */
	function SoundLoader( mcTarget:MovieClip , sName:String ) 
	{
		super(mcTarget, sName) ;
		getSound().onLoad = function (success:Boolean):Void 
		{
			trace("> sound onLoad :: " + success) ;
		} ;
		_currentPos = 0 ;
		getSound().onSoundComplete = Delegate.create(this, _onSoundComplete) ;
		setContent(_oSound) ;
		setAutoPlay(true) ;
	}

	
	static public var VOLUME_DEFAULT:Number = 60 ;


	/*override*/ public function getDuration():Number 
	{
		return isNaN(_oSound.duration) ? 0 : _oSound.duration ;
	}
	
	/*override*/ public function getPosition():Number 
	{
		return getSound().position ;	
	}

	public function getTime():Number 
	{
		return (getPosition() / 1000) ;
	}
	
	public function getPercentPosition():Number 
	{
		return MathsUtil.getPercent(getPosition(), getDuration()) ;	
	}

	/*override*/ public function load(sURL:String):Void 
	{
		sURL = sURL || this.getUrl() ;
		this.stop(true) ;
		try 
		{
			if( sURL ) 
			{
				super.setUrl( sURL ) ;
				_isLoaded = false ;
				_load() ;
			}
			else 
			{
				throw new Warning ( toString() + " got invalid url property, can't load." ) ; 
			}
		} 
		catch(e:Warning) 
		{
			
			trace(e.toString()) ;
			
		}
	}

	/*override*/ public function pause(noEvent:Boolean):Void 
	{
		if (isPlaying()) 
		{
			
			stopProgress() ;
			getSound().stop() ;
			
			_currentPos = getSound().position ;

			if (noEvent != true) 
			{
				notifyEvent(MediaEventType.MEDIA_RESUME) ;
			}
		}
		else 
		{
			this.play(_currentPos) ;
		}
	}

	/*override*/ public function play( pos:Number, noEvent:Boolean):Void 
	{

		if (!_isLoaded) 
		{
			_load() ;
		}
		
		_currentPos = (pos > 0) ? pos : 0 ;
		
		getSound().start( _currentPos / 1000 ) ;
		
		if (noEvent != true) 
		{
			notifyEvent(MediaEventType.MEDIA_START) ;
		}
		startProgress() ;
	}
	
	/*override*/ public function release():Void 
	{
		this.stop(true) ;
		super.release() ;
	}
	
	/*override*/ public function setPosition(time:Number):Void 
	{
		if (isPlaying()) 
		{
			this.play(time) ;
		}
		else 
		{
			_currentPos = (isNaN(time)) ? 0 : time ;
		}
	}
	
	/*override*/ public function stop(noEvent:Boolean):Void 
	{
		if (isPlaying()) 
		{
			stopProgress() ;
			getSound().stop() ;
			_currentPos = 0 ;
			if ( noEvent != true ) 
			{
				notifyEvent(MediaEventType.MEDIA_STOP) ;
			}
		}
	}

	private var _currentPos:Number ;

	private function _load():Void 
	{
		
		try 
		{
			if ( this.getUrl() == undefined ) 
			{
				throw new UnsupportedOperation( this + " can't play without any valid url property, loading fails.");
			}
			
		} 
		catch (e:UnsupportedOperation) 
		{
			
			trace(e.toString()) ;
			return ;
				
		}
		
		_oSound.loadSound( this.getUrl() , isAutoPlay() ) ;
		
		if (isAutoPlay()) 
		{
			startProgress() ;
			_currentPos = 0 ;
			getSound().start(_currentPos) ;
			notifyEvent(MediaEventType.MEDIA_START) ;
		}
		_isLoaded = true ;
		
		super.load();
	}

	private function _onSoundComplete():Void 
	{
		notifyEvent(MediaEventType.MEDIA_FINISH) ;
		if ( isLoop() ) 
		{
			getSound().start() ;
		} 
	}

}