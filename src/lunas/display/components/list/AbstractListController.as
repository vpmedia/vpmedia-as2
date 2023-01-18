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

import lunas.display.components.ICell;
import lunas.events.CellEvent;

import vegas.events.Event;
import vegas.util.mvc.AbstractController;

/**
 * @author eKameleon
 */
class lunas.display.components.list.AbstractListController extends AbstractController 
{

	/**
	 * Creates a new ListController instance.
	 */
	public function ListController() 
	{ 
		//
	}

	public function unSelect():Void
	{
		if (_oldCell != null)
		{
			var view_mc:MovieClip = getView().getViewContainer() ;
			MovieClip(_oldCell).enabled = view_mc.enabled ;	
			_oldCell = null ;
		}
	}

	public function viewClear():Void 
	{
		var view_mc:MovieClip = getView().getViewContainer() ;
		view_mc.unSelect() ;
		var container:MovieClip = view_mc.getContainer() ;
		container.clear() ;
	}
	
	public function viewCreateAt(index:Number):MovieClip 
	{
		return null ;
	}

	public function viewRemove(first:Number, last:Number):Void 
	{
		var view_mc:MovieClip = getView().getViewContainer() ;
		var container:MovieClip = view_mc.getContainer() ;
		container.removeRange(first, last) ;
		view_mc.unSelect() ;
	}
	
	public function viewRollOver(ev:CellEvent):Void 
	{
		var view_mc:MovieClip = getView().getViewContainer() ;
		// todo envoyer le numéro de la cellule courante
		ev.setTarget(view_mc) ;
		view_mc.dispatchEvent(ev) ;
	}
	
	public function viewRollOut(ev:CellEvent):Void 
	{
		var view_mc:MovieClip = getView().getViewContainer() ;
		// todo envoyer le numéro de la cellule courante
		ev.setTarget(view_mc) ;
		view_mc.dispatchEvent(ev) ;
	}

	public function viewSelect(ev:CellEvent):Void 
	{
		var cellIndex:Object = ev.getCellIndex() ;
		var cell:ICell = ev.getCell() ;
		var view_mc:MovieClip = getView().getViewContainer() ;
		
		view_mc.setSelectedIndex(cellIndex.itemIndex || cell["index"], true) ;
		
		//////////////////// Protected Selected !! 
		
		if (view_mc.protectSelected)
		{
		
			if (_oldCell != null)
			{
				MovieClip(_oldCell).enabled = true ;
			}
			MovieClip(cell).enabled = false ;
			
			_oldCell = cell ;
		
		}
		////////////////////
		
		view_mc.notifyChanged() ;
		
	}

	public function viewSort(ev:Event):Void 
	{
		// override this method
	}
	
	public function viewUpdateItemAt(index:Number):Void 
	{
		// override this method
	}
	
	private var _oldCell:ICell ;

}