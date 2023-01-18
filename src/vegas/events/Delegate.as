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
import vegas.core.ICloneable;
import vegas.core.IRunnable;
import vegas.events.Event;
import vegas.events.EventListener;

/**
 * Delegate was originally created by Mike Chambers for Macromedia mx.events package.
 * <p>This version is also inspired from <a href='http://www.peterjoel.com/blog/index.php?archive=2004_08_01_archive.xml#109320812208031938'>Peter Hall's EventDelegate</a> implementation and from the Francis bourre framework "<a href="http://osflash.org/pixlib">Pixlib</a>".</p>
 * <p>You can instantiate and keep a reference of a Delegate instance.</p>
 * <p>In the VEGAS implementation :
 * <li>The {@code Delegate} class implements {@code EventListener} interface. you can use a Delegate instances in the {@code addEventListener} method for all {@code EventTarget} implementations.</li>
 * <li>The {@code Delegate} class implements {@code IRunnable} interface</li>
 * </p>
 * @author eKameleon
 */
class vegas.events.Delegate extends CoreObject implements ICloneable, EventListener, IRunnable 
{

	/**
	 * Creates a new Delegate instance.
	 * @param scope the scope to be used by calling this method.
	 * @param method the method to be executed.
	 */
	public function Delegate(scope, method:Function) 
	{
		_s = scope ;
		_m = method ;
		_a = arguments.splice(2) ;
		_p = Function( Delegate.create.apply(this, [_s].concat([_m], _a) ) );
	}

	/**
	 * Add arguments to proxy method.
	 */
	public function addArguments():Void 
	{
		if (arguments.length > 0) 
		{
			_a = _a.concat(arguments) ;
			_p.a = _a ;
		}
	}
	
	/**
	 * Returns a shallow copy of the instance.
	 * @return a shallow copy of the instance.
	 */
	public function clone() 
	{
		return new Delegate(getScope(), getMethod()) ;
	}

	/**
	 * Creates a method that delegates its arguments to a specified scope. This static method is a wrapper for MM compatibility.
	 * @param scope this scope to be used by calling this method.
	 * @param method the method to be called.
	 * @return a Function that delegates its call to a custom scope, method and arguments.
	 */
	static public function create(scope, method:Function):Function 
	{
		var f:Function = function() 
		{	
			var o = arguments.callee ;
			var s = o.s ;
			var m = o.m ;
			var a = arguments.concat(o.a) ;
			return m.apply(s, a) ;
		} ;
		f.s = scope ;
		f.m = method ;
		f.a = arguments.splice(2) ;
		return f ;
	}	
	
	/**
	 * Returns the array of all arguments called in the proxy method.
	 * @return the array of all arguments called in the proxy method.
	 */
	public function getArguments():Array 
	{
		return _a ;
	}

	/**
	 * Returns the proxy method reference.
	 * @return the proxy method reference.
	 */
	public function getMethod():Function 
	{
		return _m ;
	}
	
	/**
	 * Returns the scope reference.
	 * @return the scope reference.
	 */
	public function getScope() 
	{
		return _s ;
	}
	
	/**
	 * Handles the event.
	 */
	public function handleEvent(e:Event) 
	{
		return _m.apply(_s, [e].concat(_a));
	}

	/**
	 * Run the proxy method in the provided context. 
	 */
	public function run():Void 
	{
		if (arguments.length > 0)
		{
			addArguments.apply(this, arguments) ;
		}
		_p() ;
	}

	/**
	 * Sets or change arguments of proxy method.
	 */
	public function setArguments():Void 
	{
		if (arguments.length > 0) 
		{
			_a = [].concat(arguments) ;
			_p.a = _a ;
		}
	}

	private var _m:Function ; // method

	private var _s:Object ; // scope

	private var _a:Array ; // arguments

	private var _p:Function; // proxy

}