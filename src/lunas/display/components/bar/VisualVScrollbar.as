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

import lunas.display.components.bar.AbstractScrollbar;
import lunas.display.components.bar.VisualVScrollbarBuilder;

/**
 * The VisualVScrollbar class.
 * @author eKameleon
 */
class lunas.display.components.bar.VisualVScrollbar extends AbstractScrollbar 
{

	/**
	 * Creates a new VisualVScrollbar instance.
	 */
	public function VisualVScrollbar() 
	{
		super() ;
	}

	public var bar:MovieClip ;

	public var thumb:MovieClip ;

	public function getBar():MovieClip 
	{
		return bar ;
	}

	public function getBuilderRenderer():Function 
	{
		return VisualVScrollbarBuilder ;
	}

	public function getThumb():MovieClip 
	{
		return thumb ;
	}

	public function viewEnabled():Void  
	{
		bar.enabled = enabled ;
		bar._alpha = enabled ? 100 : 50 ;
		thumb.enabled = enabled ;
		thumb._alpha = enabled ? 100 : 50 ;
	}

}