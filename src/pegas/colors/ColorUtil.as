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
 * This static tool class contains static methods to manipulate the Color instances.
 * <p>Thanks 2003 Robert Penner - Use freely, giving credit where possible.</p>
 * <p>This code is based on the book : Robert Penner's Programming Macromedia Flash MX. More informations in :
 * <ul>
 * <li>http://www.robertpenner.com/profmx
 * <li>http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20
 * </ul>
 * </p>
 * @author eKameleon
 */
class pegas.colors.ColorUtil 
{
	
	/**
	 * Inverts the color of the specified Color reference in argument.
	 */
	static public function invert(c:Color):Void 
	{
		var t:Object = c.getTransform();
		c.setTransform ( 
			{
				ra : -t.ra , ga : -t.ga , ba : -t.ba ,
				rb : 255 - t.rb , gb : 255 - t.gb , bb : 255 - t.bb 
			} 
		) ;
	}

	/**
	 * Resets the color of the specified Color reference in argument, the MovieClip display the original view since Color transformation.
	 */
	static public function reset(c:Color):Void 
	{ 
		c.setTransform ({ra:100, ga:100, ba:100, rb:0, gb:0, bb:0}) ;
	}	
	
}