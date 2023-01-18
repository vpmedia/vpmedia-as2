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

/* -------- EasyList

	AUTHOR

		Name : EasyList
		Package : neo.display.components.list
		Version : 1.0.0.0
		Date :  2006-02-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net


	DESCRIPTION

	

		Exemple de liste autoScrollable.



	CONSTANT SUMMARY

	

		- AUTO:Number

		

			auto scroll

		

		- NONE:Number

		

			no auto scroll

			

		- SCROLL_ON_CLICK:Number

		

			scroll when user select an item.

	

	PROPERTY SUMMARY
	
		- dataProvider [R/W]
		
		- labelField:String [R/W]
		
		- rowCount:Number [R/W]
		
		- rowHeight:Number [R/W]
		
		- rowWidth:Number [R/W]
		

		- scrollPolicy:Number [R/W]

		
		- selectedIndex:Number [R/W]
		
		- selectedItem [R/W]

	METHOD SUMMARY
		
		- addItem( oItem )
		
		- addItemAt( oItem, index:Number )
		
		- clear():Void
		
		- contains(oItem):Boolean
		
		- createItemAt(index:Number):MovieClip
		
			Internal method. Can be override.
		
		- editField(index:Number, fieldName:String, newData):Void
		
		- getContainer():MovieClip
		
		- getDataProvider():ListModel
		
			return the model.
		
		- getItemAt(index:Number)
		
		- getItemByKey(key:Number)
		
		- getIterator():Iterator
		
		- getLabelField():String
		
		- getRowCount():Number
		
		- getRowHeight():Number
		
		- getRowWidth():Number
		

		- getScrollPolicy():Number

		
		- getSelectedIndex():Number
		
		- getSelectedItem()
		
		- indexOf(oItem):Number
		
		- removeItem(oItem)
		
		- removeItemAt(index:Number)
		
		- removeItemsAt(index:Number, len:Number):Array
		
		- removeRange(from:Number, to:Number):Array
		
		- replaceItemAt(index:Number, oItem):Void
		
		- selectedItemAt(index:Number):Void
		
		- selectedItemNext():Void
		
		- selectedItemPrev():Void
		
		- setDataProvider(data)
		
			DESCRIPTION 
			
				clear list and initialize the model.
			
			PARAMS
			
				- data : an Array or a Iterable Object
		
		- setItemIndex( oItem, index:Number):Void
		
		- setLabelField(s:String, render:Boolean ):Void
		
			TODO :: mettre en place l'option render
		
		- setRowCount(n:Number):Void
		
		- setRowHeight(n:Number, noRender:Boolean):Void
		
		- setRowWidth(n:Number, noRender:Boolean):Void
		

		- setScrollPolicy(value:Number):Void

		
		- setSelectedIndex(index:Number):Void
		
		- setSelectedItem(item):Void
		
		- size():Number
		
		- toString():String
		
		- unSelect():Void
		
		- viewDrag : rafraichir l'affichage si l'utilisateur utilise une scrollbar

		- viewResize():Void
		
			override this method (AbstractComponent Method must be overriding)
		
		- viewRollOut 
		
			override this method - Out of a cell.
			
		- viewRollOver():Void
		
			override this method - Over of a cell.
		
		- viewSelect(ev:IEvent):Void
		
			Invoqué quand une cellule est sélectionnée dans la liste, notifie un événement UIEventType.CHANGE
	
	EVENT SUMMARY

		UIEvent
		
	EVENT TYPE SUMMARY
	
		- ADDED:UIEventType
		
		- REMOVED:UIEventType

	INHERIT 
	
		MovieClip 
			|
			AbstractComponent 
				|
				AbstractList
					|
					EasyList

	SEE ALSO
	
		UIEventType, UIEvent, IEvent

	TODO :: finir les tests du composant

	TODO :: voir si je peux placer le resize dans le builder directement
	TODO :: ajouter scrollPolicy CLICK_AND_SCROLL SCROLL NOSCROLL

	TODO :: vérifier les rollOverItem et rollOutItem et renvoyer l'identifiant de la cellule sur laquelle on passe et la cellule

			dans le paramètre child de l'événement !

	

	ADD :: 2006-02-10 scrollPolicy (NONE, AUTO, SCROLL_ON_CLICK, FULL)

	
----------------*/

import com.bourre.events.IEvent;

import neo.display.components.cell.EasyCell;
import neo.display.components.container.AutoScrollContainer;
import neo.display.components.list.AbstractList;
import neo.display.components.list.EasyListBuilder;
import neo.display.components.list.EasyListController;
import neo.display.components.list.EasyListStyle;
import neo.display.components.list.ListView;
import neo.display.components.shape.RectangleComponent;
import neo.display.Direction;
import neo.events.UIEventType;
import neo.util.factory.PropertyFactory;

class neo.display.components.list.EasyList extends AbstractList {

	// ----o Constructor

	public function EasyList() {

		_oController = new EasyListController() ;

 		_oView = new ListView(_oModel, _oController, this) ;

		_oController.setModel(_oModel) ;
		_oController.setView(_oView) ;
		_mcContainer.addEventListener(UIEventType.SCROLL, this, viewScroll) ;
		update() ;
	}
	

	// ----o Constants

	

	static public var BACKGROUND_RENDERER:Function = RectangleComponent ;

	

	static public var NONE:Number = 0 ;

	static public var AUTO:Number = 1 ;

	static public var SCROLL_ON_CLICK:Number = 2 ;

	static public var FULL:Number = AUTO | SCROLL_ON_CLICK ;

	

	static private var __ASPF__ = _global.ASSetPropFlags(EasyList, null, 7, 7) ;

	
	// ----o Public Properties
	

	public var cellRenderer:Function = EasyCell ;
	public var containerRenderer:Function = AutoScrollContainer ;


	public var scrollPolicy:Number ; // [R/W]

	
	public var vPosition:Number ; // [R/W]
	
	// ----o Public Methods


	/*override*/ public function draw():Void {

		resize() ; // recalculer la taille du composant avant d'utiliser le builder.

	}



	public function getScrollPolicy():Number {

		return _scrollPolicy ;

	}


	public function getBackground():MovieClip {
		return _mcBackground ;

	}


	public function getBuilderRenderer():Function {

		return EasyListBuilder ;

	}

	

	public function getStyleRenderer():Function {

		return EasyListStyle ;

	}


	public function getVPosition():Number { 
		var c:MovieClip = getContainer() ;
		return (c.getDirection() == Direction.VERTICAL) ? c.getScroll() : null ;
	}

	public function resize():Void {

		var s:EasyListStyle = EasyListStyle(getStyle()) ;

		var thickness:Number = isNaN(s.thickness) ? 0 : s.thickness ;

		var margin:Number = (isNaN(s.margin) ? 0 : s.margin) + thickness ;

		var spacing:Number = s.spacing ;

		var count:Number = getRowCount() ;

		var rowHeight:Number = (getDataProvider().size() > 0) ? getContainer().getChildAt(0)._height : getRowHeight() ; 

		_h = count * (rowHeight + spacing) + 2 * margin - spacing ;

		_rowWidth = getW() - (2 * margin) ;

	}
	

	public function setScrollPolicy( value:Number , noRender:Boolean):Void {

		_scrollPolicy = value ;

		if (!noRender) update() ;

	}

	
	public function setVPosition(n:Number):Void { 
		var c:MovieClip = getContainer() ;

		if (c.getDirection() == Direction.VERTICAL) c.setScroll(n) ;
	}
	
	public function viewEnabled(oE):Void {
		unSelect() ;
		getContainer().enabled = enabled ;
		notifyScroll() ;
	}

	public function viewScroll(ev:IEvent):Void {
		notifyScroll() ;
	}

	// ----o Virtual Properties


	static private var __SCROLL_POLICY__:Boolean = PropertyFactory.create(EasyList, "scrollPolicy", true) ;
	static private var __VPOSITION__:Boolean = PropertyFactory.create(EasyList, "vPosition", true) ;

	// ----o Private Properties
	
	private var _scrollPolicy:Number = EasyList.AUTO ;

	private var _h:Number = 18 ;
	private var _mcBackground:MovieClip ;
	private var _rowCount:Number = 5 ;
	private var _rowHeight:Number = 18 ;
	private var _w:Number = 180 ;
	
	
}