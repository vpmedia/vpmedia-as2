/**
* Yet another queued MovieClip loader.
* 
* When you need to load a lot of little JPG's at once, it helps 
* to enqueue these requests.  This class allows you to manage 
* just such a queue.  
* 
* The ASAP Framework has a Loader class that does a similar job, 
* but David prefers using old-school callbacks to EventDispatcher
* events when monitoring a loader queue.  If you use events, then
* each listener has to do some extra checks to make sure the movie
* it is trying to load is the one that was loaded. By using
* callbacks, we keep are code a bit leaner.  If you are an event nazi, 
* this class forwards the events named after the MovieClipLoader events:
* onLoadProgress, onLoadInit, and onLoadError
* 
* Example Usage: 
*   qloader.loadItem( holder_mc, someUrl, onProgressFunction, onCompleteFunc, callbackScope);
*   
* This code is inspired by a bit of AS1 code originally written by 
* Thomas Wester. (thomaswester.com) David refactored this to use the MovieClipLoader 
* class and added support for a priority setting that allows queue requests to be 
* added to the front of the queue if necessary.  A number of extra checks and error 
* handling routines have been added as well.
* 
* @author David Knape
* @author Thomas Wester 
*/

import com.bumpslide.util.Debug;
import mx.events.EventDispatcher;

class com.bumpslide.util.QueuedLoader {
	
	// ----------------------------------------------
	//  Private Properties

	private var _loader         :MovieClipLoader;
    private var _currentData    :Object;
    private var _swfQueue       :Array;
	private var _paused         :Boolean;
	private var _monitorInt     :Number;	// Interval
	private var _timer          :Number;
	private var _uid            :String = "";
    
	function QueuedLoader( uniqueId:String ) {
		if(_uid!=null) _uid = uniqueId;
		
        // Let's broadcast our own events
        EventDispatcher.initialize( this );
		_reset();
    }

	public function loadItem( into_mc:MovieClip, url:String, progress:Function, complete:Function, scope:Object, isPriority:Boolean ) {

		if(isPriority==null) isPriority = false;
		
		var item = {	url: url,
						into_mc: into_mc,
						progress: progress,
						complete: complete,
						scope:	scope }
		
		if( url==undefined) {
			eTrace('URL is undefined for target mc '+into_mc);
			return;
		}
						
		if( into_mc==undefined ) {
			eTrace('Target mc is undefined for url '+url);
			return;
		}


		if( into_mc.___loading == true ){
			//dTrace('already loading ' +into_mc );
			unloadItem( into_mc );
		}
		into_mc.___loading = true;
		
		if(isPriority) {
			//dTrace('Adding Item to Front of Queue:'+item.url);
			_swfQueue.unshift( item );
		} else {
			dTrace('Adding Item to Back of Queue:'+item.url);
			_swfQueue.push(	item );
		}

		//dTrace('Queue Length is now: '+_swfQueue.length);

		if(_currentData==null) _loadNext();
		
		return _swfQueue.length-1;
	}

	// Clear the Queue
    public function clearQueue() : Void {
		dTrace('Clearing Queue');
        _loader.removeListener( this );
		_loader.unloadClip( _currentData.into_mc );
		_reset();
    }

	public function pauseQueue() : Void {
		if(_swfQueue.length) {
			dTrace( 'Pausing queue' );
			_paused = true;
		}
	}
	public function resumeQueue() : Void {
		dTrace( 'Resuming queue' );
		_paused = false;
		_afterLoad();
	}

	public function unloadItem( mc : MovieClip){

		dTrace('UnloadItem '+mc);
		
		var mcFound = false;
		var doLoadNext = false;
		var item : Object;

		if(mc == _currentData.into_mc && mc!=undefined) {
			dTrace('Cancelling currently loading item '+mc);
			// This will trigger onLoadError which will trigger loadNext()
			// We don't want this to be considered an error
			_loader.removeListener( this);			
			_loader.unloadClip( _currentData.into_mc );
			_loader.addListener( this );
			_afterLoad()
		} else {
			for(var i=0; i<_swfQueue.length; ++i){

				item = _swfQueue[i];

				if( item.into_mc==mc || item.into_mc._name == undefined || !item.into_mc ) {
					dTrace('Removing Queued Item '+mc);
					_swfQueue.splice(i, 1 );
					mcFound = true;
					break;
				}
			}

			// if mc wasn't found in queue, unload it this way
			if(!mcFound) mc.unloadMovie();
		}
	}

	/**
	 * PRIVATE FUNCTIONS
	 */

    // load the next clip in the queue
    private function _loadNext() {

		clearInterval( _monitorInt);

		// remove the clipData from the beginning of the queue and store in _currentData
        _currentData = _swfQueue.shift();
		//_loader.addListener( this );
        if(!_loader.loadClip( _currentData.url, _currentData.into_mc)) {
			//dTrace('Unable to start loading of '+_currentData.url+ ' into MC '+_currentData.into_mc);
			_afterLoad();
		} else {
			//dTrace('Starting to Load swf into '+_currentData.into_mc);
			_timer = 0;
			_monitorInt = setInterval( this, '_monitorLoad', 500);
		}
    }

	// Initialize loader and Queue
	private function _reset ():Void {
        _loader = new MovieClipLoader();    // Create clip loader, and listen for events
        _loader.addListener( this );
		_swfQueue = new Array();            // clearQueue
		_currentData = null;
		_paused = false;
		clearInterval(_monitorInt);
	}

	private function _afterLoad() {
		
		_currentData = null;
		// if there is a clip in the queue, play that next
		if(_swfQueue.length>0) {
			if(!_paused) {
				_loadNext();
			} else {
				dTrace( 'queue is now paused' );
			}
		} else {			
			dispatchEvent({type: "onLoadQueueComplete"});
		}
	}

	private function _monitorLoad() {
		_timer += 500;
		if(_timer>30000) {
			onLoadError( _currentData.into_mc, 'Timed out loading url '+_currentData.url);
		}

	}

	// ----------------------------------------------
    // MovieClipLoader event handlers

	/*
	function onLoadStart( target:MovieClip ) {
		trace('Starting to load '+ _currentData.url + ' into ' + target);
	}
	//*/

	function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number) {


		//dTrace('[LOADER] Progress (box'+target._parent._parent.n+')' + bytesLoaded + '/' + bytesTotal + '  Items left in Queue: '+_swfQueue.length);
		// Call the 'complete' callback
		_currentData.progress.call( _currentData.scope, bytesLoaded, bytesTotal, _currentData.into_mc);
		// dispatch event for those who are listening
		dispatchEvent( { type: 'onLoadProgress',  target:target, url: _currentData.url } );
	}

	private function onLoadInit ( target:MovieClip) {
		
		clearInterval(_monitorInt);
		
		// Call the 'complete' callback
		_currentData.into_mc.___loading = false;
		////dTrace('loadComplete : '+target );
		_currentData.complete.call( _currentData.scope, target.getBytesLoaded(), target.getBytesTotal(), target);
		// dispatch event for those who are listening
		dispatchEvent( { type: 'onLoadInit',  target:target, url: _currentData.url } );
				
		_afterLoad();
	}

    private function onLoadError (target_mc:Object, errorCode:String, httpStatus:Number) {
        eTrace( ((httpStatus!=null) ? 'HTTP '+httpStatus : '') + ' '+errorCode );
		clearInterval( _monitorInt);
		dispatchEvent( { type: 'onLoadError', target:target_mc, url: _currentData.url , errorCode:errorCode, httpStatus:httpStatus} );	
		_afterLoad();
    }


	//
	public function get paused ():Boolean {
		return ( _paused && _swfQueue.length>0 );
	}

	function dTrace(s) {
		// leave this commented out for final build, so we can 
		// avoid Debug classes in preloaders
		//Debug.warn('[QueuedLoader ('+_uid+')] '+s);
	}
	
	function eTrace(s) {
		//Debug.error('[QueuedLoader ('+_uid+')] ERROR: '+s);
	}


	// ----------------------------------------------
    //  EventDispatcher Stuff
    var addEventListener    :Function
 	var removeEventListener :Function
 	var dispatchEvent       :Function
 	var dispatchQueue       :Function

	

}
