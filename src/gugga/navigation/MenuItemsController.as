/**
 * @author todor
 */

import mx.utils.Delegate;

import gugga.collections.HashTable;
import gugga.commands.CommandManager;
import gugga.common.EventDescriptor;
import gugga.common.ICommand;
import gugga.common.UIComponentEx;
import gugga.debug.Assertion;
import gugga.navigation.IDropDownMenuItem;
import gugga.navigation.IMenuItemsController;
import gugga.navigation.INavigationItem;
import gugga.utils.DebugUtils;
import gugga.utils.Listener;


[Event("selected")]
class gugga.navigation.MenuItemsController 
	extends UIComponentEx
	implements IMenuItemsController
{
	private var mSubItems:HashTable;
	private var mSubItemsAditionalData:HashTable;
	private var mSubItemsCommands:HashTable;
	
	private var mSelectedSubItem:INavigationItem;
	private var mSelectedSubItemID:String;
	private var mOpenedSubItem:IDropDownMenuItem;
	private var mOpenedSubItemID:String;
	
	private var mIsOpenable:Boolean = true;
	private var mIsClosable:Boolean = true;
		
	private var mCloseDropDownOnSelect : Boolean = true;
	public function get CloseDropDownOnSelect() : Boolean { return mCloseDropDownOnSelect; }
	public function set CloseDropDownOnSelect(aValue:Boolean) : Void { mCloseDropDownOnSelect = aValue; }
			
	public function get SelectedItem() : INavigationItem 
	{
		return mSelectedSubItem;
	}

	public function set SelectedItem(aValue:INavigationItem) : Void 
	{
		var id:String = getSubItemIDRecur(aValue);
		selectSubItemRecur(id);
	}

	public function get SelectedItemID():String 
	{
		return mSelectedSubItemID;
	}

	public function set SelectedItemID(aValue:String) : Void 
	{
		selectSubItemRecur(aValue);
	}
	
	public function get OpenedItem() : INavigationItem 
	{
		return mOpenedSubItem;
	}

	public function set OpenedItem(aValue:INavigationItem) : Void 
	{
		var id:String = getSubItemIDRecur(aValue);
		selectSubItemRecur(id);
	}

	public function get OpenedItemID():String 
	{
		return mOpenedSubItemID;
	}

	public function set OpenedItemID(aValue:String) : Void 
	{
		openSubItemRecur(aValue);
	}
	
	public function get HasSubItems():Boolean
	{
		return !mSubItems.IsEmpty;
	}
	
	public function MenuItemsController()
	{
		mSubItems = new HashTable();
		mSubItemsAditionalData = new HashTable();
		mSubItemsCommands = new HashTable();
	}
	
	public function addSubItem(aItem:INavigationItem, aID:String, aAditionalData:Object, aCommand:ICommand):Void
	{
		aItem.hide();
		
		mSubItems[aID] = aItem;
		mSubItemsAditionalData[aID] = aAditionalData;
		mSubItemsCommands[aID] = aCommand;
		
		Listener.createMergingListener(new EventDescriptor(aItem, "selected"), Delegate.create(this, onItemSelected), {id:aID});
		Listener.createMergingListener(new EventDescriptor(aItem, "rollOver"), Delegate.create(this, onItemRollOver), {id:aID});
		Listener.createMergingListener(new EventDescriptor(aItem, "rollOut"), Delegate.create(this, onItemRollOut), {id:aID});
	}	
	
	public function addChildSubItem(aInstanceName:String, aID:String, aAditionalData:Object, aCommand:ICommand):INavigationItem
	{
		var navigationItem:INavigationItem = INavigationItem(this[aInstanceName]);
		addSubItem(navigationItem, aID, aAditionalData, aCommand);
		
		return navigationItem;
	}
	
	private function onItemSelected(ev)
	{
		var id:String = ev.id;
		var itemsStack:Array = ev.itemsStack;
		
		//selectSubItem(id);
		
		if(!itemsStack)
		{
			itemsStack = new Array();
			
			//the item is the one clicked by the user, so it's command is executed
			var itemCommand:ICommand = ICommand(mSubItemsCommands[id]);
			CommandManager.Instance.execute(itemCommand);
		}
		
		itemsStack.push({id:id, aditionalData:mSubItemsAditionalData[id], istance:mSubItems[id]});

		dispatchEvent({type:"selected", target:this, itemsStack:itemsStack});
	}
	
	private function onItemRollOver(ev)
	{	
		if(mSubItems[ev.id] && (mSubItems[ev.id] instanceof IDropDownMenuItem))
		{
			openSubItem(ev.id);
		}
	}
	
	private function onItemRollOut(ev)
	{
		if(mSubItems[ev.id] && (mSubItems[ev.id] instanceof IDropDownMenuItem))
		{
			mOpenedSubItem = null;
			mOpenedSubItemID = null;
			mSubItems[ev.id].close();		
		}
	}
		
	public function getSubItem(aID:String):INavigationItem
	{
		if(mSubItems[aID])
		{
			return mSubItems[aID];
		}
		
		return null;
	}
	
	public function getSubItemRecur(aID:String):INavigationItem
	{
		var result : INavigationItem = null;
		
		if(mSubItems[aID])
		{
			result = mSubItems[aID];
		}
		else
		{
			var itemParent : IMenuItemsController = findSubItemParent(aID);
			if(itemParent != null)
			{
				result = itemParent.getSubItem(aID);	
			}	
		}

		return result;
	}
	
	public function getSubItemID(aItemInstance:INavigationItem):String
	{
		for (var key:String in mSubItems)
		{
			if(mSubItems[key] == aItemInstance)
			{
				return key;
			}
		}
	}
	
	public function getSubItemIDRecur(aItemInstance:INavigationItem):String
	{
		var foundID:String = getSubItemID(aItemInstance);
		
		if(foundID)
		{
			return foundID;
		}
		
		for (var key:String in mSubItems)
		{
			foundID = mSubItems[key].getSubItemIDRecur(aItemInstance);
			if(foundID)
			{
				return foundID;
			}
		}
	}

	public function callFunctionOnAllSubItemsTo(aID:String, aFunctionName:String):Void
	{
		if(mSubItems[aID])
		{
			this[aFunctionName].apply(this, [aID]);
		}
		else
		{		
			var subItem:INavigationItem;
			for (var key:String in mSubItems) 
			{			
				subItem = mSubItems[key];
				
				if (subItem instanceof MenuItemsController) 
				{
					var subMenuItemsController:IMenuItemsController = IMenuItemsController(subItem);
					var subItemParent:IMenuItemsController = subMenuItemsController.findSubItemParent(aID);
	
					//the item is under this subItem
					if(subItemParent)
					{
						this[aFunctionName].apply(this, [key]);
						subMenuItemsController.callFunctionOnAllSubItemsTo(aID, aFunctionName);
						
						return;
					}
				}
			}
		}
	}	
	
	public function findSubItemParent(aID:String) : IMenuItemsController
	{
		if(mSubItems[aID])
		{
			return this;
		}
		
		var subItem:INavigationItem;
		for (var key:String in mSubItems) 
		{			
			subItem = mSubItems[key];
			
			if (subItem instanceof MenuItemsController) 
			{
				var subMenuItemsController : IMenuItemsController = IMenuItemsController(subItem);
				var subItemParent : IMenuItemsController = subMenuItemsController.findSubItemParent(aID);
				if(subItemParent)
				{
					return subItemParent;
				}
			}
		}		
		
		return null;
	}

	/**
	* Selects sub item under the current IMenuItemsController
	* 
	* @param aID The ID of the item that should be selected.
	*/
	public function selectSubItem(aID:String):Void
	{
		if(mSelectedSubItemID != aID)
		{
			mSelectedSubItem.unselect();
			mSelectedSubItemID = aID;
			mSelectedSubItem = mSubItems[mSelectedSubItemID];
			mSelectedSubItem.select();
		}
		
		if(mCloseDropDownOnSelect && mOpenedSubItem && 
			(mOpenedSubItem instanceof IDropDownMenuItem))
		{
			mOpenedSubItem.close();
			mOpenedSubItem = null;
			mOpenedSubItemID = null;
		}
	}	
	
	/**
	* Selects sub item under the current IMenuItemsController,
	* or under one of its sub IMenuItemsController-s.
	* 
	* @param aID The ID of the item that should be selected.
	*/
	public function selectSubItemRecur(aID:String):Void
	{
		if(mSubItems[aID])
		{
			selectSubItem(aID);
		}
		else
		{
			var itemParent : IMenuItemsController = findSubItemParent(aID);
			if(itemParent)
			{
				itemParent.selectSubItem(aID);
			}
		}
	}	
	
	public function selectAllSubItemsTo(aID:String):Void
	{
		callFunctionOnAllSubItemsTo(aID, "selectSubItem");
	}	
	
	public function selectSubItemsPath(aPath:String):Void
	{
		Assertion.failIfEmpty(aPath, "Argument aPath is empty", this, arguments);
	
		var pathArray:Array = aPath.split(".");
		var subItemID:String = pathArray[0];

		Assertion.failIfEmpty(subItemID, "Section ID is not valid", this, arguments);
		
		if(pathArray.length > 1)
		{
			var pathRestArray:Array = pathArray.slice(1);
			var pathRest:String = pathRestArray.join(".");
			var subItem : IMenuItemsController = mSubItems[subItemID];
			
			subItem.selectSubItemsPath(pathRest);
		}
		
		selectSubItem(subItemID);
	}

	public function unselectAllSubItems():Void
	{
		mSelectedSubItemID = null;
		mSelectedSubItem = null;
			
		for (var key:String in mSubItems) 
		{
			mSubItems[key].unselect();
		}
	}	
	
	public function unselectAllSubItemsRecur(aID:String):Void
	{
		for (var key:String in mSubItems) 
		{
			mSubItems[key].unselect();
			if(mSubItems[key] instanceof IMenuItemsController)
			{
				mSubItems[key].unselectAllSubItemsRecur();
			}
		}
	}	

	private function showAllSubItems()
	{
		for (var key:String in mSubItems) 
		{
			mSubItems[key].show();
		}
	}

	private function hideAllSubItems()
	{
		for (var key:String in mSubItems) 
		{
			mSubItems[key].hide();
		}
	}
	
	public function openSubItem(aID:String):Void
	{
		if(mOpenedSubItemID != aID 
			&& (mSubItems[aID] instanceof IDropDownMenuItem))
		{
			mOpenedSubItem.close();
			
			mOpenedSubItemID = aID;
			mOpenedSubItem = mSubItems[mOpenedSubItemID];
			
			mOpenedSubItem.open();
		}
	}	
	
	private function openSubItemRecur(aID:String):Void
	{
		if(mSubItems[aID])
		{
			openSubItem(aID);
		}
		else
		{		
			var itemParent : MenuItemsController = MenuItemsController(findSubItemParent(aID));
			if(itemParent)
			{
				itemParent.openSubItem(aID);
			}
		}
	}	
	
	private function openAllSubItemsTo(aID:String):Void
	{
		callFunctionOnAllSubItemsTo(aID, "openSubItem");
	}	
	
	private function openSubItemsPath(aPath:String):Void
	{
		Assertion.failIfEmpty(aPath, "Argument aPath is empty", this, arguments);
	
		var pathArray:Array = aPath.split(".");
		var subItemID:String = pathArray[0];

		Assertion.failIfEmpty(subItemID, "Section ID is not valid", this, arguments);
		
		if(pathArray.length > 1)
		{
			var pathRestArray:Array = pathArray.slice(1);
			var pathRest:String = pathRestArray.join(".");
			var subItem : MenuItemsController = mSubItems[subItemID];
			
			subItem.openSubItemsPath(pathRest);
		}
		
		openSubItem(subItemID);
	}

	private function closeAllSubItems():Void
	{
		mOpenedSubItem = null;
		mOpenedSubItemID = null;
		
		for (var key:String in mSubItems)
		{
			mSubItems[key].close();
		}
	}	
	
	private function closeAllSubItemsRecur(aID:String):Void
	{
		mOpenedSubItem = null;
		mOpenedSubItemID = null;

		for (var key:String in mSubItems) 
		{
			mSubItems[key].close();
			if(mSubItems[key] instanceof IMenuItemsController)
			{
				mSubItems[key].closeAllSubItemsRecur();
			}
		}
	}	
}