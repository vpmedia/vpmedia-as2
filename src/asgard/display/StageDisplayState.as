/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.events.FullScreenEvent;

import vegas.events.AbstractCoreEventDispatcher;

/**
 * The StageDisplayState class provides constant values to enter and leave full screen mode.
 * @since Flash Player 9.0.28.0
 * @author eKameleon
 */
class asgard.display.StageDisplayState extends AbstractCoreEventDispatcher
{

	/**
	 * Creates a new StageDisplayState instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	public function StageDisplayState(bGlobal:Boolean , sChannel:String  ) 
	{
		super( bGlobal , sChannel ) ;
		Stage.addListener( this ) ;
		_available   = Stage[StageDisplayState.METHOD_NAME] != null ;
		_eFullscreen = new FullScreenEvent( FullScreenEvent.FULLSCREEN , null, this ) ;
	}
	
	/**
	 * Specifies the state to enter full screen mode.
	 */
	static public var FULLSCREEN:String = "fullScreen" ;
	
	/**
	 * The name of the Stage method to change the display state mode. Only in AS2 with intrinsic class not configured.
	 */
	static public var METHOD_NAME:String = "displayState" ;
	
	/**
	 * Specifies the state to leave full screen mode.
	 */
	static public var NORMAL:String = "normal" ;

	/**
	 * Indicates whether this player is in a container that offers a StageDisplayState interface.
	 * @return {@code true} if this player is in a container that offers a StageDisplayState interface.
	 */
	public function get available():Boolean
	{
		return _available ;
	}
	
	/**
	 * Returns the string representation of the state of the display.
	 * @return the string representation of the state of the display.
	 */
	public function get displayState():String
	{
		return Stage[METHOD_NAME] ;
	}
	
	/**
	 * Sets the string representation of the state of the display.
	 */
	public function set displayState( state:String ):Void
	{
		Stage[METHOD_NAME] = (state == FULLSCREEN) ? state : NORMAL ;
	}
	
	/**
	 * Returns the event name when the stage display state is changed.
	 * @return the event name when the stage display state is changed.
	 */
	public function getEventTypeFULLSCREEN():String
	{
		return _eFullscreen.getType() ;		
	}
	
	/**
	 * Returns the internal singleton reference of this class.
	 * @return the internal singleton reference of this class.
	 */
	static public function getInstance():StageDisplayState
	{
		if (_instance == null)
		{
			_instance = new StageDisplayState() ;	
		}
		return _instance ;
	}
	
	/**
	 * Returns {@code true} if the stage use the fullscreen mode.
	 * @return {@code true} if the stage use the fullscreen mode.
	 */
	public function isFullscreen():Boolean
	{
		return Stage[METHOD_NAME] == FULLSCREEN ;
	}	
	
	/**
	 * Returns {@code true} if the stage use the fullscreen mode.
	 * @return {@code true} if the stage use the fullscreen mode.
	 */
	public function isNormal():Boolean
	{
		return Stage[METHOD_NAME] == FULLSCREEN ;
	}
	
	/**
	 * Sets the event name when the stage display state is changed.
	 */
	public function setEventTypeFULLSCREEN( type:String ):Void
	{
		_eFullscreen.setType( type ) ;		
	}
	
	/**
	 * Toggle the fullscreen mode of the application.
	 */
	public function toggleFullScreen():Void 
	{
		displayState = (displayState == NORMAL) ? FULLSCREEN : NORMAL ; 
	} 
	
	/**
	 * Indicates whether this player is in a container that offers a StageDisplayState interface.
	 */
	private var _available:Boolean ;
	
	/**
	 * The event invoqued when the stage display state change.
	 */
	private var _eFullscreen:FullScreenEvent ;
	
	/**
	 * The internal singleton of this class.
	 */
	static private var _instance:StageDisplayState ;
	
	/**
	 * Invoqued when the stage state change.
	 */
	public function onFullScreen( b:Boolean ):Void
	{
        _eFullscreen.setBoolean( b ) ;
        dispatchEvent( _eFullscreen ) ;
	}
	
}