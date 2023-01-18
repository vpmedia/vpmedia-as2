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


import asgard.display.Direction;

import lunas.display.components.container.AutoScrollContainer;
import lunas.display.components.list.AbstractListBuilder;
import lunas.display.components.list.EasyList;
import lunas.display.components.list.EasyListStyle;

/**
 * @author eKameleon
 */
class lunas.display.components.list.EasyListBuilder extends AbstractListBuilder 
{
	
	/**
	 * Creates a new EasyListBuilder instance.
	 */
	private function EasyListBuilder( mc:MovieClip ) 
	{
		super(mc) ;
	}

	public var background:MovieClip ;
		
	public function clear():Void 
	{
		if(background) background.removeMovieClip() ;
		super.clear() ;
	}

	public function getContainerRenderer():Function 
	{
		return AutoScrollContainer ;
	}

	public function getMargin():Number 
	{
		var s:EasyListStyle = target.getStyle() ;
		var m:Number = 0 ;
		if (!isNaN(s.thickness)) m += s.thickness ;
		if (!isNaN(s.margin)) m += s.margin ;
		return m ;
	}

	public function run():Void 
	{
		_createBackground() ;
		super.run() ;
	}
		
	public function update():Void 
	{
		super.update() ;
		_refreshBackground() ;	
	}

	private function _createBackground():Void 
	{
		background = target.createChild( EasyList.BACKGROUND_RENDERER, "_mcBackground", 0) ;
	}
	
	private function _refreshBackground():Void 
	{
		var s:EasyListStyle = target.getStyle() ;
		background.refresh ( {
			t : isNaN(s.thickness) ? 0 : s.thickness ,
			lc : s.themeBorderColor || 0 ,
			la : s.themeBorderAlpha || 0 ,
			fc : s.themeColor || 0,
			fa : s.themeAlpha || 0
		} ) ;
		background.setSize( target.getW() , target.getH() ) ;
	}
	
	private function _refreshContainer():Void 
	{
		var s:EasyListStyle = target.getStyle() ;
		var c:MovieClip = target.getContainer() ;
		var margin:Number = getMargin() ;
		var sp:Number = target.getScrollPolicy() ;
		c.setDirection(Direction.VERTICAL);
		c.setAutoScroll( sp == EasyList.AUTO || sp == EasyList.FULL ) ;
		c.setSpace( isNaN(s.spacing) ? 0 : s.spacing ) ;
		c.setItemCount(target.getRowCount()) ;
		c._x = margin ;
		c._y = margin  ;
		c.update() ;
	}

}