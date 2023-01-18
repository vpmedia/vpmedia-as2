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

import asgard.media.MicrophoneStatus;

import vegas.data.map.HashMap;
import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.BasicEvent;
import vegas.events.BooleanEvent;
import vegas.events.Delegate;
import vegas.events.Event;
import vegas.util.ConstructorUtil;

/**
 * This singleton expert to control a Microphone instance.
 * @author eKameleon
 */
class asgard.media.MicrophoneExpert extends AbstractCoreEventDispatcher 
{
	
	/**
	 * Creates a new MicrophoneExpert instance.
	 * @param MicrophoneID the id name of the Microphone to control.
	 * @param MicrophoneIndex (optional) this index defines a zero-based integer that specifies which Microphone to get, as determined from the array returned by the Microphone.names property.
	 * This argument is used only the first time when the specifiec MicrophoneExpert is created. To get the default Microphone (which is recommended for most applications), omit this parameter.
	 */
	function MicrophoneExpert( microID:String , microIndex:Number ) 
	{
		_microID = microID ;
		initEvent() ;
		_mic = Microphone.get( microIndex ) ;
		_mic.toString = function():String
		{
			return "[Microphone]" ;
		} ;
		_mic.onActivity = Delegate.create(this, _onMicroActivity ) ;
		_mic.onStatus   = Delegate.create(this, _onMicroStatus ) ;
		updateMicrophone() ;
	}
	
	/**
	 * The name of the event when the Microphone activity change.
	 */
	static public var MICROPHONE_ACTIVITY_CHANGE:String = "onMicrophoneActivityChange" ;

	/**
	 * The name of the event when the Microphone is muted.
	 */
	static public var MICROPHONE_IS_MUTED:String = "onMicrophoneIsMuted" ;

	/**
	 * The name of the event when the Microphone is unmuted.
	 */
	static public var MICROPHONE_IS_UNMUTED:String = "onMicrophoneIsUnMuted" ;

	/**
	 * The default microphone echo suppression value.
	 */
	static public var DEFAULT_MICRO_ECHO_SUPPRESSION:Boolean = false ;

	/**
	 * The default microphone rate value.
	 */
	static public var DEFAULT_MICRO_RATE:Number = 11 ;
	
	/**
	 * The default microphone silence level value.
	 */
	static public var DEFAULT_MICRO_SILENCE_LEVEL:Number = 10 ;

	/**
	 * The default microphone silence timeout value.
	 */
	static public var DEFAULT_MICRO_SILENCE_TIMEOUT:Number = 1000 ;

	/**
	 * Returns {@code true} if the MicrophoneExpert contains the specified camera id.
	 * @return {@code true} if the CameraExpert contains the specified camera id.
	 */
	static public function contains( microID:String  ):Boolean
	{
		return _map.containsKey( microID ) ;	
	}

	/**
	 * Returns the Microphone reference of this object.
	 * @return the Microphone reference of this object.
	 */
	public function getMicrophone():Microphone
	{
		return _mic ;
	}
	
	/**
	 * Returns the id of this expert.
	 * @return the id of this expert.
	 */
	public function getMicrophoneID():String
	{
		return _microID ;	
	}

	/**
	 * Returns the event name when the Microphone activity change.
	 * @return the event name when the Microphone activity change.
	 */
	public function getEventTypeACTIVITY():String
	{
		return _eActivity.getType() ;		
	}

	/**
	 * Returns the event name when the Microphone is muted.
	 * @return the event name when the Microphone is muted.
	 */
	public function getEventTypeMUTED():String
	{
		return _eMuted.getType() ;		
	}
	
	/**
	 * Returns the event name when the Microphone is unmuted.
	 * @return the event name when the Microphone is unmuted.
	 */
	public function getEventTypeUNMUTED():String
	{
		return _eUnMuted.getType() ;		
	}

	/**
	 * Returns a MicrophoneExpert singleton.
	 * @param microID the Microphone id of the MicrophoneExpert singleton.
	 * @param microIndex (optional) this index defines a zero-based integer that specifies which Microphone to get, as determined from the array returned by the Microphone.names property.
	 * This argument is used only the first time when the specifiec MicrophoneExpert is created. To get the default Microphone (which is recommended for most applications), omit this parameter.
	 * @return a MicrophoneExpert singleton or null .
	 */
	static public function getInstance( microID:String , microIndex:Number ):MicrophoneExpert
	{
		if ( _map == null)
		{
			_map = new HashMap() ;	
		}
		if ( !_map.containsKey( microID ) )
		{
			_map.put( microID, new MicrophoneExpert( microID , microIndex ) ) ;
		}
		return _map.get( microID ) ;
	}

	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 */
	public function initEvent():Void
	{
		_eActivity   = new BooleanEvent( MICROPHONE_ACTIVITY_CHANGE , null, this) ;
		_eMuted      = new BasicEvent( MICROPHONE_IS_MUTED, this ) ;
		_eUnMuted    = new BasicEvent( MICROPHONE_IS_UNMUTED, this ) ;
	}

	/**
	 * Release the specified MicrophoneExpert singleton.
	 * @param microID the microphone id of the MicrophoneExpert singleton.
	 * @return the removed MicrophoneExpert singleton or null .
	 */
	static public function release( microID:String ):MicrophoneExpert
	{
		return _map.remove( microID ) ;
	}

	/**
	 * Sets the Microphone rate value.
	 * @param rate the microphone rate value.
	 */
	public function setMicrophoneRate( rate:Number ):Void
	{
		if ( isNaN( rate ) ) 
		{
			rate = DEFAULT_MICRO_RATE ;
		}
		getLogger().info( this + " setRate : " + rate ) ;
		_mic.setRate( rate ) ;
	}
	
	/**
	 * Sets the Microphone silence level.
	 * @param silencelevel the setting object.
	 */
	public function setMicrophoneSilenceLevel( silencelevel:Object )
	{
		var level:Number = silencelevel.level ;
		if ( isNaN( level ) ) 
		{
			level = DEFAULT_MICRO_SILENCE_LEVEL ;
		}
		getLogger().info( this + " setSilenceLevel level : " + level ) ;
		
		var timeout:Number = silencelevel.timeout ;
		if ( isNaN( timeout ) ) 
		{
			timeout = DEFAULT_MICRO_SILENCE_TIMEOUT ;
		}
		getLogger().info( this + " setSilenceLevel timeout : " + timeout ) ;
		
		_mic.setSilenceLevel( level , timeout ) ;
	}

	/**
	 * Sets the Microphone echo suppression flag.
	 * @param echosuppression the flag to indicates if the echosuppression is on or off.
	 */
	public function setMicrophoneUseEchoSuppression( echosuppression:Boolean ):Void
	{
		if ( echosuppression == null ) 
		{
			echosuppression = DEFAULT_MICRO_ECHO_SUPPRESSION ;
		}
		getLogger().info( this + " setEchoSuppression : " + echosuppression ) ;
		_mic.setUseEchoSuppression( echosuppression  ) ;
	}
	
	/**
	 * Sets the event name when the Microphone activity change.
	 */
	public function setEventTypeACTIVITY(type:String ):Void
	{
		_eActivity.setType( type ) ;		
	}

	/**
	 * Sets the event name when the Microphone is muted.
	 */
	public function setEventTypeMUTED(type:String ):Void
	{
		_eMuted.setType( type ) ;		
	}
	
	/**
	 * Sets the event name when the Microphone is unmuted.
	 */
	public function setEventTypeUNMUTED(type:String ):Void
	{
		_eUnMuted.setType( type ) ;		
	}

	/**
	 * Returns the String representation of the object.
	 * @return the String representation of the object.
	 */
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + ( getMicrophoneID() != null ? (":" + getMicrophoneID() ) : "" ) + "]" ;	
	}

	/**
	 * Update the Microphone setting.
	 */
	public function updateMicrophone( init:Object ):Void
	{
		setMicrophoneUseEchoSuppression( init.echosuppression ) ;
		setMicrophoneRate( init.rate ) ;
		setMicrophoneSilenceLevel( init.silencelevel ) ;
	}

	/**
	 * The Microphone singleton reference.
	 */
	private var _mic:Microphone ;

	/**
	 * The MicrophoneExpert id.
	 */
	private var _microID:String ;

	private var _eActivity:Event ;
	
	private var _eMuted:Event ;
	
	private var _eUnMuted:Event ;

	static private var _map:HashMap  ;

	/**
	 * Invoked when the Microphone starts or stops detecting sound.
	 */
	public function _onMicroActivity( activity:Boolean ):Void
	{
		BooleanEvent(_eActivity).setBoolean( activity ) ;
		dispatchEvent( _eActivity ) ;
	}

	/**
	 * Invoqued when the Microphone status change.
	 */
	private function _onMicroStatus( oInfo:Object ):Void
	{
		var code:String = oInfo.code ;
		switch( code )
		{
			case MicrophoneStatus.MUTED :
			{
				dispatchEvent( _eMuted ) ;
				break ;
			}	
			case MicrophoneStatus.UNMUTED :
			{
				dispatchEvent( _eUnMuted ) ;
				break ;	
			}
		}
	}

}