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

// TODO finir les tests du composant
// TODO voir si je peux placer le resize dans le builder directement
// TODO ajouter scrollPolicy CLICK_AND_SCROLL SCROLL NOSCROLL
// TODO vérifier les rollOverItem et rollOutItem et renvoyer l'identifiant de la cellule sur laquelle on passe et la cellule dans le paramètre child de l'événement !

import asgard.display.Direction;

import lunas.display.components.cell.EasyCell;
import lunas.display.components.container.AutoScrollContainer;
import lunas.display.components.list.AbstractList;
import lunas.display.components.list.EasyListBuilder;
import lunas.display.components.list.EasyListController;
import lunas.display.components.list.EasyListStyle;
import lunas.display.components.list.ListView;
import lunas.display.components.shape.RectangleComponent;

import vegas.events.Event;

class lunas.display.components.list.EasyList extends AbstractList 
{

	/**
	 * Creates a  new EasyList instance.
	 */
	public function EasyList() 
	{
		super() ;
		update() ;
	}
	
	static public var BACKGROUND_RENDERER:Function = RectangleComponent ;
	
	static public var NONE:Number = 0 ;
	static public var AUTO:Number = 1 ;
	static public var SCROLL_ON_CLICK:Number = 2 ;
	static public var FULL:Number = AUTO | SCROLL_ON_CLICK ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(EasyList, null, 7, 7) ;
	
	public var cellRenderer:Function = EasyCell ;

	public var containerRenderer:Function = AutoScrollContainer ;

	public function get scrollPolicy():Number 
	{
		return getScrollPolicy() ;	
	}
	
	public function set scrollPolicy(n:Number):Void 
	{
		setScrollPolicy(n) ;	
	}
	
	public function get vPositiony():Number 
	{
		return getVPosition() ;	
	}
	
	public function set vPosition(n:Number):Void 
	{
		setVPosition(n) ;	
	}
	
	/*override*/ public function draw():Void {
		resize() ; // recalculer la taille du composant avant d'utiliser le builder.
	}

	/*override*/ public function initialize():Void {
		super.initialize() ;
		_oController = new EasyListController() ;
 		_oView = new ListView(_oModel, _oController, this) ;
		_oController.setModel(_oModel) ;
		_oController.setView(_oView) ;
	}

	public function getScrollPolicy():Number {
		return _scrollPolicy ;
	}

	public function getBackground():MovieClip {
		return _mcBackground ;
	}

	public function getBuilderRenderer():Function 
	{
		return EasyListBuilder ;
	}

	public function getController():EasyListController 
	{
		return EasyListController(_oController) ;
	}
	
	public function getStyleRenderer():Function 
	{
		return EasyListStyle ;
	}

	public function getVMaxPosition():Number 
	{
		return getContainer().getMaxscroll() ;
	}

	public function getVPosition():Number 
	{ 
		var c:MovieClip = getContainer() ;
		return (c.getDirection() == Direction.VERTICAL) ? c.getScroll() : null ;
	}

	public function resize():Void 
	{
		var s:EasyListStyle = EasyListStyle(getStyle()) ;
		var thickness:Number = isNaN(s.thickness) ? 0 : s.thickness ;
		var margin:Number = (isNaN(s.margin) ? 0 : s.margin) + thickness ;
		var spacing:Number = s.spacing ;
		var count:Number = getRowCount() ;
		var rowHeight:Number = (getDataProvider().size() > 0) ? getContainer().getChildAt(0)._height : getRowHeight() ; 
		_h = count * (rowHeight + spacing) + 2 * margin - spacing ;
		_rowWidth = getW() - (2 * margin) ;
	}
	
	public function setScrollPolicy( value:Number , noRender:Boolean):Void 
	{
		_scrollPolicy = value ;
		if (!noRender) update() ;
	}
	
	public function setVPosition(n:Number):Void 
	{ 
		var c:MovieClip = getContainer() ;
		if (c.getDirection() == Direction.VERTICAL) c.setScroll(n) ;
	}
	
	public function viewEnabled(oE):Void 
	{
		unSelect() ;
		getContainer().enabled = enabled ;
		notifyScroll() ;
	}

	public function viewScroll(ev:Event):Void 
	{
		notifyScroll() ;
	}
	
	private var _scrollPolicy:Number = EasyList.AUTO ;
	private var _h:Number = 18 ;
	private var _mcBackground:MovieClip ;
	private var _rowCount:Number = 5 ;
	private var _rowHeight:Number = 18 ;
	private var _w:Number = 180 ;
	
	
}