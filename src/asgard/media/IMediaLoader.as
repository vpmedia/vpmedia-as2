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

import asgard.net.ILoader;

/**
 * This interface defined a ILoader who showed a Media (Sound, Video, ..)
 * @author eKameleon
 */
interface asgard.media.IMediaLoader extends ILoader 
{
	
	/**
	 * Returns the duration of the media loader.
	 */
	public function getDuration():Number ;

	/**
	 * Returns the position of the media loader.
	 */
	public function getPosition():Number ;

	/**
	 * Returns the volume of the media loader.
	 */
	public function getVolume():Number ;

	/**
	 * Returns 'true' if the media loader auto play.
	 */
	public function isAutoPlay():Boolean ;

	/**
	 * Returns 'true' if the media loader is playing.
	 */
	public function isPlaying():Boolean ;

	/**
	 * Pause the media loader.
	 */
	public function pause():Void ;
	
	/**
	 * Play the media loader.
	 */
	 public function play():Void ;

	/**
	 * Sets the state of the auto play value for the media loader.
	 */
	public function setAutoPlay(b:Boolean):Void ;
	
	/**
	 * Sets the play activity of the media loader.
	 */
	public function setPlaying(b:Boolean):Void ;

	/**
	 * Set the position of the media loader.
	 */
	public function setPosition(time:Number):Void ;

	/**
	 * Sets the volume of the media loader.
	 */
	public function setVolume(n:Number):Void ;

	/**
	 * Stop the media loader.
	 * override this method 
	 */
	public function stop():Void ;

}