 /**
 * @author Marcel
 */

import ch.sfug.events.ErrorEvent;
import ch.sfug.events.Event;
import ch.sfug.events.EventDispatcher;
import ch.sfug.events.ProgressEvent;
import ch.sfug.net.loader.AbstractLoader;

class ch.sfug.net.loader.QueueLoader extends EventDispatcher {

    private var inProgress:Boolean = false;
    private var queue:Array;
    private var activ:Number;


    public function QueueLoader() {
    	super();
        queue = new Array();
	}

	/**
	 * starts to download the queue
	 */
    public function start():Void {
    	activ = 0;
		inProgress = true;
		loadNext();
    }

	/**
	 * catches the event from a loader when its finished with loading
	 */
	private function onLoaded( evt:Event ):Void {

		dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, activ, queue.length ) );
		loadNext();
	}

	/**
	 * catches the error event of the loaders
	 */
	private function onError( e:ErrorEvent ):Void {
		inProgress = false;
		dispatchEvent( e );
	}


	/**
	 * loads the next loader.
	 */
	private function loadNext():Void {
		if( queue.length > activ ) {
            var loader:AbstractLoader = AbstractLoader( queue[ activ ] );
            activ++;
            loader.addEventListener( Event.COMPLETE, onLoaded, this );
            loader.addEventListener( ErrorEvent.ERROR, onError, this );
            loader.load();
    	} else {
    		inProgress = false;
    		//clear the queue when everthing is finished
    		queue = new Array();
    		activ = 0;
    		dispatchEvent( new Event( Event.COMPLETE ) );
    	}
	}

	/**
	 * adds a loader to the queue
	 */
    public function addLoader( l:AbstractLoader ):Void {
    	if( l != undefined ) {
    		queue.push( l );
    	}
    }

    /**
     * returns true if the queue loader is running else false
     */
    public function get running():Boolean {
    	return inProgress;
    }

    /**
     * returns the array of the loaders
     */
    public function get loaders(  ):Array {
    	return this.queue;
    }

}