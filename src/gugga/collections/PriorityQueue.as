import gugga.collections.HashTable;
import gugga.collections.PriorityItem;
import gugga.collections.IIterable;
import gugga.collections.IIterator;

class gugga.collections.PriorityQueue implements IIterable
{
	private var mPriorityQueue:HashTable;
	
	private var mCount:Number;
	public function get count():Number 
	{
		return mCount;
	}
	
	public function PriorityQueue()
	{
		mPriorityQueue = new HashTable();
		mCount = 0;
	}
	
	public function addItem(aItem:PriorityItem)
	{
		if (mPriorityQueue.containsKey(aItem.ID))
		{
			trace("Error: Item already added!!!");
		}
		else
		{
			
			mPriorityQueue[aItem.ID] = aItem;
			mCount++;
		}
	}
	
	public function removeItem(aItemID:String)
	{
		if (!mPriorityQueue.containsKey(aItemID))
		{
			trace("Error: Item not exist!!!");
			return;
		}
		
		delete mPriorityQueue[aItemID];
		mCount--;
	}
	
	public function changePriority(aItemID:String, aPriority:Number)
	{
		var item:PriorityItem;
		item = mPriorityQueue[aItemID];
		item.Priority = aPriority;
		mPriorityQueue[item.ID] = item;
	}
	
	public function increasePriority(aItemID:String)
	{
		var item:PriorityItem;
		item = mPriorityQueue[aItemID];
		item.Priority = item.Priority + 1;
		mPriorityQueue[aItemID] = item;
	}

	public function getHeighestPriorityItem():PriorityItem
	{
		var maxPriorityItem:PriorityItem;
		var maxPriority:Number = -1;
		for (var itemID:String in mPriorityQueue)
		{
			var item:PriorityItem = mPriorityQueue[itemID];
			if(maxPriority < item.Priority)
			{
				maxPriorityItem = item;
				maxPriority = item.Priority;
			}
		}
		return maxPriorityItem;
	}
	
	/**
	 * Returns an iterator for the queue items.
	 */
	public function getIterator () : IIterator
	{
		return mPriorityQueue.getIterator();
	}
}