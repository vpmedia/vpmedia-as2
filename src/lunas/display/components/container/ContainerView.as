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

/** ContainerView

	AUTHOR

		Name : ContainerView
		Package : lunas.display.components.container
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

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
	
		AbstractView → ContainerView

**/

import lunas.display.components.container.ContainerController;
import lunas.display.components.container.ContainerModel;

import vegas.events.ModelChangedEvent;
import vegas.events.ModelChangedEventType;
import vegas.util.mvc.AbstractView;
import vegas.util.mvc.IController;
import vegas.util.mvc.IModel;

class lunas.display.components.container.ContainerView extends AbstractView 
{

	// ----o Constructor

	public function ContainerView(oModel:IModel, oController:IController, mcContainer:MovieClip) 
	{ 
		super(oModel, oController, mcContainer) ;
	}

	// ----o Public Methods

	public function handleEvent(ev:ModelChangedEvent):Void 
	{
		var eventName:String = ev.getType() ;
		var target:ContainerModel = ev.getTarget() ;
		var c:ContainerController = ContainerController(getController()) ;
		switch (eventName) 
		{
		
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

}