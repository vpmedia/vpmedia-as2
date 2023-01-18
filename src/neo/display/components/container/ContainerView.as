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

/* -------- ContainerView

	AUTHOR

		Name : ContainerView
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
	
		- getController():IController
		
		- getViewContainer():MovieClip
		
		- registerWithModel( oModel:IModel ):Void
		
		- setController(oController:IController):Void
		
		- setModel(oModel:IModel):Void
		
		- setViewContainer(mcContainer:MovieClip):Void

	IMPLEMENTS 
	
		IView

	INHERIT 
	
		AbstractView 

			|

			ContainerView

----------------*/

import com.bourre.core.HashCodeFactory;
import com.bourre.mvc.AbstractView;
import com.bourre.mvc.IController;
import com.bourre.mvc.IModel;

import neo.display.components.container.ContainerController;
import neo.display.components.container.ContainerModel;
import neo.events.ModelChangedEvent;
import neo.events.ModelChangedEventType;

class neo.display.components.container.ContainerView extends AbstractView {

	// ----o Constructor

	public function ContainerView(oModel:IModel, oController:IController, mcContainer:MovieClip) { 
		super(oModel, oController, mcContainer) ;
	}

	// ----o Public Methods


	public function modelChanged(ev:ModelChangedEvent):Void {
		var type:String = ev.getType() ;
		var target:ContainerModel = ev.getTarget() ;
		var c:ContainerController = ContainerController(getController()) ;
		switch (ev.eventName) {

			case ModelChangedEventType.ADD_ITEMS :
				//
				break ;
			
			case ModelChangedEventType.CLEAR_ITEMS :
				
				c.removeItems(ev.removedItems) ;
				break ;
			
			case ModelChangedEventType.REMOVE_ITEMS :
				c.removeItems(ev.removedItems) ;
				break ;

			case ModelChangedEventType.UPDATE_ITEMS : 
				//
				break ;

			default :
				//
		}
		getViewContainer().update() ;
	}

	public function toString() : String {
		return '[ContainerView' + HashCodeFactory.getKey( this ) + ']' ;
	}

}