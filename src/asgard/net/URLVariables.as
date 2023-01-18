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

import vegas.core.CoreObject;
import vegas.core.ISerializable;

/**
 * The {@code URLVariables} class allows you to transfer variables between a Flash® application and a server.
 * Use {@code URLVariables} objects with methods of the {@code URLLoader} class, with the data property of the {@code URLRequest} class, and with flash.net package functions.
 * @author eKameleon
 */
dynamic class asgard.net.URLVariables extends CoreObject implements ISerializable 
{
	
	/**
	 * Creates a new URLVariables object.
	 */
	public function URLVariables( source:String ) 
	{
		super() ;
		if (source) decode(source)  ;
	}

	/**
	 * Converts the variable string to properties of the specified URLVariables object.
	 */
	public function decode(source:String):Void 
	{
		LoadVars.prototype.decode.apply(this, [source]) ;
	}

	/**
	 * Returns the EDEN {@code String} representation of this object.
	 * @return the EDEN {@code String} representation of this object.
	 */	
	public function toSource(indent:Number, indentor:String):String 
	{
		return "new URLVariables(" + toString() + ")" ;	
	}

	/**
	 * Returns the {@code String} representation of this object.
	 * @return the {@code String} representation of this object.
	 */	
	/*override*/ public function toString():String 
	{
		return LoadVars.prototype.toString.call(this) ;
	}

}