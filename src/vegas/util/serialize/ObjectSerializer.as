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

import vegas.util.ArrayUtil;
import vegas.util.serialize.Serializer;

/**
 * This serializer convert a primitive object in an EDEN string representation.
 * EDEN Compatibility to serialize ECMAScript data.
 * @author eKameleon
 */
class vegas.util.serialize.ObjectSerializer 
{

	/**
	 * Returns a Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */	
	static public function toSource(o:Object, indent:Number, indentor:String):String 
	{
		var each:String ;
		var source:Array = [] ;
		if (indent != null) indent ++ ;
		for (each in o) 
		{
			if ( o.hasOwnProperty(each) ) 
			{
				if (o[each] === undefined) 
				{
					source.push( each + ":" + "undefined") ;
				}
				else if (o[each] === null) 
				{
					source.push( each + ":" + "null") ;
				}
				else 
				{
					source.push( each + ":" + Serializer.toSource(o[each], indent, indentor) ) ;
				}
			}
		}
		if (indent == null) 
		{
			return "{" + source.join(",") + "}" ;
		}
		if (indentor == null)
		{
			indentor = "    " ;
		}
		if(indent == null ) 
		{
			indent = 0;
		}
		var decal:String = "\n" + ArrayUtil.initialize( indent, indentor ).join( "" ) ;
		return decal + "{" + decal + source.join( "," + decal ) + decal + "}" ;
    }

}