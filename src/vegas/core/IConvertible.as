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

/**
 * Allows an object to be converted to an equivalent type.
 * @author eKameleon
 * @see <a href="http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf">Standard ECMAScript-262 3rd Edition CHAP 9 : 'Type Conversion'</a>
 */
interface vegas.core.IConvertible 
{
	
	/**
	 * Converts an object to an equivalent Boolean value.
	 */
	function toBoolean():Boolean ;
	
	/**
	 * Converts an object to an equivalent Number value.
	 */
	function toNumber():Number ;
	
	/**
	 * Converts an object to an equivalent Object value.
	 */
	function toObject():Object ;
	
}