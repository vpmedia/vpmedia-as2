/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* -------- EasyListController

	AUTHOR

		Name : EasyListController
		Package : neo.display.components.list
		Version : 1.0.0.0
		Date :  2006-02-17
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
	
		- getModel():IModel

		- getView():IView

		- setModel(oModel:IModel):Void

		- setView(oView:IView):Void

		- toString():String

		- viewClear():Void

		- viewCreateAt(container:MovieClip, index:Number):MovieClip

		- viewRemove(first:Number, last:Number)

		- viewRollOut 
			
		- viewRollOver():Void
			
		- viewSelect(ev:IEvent):Void
			Invoqué quand une cellule est sélectionnée dans la liste, notifie un événement UIEventType.CHANGE

		-  viewUpdateItemAt(index:Number)
			Permet de rafraichir l'affichage d'une cellule dans la liste.

	IMPLEMENTS 
	
		IController

	INHERIT 
	
		AbstractController
			|
			AbstractListController 
				|
				EasyListController

----------------*/

import com.bourre.core.HashCodeFactory;
import com.bourre.events.IEvent;

import neo.display.components.list.AbstractListController;
import neo.display.components.list.EasyList;
import neo.display.components.list.ListModel;
import neo.display.group.RadioButtonGroup;
import neo.events.ButtonEventType;

class neo.display.components.list.EasyListController extends AbstractListController {

	// ----o Constructor

	public function EasyListController() { 
		//
	}

	// ----o Public Methods

	public function toString() : String {
		return '[EasyListController' + HashCodeFactory.getKey( this ) + ']' ;
	}

	public function viewCreateAt(index:Number):MovieClip {
		if ( isNaN(index) ) return null ;
		var item:Object = ListModel(getModel()).getItemAt(index) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		var container:MovieClip = view_mc.getContainer() ;
		var mI:MovieClip = container.addChildAt(view_mc.cellRenderer, index) ; // ici utiliser interface ICell
		mI.addEventListener(ButtonEventType.DOWN, this, viewSelect) ;
		mI.addEventListener(ButtonEventType.ROLLOVER, this, viewRollOver) ;
		mI.addEventListener(ButtonEventType.ROLLOUT, this, viewRollOut) ;
		mI.index = index ;
		mI.setCellIndex(index) ;
		mI.setW(view_mc.getRowWidth()) ;
		mI.setListOwner(view_mc) ;
		mI.setToggle(true) ;
		mI.setGroupName(view_mc.getGroupName()) ;
		mI.setLabel(item[ view_mc.getLabelField() ]) ;
		return mI ;
	}
	
	public function viewRemove(first:Number, last:Number):Void {
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
	
	public function viewSelect(ev:IEvent):Void {
		super.viewSelect(ev) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		var p:Number = view_mc.getScrollPolicy() ;
		if (p == EasyList.SCROLL_ON_CLICK || p == EasyList.FULL) view_mc.setVPosition ( view_mc.getSelectedIndex() + 1) ;
	}

	public function viewSort(ev:IEvent):Void {
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

	public function viewUpdateItemAt(index:Number):Void {
		var item:Object = ListModel(getModel()).getItemAt(index) ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		view_mc.unSelect() ;
		var container:MovieClip = view_mc.getContainer() ;
		var mI:MovieClip = container.getChildAt(index) ;
		mI.setLabel(item[ view_mc.getLabelField() ]) ;
	}

}