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


import lunas.core.IBuilder;

import vegas.core.CoreObject;

/**
 * This class provides a skeletal implementation of the {@code IBuilder} interface, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.core.AbstractBuilder extends CoreObject implements IBuilder 
{
	
	/**
	 * Creates a new AbstractBuilder instance.
	 * @param mc the target of the component reference to build.
	 */
	private function AbstractBuilder( target ) 
	{
		setTarget(target) ;
	}

	/**
	 * The target reference of the component to build.
	 */
	public var target ;
	
	/**
	 * Clear the view of the component.
	 */
	public function clear():Void 
	{
		// override
	}
	
	/**
	 * Run the build of the component.
	 */
	public function run():Void 
	{
		// override
	}

	/**
	 * Returns the target reference of the component.
	 * @return the target reference of the component.
	 */
	public function getTarget() 
	{
		return target ;
	}
	
	/**
	 * Sets the target reference of the component.
	 */
	public function setTarget( target):Void 
	{
		this.target = target ;
	}
	
	/**
	 * Update the view of the component.
	 */
	public function update():Void 
	{
		// override
	}

}