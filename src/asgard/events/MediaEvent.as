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

import asgard.events.LoaderEvent;
import asgard.media.IMediaLoader;

/**
 * The MediaEvent class.
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.events.MediaEvent extends LoaderEvent 
{

	/**
	 * Creates a new MediaEvent instance.
	 */
	public function MediaEvent(type:String, loader:IMediaLoader, p_code:Number, p_error:String, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, loader, p_code, p_error, context, bubbles, eventPhase, time, stop) ;
	}
	
	/**
	 * The name of the MediaEvent when the media is cleared.
	 */
	static public var MEDIA_CLEAR:String = "onMediaClear" ;

	/**
	 * The name of the MediaEvent when the media is finished.
	 */
	static public var MEDIA_FINISH:String = "onMediaFinished" ;

	/**
	 * The name of the MediaEvent when the media progress.
	 */
	static public var MEDIA_PROGRESS:String = "onMediaProgress" ;
	
	/**
	 * The name of the MediaEvent when the media is resumed.
	 */
	static public var MEDIA_RESUME:String = "onMediaResumed" ;

	/**
	 * The name of the MediaEvent when the media is started.
	 */
	static public var MEDIA_START:String = "onMediaStarted" ;
	
	/**
	 * The name of the MediaEvent when the media is stopped.
	 */
	static public var MEDIA_STOP:String = "onMediaStopped" ;

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new MediaEvent(getType(), getTarget()) ;
	}

	/**
	 * Returns the duration of the media.
	 * @return the duration of the media.
	 */
	public function getDuration():Number 
	{
		return getLoader().getDuration() ;	
	}

	/**
	 * Returns the load of the media.
	 * @return the load of the media.
	 */
	public function getLoader():IMediaLoader 
	{
		return _oLoader ;
	}

	/**
	 * Returns the position of the media.
	 * @return the position of the media.
	 */
	public function getPosition():Number 
	{
		return getLoader().getPosition() ;	
	}
	
	/**
	 * Returns the volume of the media.
	 * @return the volume of the media.
	 */
	public function getVolume():Number 
	{
		return getLoader().getVolume() ;	
	}

	/**
	 * Internal IMediaLoader reference.
	 */	
	private var _oLoader:IMediaLoader ;

}
