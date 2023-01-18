import gugga.common.ICommand;
import gugga.common.UIComponentEx;
import gugga.utils.DebugUtils;

[Event("commandBufferContentChanged")]
[Event("commandAdded")] //currentCommandIndex : Number

/**
 * @author Krasimir
 */
class gugga.commands.CommandHistory extends UIComponentEx {
	private var mHistoryBuffer:Array;
	private var mCurrent:Number;
	
	public function CommandHistory()
	{
		clear();
	}
	
	public function hasUndoableActions(): Boolean
	{
		return mCurrent >= 0;
	}
	public function hasRedoableActions(): Boolean
	{
		return ( mCurrent+1 < mHistoryBuffer.length); 
	}

	public function undo()
	{
		if 	(hasUndoableActions())
		{
			ICommand( mHistoryBuffer[mCurrent]).undo();
			mCurrent --;
			
			dispatchEvent({type:"commandBufferContentChanged", currentCommandIndex: mCurrent, target : this });
		}
	}

	public function redo()
	{
		if 	(hasRedoableActions())
		{
			mCurrent ++;
			ICommand( mHistoryBuffer[mCurrent]).execute();
			
			dispatchEvent({type:"commandBufferContentChanged", currentCommandIndex: mCurrent, target : this});
		}
		
	}

	public function add(cmd : ICommand)
	{
		while (hasRedoableActions())
			mHistoryBuffer.pop();
			
		mHistoryBuffer.push(cmd);
		mCurrent = mHistoryBuffer.length -1;
		
		dispatchEvent({type:"commandBufferContentChanged", currentCommandIndex: mCurrent, target : this});
		dispatchEvent({type:"commandAdded", currentCommandIndex: mCurrent, target : this});
	}
	
	public function clear()
	{
		mHistoryBuffer = new Array();
		mCurrent = -1;
		
		dispatchEvent({type:"commandBufferContentChanged", currentCommandIndex: mCurrent, target : this});
	}
	
	private function getNextUndoCommand():ICommand
	{
		return null;
	}
	private function getNextRedoCommand():ICommand
	{
		return null;
	}
	
	/**
	 * This method navigates through the history by executing particular command in the history buffer.
	 * 
	 * @param Number command index indicating which command to execute. 
	 * 
	 * @see BrowserHistoryManager
	 */
	public function navigate(aCommandIndex : Number)
	{
		if(mCurrent > aCommandIndex)
		{
			DebugUtils.trace("undo");
			ICommand(mHistoryBuffer[aCommandIndex + 1]).undo();
			mCurrent = aCommandIndex;
		}
		else if(mCurrent < aCommandIndex)
		{
			DebugUtils.trace("execute (redo)");
			ICommand(mHistoryBuffer[aCommandIndex]).execute();
			mCurrent = aCommandIndex;
		}
		else
		{
			DebugUtils.trace("requesting current navigation state - history buffer takes no action");	
		}
	}
}