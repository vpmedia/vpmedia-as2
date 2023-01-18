 
 /**
 * @author Marcel
 */

import ch.sfug.events.ErrorEvent;
import ch.sfug.events.Event;
import ch.sfug.events.HTTPStatusEvent;
import ch.sfug.events.TimerEvent;
import ch.sfug.net.loader.AbstractLoader;
import ch.sfug.utils.Timer;

class ch.sfug.net.loader.XMLLoader extends AbstractLoader {

	private var xml:XML;
	private var _tosend:XML;
	private var _timer:Timer;

	/**
	 * creates an xml loader
	 * @param url the url from where you want the xml file
	 * @param timoutTime the timeout time in milliseconds if you specify 0 not timer will be used. the default value is 3000ms.
	 * @param tosend the xml data you want to send to the url. this is optional.
	 */
	public function XMLLoader( url:String, timoutTime:Number, tosend:XML )	{
		super( url );

		this.timeoutTime = timoutTime;
		this._tosend = tosend;

		xml = new XML();
		xml.ignoreWhite = true;
		var t:XMLLoader = this;

		xml.onLoad = function( suc:Boolean ) {
			t.onLoad( suc );
		};
		xml.onHTTPStatus = function( num:Number ) {
			t.onHTTPStatus( num );
		};

	}

	/**
	 * starts the download of the xml file
	 */
	public function load( url:String ):Void {
		this.url = url;
		if( _timer != undefined ){
			_timer.start( false );
		};
		if( _tosend == undefined ) {
			xml.parseXML( "" );
			xml.load( _url );
		} else {
			// if there is data to send, send it with the tosend obj and store the result into the xml obj. for the getXML function.
			_tosend.sendAndLoad( _url, xml );
		}
		dispatchEvent( new Event( Event.OPEN ) );
	}

	/**
	 * returns the xml file
	 */
	public function getXML():XML {
		return xml;
	}

	/**
	 * catch the event from the xml to dispatch the complete event
	 */
	private function onLoad( success:Boolean ):Void {
		stopAndResetTimer();
		if( success ) {
			if( xml.status == 0 ) {
				dispatchEvent( new Event( Event.COMPLETE ) );
			} else {
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, getErrorDesc( xml.status ) ) );
			}
		} else {
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, getErrorDesc( -1 ) ) );
		}
	}

	/**
	 * catch the event from the xml file to dispatch the httpstatus event
	 */
	private function onHTTPStatus( status:Number ):Void {
		stopAndResetTimer();
		dispatchEvent( new HTTPStatusEvent( HTTPStatusEvent.HTTPSTATUS, status ) );
	}

	/**
	 * catch the event from the timer
	 */
	 private function onTimeout( evt:TimerEvent ):Void
	{
		dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, "Timeout Error; blank xml file?" ) );
	}

	/**
	 * sets the timeout time.
	 * @param time if you set the time to 0 there is no timer that checks for a time out otherwise it will check for a timeout
	 */
    public function set timeoutTime( time:Number ):Void
    {
    	if( time == undefined ) time = 3000;
    	if( time > 0 ){
			_timer = new Timer( time, 1 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimeout, this );
		} else {
			stopAndResetTimer();
			_timer = undefined;
    	}
    }

    /**
     * stops and resets the timer
     */
	private function stopAndResetTimer(): Void
	{
		if(_timer != undefined)
		{
			_timer.stop();
			_timer.reset();
		}
	}

	/**
	 * returns the error description of the xml error
	 */
	private function getErrorDesc(num:Number):String {
		switch (num) {
			case -1:
				return "Could not load XML file: " + _url;
			case -2:
				return "A CDATA section was not properly terminated.";
			case -3:
				return "The XML declaration was not properly terminated.";
			case -4:
				return "The DOCTYPE declaration was not properly terminated.";
			case -5:
				return "A comment was not properly terminated.";
			case -6:
				return "An XML element was malformed.";
			case -7:
				return "Out of memory.";
			case -8:
				return "An attribute value was not properly terminated.";
			case -9:
				return "A start-tag was not matched with an end-tag.";
			case -10:
				return "An end-tag was encountered without a matching start-tag.";
		}
	}
}
