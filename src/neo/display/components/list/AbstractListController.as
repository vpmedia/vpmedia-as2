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

/* -------- AbstractListController

	AUTHOR

		Name : AbstractListController
		Package : neo.display.components.list
		Version : 1.0.0.0
		Date :  2006-02-09
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
		
		- viewCreateAt(index:Number):MovieClip
		
		- viewRemove(first:Number, last:Number):Void
		
		- viewRollOut 
			Override this method - Out of a cell.
			
		- viewRollOver():Void
			override this method - Over of a cell.
		
		- viewSelect(ev:IEvent):Void
			Invoqué quand une cellule est sélectionnée dans la liste, notifie un événement UIEventType.CHANGE
		
		-  viewUpdateItemAt(index:Number)
			Permet de rafraichir l'affichage d'une cellule dans la liste.

	IMPLEMENTS 

		IController

	INHERIT 
	
		AbstractController 
			|
			ListController

----------------*/

import com.bourre.core.HashCodeFactory;
import com.bourre.events.IEvent;
import com.bourre.mvc.AbstractController;

class neo.display.components.list.AbstractListController extends AbstractController {

	// ----o Constructor

	public function AbstractListController() { 
		//
	}

	// ----o Public Methods

	public function toString() : String {
		return '[AbstractListController' + HashCodeFactory.getKey( this ) + ']' ;
	}

	public function viewClear():Void {
		var view_mc:MovieClip = getView().getViewContainer() ;
		view_mc.unSelect() ;
		var container:MovieClip = view_mc.getContainer() ;
		container.clear() ;
	}
	
	public function viewCreateAt(index:Number):MovieClip {
		return null ;
	}

	public function viewRemove(first:Number, last:Number):Void {
		var view_mc:MovieClip = getView().getViewContainer() ;
		var container:MovieClip = view_mc.getContainer() ;
		container.removeRange(first, last) ;
		view_mc.unSelect() ;
	}
	
	public function viewRollOver(ev:IEvent):Void {
		var view_mc:MovieClip = getView().getViewContainer() ;
		ev.setTarget(this) ;
		view_mc.broadcastEvent(ev) ;
	}
	
	public function viewRollOut(ev:IEvent):Void {
		var view_mc:MovieClip = getView().getViewContainer() ;
		ev.setTarget(this) ;
		view_mc.broadcastEvent(ev) ;
	}

	public function viewSelect(ev:IEvent):Void {
		var target:MovieClip = ev.getTarget() ;
		var cellIndex:Object = target.getCellIndex() ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		view_mc.setSelectedIndex(cellIndex.itemIndex || target.index, true) ;
		view_mc.notifyChanged() ;
	}

	public function viewSort(ev:IEvent):Void {
		// override this method
	}
	
	public function viewUpdateItemAt(index:Number):Void {
		// override this method
	}

}