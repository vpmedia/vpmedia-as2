/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.util.TypeUtil;

/**
 * This tool class is used to transform the fill color in a shap draw with the APIs of draw of the MovieClip class.
 * @author eKameleon
 * Thanks : ascb framework <http://www.person13.com/ascblibrary/>
 */
class pegas.draw.FillMatrix extends CoreObject 
{

	/**
	 * Creates a new FillMatrix instance.
	 */
	public function FillMatrix() 
	{
		var first = arguments[0] ;
		if(!first || TypeUtil.typesMatch(first, String) ) {
   			matrixType = first || "box" ;
   			x = isNaN(arguments[1]) ? 0 : arguments[1] ;
			y = isNaN(arguments[2]) ? 0 : arguments[2] ;
			w = isNaN(arguments[3]) ? 100 : arguments[3] ;
			h = isNaN(arguments[4]) ? 100 : arguments[4] ;
			r = isNaN(arguments[5]) ? 0 : arguments[5] ;
		} else {
			a = arguments[0] ;
			b = arguments[1] ;
			c = arguments[2] ;
			d = arguments[3] ;
			e = arguments[4] ;
			f = arguments[5] ;
			g = arguments[6] ;
			h = arguments[7] ;
			i = arguments[8] ;
		}
	}

	public var x:Number ;
	public var y:Number ;
	public var w:Number ;
	public var h:Number ;
	public var r:Number ;
	public var a:Number ;
	public var b:Number ;
	public var c:Number ;
	public var d:Number ; 
	public var e:Number ;
	public var f:Number ;
	public var g:Number ;
	public var i:Number ;
	public var matrixType:String ;

}