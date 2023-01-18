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
import vegas.util.format.IFormatter;

/**
 * Abstract class to creates classes who implemented IFormatter interface.
 * @author eKameleon
 */
class vegas.util.format.AbstractFormatter extends CoreObject implements IFormatter 
{

	/**
	 * Abstract constructor to creates a new class who extends AbstractFormatter.
	 */
	private function AbstractFormatter(pattern:String) 
	{
		setPattern(pattern) ;
	}
	
	/**
	 * Returns the internal pattern of this formatter.
	 * @return the string representation of the pattern of this formatter.
	 */
	public function get pattern():String
	{
		return getPattern() ;	
	}

	/**
	 * Sets the internal pattern of this formatter.
	 */
	public function set pattern( expression:String ):Void
	{
		setPattern( expression ) ;	
	}

	/**
	 * This method format an expression with the pattern of this formatter.
	 * Overrides this method.
	 */	
	public function format():String 
	{
		return null ;
	}

	/**
	 * Returns the string representation of the pattern of this formatter.
	 * @return the string representation of the pattern of this formatter.
	 */
	public function getPattern():String 
	{
		return _pattern ;
	}

	/**
	 * Sets the internal pattern of this formatter.
	 */
	public function setPattern( expression:String ):Void 
	{
		_pattern = new String( expression ) ;
	}

	/**
	 * The internal pattern of this formatter.
	 */
	private var _pattern:String ;

}