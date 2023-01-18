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
import asgard.net.ILoader;

import pegas.maths.Range;

import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.Delegate;
import vegas.events.TimerEvent;
import vegas.util.Timer;

/**
 * This class is an abstract class to creates concrete ILoader class.
 * @author eKameleon
 */
class asgard.net.AbstractLoader extends AbstractCoreEventDispatcher implements ILoader 
{

	/**
	 * Creates a new AbstractLoader instance. This class is an abstract class to creates concrete ILoader class.
	 */
	private function AbstractLoader() 
	{
		super() ;
		initEvent() ;
		_setInitTimer() ;
		_setProgressTimer() ;
	}

	/**
	 * (read-only) Returns the current bytes value of the external data to load during the loading.
	 * @return the current bytes value of the external data to load during the loading.
	 */
	public function get bytesLoaded():Number 
	{
		return getBytesLoaded() ;
	}

	/**
	 * (read-only) Returns the total bytes value of the external data to load.
	 * @return the total bytes value of the external data to load.
	 */
	public function get bytesTotal():Number 
	{
		return getBytesTotal() ;
	}

	/**
	 * (read-write) Returns the current data value of this loader.
	 * @return the current data value of this loader.
	 */
	public function get data() 
	{
		return getData() ;
	}

	/**
	 * (read-write) Sets the current data value of this loader.
	 */
	public function set data( o ):Void 
	{
		setData(o) ;	
	}

	/**
	 * (read-write) Returns the name value of this loader.
	 * @return the name value of this loader.
	 */
	public function get name():String 
	{
		return getName() ;	
	}

	/**
	 * (read-write) Sets the name value of this loader.
	 */
	public function set name(sName:String):Void 
	{
		setName(sName) ;	
	}

	/**
	 * (read-only) Returns the percent value during the loading.
	 * @return the percent value during the loading.
	 */
	public function get percent():Number 
	{
		return getPercent() ;	
	}
	
	/**
	 * (read-only) Returns {@code true} if the loader is in progress.
	 */
	public function get running():Boolean 
	{
		return getRunning() ;	
	}

	/**
	 * (read-write) Returns the timeout delay value.
	 */
	public function get timeOut():Number 
	{
		return getTimeOut() ;
	}

	/**
	 * (read-write) Sets the timeout delay value.
	 */
	public function set timeOut( n:Number ):Void 
	{
		setTimeOut(n) ;	
	}
	
	/**
	 * (read-write) Returnss the url value.
	 */
	public function get url():String 
	{
		return this.getUrl() ;
	}

	/**
	 * (read-write) Sets the url value.
	 */
	public function set url( sURL:String ):Void 
	{
		setUrl(sURL) ;	
	}

	/**
	 * Returns the current bytes value of the external data to load during the loading.
	 */
	public function getBytesLoaded():Number 
	{
		var bytesLoaded:Number = getContent().getBytesLoaded() ;
		return isNaN(bytesLoaded) ? 0 : bytesLoaded ;
	}

	/**
	 * Returns the total bytes value of the external data to load.
	 */
	public function getBytesTotal():Number 
	{
		var bytesTotal:Number = getContent().getBytesTotal() ;
		return isNaN(bytesTotal) ? 0 : bytesTotal ;
	}

	/**
	 * Returns the content reference of this loader.
	 */
	public function getContent() 
	{
		return _oContent ;
	}
	
	/**
	 * Returns the data of this loader.
	 */
	public function getData() 
	{
		return _oData ;	
	}

	/**
	 * Returns the name of the loader.
	 */
	public function getName():String 
	{
		return _sName ;
	}

	/**
	 * Returns the percent value of the loading progression.
	 * @return the percent number value of the loading progression. 
	 */
	public function getPercent():Number 
	{
		var n:Number = Math.round( getBytesLoaded() * 100 / getBytesTotal() ) ;
		n = Range.PERCENT_RANGE.clamp( n > 0 ? n : 0 ) ;
		return (isNaN(n)) ? 0 : n ;
	}
	
	/**
	 * Return {@code true} if the loading is in progress.
	 * @return {@code true} if the loading is in progress.
	 */
	public function getRunning():Boolean 
	{
		return _isRunning ;	
	}

	/**
	 * Returns the delay of the timeout error.
	 * @return the delay of the timeout error.
	 */
	public function getTimeOut():Number 
	{
		return _nTimeOut ;
	}

	/**
	 * Returns the url of the loader.
	 * @return the url of the loader.
	 */
	public function getUrl():String 
	{
		return _sURL;
	}
	
	/**
	 * Init the internal LoaderEvent in this instance.
	 */
	public function initEvent():Void 
	{
		_e = new LoaderEvent(null, this) ;
	}

	/**
	 * Load the external content in the loader.
	 */
	public function load():Void 
	{
		if (_tLoadProgress.running) 
		{
			_stopLoadProgress() ;
		}
		if ( this.getUrl() != null ) 
		{
			notifyStart() ;
			_nLastBytesLoaded = 0;
			_nTime = getTimer();
			_setRunning(true) ;
			_startLoadProgress() ;
		} 
		else 
		{
			
			notifyError(this + ".load() can't retrieve file url : " + this.getUrl() , null ) ;
		}
	}

	/**
	 * Notify an error.
	 */
	public function notifyError(sError:String, nCode:Number):Void 
	{
		_e.setType( getEventTypeERROR() ) ;
		_e.error = sError ;
		_e.code = nCode ;
		release() ;
		dispatchEvent(_e);
	}

	/**
	 * Notify an event.
	 */
	public function notifyEvent(eventType:String):Void 
	{
		_e.setType(eventType) ;
		_e.error = null ;
		_e.code = null ;
		dispatchEvent(_e) ;
	}

	/**
	 * Notify the start of the loader.
	 */
	public function notifyStart():Void 
	{
		notifyEvent( getEventTypeSTART() ) ;
	}

	/**
	 * Invoqued when the loading is finish and the loader is init.
	 */	
	public function onLoadInit() : Void 
	{
		_stopInitTimer() ;
		_setRunning(false) ;
		notifyEvent( getEventTypeINIT() );
	}
	
	/**
	 * Release the loader.
	 */
	public function release():Void 
	{
		_setRunning(false) ;
		_tInit.stop() ;
		_stopLoadProgress() ;
	}


	/**
	 * Run the command.
	 * @see IRunnable
	 */
	public function run():Void 
	{
		load() ;
	}
	
	/**
	 * Sets the internal content reference.
	 */
	public function setContent(o):Void 
	{
		_oContent = o;
	}

	/**
	 * Sets the data of this loader.
	 */
	public function setData( o ):Void 
	{
		_oData = o ;
	}

	/**
	 * Sets the name of this loader.
	 */
	public function setName(sName:String):Void 
	{
		_sName = sName;
	}

	/**
	 * Sets the delay of the timeout connection.
	 */
	public function setTimeOut( n : Number ):Void 
	{
		_nTimeOut = Math.max(1000, n) ;
	}

	/**
	 * Sets the url of this loader.
	 */
	public function setUrl(sURL:String):Void 
	{
		_sURL = sURL;
	}
	
	/**
	 * (protected) Returns the event type of the internal event when the loader is complete.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeCOMPLETE():String
	{
		return LoaderEvent.COMPLETE ;	
	}

	/**
	 * (protected) Returns the event type of the internal event when the loader failed and notify an error.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeERROR():String
	{
	 	return LoaderEvent.IO_ERROR ;
	}
	
	/**
	 * (protected) Returns the event type of the internal event when the loader is finished.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeFINISH():String
	{
	 	return LoaderEvent.FINISH ;
	}

	/**
	 * (protected) Returns the event type of the internal event when the loader is complete.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeINIT():String
	{	
		return LoaderEvent.INIT ;
	}
	
	/**
	 * (protected) Returns the event type of the internal event when the loader is in progress.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypePROGRESS():String
	{
		return LoaderEvent.PROGRESS ;
	}
	
	/**
	 * (protected) Returns the event type of the internal event when the loader is out of time.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeTIMEOUT():String
	{
		return LoaderEvent.TIMEOUT ;
	}

	/**
	 * (protected) Returns the event type of the internal event when the loader is started.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeSTART():String
	{
		return LoaderEvent.START ;
	}

	/**
	 * (protected) Returns the event type of the internal event when the loader is stopped.
	 * Overrides this method if you want custom your object.
	 */
	/*protected*/ function getEventTypeSTOP():String
	{
		return LoaderEvent.STOP ;
	}

	/**
	 * The internal event reference.
	 */
	private var _e:LoaderEvent ;

	/**
	 * The internal boolean to defined if the loader is running.
	 */
	private var _isRunning:Boolean ;

	/**
	 * The internal value to defined the last bytes during the loading.
	 */
	private var _nLastBytesLoaded : Number;

	/**
	 * The internal timeout interval (default 9 seconds).
	 */
	private var _nTimeOut:Number = 9000 ;

	/**
	 * The internal time value.
	 */
	private var _nTime:Number ;
	
	/**
	 * The internal content reference.
	 */
	private var _oContent ;
	
	/**
	 * The internal data of the loader.
	 */
	private var _oData ;
	
	/**
	 * The internal name of the loader.
	 */
	private var _sName:String ;
	
	/**
	 * The internal url string representation.
	 */
	private var _sURL:String ;
	
	/**
	 * The internal init timer.
	 */
	private var _tInit : Timer;
	
	/**
	 * The internal progress timer.
	 */
	private var _tLoadProgress:Timer ;

	/**
	 * Check the current timeout during the loading.
	 */
	/*protected*/ private function _checkTimeOut( nLastBytesLoaded:Number, nTime:Number ) : Void 
	{
		if ( nLastBytesLoaded != _nLastBytesLoaded) 
		{
			_nLastBytesLoaded = nLastBytesLoaded ;
			_nTime = nTime ;
		}
		else if ( (nTime - _nTime)  > _nTimeOut) 
		{
			notifyEvent( getEventTypeTIMEOUT() );
			release() ;
			notifyError(this + " load timeout with url : '" + this.getUrl() + "'." , null ) ;
		}
	}
	
	/**
	 * Notify if the loading is in progress.
	 */
	/*protected*/ private function _onLoadProgress():Void 
	{
		_checkTimeOut( getBytesLoaded(), getTimer() ) ;
		if ( getBytesLoaded() > 4 && getBytesLoaded() == getBytesTotal()) 
		{
			_stopLoadProgress() ;
			notifyEvent( getEventTypePROGRESS() );
			notifyEvent( getEventTypeCOMPLETE() ) ;
			_startInitTimer() ;
		} 
		else 
		{
			notifyEvent( getEventTypePROGRESS() );
		}
	}
	
	/*protected*/ private function _setInitTimer( f:Function ) 
	{
		_tInit = new Timer(150, 1) ;	
		_tInit.addEventListener(TimerEvent.TIMER, new Delegate(this, f || onLoadInit)) ;
	}

	/*protected*/ private function _setProgressTimer( f:Function ) 
	{
		_tLoadProgress = new Timer(50) ;
		_tLoadProgress.addEventListener(TimerEvent.TIMER, new Delegate(this, f || _onLoadProgress)) ;
	}

	/*protected*/ private function _setRunning( b:Boolean ):Void 
	{
		_isRunning = b ;
	}
	
	/*protected*/ private function _startInitTimer():Void 
	{
		_tInit.start() ;	
	}
	
	/**
	 * Stop the load progress timer.
	 */
	private function _startLoadProgress():Void
	{
		_tLoadProgress.start() ;
	}
	
	/*protected*/ private function _stopInitTimer():Void 
	{
		if (_tInit.running) 
		{
			_tInit.stop() ;
		}	
	}

	/**
	 * Stop the load progress timer.
	 */
	private function _stopLoadProgress():Void
	{
		_tLoadProgress.stop() ;
	}

}