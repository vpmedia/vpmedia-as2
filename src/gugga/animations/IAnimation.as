import gugga.common.ITask;

[Event("start")]
[Event("completed")]

/**
 * TODO: Should be revised.
 */

/**
 * @author todor
 */
interface gugga.animations.IAnimation extends ITask 
{
	public function addCuePoint(aPosition:Number, aEventName:String):Void;
}