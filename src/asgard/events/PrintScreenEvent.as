import asgard.media.PrintScreen;

import flash.display.BitmapData;

import pegas.events.ActionEvent;

/**
 * The PrintScreenEvent is notify by all the objects who implements the Action interface.
 * @author eKameleon
 */
class asgard.events.PrintScreenEvent extends ActionEvent 
{
	
	/**
	 * Creates a new PrintScreenEvent instance.
	 * @param type the type of the event.
	 * @param target the PrintScreen target reference of this event.
	 */
	public function PrintScreenEvent( type:String, target:PrintScreen, bubbles:Boolean, eventPhase:Number, time:Number, stop : Number ) 
	{
		super(type, target, null, null, bubbles, eventPhase, time, stop);
	}

	/**
	 * The name of the event when the capture is cleared.
	 */	
	static public var CLEAR:String = "onCleared" ;
	
	/**
	 * The name of the event when the capture process is finished.
	 */
	static public var FINISH:String = "onFinished" ;
	
	/**
	 * The name of the event when the capture process is in progress.
	 */
	static public var PROGRESS:String = "onProgress" ;
	
	/**
	 * The name of the event when the capture process is started.
	 */
	static public var START:String = "onStarted" ;

	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		return new PrintScreenEvent(getType(), getTarget()) ;
	}

	/**
	 * Returns the internal BitmapData reference.
	 * @return the internal BitmapData reference.
	 */
	public function getBitmapData():BitmapData
	{
		return getTarget().getBitmapData() ;
	}

	/**
	 * Returns the array representation of the capture buffer.
	 * @return the array representation of the capture buffer.
	 */
	public function getBuffer():Array
	{
		return getTarget().getBuffer() ;	
	}
	
	/**
	 * Returns the progress percent value of the capture process.
	 */
	public function getPercent():Number
	{
		return getTarget().getPercent() ;
	}
	
	/**
	 * Returns the PrintScreen reference of this event.
	 * @return the PrintScreen reference of this event.
	 */
	public function getTarget():PrintScreen
	{
		return PrintScreen( super.getTarget() ) ;
	}
	
	/**
	 * Returns the elapsed time during the capture (in ms).
	 * @return the elapsed time during the capture (in ms).
	 */
	public function getTime():Number
	{
		return getTarget().getTime() ;	
	}

}