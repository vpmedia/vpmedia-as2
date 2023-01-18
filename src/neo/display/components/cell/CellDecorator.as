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

/* ------- CellDecorator

	AUTHOR

		Name : CellDecorator
		Package : neo.display.components.cell
		Version : 1.0.0.0
		Date :  2006-02-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	DESCRIPTION
		
		Decorator de tous les composants qui doivent implémenter l'interface ICell

	METHOD SUMMARY
	
		- getDataLabel():String
		
			Renvoi une chaîne contenant le nom du champ de données du composant CellRenderer.
		
		- getCellIndex():Object
		
			Renvoi un objet avec deux champs, columnIndex et rowIndex, indiquant la position de la cellule. 
		
		- getListOwner()
		
			Référence à la liste contenant la cellule
		
		- getPreferredHeight():Number
			
			Renvoi la hauteur que devrait avoir une cellule dans la liste.
		
		- getPreferredWidth()
		
			Renvoi la largeur que devrait avoir une cellule dans la liste.
		
		- getSize(w:Number, h:Number):Object
		
		- initialize():Void
		
		- setCellIndex( itemIndex:Number , columnIndex:Number ):Void
		
			Défini un objet ayant les 2 propriétés itemIndex et columnIndex
		
		- setSize(w:Number, h:Number):Void
			
			override - Définit la largeur et la hauteur d'une cellule. (tous les composants ont cette méthode)
		
		- setValue()
		
			Définit le contenu à afficher dans la cellule.
	
	INHERIT
	
		CoreObject
	
	IMPLEMENTS
	
		IFormattable
		
----------  */

import neo.core.CoreObject;
import neo.display.components.ICell;

class neo.display.components.cell.CellDecorator extends CoreObject implements ICell {

	// ----o Constructor

	public function CellDecorator( t:MovieClip ) { 
		target = t ;
		initialize() ;
	}
	
	// ----o Public Property

	public var target:MovieClip ;

	// ----o Public Methods

	public function getCellIndex():Object {
		return _cellIndex ;

	}
	
	public function getListOwner():MovieClip {
		return _listOwner ;

	}

	public function getPreferredHeight():Number {
		return _listOwner.getRowHeight() || target.getH() ;	
	}
	
	public function getPreferredWidth():Number {
		return _listOwner.getRowWidth() || target.getW() ;

	}
	
	public function getSize(w:Number, h:Number):Object {
		return {
			w : w || getPreferredWidth()  ,
			h : h || getPreferredHeight()
		};
	}
	
	public function initialize():Void {
		// override

	}
	
	public function setCellIndex( itemIndex:Number , columnIndex:Number ):Void {
		_cellIndex = { 
			itemIndex : isNaN(itemIndex) ? null : itemIndex , 
			columnIndex : isNaN(columnIndex) ? null : columnIndex 

		} ;

	}

	public function setListOwner(owner:MovieClip):Void {
		_listOwner = owner ;

	}
	
	public function setSize(w:Number, h:Number):Void {
		// override
	}
	
	public function setValue ():Void {
		// override

	}
	
	// ----o Private Properties
	
	private var _cellIndex:Object ;
	private var _listOwner:MovieClip ;
	
}