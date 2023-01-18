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
 * Allows an object to control its own serialization and deserialization.
 * Note : To add a diffrent syntax formating it should be possible to add a 3rd *formater* argument and override the implementation of the method in all core objects.
 * @author eKameleon
 * @see Core2 & Eden framework inspired by Mozilla SpiderMonkey (Zwetan)
 */
interface vegas.core.ISerializable 
{
	
	/**
	 * Returns a Eden representation of the object.
	 * @param indent:Number optional the starting of the indenting
	 * @param identor:String the string value used to do the indentation
	 * @return a string representing the source code of the object.
	 */
	function toSource(indent:Number, indentor:String):String ;
	
}