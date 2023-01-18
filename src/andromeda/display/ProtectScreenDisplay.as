/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.core.ApplicationDepthList;
import andromeda.core.ApplicationList;

import asgard.display.BackgroundDisplay;

import vegas.events.Delegate;

/**
 * This display protect the view of the application of all mouse activity.
 * @author eKameleon
 */
class andromeda.display.ProtectScreenDisplay extends BackgroundDisplay
{

	/**
	 * Creates a new ProtectScreenDisplay instance.
	 * @param target the DisplayObject instance control this target.
	 * @param nDepth the depth of the display target reference.
	 */
	function ProtectScreenDisplay( target:MovieClip ) 
	{
		
		super( ApplicationList.PROTECT_SCREEN, target.createEmptyMovieClip( ApplicationList.PROTECT_SCREEN, ApplicationDepthList.PROTECT_DEPTH )  ) ;
        
		Stage.addListener(this) ;
		
		background.onPress = Delegate.create(this, doNothing) ;
		background.useHandCursor = false ;
		
		themeAlpha = 0 ;
		themeColor = 0 ;
		
		hide() ;
						
		isFull = true ;
	}

	/**
	 * This Method do nothing when the use click on the ProtectScreen
	 */	
	 public function doNothing():Void
	 {
	 	getLogger().warn( this + " do nothing ..." ) ;
	 }

	/**
	 * Invoqued when the Stage size change.
	 */
	public function onResize():Void
	{
		update() ;
	}

}