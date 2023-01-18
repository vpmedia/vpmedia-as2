/**
 * @author todor
 */

import mx.utils.Delegate;

import flash.geom.Point;

import gugga.common.ITask;
import gugga.navigation.DropDownMenuItemTitle;
import gugga.navigation.IDropDownMenuItem;
import gugga.navigation.INavigationItem;
import gugga.navigation.MenuItemsController;

[Event("selected")]
class gugga.navigation.DropDownMenuItem 
	extends MenuItemsController 
	implements IDropDownMenuItem
{
	private var mHitAreaClip:MovieClip;
	private var mTitleButton:DropDownMenuItemTitle;
	private var mIsSelected:Boolean = false;
	private var mHitTestBoundingBox:Boolean = false;
	
	private var mOpeningTask:ITask;
	private var mClosingTask:ITask;
	
	public function get HitTestBoundingBox():Boolean { return mHitTestBoundingBox; }
	public function set HitTestBoundingBox(aValue:Boolean):Void { mHitTestBoundingBox = aValue; }
	
	public function get IsSelected():Boolean { return mIsSelected; }
	public function get SelectedSubItem():INavigationItem { return mSelectedSubItem; }
	public function get SelectedSubItemID():String { return mSelectedSubItemID; }
	
	public function DropDownMenuItem()
	{
		mHitAreaClip = this;
	}
	
	public function registerTitleButton(aDropDownMenuItemTitle:DropDownMenuItemTitle):Void
	{
		if(mTitleButton)
		{
			mTitleButton.removeEventListener("click", Delegate.create(this, onTitleButtonClick));
			mTitleButton.removeEventListener("rollOver", Delegate.create(this, onTitleButtonRollOver));
		}
		
		mTitleButton = aDropDownMenuItemTitle;
		mTitleButton.addEventListener("click", Delegate.create(this, onTitleButtonClick));
		mTitleButton.addEventListener("rollOver", Delegate.create(this, onTitleButtonRollOver));
	}		
	
	public function registerChildTitleButton(aInstanceName:String):DropDownMenuItemTitle
	{
		var dropDownMenuItemTitle:DropDownMenuItemTitle = DropDownMenuItemTitle(this[aInstanceName]);
		registerTitleButton(dropDownMenuItemTitle);
		return dropDownMenuItemTitle;
	}
	
	private function onTitleButtonClick(ev)
	{
		dispatchEvent({type:"selected", target:this});
	}

	private function onTitleButtonRollOver(ev)
	{
		mTitleButton.playRollOver(); //TODO: can be called by the child class, not here
		dispatchEvent({type:"rollOver", target:this});
	}
	
	private function onMeRollOut()
	{
		mTitleButton.playRollOut(); //TODO: can be called by the child class, not here
		dispatchEvent({type:"rollOut", target:this});
	}
	
	private function onEnterFrameHandler(){
		/**
		 *	TODO: Couldn't we use other way for determine global coordinates?
		 *	bad case is when you are loaded in other movie and lockroot of 
		 *	your parent is set to true.
		 *	
		 *	Completed! 
		 */
		
		var mouseCoordinates : Point = new Point(mHitAreaClip._xmouse, mHitAreaClip._ymouse);
		mHitAreaClip.localToGlobal(mouseCoordinates);

		if(!mHitAreaClip.hitTest(mouseCoordinates.x, mouseCoordinates.y, !mHitTestBoundingBox)){
			onMeRollOut();
		}
	}

	public function registerOpeningTask(aTask:ITask):Void
	{
		mOpeningTask = aTask;
	}		

	public function registerClosingTask(aTask:ITask):Void
	{
		mClosingTask = aTask;
	}
	
	public function setHitArea(aHitAreaClip:MovieClip):Void
	{
		mHitAreaClip = aHitAreaClip;
	}	
	
	public function select():Void 
	{
		if(!mIsSelected)
		{
			mIsSelected = true;
			mTitleButton.select();
		}
	}

	public function unselect():Void 
	{
		if(mIsSelected)
		{
			mIsSelected = false;
			mTitleButton.unselect();
			unselectAllSubItems();//This code is present in VanileRoyal's version. Majbe it fixes a bug.
		}
	}

	public function show():Void 
	{
		super.show();
		mTitleButton.show();
	}	

	public function hide():Void 
	{
		super.hide();
		mTitleButton.hide();
	}	
	
	public function open():Void 
	{
		mTitleButton.playRollOver();//This code is present in VanileRoyal's version. Majbe it fixes a bug.
		this.onEnterFrame = onEnterFrameHandler;
		
		if(mOpeningTask)
		{
			mOpeningTask.start();
		}
		else
		{
			showAllSubItems();
		}
	}

	public function close():Void 
	{
		mTitleButton.playRollOut();//This code is present in VanileRoyal's version. Majbe it fixes a bug.
		this.onEnterFrame = null;
		
		if(mClosingTask)
		{
			mClosingTask.start();
		}
		else
		{
			hideAllSubItems();
		}
	}
}