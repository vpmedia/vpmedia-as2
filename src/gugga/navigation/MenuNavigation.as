import mx.utils.Delegate;

import gugga.navigation.INavigation;
import gugga.navigation.INavigationItem;
import gugga.navigation.MenuItemsController;
import gugga.utils.DebugUtils;
import gugga.utils.DrawUtil;
 
[Event("navigate")]

/**
 * @author todor
 */
class gugga.navigation.MenuNavigation extends MenuItemsController implements INavigation
{
	private var mDisableMouseEventsCover : MovieClip;
	
	public function MenuNavigation()
	{
		mTrackableID = "MenuNavigation";
		
		hide();
	}
	
	public function getSelectedItem() : INavigationItem 
	{
		return SelectedItem;
	}

	public function setSelectedItem(aValue:INavigationItem) : Void 
	{
		SelectedItem = aValue;
	}

	public function getSelectedItemID():String 
	{
		return SelectedItemID;
	}

	public function setSelectedItemID(aValue:String) : Void 
	{
		SelectedItemID = aValue;
	}

	public function enable() : Void
	{
		this.enabled = true;
		mDisableMouseEventsCover._visible = false;
	}

	public function disable() : Void
	{
		this.enabled = false;
		mDisableMouseEventsCover.swapDepths(this.getNextHighestDepth());
		mDisableMouseEventsCover._visible = true;
	}
	
	public function initUI()
	{
		this.addEventListener("selected", Delegate.create(this, onMeSelected));
		
		super.initUI();
	}
	
	public function start():Void
	{
		createDisableMouseEventsCover();
		
		show();
		showAllSubItems();
		
		enable();
	}
	
	private function createDisableMouseEventsCover()
	{
		var itemsArray : Array = new Array();
		
		for (var key:String in mSubItems) 
		{
			itemsArray.push(mSubItems[key]);
		}
		
		if(mDisableMouseEventsCover)
		{
			mDisableMouseEventsCover.removeMovieClip();
		}
		
		mDisableMouseEventsCover = DrawUtil.createCoverForMovieClips("DisableMouseEventsCover", this, itemsArray);
		mDisableMouseEventsCover.onRelease = function(){};
		mDisableMouseEventsCover.useHandCursor = false;
	}
	
	private function onMeSelected(ev)
	{
		var itemsStack:Array = ev.itemsStack;

		var primalID:String = itemsStack[0].id;
		var primalAditionalData:String = itemsStack[0].aditionalData;
				
		dispatchEvent({type:"navigate", target:this, id: primalID, aditionalData: primalAditionalData, 
			itemsStack:itemsStack});
	}
}