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

/* ---------- Sequencer


	!!!!!!!!! EN CONSTRUCTION !!!!!!!!!

	AUTHOR
	
		Name : Sequencer
		Package : neo.process
		Version : 1.0.0.0
		Date :  2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	DESCRIPTION 
	
		Permet de gérer via une queue un séquençage de plusieurs objets qui implémentent l'interface Action.
			
	PROPERTY SUMMARY
	
		- running:Boolean [R/W]
		
	METHOD SUMMARY
	
		- addAction(action:Action):Boolean
		
			ajoute une action dans la séquence et renvoi true si l'action est bien ajoutée.
			
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- addListener (oL, f:Function):Void ;
		
		- clear()
		
			vider la séquence
		
		- clone():Sequencer
		
			renvoi une copie indépendante de l'instance.

		- execute( e: IEvent )
		
			lancer la séquence sur le premier élément mi en queue dans la séquence
		
		- getRunning():Boolean
		
			renvoi true si la séquence est en action.
			
		- removeEventListener(e:EventType, oL):Void ;
		
		- removeListener(oL):Void ;
		
		- notifyStarted():Void
			
			notifie le lancement de la séquence
		
		- notifyFinished():Void
		
			notifie la fin de la séquence
				
		- size():Number
		
			nombre d'éléments dans la séquence.
		
		- start():Void
			
			lancer la séquence
		
		- stop() : arrêter la séquence (n'arrête pas la dernière action en cours d'éxécution)

	EVENT SUMMARY
	
		- ActionEventType.FINISHED
		
		- ActionEventType.PROGRESS
		
		- ActionEventType.STARTED

	INHERIT
	
		Object 
			|
			AbstractAction
				|
				Sequencer

	IMPLEMENTS
	
		Command, IAction, ICloneable, IFormattable

	TODO : renommer la classe en QueueSequencer ou un truc dans le genre.
	TODO : TypeQueue && LinearQueue && Queue !!
	
	!!!!!!!!! EN CONSTRUCTION !!!!!!!!!
	
----------  */

import neo.process.AbstractAction;

class neo.process.Sequencer extends AbstractAction {
/*	
	// ----o Constructor
	
	public function Sequencer() {
		_queue = new TypedQueue(IAction, new Queue()) ; 
		// !!!!!!!!! EN CONSTRUCTION !!!!!!!!!
	}

	// ----o Public Properties
	
	public var running:Boolean ; // [RW]
	
	// ----o Public Methods
	
	public function addAction(action:IAction):Boolean {
		var a:IAction = action.clone() ;
		var isEnqueue:Boolean = _queue.enqueue(a) ;
		if (isEnqueue) a.addEventListener(ActionEventType.FINISHED, this, execute()) ;
		return isEnqueue ;
	}
	
	public function clear():Void {
		_queue.clear() ;
	}

	public function clone() {
		var s:Sequencer = new Sequencer() ;
		var it:Iterator = _queue.getIterator() ;
		while (it.hasNext()) {
			s.addAction(it.next().clone()) ;
		}
		return s ;
	}

	public function execute():Void {
		if (_queue.size() > 0) {
			if (!_running) 	notifyStarted() ;
			else notifyProgress() ;
			_running = true ;
			_cur = _queue.poll() ;
			_cur.run() ;
		} else {
			if (_running) {
				_running = false ;
				notifyFinished() ;
			}
		}
	}

	public function getRunning():Boolean {
		return _running == true ;
	}

	public function size():Number {
		return _queue.size() ;
	}

	public function start():Void {
		if (_running) return ;
		run() ;
	}
	
	public function stop(noEvent:Boolean):Void {
		_cur.removeEventListener(ActionEventType.FINISHED, _runner) ;
		_running = false ;
		if (noEvent) return ;
		notifyFinished() ;
	}

	// ----o Virtual Properties
	
	static private var __RUNNING__ = PropertyFactory.create(Sequencer, "running", true, true) ;

	// ----o Private Properties	
	
	private var _cur ;
	//!!!!!!!!! EN CONSTRUCTION !!!!!!!!!
	private var _queue:TypedQueue  ;
	private var _running:Boolean = false ;
*/	
}