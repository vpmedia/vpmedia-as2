 /**
 * @author ...
 *
 */

import ch.sfug.events.ErrorEvent;
import ch.sfug.events.Event;
import ch.sfug.events.ProgressEvent;
import ch.sfug.net.loader.AbstractLoader;

class ch.sfug.net.loader.MediaLoader extends AbstractLoader {

	private var _target:MovieClip;
	private var mcl:MovieClipLoader;

	/**
	 * constructor
	 * @param		mediaUrl		String		the clips url
	 * @param		mediaTarget		MovieClip	the target to load the clip into
	 */
	public function MediaLoader( mediaUrl:String ,mediaTarget:MovieClip )
	{
		super( mediaUrl );

		this.target = mediaTarget;

		mcl = new MovieClipLoader();
		mcl.addListener( this );
	}

	/**
	 * starts the actual loading
	 * this function has 2 optional parameters load([url:String], [target:MovieClip])
	 * to reassign the url/target value at loading time
	 *
	 * @param ur (optional) reassign url before loading
	 * @param trt (optional) reassign target before loading
	 */
	public function load( url:String, trt:MovieClip ):Void {
		this.url = url;
		this.target = trt;
		if( _url == undefined || url == "" || target == undefined ) {
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, "MediaLoader needs an url to load and a target mc. Now, url: " + url + " / target: " + target ) );
		} else {
			mcl.loadClip( _url, _target );
		}
	}

	/**
	 * cleans up for destruction
	 */
	public function unload():Void
	{
		mcl.unloadClip(_target);
	}

	/**
	 * setter method for the target the media loads into
	 * @mediaTarget		MovieClip		url to load media from
	 */
	public function set target( mediaTarget:MovieClip ):Void
	{
		if( mediaTarget != undefined ) {
			_target = mediaTarget;
		}
	}

	/**
	 * returns the loading target
	 */
	public function get target(  ):MovieClip {
		return this._target;
	}

	/**
	 * dispatches the event that the media is loaded but not yet initalized
	 */
	private function onLoadComplete(target_mc:MovieClip, httpStatus:Number):Void
	{
		dispatchEvent( new Event(Event.COMPLETE) );
	}

	/**
	 * dispatches an error event with the errormessage and an additional httpstatus message
	 */
	private function onLoadError(target_mc:MovieClip, code:String, statusNum:Number):Void
	{
		var msg:String = "MediaLoader could not load: " + _url + "\nreason:" + code + "\nHTTP-Status: " + statusNum;
		dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, msg ) );
	}

	/**
	 * dispatches the event that the media has finished initialisation
	 */
	private function onLoadInit(target_mc:MovieClip):Void
	{
		dispatchEvent( new Event( Event.INIT ) );
	}

	/**
	 * dispatches a ProgressEvent which you can get the loaded / total bytes from
	 */
	private function onLoadProgress(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void
	{
		//target_mc argument ignored....
		dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, loadedBytes, totalBytes) );
	}

	/**
	 * dispatches when loading starts
	 */
	private function onLoadStart(target_mc:MovieClip):Void
	{
		dispatchEvent( new Event(Event.OPEN) );
	}
}