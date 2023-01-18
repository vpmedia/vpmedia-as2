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

import pegas.process.AbstractAction;

import vegas.events.Delegate;

class pegas.process.ActionProxy extends AbstractAction 
{

	/**
	 * Creates a new ActionProxy instance.
	 */
	public function ActionProxy(o:Object, f:Function) 
	{
		obj = o ;
		func = f ;
		args = arguments.splice(2) ;
	}

	public var args:Array ;
	public var func:Function ;
	public var obj:Object ;
	
	public function clone() 
	{
		var p:ActionProxy = new ActionProxy(obj, func);
		p.args = args ;
		return p ;
	}
	
	public function run():Void 
	{
		notifyStarted() ;
		_setRunning(true) ;
		Delegate.create.apply(this, [obj, func].concat(args)) ();
		_setRunning(false) ;
		notifyFinished() ;
	}

}

