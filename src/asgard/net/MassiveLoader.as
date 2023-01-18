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

import asgard.events.LoaderEvent;
import asgard.net.AbstractLoader;
import asgard.net.ILoader;
import asgard.net.LoaderListener;

import vegas.core.HashCode;
import vegas.data.map.HashMap;
import vegas.data.queue.LinearQueue;
import vegas.errors.Warning;
import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.events.EventTarget;
import vegas.events.TimerEvent;
import vegas.util.Timer;

// TODO : vérifier le cablage du système événementiel.

/**
 * Enqueue ILoader in a buffer and run all ILoader one by one.
 * @author eKameleon
 */
class asgard.net.MassiveLoader extends AbstractLoader implements LoaderListener 
{

	/**
	 * Create a new MassiveLoader.
	 */ 
	public function MassiveLoader() 
	{
		
		super() ;
		
		_timer = new Timer(120, 1) ;
		_timer.addEventListener( TimerEvent.TIMER, new Delegate(this, _next) ) ;
			
		_timerComplete = new Timer(120, 1) ;
		_timerComplete.addEventListener(TimerEvent.TIMER, new Delegate(this, _onLoadComplete)) ;
		
		_listenerComplete = new Delegate(this, onLoadComplete) ;
		_listenerError    = new Delegate(this, onLoadError) ;
		_listenerInit     = new Delegate(this, onLoadInit) ;
		_listenerProgress = new Delegate(this, onLoadProgress) ;
		_listenerStart    = new Delegate(this, onLoadStart) ;
		_listenerTimeout  = new Delegate(this, onLoadTimeOut) ;
		
		_mListeners = new HashMap() ;
		
		_qBuffer = new LinearQueue() ;
		
	}

	/**
	 * Clear the buffer.
	 */
	public function clear():Void 
	{
		_qBuffer.clear() ;	
	}
	
	/**
	 * Enqueue a new loader in the massive loader buffer.
	 */
	public function enqueue( loader:ILoader, sName:String, sURL:String ):String 
	{

		try 
		{
			if (sName) 
			{
				loader.setName(sName) ;
			}
			if (loader.getName() == null) 
			{
				throw new Warning("You passed ILoader object without any name property in " + this + ".enqueue()." ) ;
			}
		}
		catch(e:Warning) 
		{
			e.toString() ;
		}
		catch(e:Error)
		{
			e.toString() ;	
		}

		try 
		{
			if (sURL) 
			{
				loader.setUrl(sURL) ;
			}
			if (loader.getUrl() == undefined) 
			{
				throw new Warning("You passed ILoader object without any url property in " + this + ".enqueue().") ;
			}
		} 
		catch(e:Warning) 
		{
			e.toString() ;					
		}
		
		if (loader.getName() == null) 
		{
			loader.setName( "loader_library" + HashCode.next() ) ;
		} 
		_qBuffer.enqueue(loader) ;
		
		return loader.getName() ;
		
	}

	/**
	 * Returns the delay between 2 loader when the MassiveLoader is running.
	 * @return the delay between 2 loader when the MassiveLoader is running.
	 */
	public function getDelay():Number 
	{
		return _timer.getDelay() ;	
	}

	/**
	 * Returns {@code true} if the massive loader is in progress.
	 * @return {@code true} if the massive loader is in progress.
	 */
	public function getRunning():Boolean 
	{
		return _isRunning ;	
	}

	/**
	 * Returns {@code true} is the buffer is empty.
	 * @return {@code true} is the buffer is empty.
	 */
	public function isEmpty():Boolean 
	{
		return _qBuffer.isEmpty() ;	
	}

	/**
	 * Load all the loaders in the massive loader.
	 */
	public function load():Void 
	{
		if ( !_isRunning && !isEmpty() ) 
		{
			var ar:Array = toArray() ;
			var len:Number = ar.length ;
			while (--len > -1) 
			{
				var oLoader:ILoader = ar[len] ;
				if (oLoader.getUrl() == undefined) 
				{
					notifyError( this + ".run() encounters ILoader object without url property, load fails." ) ;
					return ;
				}
			}
			notifyEvent( getEventTypeSTART() ) ;
			_setRunning(true) ;
			_next() ;
		}
	}

	/**
	 * Invoqued when a loader is complete.
	 */
	public function onLoadComplete(e:LoaderEvent):Void 
	{
		// overrides this method.
	}

	/**
	 * Invoqued when the loading failed.
	 */
	public function onLoadError(e:LoaderEvent):Void 
	{
		if (isEmpty()) 
		{
			_timerComplete.start() ;
		} 
		else 
		{
			_timer.start() ;
		}
	}

	/**
	 * Invoqued when the loading is complete and the content initialize.
	 */
	public function onLoadInit( e:LoaderEvent ):Void 
	{
		if (isEmpty()) 
		{
			_timerComplete.start() ;
		}
		else 
		{
			_timer.start() ;
		}
	}

	/**
	 * Invoqued during the load progress.
	 */
	public function onLoadProgress(e : LoaderEvent) : Void 
	{
		// internal method - override this method
	}

	/**
	 * Invoqued when the loading start.
	 */
	public function onLoadStart(e : LoaderEvent) : Void 
	{
		// internal method - override this method
	}

	/**
	 * Invoqued if the loading is out of time.
	 */
	public function onLoadTimeOut(e : LoaderEvent) : Void 
	{
		if (isEmpty()) 
		{
			_timerComplete.start() ;
		} 
		else 
		{
			_timer.start() ;
		}
	}
	
	/**
	 * Run the MassiveLoader.
	 */
	public function run():Void 
	{
		super.run() ;
	}

	/**
	 * Defines the delay between 2 loadings in the internal queue. 
	 */
	public function setDelay(n:Number):Void 
	{
		_timer.setDelay(n) ;
		_timerComplete.setDelay(n) ;
	}
	
	/**
	 * Returns the number of ILoader in the buffer of the MassiveLoader.
	 * @return the number of ILoader in the buffer of the MassiveLoader.
	 */
	 public function size():Number 
	 {
		return _qBuffer.size() ;	
	}
	
	/**
	 * Returns the array representation of the MassiveLoader.
	 * @return the array representation of the MassiveLoader.
	 */
	public function toArray():Array 
	{
		return _qBuffer.toArray() ;	
	}

	private var _listenerComplete:EventListener ;
	
	private var _listenerError:EventListener ;
	
	private var _listenerInit:EventListener ;
	
	private var _listenerProgress:EventListener ;
	
	private var _listenerStart:EventListener ;
	
	private var _listenerTimeout:EventListener ;

	private var _qBuffer:LinearQueue ;

	private var _timer:Timer ;

	private var _timerComplete:Timer ;

	private var _mListeners:HashMap ;

	private var _oCurrentLoader:ILoader ;

	/**
	 * Launch the next loader.
	 */	
	private function _next():Void 
	{
		if (_oCurrentLoader != undefined) 
		{
			_unRegisterCurrentLoader() ;
		}
		_oCurrentLoader = ILoader( _qBuffer.poll() );
		AbstractLoader(_oCurrentLoader).setParent( getEventDispatcher() ) ;
		_registerCurrentLoader() ;
		_oCurrentLoader.load() ;
	}

	/**
	 * Invoqued when the massiveloader is complete.
	 */
	private function _onLoadComplete():Void 
	{
		_unRegisterCurrentLoader() ;
		notifyEvent( LoaderEvent.FINISH ) ;
	}

	/**
	 * Register the listeners of the curent loader.
	 */
	private function _registerCurrentLoader():Void 
	{
		EventTarget(_oCurrentLoader).addEventListener(LoaderEvent.COMPLETE, _listenerComplete) ;
		EventTarget(_oCurrentLoader).addEventListener(LoaderEvent.IO_ERROR, _listenerError) ;
		EventTarget(_oCurrentLoader).addEventListener(LoaderEvent.INIT, _listenerInit) ;
		EventTarget(_oCurrentLoader).addEventListener(LoaderEvent.PROGRESS, _listenerProgress) ;
		EventTarget(_oCurrentLoader).addEventListener(LoaderEvent.START, _listenerStart) ;
		EventTarget(_oCurrentLoader).addEventListener(LoaderEvent.TIMEOUT, _listenerTimeout) ;
	}

	/**
	 * Unregister the listeners of the curent loader.
	 */
	private function _unRegisterCurrentLoader():Void 
	{
		EventTarget(_oCurrentLoader).removeEventListener(LoaderEvent.COMPLETE, _listenerComplete) ;
		EventTarget(_oCurrentLoader).removeEventListener(LoaderEvent.IO_ERROR, _listenerError) ;
		EventTarget(_oCurrentLoader).removeEventListener(LoaderEvent.INIT, _listenerInit) ;
		EventTarget(_oCurrentLoader).removeEventListener(LoaderEvent.PROGRESS, _listenerProgress) ;
		EventTarget(_oCurrentLoader).removeEventListener(LoaderEvent.START, _listenerStart) ;
		EventTarget(_oCurrentLoader).removeEventListener(LoaderEvent.TIMEOUT, _listenerTimeout) ;
	}
	
}