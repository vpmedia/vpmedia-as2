/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.display.components.list.AbstractListController;
import lunas.display.components.list.EasyList;
import lunas.display.components.list.ListModel;
import lunas.display.group.RadioButtonGroup;
import lunas.events.CellEvent;
import lunas.events.CellEventType;

import vegas.events.Delegate;
import vegas.events.Event;

/** 
 * @author eKameleon
 */
class lunas.display.components.list.EasyListController extends AbstractListController 
{

	/**
	 * Creates a new EasyListController instance.
	 */
	public function EasyListController() 
	{ 
		//
	}

	public function viewCreateAt(index:Number):MovieClip 
	{
		if ( isNaN(index) ) return null ;
		var item:Object = ListModel(getModel()).getItemAt(index) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		var container:MovieClip = view_mc.getContainer() ;
		var mI = container.addChildAt( view_mc.cellRenderer , index) ; // ici utiliser interface ICell
		mI.addEventListener(CellEventType.DOWN, new Delegate(this, viewSelect)) ;
		mI.addEventListener(CellEventType.ROLLOVER, new Delegate(this, viewRollOver)) ;
		mI.addEventListener(CellEventType.ROLLOUT, new Delegate(this, viewRollOut)) ;
		mI.index = index ;
		mI.setCellIndex(index) ;
		mI.setW(view_mc.getRowWidth()) ;
		mI.setListOwner(view_mc) ;
		mI.setToggle(true) ;
		mI.setGroupName( view_mc.getGroupName() ) ;
		mI.setLabel(item[ view_mc.getLabelField() ]) ;
		return mI ;
	}
	
	public function viewRemove(first:Number, last:Number):Void 
	{
		super.viewRemove(first, last) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		var container:MovieClip = view_mc.getContainer() ;
		var child ;
		var gName:String = view_mc.getGroupName() ;
		RadioButtonGroup.getInstance().resetGroup(gName) ;
		var size:Number = container.size() ;
		while(--size > -1) {
			child = container.getChildAt(size) ;
			child.index = size ;
			child.setCellIndex(size) ;
			child.setGroupName(gName) ;
		}
	}
	
	public function viewSelect(ev:CellEvent):Void 
	{
		super.viewSelect(ev) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		var p:Number = view_mc.getScrollPolicy() ;
		if (p == EasyList.SCROLL_ON_CLICK || p == EasyList.FULL) view_mc.setVPosition ( view_mc.getSelectedIndex() + 1) ;
	}

	public function viewSort(ev:Event):Void 
	{
		var model = ListModel(getModel()) ;
		var size:Number = model.size() ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		view_mc.unSelect() ;
		var container:MovieClip = view_mc.getContainer() ;
		while(--size > -1) {
			var curItem = model.getItemAt(size) ;
			var label:String = curItem[ view_mc.getLabelField() ] ;
			container.getChildAt(size).setLabel(label) ;
		}
	}

	public function viewUpdateItemAt(index:Number):Void 
	{
		var item:Object = ListModel(getModel()).getItemAt(index) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		view_mc.unSelect() ;
		var container:MovieClip = view_mc.getContainer() ;
		var mI:MovieClip = container.getChildAt(index) ;
		mI.setLabel(item[ view_mc.getLabelField() ]) ;
	}

}