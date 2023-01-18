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

/* ------- ICell [interface]

	AUTHOR

		Name : ICell
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2006-02-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	DESCRIPTION
		
		Interface pour tous les composants de type Cellule (liste, tableau etc.)

	METHOD SUMMARY
	
		- getDataLabel():String
		
			Renvoi une chaîne contenant le nom du champ de données du composant CellRenderer.
		
		- getCellIndex():Object
		
			Renvoi un objet avec deux champs, columnIndex et rowIndex, indiquant la position de la cellule. 
		
		- getListOwner():MovieClip
		
			Référence à la liste contenant la cellule
		
		- getPreferredHeight():Number
			
			Renvoi la hauteur que devrait avoir une cellule dans la liste.
		
		- getPreferredWidth()
		
			Renvoi la largeur que devrait avoir une cellule dans la liste.
		
		- getSize(w:Number, h:Number):Object
		
		- setCellIndex( itemIndex:Number , columnIndex:Number ):Void
		
			Défini un objet ayant les 2 propriétés itemIndex et columnIndex
		
		- setListOwner(owner:MovieClip):Void
		
			Permet de définir la référence vers la liste contenant la cellule.
		
		- setSize(w:Number, h:Number):Void
			
			Définit la largeur et la hauteur d'une cellule. (tous les composants ont cette méthode)
		
		- setValue():Void
		
			Définit le contenu à afficher dans la cellule.
	
		
----------  */

interface neo.display.components.ICell {
	
	function getCellIndex():Object ;
	
	function getListOwner():MovieClip ;
	
	function getPreferredWidth():Number ;
	
	function getPreferredHeight():Number ;
	
	function setCellIndex( itemIndex:Number , columnIndex:Number ):Void ;
	
	function setListOwner(owner:MovieClip):Void ;
	
	function setSize(w:Number, h:Number):Void ;
	
	function setValue ():Void ;
	
}