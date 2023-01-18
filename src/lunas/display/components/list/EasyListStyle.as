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

import lunas.display.components.AbstractStyle;
import lunas.display.components.button.EasyButtonStyle;

/**
 * @author eKameleon
 */
class lunas.display.components.list.EasyListStyle extends AbstractStyle 
{

	
	/**
	 * Creates a new EasyListStyle instance.
	 */
	public function EasyListStyle( init:Object ) 
	{
		super(init) ;
	}

	static public var LABEL_STYLE_NAME:String = "EasyButtonLabel" ;

	var themeColor:Number = 0xFFFFFF ;
	var themeDisabled:Number = 0xFFFFFF  ;
	var themeAlpha:Number = 20 ;
	var thickness:Number = 1 ;
	var themeBorderColor:Number = 0xFFFFFF ;
	var themeBorderAlpha:Number = 100 ;

	var margin:Number = 1 ;
	var spacing:Number = 1 ;
	var cellStyle:EasyButtonStyle = undefined ;
	
}