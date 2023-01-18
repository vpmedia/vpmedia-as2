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

/**
 * This static class register all types used to draw an Arc with the ArcPen tool.
 * @author eKameleon
 */
class pegas.draw.ArcType 
{

	/**
	 * The chord type.
	 */
	static public var CHORD:String = "CHORD" ;
	
	/**
	 * The pie type.
	 */
	static public var PIE:String = "PIE" ;

	static private var __ASPF__ = _global.ASSetPropFlags(ArcType, null, 7, 7) ;

	/**
	 * Returns {@code true} if the specified type in argument is a valide ArcType.
	 * @return {@code true} if the specified type in argument is a valide ArcType.
	 */
	static public function validate(type:String):Boolean 
	{
		return (type == ArcType.CHORD || type == ArcType.PIE) ;
	}
	
}