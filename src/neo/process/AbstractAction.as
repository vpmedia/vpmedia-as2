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

/* ----- AbstractAction

	AUTHOR
	
		Name : Action
		Package : neo.process
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- looping:Boolean
		
		- running:Boolean

	METHOD SUMMARY
	
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- addListener (oL, f:Function):Void ;
		
		- clone()
		
			override this method
		
		- execute( e: IEvent )
		
			override this method
		
		- notifyChanged():Void
		
		- notifyCleared():Void
		
		- notifyFinished():Void 
		
		- notifyLooped():Void
		
		- notifyResumed():Void
		
		- notifyStarted():Void
		
		- notifyStopped():Void
		
		- toString():String

	EVENT SUMMARY
	
		ActionEvent

	EVENT TYPE SUMMARY
	
		- ActionEventType.CHANGED
		
		- ActionEventType.CLEARED
		
		- ActionEventType.FINISHED
		
		- ActionEventType.LOOPED
		
		- ActionEventType.PROGRESS
		
		- ActionEventType.RESUMED
		
		- ActionEventType.STARTED
		
		- ActionEventType.STOPPED

	INHERIT
	
		EventBroadcaster
			|
			AbstractAction

	IMPLEMENTS
	
		Command, IAction, ICloneable, IFormattable
	
----------  */


import com.bourre.core.HashCodeFactory;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;

import neo.core.IAction;
import neo.core.IFormattable;
import neo.events.ActionEvent;
import neo.events.ActionEventType;
import neo.util.ConstructorUtil;


class neo.process.AbstractAction extends EventBroadcaster implements IAction, IFormattable {
	
	// ----o Constructor
	
	private function AbstractAction() {
		//
	}

	// ----o Public Properties
	
	public var looping:Boolean ;
	
	public var running:Boolean ;
	
	// ----o Public Methods

	public function execute(e:IEvent) : Void {
		// override this method

	}

	public function notifyChanged():Void {
		_notify(ActionEventType.CHANGED) ;
	}

	public function notifyCleared():Void {
		_notify(ActionEventType.CLEARED) ;
	}	

	public function notifyFinished():Void {
		_notify(ActionEventType.FINISHED) ;
	}
	
	public function notifyLooped():Void {
		_notify(ActionEventType.LOOPED) ;
	}

	public function notifyProgress():Void {
		_notify(ActionEventType.PROGRESS) ;
	}
	
	public function notifyResumed():Void {
		_notify(ActionEventType.RESUMED) ;
	}
	
	public function notifyStarted():Void {
		_notify(ActionEventType.STARTED) ;
	}
	
	public function notifyStopped():Void {
		_notify(ActionEventType.STOPPED) ;
	}


	public function toString():String {

		return "[" + ConstructorUtil.getName(this) + HashCodeFactory.getKey( this ) + "]" ;

	}


	// ----o Private Methods
	
	private function _notify(type:ActionEventType):Void {
		broadcastEvent( new ActionEvent(type) ) ;
	}
	
}
