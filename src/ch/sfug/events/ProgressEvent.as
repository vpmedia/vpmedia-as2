import ch.sfug.events.Event;

/**
 * a class that represents a progress event thrown by a dataloader.
 * you can access the total and loaded number of bytes.
 *
 * @author mich
 */
class ch.sfug.events.ProgressEvent extends Event {

	private var bl:Number;
	private var bt:Number;

	public static var PROGRESS:String = "progress";

	public function ProgressEvent( type:String, bytesLoaded:Number, bytesTotal:Number ) {
		super(type);

		this.bl = bytesLoaded;
		this.bt = bytesTotal;

	}

	/**
	 * returns the number of bytes loaded so far
	 */
	public function get bytesLoaded( ):Number {
		return this.bl;
	}

	/**
	 * returns the number of total bytes to load
	 */
	public function get bytesTotal( ):Number {
		return this.bt;
	}

	/**
	 * overwrite default toString
	 */
	public function toString(  ):String {
		return "ProgressEvent: " + bl + " / " + bt;
	}

}