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

import asgard.media.CameraStatus;

import vegas.data.map.HashMap;
import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.BasicEvent;
import vegas.events.BooleanEvent;
import vegas.events.Delegate;
import vegas.events.Event;
import vegas.util.ConstructorUtil;

/**
 * This singleton expert to control a Camera instance.
 * @author eKameleon
 */
class asgard.media.CameraExpert extends AbstractCoreEventDispatcher 
{
	
	/**
	 * Creates a new CameraExpert instance.
	 * @param cameraID the id name of the Camera to control.
	 * @param cameraIndex (optional) this index defines a zero-based integer that specifies which camera to get, as determined from the array returned by the Camera.names property.
	 * This argument is used only the first time when the specifiec CameraExpert is created. To get the default camera (which is recommended for most applications), omit this parameter.
	 */
	function CameraExpert( cameraID:String , cameraIndex:Number ) 
	{
		_cameraID = cameraID ;
		initEvent() ;
		_cam = Camera.get( cameraIndex ) ;
		_cam.toString = function():String
		{
			return "[Camera]" ;
		} ;
		_cam.onActivity = Delegate.create(this, _onCameraActivity ) ;
		_cam.onStatus   = Delegate.create(this, _onCameraStatus ) ;
		updateCamera() ;
	}
	
	/**
	 * The name of the event when the Camera activity change.
	 */
	static public var CAMERA_ACTIVITY_CHANGE:String = "onCameraActivityChange" ;

	/**
	 * The name of the event when the Camera is muted.
	 */
	static public var CAMERA_IS_MUTED:String = "onCameraIsMuted" ;

	/**
	 * The name of the event when the Camera is unmuted.
	 */
	static public var CAMERA_IS_UNMUTED:String = "onCameraIsUnMuted" ;

	/**
	 * The default camera mode favor area value.
	 */
	static public var DEFAULT_CAMERA_MODE_FAVOR_AREA:Boolean = true ;
	
	/**
	 * The default camera mode fps value.
	 */
	static public var DEFAULT_CAMERA_MODE_FPS:Number = 24 ;
	
	/**
	 * The default camera mode height value.
	 */
	static public var DEFAULT_CAMERA_MODE_HEIGHT:Number = 100 ;
	
	/**
	 * The default camera mode width value.
	 */
	static public var DEFAULT_CAMERA_MODE_WIDTH:Number = 140 ;
	
	/**
	 * The default camera motion level.
	 */
	static public var DEFAULT_CAMERA_MOTION_LEVEL:Number = 50 ;
	
	/**
	 * The default camera motion timeout.
	 */
	static public var DEFAULT_CAMERA_MOTION_TIMEOUT:Number = 2000 ;
	
	/**
	 * The default camera quality bandwidth.
	 */
	static public var DEFAULT_CAMERA_QUALITY_BANDWIDTH:Number = 6144 ;
	
	/**
	 * The default camera quality level.
	 */
	static public var DEFAULT_CAMERA_QUALITY_LEVEL:Number = 0 ;
	
	/**
	 * Returns {@code true} if the CameraExpert contains the specified camera id.
	 * @return {@code true} if the CameraExpert contains the specified camera id.
	 */
	static public function contains( cameraID:String  ):Boolean
	{
		return _map.containsKey( cameraID ) ;	
	}
	
	/**
	 * Returns the Camera client reference.
	 * @return the Camera client reference.
	 */
	public function getCamera():Camera
	{
		return _cam ;
	}
	
	/**
	 * Returns the id of the Camera to control.
	 * @return the id of the Camera to control.
	 */
	public function getCameraID():String
	{
		return _cameraID ;	
	}

	/**
	 * Returns the event name when the Camera activity change.
	 * @return the event name when the Camera activity change.
	 */
	public function getEventTypeACTIVITY():String
	{
		return _eActivity.getType() ;		
	}

	/**
	 * Returns the event name when the Camera is muted.
	 * @return the event name when the Camera is muted.
	 */
	public function getEventTypeMUTED():String
	{
		return _eMuted.getType() ;		
	}
	
	/**
	 * Returns the event name when the Camera is unmuted.
	 * @return the event name when the Camera is unmuted.
	 */
	public function getEventTypeUNMUTED():String
	{
		return _eUnMuted.getType() ;		
	}

	/**
	 * Returns a CameraExpert singleton.
	 * @param cameraID the camera id of the CameraExpert singleton.
	 * @param cameraIndex (optional) this index defines a zero-based integer that specifies which camera to get, as determined from the array returned by the Camera.names property.
	 * This argument is used only the first time when the specifiec CameraExpert is created. To get the default camera (which is recommended for most applications), omit this parameter.
	 * @return a CameraExpert singleton or null .
	 */
	static public function getInstance( cameraID:String , cameraIndex:Number ):CameraExpert
	{
		if ( _map == null)
		{
			_map = new HashMap() ;	
		}
		if ( !_map.containsKey( cameraID ) )
		{
			_map.put( cameraID, new CameraExpert( cameraID , cameraIndex ) ) ;
		}
		return _map.get( cameraID ) ;
	}

	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 * Overrides this method.
	 */
	public function initEvent():Void
	{
		_eActivity   = new BooleanEvent( CAMERA_ACTIVITY_CHANGE , null, this) ;
		_eMuted      = new BasicEvent( CAMERA_IS_MUTED, this ) ;
		_eUnMuted    = new BasicEvent( CAMERA_IS_UNMUTED, this ) ;
	}

	/**
	 * Release the specified CameraExpert singleton.
	 * @param cameraID the camera id of the CameraExpert singleton.
	 * @return the removed CameraExpert singleton or null .
	 */
	static public function release( cameraID:String ):CameraExpert
	{
		return _map.remove( cameraID ) ;
	}

	/**
	 * Sets the camera capture mode to the native mode that best meets the specified requirements.
	 */
	public function setCameraMode( init:Object ):Void
	{
		
		var width:Number = init.width ;
		if (isNaN( width )) 
		{
			width = DEFAULT_CAMERA_MODE_WIDTH ;
		}
		
		getLogger().info( this + " setCameraMode width : " + width ) ;

		var height:Number = init.height ;
		if (isNaN( height )) 
		{
			height = DEFAULT_CAMERA_MODE_HEIGHT ;
		}
		
		getLogger().info( this + " setCameraMode height : " + height ) ;
		
		var fps:Number = init.fps ;
		if (isNaN( fps ))
		{
			fps = DEFAULT_CAMERA_MODE_FPS ;	
		}
		
		getLogger().info( this + " setCameraMode fps : " + fps ) ;
		
		_cam.setMode( width , height, fps ) ;
	
		var favorarea:Boolean = init.favorarea ;
		if ( favorarea == null )
		{
			favorarea = DEFAULT_CAMERA_MODE_FAVOR_AREA ;	
		}
		
		getLogger().info( this + " setCameraMode favorarea : " + favorarea ) ;
		
		_cam.setMode( width , height, fps , favorarea ) ;
		
	}
	
	/**
	 * Specifies how much motion is required to invoke Camera.onActivity(true).
	 */
	public function setCameraMotionLevel( init:Object ):Void
	{
		
		var level:Number = init.level ;
		if (isNaN( level )) 
		{
			level = DEFAULT_CAMERA_MOTION_LEVEL ;
		}
		getLogger().info( this + " setCameraMotionLevel level : " + level ) ;

		var timeout:Number = init.timeout ;
		if (isNaN( timeout )) 
		{
			timeout = DEFAULT_CAMERA_MOTION_TIMEOUT ;
		}
		getLogger().info( this + " setCameraMotionLevel timeout : " + timeout ) ;

		_cam.setMotionLevel( level, timeout ) ;
		
	}

	/**
	 * Sets the maximum amount of bandwidth per second or the required picture quality of the current outgoing video feed.
	 */
	public function setCameraQualityLevel( init:Object ):Void
	{
		
		var bandwidth:Number = init.bandwidth ;
		if (isNaN( bandwidth )) 
		{
			bandwidth = DEFAULT_CAMERA_QUALITY_BANDWIDTH ;
		}
		getLogger().info( this + " setQualityLevel bandwidth : " + bandwidth ) ;
		
		var level:Number = init.level ;
		if (isNaN( level )) 
		{
			level = DEFAULT_CAMERA_QUALITY_LEVEL ;
		}
		
		getLogger().info( this + " setQualityLevel level : " + level ) ;
		
		_cam.setQuality( bandwidth, level ) ;
		
	}
	
	/**
	 * Sets the event name when the Camera activity change.
	 */
	public function setEventTypeACTIVITY(type:String ):Void
	{
		_eActivity.setType( type ) ;		
	}

	/**
	 * Sets the event name when the Camera is muted.
	 */
	public function setEventTypeMUTED(type:String ):Void
	{
		_eMuted.setType( type ) ;		
	}
	
	/**
	 * Sets the event name when the Camera is unmuted.
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
		return "[" + ConstructorUtil.getName(this) + ( getCameraID() != null ? (":" + getCameraID()) : "" ) + "]" ;	
	}


	/**
	 * Update the Camera setting.
	 */
	public function updateCamera( init:Object ):Void
	{
		setCameraQualityLevel( init.quality ) ;
		setCameraMode( init.mode ) ;
		setCameraMotionLevel( init.motionlevel) ;
	}

	/**
	 * The Camera singleton reference.
	 */
	private var _cam:Camera ;

	/**
	 * The Camera id.
	 */
	private var _cameraID:String ;

	private var _eActivity:Event ;
	
	private var _eMuted:Event ;
	
	private var _eUnMuted:Event ;

	static private var _map:HashMap  ;

	/**
	 * Invoked when the camera starts or stops detecting sound.
	 */
	public function _onCameraActivity( activity:Boolean ):Void
	{
		BooleanEvent(_eActivity).setBoolean( activity ) ;
		dispatchEvent( _eActivity ) ;
	}

	/**
	 * Invoqued when the camera status change.
	 */
	private function _onCameraStatus( oInfo:Object ):Void
	{
		var code:String = oInfo.code ;
		getLogger().fatal(this + " camera status : " + code) ;
		switch( code )
		{
			case CameraStatus.MUTED :
			{
				dispatchEvent( _eMuted ) ;
				break ;
			}	
			case CameraStatus.UNMUTED :
			{
				dispatchEvent( _eUnMuted ) ;
				break ;	
			}
		}
	}

}