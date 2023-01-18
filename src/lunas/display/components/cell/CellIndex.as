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

/** CellIndex

	AUTHOR

		Name : CellIndex
		Package : lunas.display.components.cell
		Version : 1.0.0.0
		Date :  2006-04-03
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	DESCRIPTION
		
		Permet de définir l'index d'une cellule dans une liste ou dans un tableau.

	PROPERTY SUMMARY
	
		- columnIndex:Number [R/W]
		
		- itemIndex:Number [R/W]

	METHOD SUMMARY
	
		- getColumnIndex():Number
		
		- getItemIndex():Number

		- setColumnIndex( n:Number ):Void
		
		- setItemIndex( n:Number ):Void

	INHERIT
	
		CoreObject → CellIndex
	
	IMPLEMENTS
	
		IFormattable, IHashable
		
**/

import vegas.core.CoreObject;

class lunas.display.components.cell.CellIndex extends CoreObject {

	// ----o Constructor

	public function CellIndex( index:Number, column:Number ) { 
		setColumnIndex(column) ;
		setItemIndex(index) ;
	}
	
	// ----o Public Property

	// public var columnIndex:Number ; // [R/W]
	// public var itemIndex:Number ; // [R/W]

	// ----o Public Methods

	public function getColumnIndex():Number {
		return _columnIndex ; 
	}

	public function getItemIndex():Number {
		return _itemIndex ;
	}

	public function setColumnIndex( n:Number ):Void {
		_columnIndex = isNaN(n) ? null : n ; 
	}

	public function setItemIndex( n:Number ):Void {
		_itemIndex = isNaN(n) ? null : n ;
	}

	// ----o Virtual Properties
	
	public function get columnIndex():Number {
		return getColumnIndex() ;
	}
	
	public function set columnIndex(n:Number):Void {
		setColumnIndex(n) ;
	}
	
	public function get itemIndex():Number {
		return getItemIndex() ;
	}
	
	public function set itemIndex(n:Number):Void {
		setItemIndex(n) ;
	}

	// ----o Private Properties

	private var _columnIndex:Number = null ;	
	private var _itemIndex:Number = null ;

	
}