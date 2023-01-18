/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- ActionProxy

	AUTHOR

		Name : ActionProxy
		Package : neo.process
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTIES
	
		- args:Array
		
		- func:Function
		
		- obj:Object

	METHODS
	
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- addListener (oL, f:Function):Void ;
		
		- clone():Pause
		
		- execute( e: IEvent )
		
		- notifyFinished():Void 
		
		- notifyStarted():Void 
		
		- removeEventListener(e:EventType, oL):Void ;
	
		- removeListener(oL):Void ;
		
		- toString():String

	EVENT TYPE
	
		- FINISHED:ActionEventType
		
		- STARTED:ActionEventType

	INHERIT
	
		Object 
			|
			AbstractAction
				|
				ActionProxy

	IMPLEMENTS
	
		Command, IAction, ICloneable, IFormattable

----------  */

import com.bourre.commands.Delegate;

import neo.events.ActionEventType;
import neo.process.AbstractAction;

class neo.process.ActionProxy extends AbstractAction {

	// ----o Constructor
	
	public function ActionProxy(o:Object, f:Function) {
		obj = o ;
		func = f ;
		args = arguments.splice(2) ;
	}

	// ----o Constant
	
	static public var FINISHED:ActionEventType = ActionEventType.FINISHED ;
	
	static public var STARTED:ActionEventType = ActionEventType.STARTED ;
	
	// ----o Public Properties
	
	public var args:Array ;
	public var func:Function ;
	public var obj:Object ;
	
	// ----o Public Methods

	public function clone() {
		var p:ActionProxy = new ActionProxy(obj, func);
		p.args = args ;
		return p ;
	}
	
	public function execute():Void {
		notifyStarted() ;
		Delegate.create.apply(this, [obj, func].concat(args)) ();
		notifyFinished() ;
	}

}

