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

/* ------- 	EasyProgressbar

	AUTHOR
	
		Name : EasyProgressbar
		Package : neo.display.components.bar
		Version : 1.0.0.0
		Date :  2006-02-21
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- direction:Number [R/W]
		
		- position:Number [R/W]
	
	METHOD SUMMARY
		
		- getDirection():Number
		
		- getPosition():Number
		

		- resize():Void

				
		- setDirection(n:Number):Void
		
		- setPosition(pos:Number, noEvent:Boolean):Void
		
	
	EVENT TYPE SUMMARY
	
		- CHANGE:EventType
	
----------  */

import neo.display.components.bar.AbstractProgressbar;
import neo.display.components.shape.RectangleComponent;
import neo.display.Direction;

class neo.display.components.bar.EasyProgressbar extends AbstractProgressbar {

	// ----o Constructor
	
	public function EasyProgressbar() {
		super() ;

		_createBackground() ;
		_createBar() ;
		setSize(150, 6) ;
	}

	// ----o Constant
	

	static public var BACKGROUND_RENDERER:Function = RectangleComponent ;
	static public var BAR_RENDERER:Function = RectangleComponent ;
	

	// ----o Public Properties

	

	public var background:MovieClip ;

	public var bar:MovieClip ;

	public var border:Number = 0 ;

	

	// ----o Public Methods		


	public function resize():Void {

		bar._x = border ;

		bar._y = border ;

		var nB:Number = 2 * border ;

		var nD:Number = getDirection() ;

		var max:Number = (nD == Direction.VERTICAL) ? getH() : getW() ;

		var size:Number =  Math.floor(getPosition() * (max - nB) / 100) ;

		var __w:Number = (nD == Direction.VERTICAL) ? (_w-nB) : size  ;

		var __h:Number = (nD == Direction.VERTICAL) ? size : (_h - nB) ;

		bar.setSize(__w, __h) ;

	}


	public function viewChanged():Void {

		_refreshBackground() ;
		_refreshBar() ;
	}

	public function viewPositionChanged():Void {

		resize() ;

	}


	// ----o Private Methods


	private function _createBackground():Void {

		createChild(BACKGROUND_RENDERER, "background", 0) ;

	}

	
	private function _createBar():Void {
		createChild(BAR_RENDERER, "bar", 1) ;
	}


	private function _refreshBackground():Void {

		background.refresh( {

			t : 1 , la : 100 , lc : 0xFFFFFF ,

			fc : 0xD0330D , fa : 100

		} ) ;

		background.setSize(_w, _h) ;

	}


	private function _refreshBar():Void {

		bar.refresh( {
			t : null , la : null , lc : null ,
			fc : 0xF8E2B1 , fa : 100
		} ) ;

		resize() ;

	}

	
}