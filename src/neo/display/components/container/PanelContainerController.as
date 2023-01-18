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

/* -------- PanelContainerController

	AUTHOR

		Name : PanelContainerController
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-10
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
	
		- getModel():IModel
		
		- getView():IView
		
		- hideAt(index:Number):Void
		
		- removeItems(items:Array):Void
		
		- setModel(oModel:IModel):Void
		
		- setView(oView:IView):Void

	IMPLEMENTS 
	
		IController

	INHERIT 
	
		AbstractController 
			|	
			ContainerController
				|
				PanelContainerController


----------------*/

import com.bourre.core.HashCodeFactory;

import neo.display.components.container.ContainerController;
import neo.display.components.container.ContainerModel;

class neo.display.components.container.PanelContainerController extends ContainerController {

	// ----o Constructor

	public function PanelContainerController() { 
		//
	}

	// ----o Public Methods

	public function hideAt(index:Number):Void {
		ContainerModel(getModel()).getChildAt(index)._visible = false ;
	}

	public function toString() : String {
		return '[PanelContainerController' + HashCodeFactory.getKey( this ) + ']' ;
	}

}