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

/* -------- PanelContainerView

	AUTHOR

		Name : PanelContainerView
		Package : neo.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-08
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

import neo.display.components.container.ContainerModel;
import neo.display.components.container.PanelContainerController;
import neo.events.ModelChangedEvent;
import neo.events.ModelChangedEventType;

class neo.display.components.container.PanelContainerView extends AbstractView {

	// ----o Constructor

	public function PanelContainerView(oModel:IModel, oController:IController, mcContainer:MovieClip) { 
		super(oModel, oController, mcContainer) ;
	}

	// ----o Public Methods

	public function modelChanged(ev:ModelChangedEvent):Void {
		var type:String = ev.getType() ;
		var m:ContainerModel = ev.getTarget() ; // no use for the moment
		var c:PanelContainerController = PanelContainerController(getController()) ;
		switch (ev.eventName) {
		
			case ModelChangedEventType.ADD_ITEMS :

				var index:Number = ev.index ;
				if (!isNaN(index)) c.hideAt(index) ;

				
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
		return '[PanelContainerView' + HashCodeFactory.getKey( this ) + ']' ;
	}


}