import gugga.collections.IIterator;
import gugga.collections.LinkedListItem;
import gugga.collections.LinkedListIterator;

/**
 * @author Todor Kolev
 */
class gugga.collections.LinkedList 
{
	private var mFirstItem : LinkedListItem;
	private var mLastItem : LinkedListItem;
	
	public function LinkedList()
	{
		mFirstItem = null;
		mLastItem = null;
	}
		
	public function get Count() : Number
	{
		var iterator : LinkedListIterator = LinkedListIterator(getIterator());
		var i : Number = 0;

		while(iterator.iterate())
		{
			i++;
		}
		
		return i;
	}
	
	public function contains(aItemData:Object) : Boolean
	{
		var iterator : LinkedListIterator = LinkedListIterator(getIterator());
		
		while(iterator.iterate())
		{
			if(aItemData === iterator.CurrentListItem.Data)
			{
				return true;
			}
		}
		
		return false;
	} 
	
	private function containsItem(aItem:LinkedListItem) : Boolean
	{
		var currentItem:LinkedListItem = mFirstItem;
		
		while(currentItem != null)
		{
			if(currentItem == aItem)
			{
				return true;
			}
			
			currentItem = currentItem.NextItem;
		}
	}
	
	public function getItemPredecessor(aItem:LinkedListItem)
	{
		if(aItem != mFirstItem && containsItem(aItem))
		{
			var iterator:LinkedListIterator = new LinkedListIterator(mFirstItem);
			
			while(iterator.iterate())
			{	
				if(iterator.CurrentListItem.NextItem == aItem)
				{
					return iterator.CurrentListItem;
				}
			}
		}
		else
		{
			return null;
		}
	}
	
	public function insertBefore(aTargetItem:LinkedListItem, aData:Object)
	{
		var newItem : LinkedListItem = new LinkedListItem();
		newItem.Data = aData;
		newItem.NextItem = aTargetItem; 
		
		var itemPredecessor : LinkedListItem = getItemPredecessor(aTargetItem);
		itemPredecessor.NextItem = newItem;
		
		if(aTargetItem == mFirstItem)
		{
			mFirstItem = newItem;
		}
	}  

	public function insertAfter(aTargetItem:LinkedListItem, aData:Object)
	{
		var newItem = new LinkedListItem();
		newItem.Data = aData;
		newItem.NextItem = aTargetItem.NextItem; 
		
		aTargetItem.NextItem = newItem;
		
		if(aTargetItem == mLastItem)
		{
			mLastItem = newItem;
		}
	}  

	public function insertHead(aData:Object)
	{
		var newItem = new LinkedListItem();
		newItem.Data = aData;
		newItem.NextItem = mFirstItem; 
		
		mFirstItem = newItem;
		
		if(!mLastItem)
		{
			mLastItem = mFirstItem;
		}
	}  

	public function insertTail(aData:Object)
	{
		var newItem = new LinkedListItem();
		newItem.Data = aData;
		newItem.NextItem = null; 
		
		mLastItem.NextItem = newItem;
		mLastItem = newItem;
		
		if(!mFirstItem)
		{
			mFirstItem = mLastItem;
		}
	}  	

	public function deleteBefore(aTargetItem:LinkedListItem)
	{
		if(aTargetItem != mFirstItem)
		{
			var itemPredecessor : LinkedListItem = getItemPredecessor(aTargetItem);
			
			if(itemPredecessor == mFirstItem)
			{
				mFirstItem = aTargetItem;
			}
			else
			{
				var itemPrePredecessor : LinkedListItem = getItemPredecessor(itemPredecessor);				
				itemPrePredecessor.NextItem = aTargetItem;
			}
		}
	}  

	public function deleteAfter(aTargetItem:LinkedListItem)
	{
		if(aTargetItem != mLastItem)
		{
			var nextItem : LinkedListItem = aTargetItem.NextItem;
			aTargetItem.NextItem = nextItem.NextItem;
			
			if(nextItem == mLastItem)
			{
				mLastItem = aTargetItem;
			}
		}
	}  
	
	public function deleteItem(aItem:LinkedListItem)
	{
		var itemPredecessor : LinkedListItem = getItemPredecessor(aItem);
		
		if(itemPredecessor)
		{
			itemPredecessor.NextItem = aItem.NextItem;
		}
		
		if(aItem == mFirstItem)
		{
			mFirstItem = aItem.NextItem;
		}

		if(aItem == mLastItem)
		{
			mLastItem = itemPredecessor;
		}
	}  

	public function deleteHead()
	{
		var currentHead:LinkedListItem = mFirstItem;
		
		mFirstItem = currentHead.NextItem;
		
		currentHead.NextItem = null;
	}  

	public function deleteTail()
	{
		if(mFirstItem != mLastItem)
		{
			var lastItemPredecessor:LinkedListItem = getItemPredecessor(mLastItem);
		
			lastItemPredecessor.NextItem = null;
			mLastItem = lastItemPredecessor;
		}
		else
		{
			mFirstItem = null;
			mLastItem = null;
		}
	}  
	
	public function getIterator() : IIterator
	{
		var iterator : IIterator = new LinkedListIterator(this.mFirstItem);
		return iterator;
	}	
	
	public function getHead() : Object
	{
		return mFirstItem.Data;
	}
	
	public function getTail() : Object
	{
		return mLastItem.Data;
	}
	
	public function isHead(aData:Object) : Boolean
	{
		return (aData === getHead());
	}
	
	public function isTail(aData:Object) : Boolean
	{
		return (aData === getTail());
	}
	
	public function getFirstItemContaining(aData:Object) : LinkedListItem
	{
		return getFirstItemContainingAfter(aData, mFirstItem);
	}
	
	public function getFirstItemContainingAfter(aData:Object, aBeginFrom : LinkedListItem) : LinkedListItem
	{
		var iterator : LinkedListIterator = new LinkedListIterator(aBeginFrom);
		
		while(iterator.iterate())
		{
			if(iterator.Current == aData)
			{
				return iterator.CurrentListItem;
			}
		}
		
		return null;
	}
}