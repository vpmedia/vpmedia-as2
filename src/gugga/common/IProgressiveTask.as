/**
 * @author todor
 */

import gugga.common.ITask;

[Event("start")]
[Event("progress")]//event object data fields: total, current, percents
[Event("interrupted")]
[Event("completed")]

interface gugga.common.IProgressiveTask extends ITask 
{
	//progress in percents: 0-100
	public function getProgress() : Number;	
}