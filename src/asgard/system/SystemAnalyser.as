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

import asgard.system.SystemAnalyserFormat;
import asgard.system.SystemEvent;

import vegas.core.IFormattable;
import vegas.core.IRunnable;
import vegas.data.iterator.ArrayIterator;
import vegas.events.EventDispatcher;

/**
 * This Singleton check all properties in the System.capabilities class.
 * <p>You can insert or remove properties or sort the analyse with the properties array.</p>
 */
class asgard.system.SystemAnalyser extends EventDispatcher implements IRunnable, IFormattable 
{

	/**
	 * Creates the SystemAnalyser singleton.
	 */
	private function SystemAnalyser() 
	{
	
	}

	/**
	 * The array representation of all properties to be check by the SystemAnalyser.
	 */
	public var properties:Array = [ 
		"language", 
		"os", 
		"manufacturer", 
		"playerType", 
		"version", 
		"localFileReadDisable", 
		"screenDPI", 
		"avHardwareDisable", 
		"hasAudio", 
		"hasAudioEncoder", 
		"hasMP3", 
		"hasStreamingAudio", 
		"hasStreamingVideo", 
		"hasVideoEncoder", 
		"hasEmbeddedVideo", 
		"hasScreenBroadcast", 
		"hasScreenPlayback" 
	] ;

	/**
	 * Returns the singleton reference of the SystemAnalyser class.
	 * @return the singleton reference of the SystemAnalyser class.
	 */
	static public function getInstance(Void):SystemAnalyser {
		if (__INSTANCE__ == undefined) __INSTANCE__ = new SystemAnalyser() ;
		return __INSTANCE__ ;
		
	}

	/**
	 * Returns the value of the specified system property passed in argument.
	 * @return the value of the specified system property passed in argument.
	 * @see System.capabilities
	 */
	public function getSystemProperty(prop:String) 
	{
		return System.capabilities[prop] ;
	}

	/**
	 * Run the check of all properties.
	 * This method dispatch a SystemEvent 
	 * @see SystemEvent
	 */
	public function run():Void
	{ 
        var it:ArrayIterator = new ArrayIterator(properties) ; 
        while(it.hasNext()) 
        { 
            var cur:String = it.next() ; 
			var ev:SystemEvent = new SystemEvent(this, cur, System.capabilities[cur]) ;
			dispatchEvent( ev, false) ; 
        } 
	}

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String 
	{
		return (new SystemAnalyserFormat()).formatToString(this) ;
	}

	/**
	 * The internal singleton of this class.
	 */
	static private var __INSTANCE__:SystemAnalyser ;

	
}