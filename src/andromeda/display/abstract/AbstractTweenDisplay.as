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

import asgard.display.BackgroundDisplay;

/**
 * The AbstractTweenDisplay class.
 * @author eKameleon
 */
class andromeda.display.abstract.AbstractTweenDisplay extends BackgroundDisplay 
{
	
	/**
	 * Creates a new AbstractTweenDisplay.
	 */
	public function AbstractTweenDisplay(sName : String, target:MovieClip) 
	{
		super(sName, target);
	}
	
	/**
	 * The begin value of the easing in the show method.
	 */
	public var easingBegin:Number ;

	/**
	 * The duration value of the easing in the show method.
	 */
	public var easingDuration:Number ;
	
	/**
	 * The end value of the easing in the show method.
	 */
	public var easingEnd:Number ;

	/**
	 * The id value of the easing in the show method.
	 * @see ApplicationEasingController
	 * @see EasingList
	 */
	public var easingID:String ;

	/**
	 * The property value of the easing in the show method.
	 */
	public var easingProperty:String ;

	/**
	 * If this value is 'true' the Background use a Tween with a duration of seconds to show.
	 */
	public var easingUseSeconds:Boolean ;
	
	/**
	 * Determinates if the display use easing.
	 */
	public var useEasing:Boolean = true ;

}