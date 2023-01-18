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
import vegas.core.IRunnable;

/**
 * Factory of the pattern Decorator based on the prototype methods injection (Mixin).
 * @author eKameleon
 */
class vegas.util.Mixin extends CoreObject implements IRunnable 
{

	/**
	 * Creates a new Mixin instance.
	 * @param fConstructor the function constructor to used to create a mixin.
	 * @param target the target reference to injected new method with the mixin.
	 * @param attributes the array of all attributes to used in the mixin operation. 
	 */
	public function Mixin( fConstructor:Function, target, attributes:Array) 
	{
		setAttributes(attributes) ;
		setConstructor(fConstructor);
		setTarget(target) ;
	}
	
	/**
	 * Returns the array of all attributes.
	 * @return the array of all attributes.
	 */
	public function getAttributes():Array 
	{
		return _ar ;
	}

	/**
	 * Returns the function constructor to used to create a mixin.
	 * @return the function constructor to used to create a mixin.
	 */
	public function getConstructor():Function 
	{
		return _c ;
	}	

	/**
	 * Returns the target reference to injected new method with the mixin.
	 * @return the target reference to injected new method with the mixin.
	 */
	public function getTarget() 
	{
		return _target ;
	}

	/**
	 * Runs the process.
	 */
	public function run():Void 
	{
		if ( !_ar || !_c || !_target ) 
		{
			return ;
		}
		var instance = new _c() ;
		var l:Number = _ar.length ;
		while(--l > -1) 
		{
			var prop:String = _ar[l] ;
			_target[prop] = instance[prop] ; 
		}
		_global.ASSetPropFlags(_target, _ar, 1, 1) ;
	}

	/**
	 * Sets the array of all attributes.
	 */
	public function setAttributes(ar:Array):Void 
	{
		_ar = ar ;
	}

	/**
	 * Sets the function constructor to used to create a mixin.
	 */
	public function setConstructor(f:Function):Void 
	{
		_c = f ;
	}

	/**
	 * Sets the target reference to injected new method with the mixin.
	 */
	public function setTarget(o):Void 
	{
		_target = o ;
	}
	
	private var _ar:Array ;
	private var _c:Function ;
	private var _target ;
	
	
}