import gugga.collections.ArrayList;
import gugga.debug.Assertion;
import mx.events.EventDispatcher;
import gugga.collections.IIterable;
import gugga.collections.IIterator;
import gugga.collections.ArrayListIterator;

[Event("completed")]

/**
 * <code>CheckList</code> is a container for items that should be checked.
 * <p> 
 * To register new item in the <code>CheckList</code> use the <code>add()</code> 
 * method. 
 * <p>
 * To check existing items in the <code>CheckList</code> use the 
 * <code>check()</code> method.
 * <p>
 * To uncheck all checked items in the <code>CheckList</code> use the 
 * <code>reset()</code> method.
 * <p>
 * To unregister existing item in the <code>CheckList</code> use the 
 * <code>remove()</code> method.
 * <p>
 * <code>isCompleted()</code> method will return <code>true</code> only if all 
 * registered items in the <code>CheckList</code> are checked.
 * <p>
 * <code>isObjectChecked(aObject:Object)</code> method will return 
 * <code>true</code> only if the specified <code>Object</code> is a registered 
 * item in the <code>CheckList</code> and it is checked.
 * <p>
 * <code>isObjectRegistered(aObject:Object)</code> method will return 
 * <code>true</code> only if the specified <code>Object</code> is a registered 
 * item in the <code>CheckList</code>.
 * <p>
 * To get the <code>ArrayList</code> of all registered items in the 
 * <code>CheckList</code> use the <code>RegisteredObjects</code> property.
 * <p>
 * To get the <code>ArrayList</code> of all checked items in the 
 * <code>CheckList</code> use the <code>CheckedObjects</code> property.
 * <p>
 * To get the <code>ArrayList</code> of all unchecked items in the 
 * <code>CheckList</code> use the <code>UncheckedObjects</code> property.
 * 
 * @see ArrayList
 */
class  gugga.collections.CheckList 
	extends EventDispatcher implements IIterable
{
	private var mRegisteredObjects:ArrayList;
	private var mCheckedObjects:ArrayList;
	
	public function get RegisteredObjects() : ArrayList
	{
		return mRegisteredObjects.clone();
	}
	
	public function get CheckedObjects() : ArrayList
	{
		return mCheckedObjects.clone();
	}
	
	public function get UncheckedObjects() : ArrayList
	{
		var result : ArrayList = new ArrayList();
		for (var i : Number = 0; i < mRegisteredObjects.length; i++)
		{
			var item : Object = mRegisteredObjects[i];
			if(!isObjectChecked(item))
			{
				result.addItem(item);
			}
		}
		
		return result;
	}
	
	public function CheckList()
	{
		mRegisteredObjects = new ArrayList();
		mCheckedObjects = new ArrayList();
	}
	
	public function add(aObject:Object):Void
	{
		Assertion.failIfReturnsTrue(
			this, isObjectRegistered, [aObject], 
			"Object already added", this, arguments);
		
		mRegisteredObjects.push(aObject);
	}
	
	public function remove(aObject : Object) : Void
	{
		mRegisteredObjects.removeItem(aObject);
		mCheckedObjects.removeItem(aObject);
	}
		
	public function check(aObject:Object):Void
	{
		Assertion.failIfReturnsFalse(
			this, isObjectRegistered, [aObject], 
			"Trying to check unregistered object", this, arguments);
		
		if(!isObjectChecked(aObject))
		{
			mCheckedObjects.push(aObject);	
			
			//TODO: Should be tested
			if(isCompleted())
			{
				dispatchEvent({type: "completed", target: this});
			}
		}
	}
	
	public function reset():Void
	{
		mCheckedObjects = new ArrayList();
	}
	
	public function	isObjectRegistered(aObject:Object):Boolean
	{	
		var isRegistered:Boolean = mRegisteredObjects.containsItem(aObject);
		return isRegistered;
	}
	
	public function	isObjectChecked(aObject:Object):Boolean
	{	
		var isChecked:Boolean = mCheckedObjects.containsItem(aObject);
		return isChecked;
	}
		
	public function isCompleted():Boolean
	{
		if(mCheckedObjects.length == mRegisteredObjects.length)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * Returns an iterator for the unchecked objects.
	 */
	public function getIterator () : IIterator
	{
		return new ArrayListIterator(this.RegisteredObjects);
	}
	
	/**
	 * Returns an iterator for the checked objects.
	 */
	public function getCheckedObjectsIterator () : IIterator
	{
		return new ArrayListIterator(this.CheckedObjects);
	}
	
		/**
	 * Returns an iterator for the unchecked objects.
	 */
	public function getUncheckedObjectsIterator () : IIterator
	{
		return new ArrayListIterator(this.UncheckedObjects);
	}
}