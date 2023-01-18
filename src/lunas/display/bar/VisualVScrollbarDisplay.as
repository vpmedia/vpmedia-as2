/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.display.abstract.AbstractScrollbarDisplay;
import lunas.display.bar.VisualVScrollbarDisplayBuilder;

/**
 * The VisualVScrollbarDisplay class.
 * @author eKameleon
 */
class lunas.display.bar.VisualVScrollbarDisplay extends AbstractScrollbarDisplay 
{

	/**
	 * Creates a new VisualVScrollbarDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	public function VisualVScrollbarDisplay(sName:String, target:MovieClip ) 
	{ 
		
		super ( sName, target ) ;
		
	}

	/**
	 * Returns the bar reference of this display.
	 * @return the bar reference of this display.
	 */
	public function getBar():MovieClip 
	{
		return view.bar ;
	}
	
	/**
	 * Returns the IBuilder constructor use in the constructor of the component to build it.
	 * @return the IBuilder constructor use in the constructor of the component to build it.
	 */
	public function getBuilderRenderer():Function 
	{
		return VisualVScrollbarDisplayBuilder ;
	}

	/**
	 * Returns the thumb reference of this display.
	 * @return the thumb reference of this display.
	 */
	public function getThumb():MovieClip 
	{
		return view.thumb ;
	}

	/**
	 * Invoqued when the enabled property is changed.
	 */
	public function viewEnabled():Void  
	{
		getBar().enabled = enabled ;
		getBar()._alpha = enabled ? 100 : 50 ;
		getThumb().enabled = enabled ;
		getThumb()._alpha = enabled ? 100 : 50 ;
	}

}