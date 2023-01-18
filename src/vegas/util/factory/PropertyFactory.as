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

import vegas.util.StringUtil;

/**
 * This factory class creates virtual properties.
 * <p>You must defined your virtual properties in public if you use this class in AS2 class.</p>
 * @author eKameleon
 */
class vegas.util.factory.PropertyFactory 
{

	/**
	 * Creates a new virtual property (read_write or read only).
	 * @see Object.addProperty method.
	 */	
	static public function create(o, propName:String, isPrototype:Boolean, isReadOnly:Boolean):Boolean 
	{
		if (isPrototype) 
		{
			o = o["prototype"] ;
		}
		var suffix:String = StringUtil.ucFirst(propName) ;
		var g:Function = o["get"+suffix] ;
		var s:Function = isReadOnly ? null: o["set"+suffix] ;
		return o.addProperty(propName, g, s) ;
	}
	
}