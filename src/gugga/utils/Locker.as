import mx.events.EventDispatcher;
import gugga.crypt.GUID;
import gugga.collections.ArrayList;

[Event("locked")]

[Event("unlocked")]
/**
 * @author Todor Kolev
 */
class gugga.utils.Locker extends EventDispatcher 
{
	private var mLocks : Object;
	
	public function Locker() 
	{
		mLocks = new Object();
	}
	
	public function setLock(aLockID:String) : String
	{
		if(!isLocked())
		{
			dispatchEvent({type: "locked", target: this});
		}
		
		var lockID:String;
		
		if(aLockID)
		{
			lockID = aLockID;
		}
		else
		{
			lockID = GUID.create();
		}
				
		mLocks[lockID] = true;
		
		return lockID;
	}
	
	public function clearLock(aLockID:String) : Void
	{
		delete mLocks[aLockID];
		
		if (!isLocked())
		{
			dispatchEvent({type: "unlocked", target: this});
		}
	}	
	
	public function clearAllLocks() : Void
	{
		mLocks = new Object();
		dispatchEvent({type: "unlocked", target: this});
	}	
	
	public function isLocked() : Boolean
	{
		for (var key:String in mLocks)
		{
			return true;
		}
		
		return false;
	}
		
}