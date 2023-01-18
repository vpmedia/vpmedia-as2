 /**
 * @author mih
 */

import ch.sfug.events.ErrorEvent;
import ch.sfug.events.Event;
import ch.sfug.events.HTTPStatusEvent;
import ch.sfug.events.TimerEvent;
import ch.sfug.net.loader.AbstractLoader;
import ch.sfug.utils.Timer;

class ch.sfug.net.loader.VarsLoader extends AbstractLoader {

	private var result_lv:LoadVars;
	private var send_lv:LoadVars;
	private var sendMethod:String;
	private var _timer:Timer;

	/**
	 * constructor
	 *
	 * @param url 			the result_lv url
	 * @param tosend		send_lv object for sending data
	 * @param sendMethod	"POST" or "GET" as sending method
	 * @param timoutTime	timeout time
	 */

	public function VarsLoader(url:String, send_lv:LoadVars, sendMethod:String, timoutTime:Number) {
		super(url);

		this.timeoutTime = timoutTime;
		this.send_lv = send_lv;
		this.sendMethod = sendMethod;

	}

	/**
	 * resets the loadvars object
	 */
	public function init(  ):Void {
		result_lv = new LoadVars();
		var t:VarsLoader = this;

		result_lv.onLoad = function(suc:Boolean) {
			t.onLoad(suc);
		};
		result_lv.onHTTPStatus = function(num:Number) {
			t.onHTTPStatus(num);
		};
	}

	/**
	 * starts the download of the result_lv file
	 *
	 * @param url (optional) reassign url before loading
	 * @param send a loadvars object to send parameter with the request
	 */
	public function load( url:String, send:LoadVars ):Void {
		this.url = url;
		this.init();
		if(_timer != undefined){
			_timer.start(false);
		};
		if( send != undefined ) send_lv = send;
		if(send_lv == undefined) {
			result_lv.load(_url);
		} else {
			// if there is data to send, send it with the tosend obj and store the result into the result_lv obj. for the getLoadVars function.
			if(sendMethod != "GET" || sendMethod != "POST") sendMethod = "POST";
			send_lv.sendAndLoad(_url, result_lv, sendMethod);
		}
	}

	/**
	 * returns the result_lv file
	 */
	public function getLoadVars():LoadVars {
		return result_lv;
	}

	/**
	 * catch the event from the result_lv file to dispatch the complete event
	 */
	private function onLoad(success:Boolean):Void {
		stopAndResetTimer();
		if(success) {
			dispatchEvent(new Event(Event.COMPLETE));
		} else {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, getErrorDesc(-1)));
		}
	}

	/**
	 * catch the event from the result_lv file to dispatch the httpstatus event
	 */
	private function onHTTPStatus(status:Number):Void {
		stopAndResetTimer();
		dispatchEvent(new HTTPStatusEvent(HTTPStatusEvent.HTTPSTATUS, status));
	}

	/**
	 * catch the event from the timer
	 */
	 private function onTimeout(evt:TimerEvent):Void
	{
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, "Timeout Error; could not find the file?"));
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
	 * returns the error description of the result_lv error
	 */
	private function getErrorDesc(num:Number):String {
		switch (num) {
			case -1:
				return "Could not load the file: " + url;
		}
	}

}