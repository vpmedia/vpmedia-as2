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

/* -------- AbstractComponent

	AUTHOR

		Name : AbstractContainer
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
	

		- addChild( oChild )

		

		- addChildAt( oChild, index:Number )

		

		- clear():Void

		

		- contains(oChild):Boolean

		

		- createContainer():Void

		

			internal method, use this method to define 'container movieclip'

		

		- getChildAt(index:Number)

		

		- getChildByKey(key:Number)

		

		- getChildByName(name:String)

		

		- getIterator():Iterator

		

		- indexOf(oChild):Number

		

		- removeChild(oChild)

		

		- removeChildAt(index:Number)

		

		- removeChildsAt(index:Number, len:Number):Array

		

		- removeItems(items:Array):Void

		

			Méthode interne, permet de supprimer les childs dans le Container.

			Cette méthode ne change pas le modèle.

		

		- removeRange(from:Number, to:Number):Array

		

		- setChildIndex( oChild, index:Number):Void

		

		- size():Number

		

		- toString():String

	
	EVENT SUMMARY


		UIEvent

		

	EVENT TYPE SUMMARY

	

		- ADDED:UIEventType

		

		- REMOVED:UIEventType

	IMPLEMENTS 
	
		IComponents

	INHERIT 
	
		MovieClip 
			|
			AbstractComponent 
				|
				AbstractContainer

		- AbstractComponent
	
			- enabled:Boolean [R/W]
			
				Défini si le clip doit recevoir les événements d'un bouton ou non.
			
			- h:Number [R/W]
			
				hauteur du composant - attention ne pas confondre avec _height la hauteur du 'clip'.
			
			- group:Boolean [R/W] 
			
				Défini si le composant peut appartenir à un groupe ou non.
			
			- groupName:String [R/W] 
			
				Défini via une chaine de caractère le nom d'un groupe auquel peut être attaché le composant.
				Si la propriété groupName est définie alors la propriété group prend pour valeur automatiquement 'true'.
			
			- minWidth:Number
			
			- minHeight:Number
			
			- maxWidth:Number
			
			- maxHeight:Number
			
			- style:IStyle [R/W] 
				
				renvoi et défini le style du composant.
	
			- w:Number [R/W]
			
				largeur du composant - attention ne pas confondre avec _width la largeur du 'clip'.
	
----------------*/

import neo.display.components.container.AbstractContainer;
import neo.display.components.container.ContainerController;
import neo.display.components.container.ContainerView;

class neo.display.components.container.SimpleContainer extends AbstractContainer {

	// ----o Constructor

	public function SimpleContainer () { 
		_oController = new ContainerController() ;
		_oView = new ContainerView(_oModel, _oController, this) ;
		_oController.setModel(_oModel) ;
		_oController.setView(_oView) ;
	}

}