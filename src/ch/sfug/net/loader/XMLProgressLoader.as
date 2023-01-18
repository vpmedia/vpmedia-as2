import ch.sfug.events.ProgressEvent;
import ch.sfug.events.TimerEvent;
import ch.sfug.net.loader.XMLLoader;
import ch.sfug.utils.Timer;

/**
 * enhance the default xmlloader with a progress event
 * @author loop
 */
class ch.sfug.net.loader.XMLProgressLoader extends XMLLoader {

	private var timer:Timer;

	public function XMLProgressLoader( url:String, timoutTime:Number, tosend:XML) {
		super( url, timoutTime, tosend );
		this.timer = new Timer( 100, 0 );
		this.timer.addEventListener( TimerEvent.TIMER, calcProgress, this );
	}

	/**
	 * extends the super load function to start the progresscalculator
	 */
	public function load( url:String ):Void {
		super.load( url );
		this.timer.start();
	}

	/**
	 * extends the super function to stop the progress calculation
	 */
	private function onLoad( success:Boolean ):Void {
		calcProgress();
		super.onLoad( success );
		this.timer.stop();
		this.timer.reset();
	}

	/**
	 * creates a xml progress event
	 */
	private function calcProgress():Void {
		if( xml.getBytesLoaded() != undefined && xml.getBytesTotal() != undefined ) {
			dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, xml.getBytesLoaded(), xml.getBytesTotal() ) );
		}
	}

}