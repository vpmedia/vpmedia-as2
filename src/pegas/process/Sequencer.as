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

import pegas.events.ActionEvent;
import pegas.process.AbstractAction;
import pegas.process.Action;

import vegas.data.iterator.Iterator;
import vegas.data.queue.LinearQueue;
import vegas.data.queue.TypedQueue;
import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.events.EventTarget;
import vegas.util.serialize.Serializer;

/**
 * A Sequencer of Action process.
 * @author eKameleon
 */
class pegas.process.Sequencer extends AbstractAction 
{
	
	/**
	 * Creates a new Sequencer instance.
	 * @param ar An Array of {@code Action} objects.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	public function Sequencer( ar:Array , bGlobal:Boolean, sChannel:String ) 
	{
		super(bGlobal, sChannel);
		_queue = new TypedQueue(Action, new LinearQueue()) ; 
		_runner = new Delegate(this, run) ;
		var l:Number = ar.length ;
		if (l>0) 
		{
			for (var i:Number = 0 ; i < l ; i++) 
			{
				var a:Action = ar[i] ;
				if (a instanceof Action) 
				{
					addAction(ar[i]) ;
				}		
			}
		}
	}

	/**
	 * Adds a process(Action) in the Sequencer.
	 * @return {@code true} if the method success.
	 */
	public function addAction(action:Action, isClone:Boolean):Boolean 
	{
		var a:Action = isClone ? action.clone() : action ;
		var isEnqueue:Boolean = _queue.enqueue(a) ;
		if (isEnqueue)
		{
			EventTarget(a).addEventListener( ActionEvent.FINISH, _runner ) ;
		}
		return isEnqueue ;
	}
	
	/**
	 * Removes all process in the Sequencer.
	 * @param noEvent A boolean flag to disabled the events dispatched by this method if is {@code true}.
	 * @param callback Function to map and check the current process in progress in the sequencer before reset it.
	 */
	public function clear( noEvent:Boolean, callback:Function ):Void 
	{
		if (running) 
		{
			EventTarget(_cur).removeEventListener(ActionEvent.FINISH, _runner) ;
			if (callback != null)
			{
				callback.call( this, _cur ) ;
			}
			_setRunning(false) ;
		}
		_cur = null ;
		_queue.clear() ;
		if (noEvent) return ;
		notifyCleared() ;
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var s:Sequencer = new Sequencer() ;
		var it:Iterator = _queue.iterator() ;
		while (it.hasNext()) 
		{
			s.addAction(it.next().clone()) ;
		}
		return s ;
	}

	/**
	 * Returns the current process in progress.
	 * @return the current process in progress.
	 */
	public function getCurrent()
	{
		return _cur ;	
	}

	/**
	 * Launchs the Sequencer with the first element in the internal Queue of this Sequencer.
	 */
	public function run():Void 
	{
		if (_queue.size() > 0) 
		{
			if (!running) 
			{
				notifyStarted() ;
			}
			else 
			{
				notifyProgress() ;
			}
			_setRunning(true) ;
			_cur = _queue.poll() ;
			_cur.run() ;
		}
		else 
		{
			EventTarget(_cur).removeEventListener(ActionEvent.FINISH, _runner) ;
			_cur = null ;
			if (running) 
			{
				_setRunning(false) ;
				notifyFinished() ;
			}
		}
	}
	
	/**
	 * Returns the numbers of process in this Sequencer.
	 * @return the numbers of process in this Sequencer.
	 */
	public function size():Number 
	{
		return _queue.size() ;
	}
	
	/**
	 * Starts the Sequencer if is not in progress.
	 */
	public function start():Void 
	{
		if (!running) 
		{
			run() ;
		}
	}
	
	/**
	 * Stops the Sequencer. Stop only the last process if is running.
	 * @param noEvent A boolean flag to disabled the events dispatched by this method if is {@code true}.
	 * @param callback Function to map and check the current process in progress in the sequencer before reset it.
	 */
	public function stop( noEvent:Boolean , callback:Function )
	{
		if (running) 
		{
			EventTarget(_cur).removeEventListener(ActionEvent.FINISH, _runner) ;
			if (callback != null)
			{
				callback.call( this, _cur ) ;
			}
			_cur = null ;
			_setRunning(false) ;
			if (noEvent) return ;
			notifyStopped() ;
			notifyFinished() ;
		}
	}
	
	/**
	 * Returns the array representation of all process in this Sequencer.
	 * @return the array representation of all process in this Sequencer.
	 */
	public function toArray():Array 
	{
		return _queue.toArray() ;	
	}

	/**
	 * Returns the source of the specified object passed in argument.
	 * @return the source of the specified object passed in argument.
	 */
	public function toSource():String 
	{
		var sourceA:String = Serializer.toSource(toArray()) ;
		return Serializer.getSourceOf(this, [sourceA]) ;
	}

	private var _cur:Action ;
	private var _queue:TypedQueue  ;
	private var _runner:EventListener ;
	
}