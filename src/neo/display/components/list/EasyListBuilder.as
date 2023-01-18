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

/* ---------- EasyListBuilder

	AUTHOR
		
		Name : EasyListBuilder
		Package : neo.display.components.list
		Version : 1.0.0.0
		Date :  2006-02-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR


	PROPERTY SUMMARY
	
		- target:MovieClip

	METHOD SUMMARY
	
		- clear():Void
		
		- execute(e:IEvent):Void
		
		- toString():String
		
		- update():Void

	INHERIT
	
		Object
			|
			CoreObject
				|
				AbstractBuilder
					|
					EasyListBuilder

-------------- */

import neo.display.components.AbstractBuilder;
import neo.display.components.list.EasyList;
import neo.display.components.list.EasyListStyle;

class neo.display.components.list.EasyListBuilder extends AbstractBuilder {
	
	// ----o Constructor

	private function EasyListBuilder( mc:MovieClip ) {
		target = mc ;
	}

	// ----o Public Properties
	
	public var background:MovieClip ;
		
	// ----o Public Methods

	public function clear():Void {
		if(background) background.removeMovieClip() ;
	}
	
	public function execute():Void {
		_createBackground() ;
	}
	
	public function getMargin():Number {
		var s:EasyListStyle = target.getStyle() ;
		var m:Number = 0 ;
		if (!isNaN(s.thickness)) m += s.thickness ;
		if (!isNaN(s.margin)) m += s.margin ;
		return m ;

	}
	
	public function update():Void {
		_refreshContainer() ;
		_refreshBackground() ;	
	}

	// ----o Private Methods


	private function _createBackground():Void {
		background = target.createChild( EasyList.BACKGROUND_RENDERER, "_mcBackground", 0) ;
	}
	
	private function _refreshBackground():Void {
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
	
	private function _refreshContainer():Void {
		var s:EasyListStyle = target.getStyle() ;
		var c:MovieClip = target.getContainer() ;
		var margin:Number = getMargin() ;

		var sp:Number = target.getScrollPolicy() ;

		c.setAutoScroll( sp == EasyList.AUTO || sp == EasyList.FULL ) ;
		c.setSpace( isNaN(s.spacing) ? 0 : s.spacing ) ;
		c.setItemCount(target.getRowCount()) ;
		c._x = margin ;
		c._y = margin  ;
		c.update() ;
	}

}