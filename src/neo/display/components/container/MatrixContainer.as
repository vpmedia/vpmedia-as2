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

/* ---------- MatrixContainer

	AUTHOR
	
		Name : MatrixContainer
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- autosize:Boolean [R/W]
		
		- columns:Number [R/W]
		
		- lines:Number [R/W]
	
	METHOD SUMMARY

		* override changeItemsPosition():Void
		
		- draw():Void
		
		* getAutoSize():Boolean
		
		- getBackground():MovieClip
		
		- getBound():Object
		
		* getColumns():Number
		
		- getCoordinateProperty():String
		
		- getDirection():Number
		
		- getItemCount():Number
		
		- getItemPositionAt(n:Number):Number 
		
		* getLines():Number 
		
		- getMask():MovieClip
		
		- getMaskIsActive():Boolean
		
		- getSizeProperty():String
		
		- getSpace():Number
		
		* override resize():Void
		
		* setAutoSize(b:Boolean):Void
		
		* setColumns(n:Number):Void
		
		- setDirection(n:Number):Void
		
		- setItemCount(n:Number):Void
		
		* setLines(n:Number):Void
		
		- setMaskIsActive (bool:Boolean)
		
		- setSpace(n:Number)
		
		- viewEnabled():Void

	INHERIT
	
		AbstractComponent 
			|
			AbstractContainer
				|
				SimpleContainer
					|
					ListContainer
						|
						MatrixContainer

----------  */

import neo.display.components.container.ListContainer;
import neo.display.Direction;
import neo.util.factory.PropertyFactory;

class neo.display.components.container.MatrixContainer extends ListContainer {
	
	// ----o Constructor

	public function MatrixContainer () {
		super() ;
	}

	// ----o Public Properties

	public var autoSize:Boolean ; // [R/W]
	public var columns:Number ; // [R/W]
	public var lines:Number ; // [R/W]

	// ----o Public Methods

	/*override*/ public function changeItemsPosition():Void {
		if ( (_columns > 1 && _nDirection == 0) || (_lines>1 && _nDirection == 1) ) {
			var oC ;
			var c:Number ;
			var l:Number ;
			var n:Number = _oModel.size() ;
			for (var i:Number = 0 ; i<n ; i++) {
				c = (_nDirection == Direction.HORIZONTAL) ? (i%_columns) : Math.floor(i/_lines) ;
				l = (_nDirection == Direction.HORIZONTAL) ? Math.floor(i/_columns) : (i%_lines) ;
				oC = _oModel.getChildAt(i) ;
				oC._x = c * (oC._width + _nSpace) ; 
				oC._y = l * (oC._height + _nSpace) ;
			}
		} else {
			super.changeItemsPosition() ;
		}
	}
	
	public function getAutoSize():Boolean {
		return _autoSize ;
	}

	public function getColumns():Number { 
		return _columns ;
	}

	public function getLines():Number { 
		return _lines ;
	}
	
	public function resize():Void {
		if ( (_lines>1 && _nDirection == 1) || (_columns > 1 && _nDirection == 0) ) {
			if (autoSize) {
				_w = _mcContainer._width ;  
				_h = _mcContainer._height ;
			}
			_bound = {
				w : _w , 
				h : _h 
			};
		} else {
			super.resize() ;
		}

	}

	public function setAutoSize(b:Boolean):Void {
		_autoSize = b ;
		doLater() ;
	}
	
	public function setColumns(n:Number):Void {
		_columns = (n>1) ? n : 1 ;
		update() ;
	}

	public function setLines(n:Number):Void {
		_lines = (n>1) ? n : 1 ;
		update() ;
	}

	// ----o Virtual Properties

	static private var __AUTOSIZE__:Boolean = PropertyFactory.create(MatrixContainer, "autoSize", true) ;
	static private var __COLUMNS__:Boolean = PropertyFactory.create(MatrixContainer, "columns", true) ;
	static private var __LINES__:Boolean = PropertyFactory.create(MatrixContainer, "lines", true) ;
	
	// ----o Private Properties
	
	private var _lines:Number = 3 ;
	private var _columns:Number = 3 ; 
	private var _autoSize:Boolean ;
	
}