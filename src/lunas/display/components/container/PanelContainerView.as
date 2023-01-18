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

import lunas.display.components.container.ContainerModel;
import lunas.display.components.container.PanelContainerController;

import vegas.events.ModelChangedEvent;
import vegas.events.ModelChangedEventType;
import vegas.util.mvc.AbstractView;
import vegas.util.mvc.IController;
import vegas.util.mvc.IModel;

/**
 * The PanelContainerView component. 
 */
class lunas.display.components.container.PanelContainerView extends AbstractView 
{

	/**
	 * Creates a new PanelContainerView 
	 */
	public function PanelContainerView(oModel:IModel, oController:IController, mcContainer:MovieClip) 
	{ 
		super(oModel, oController, mcContainer) ;
	}

	public function handleEvent(ev:ModelChangedEvent):Void 
	{
		
		var eventName:String = ev.getType() ;
		var m:ContainerModel = ev.getTarget() ; // no use for the moment
		var c:PanelContainerController = PanelContainerController(getController()) ;
		
		switch (eventName) 
		{
		
			case ModelChangedEventType.ADD_ITEMS :
			{

				var index:Number = ev.index ;
				if (!isNaN(index)) c.hideAt(index) ;
				break ;
			}	
			case ModelChangedEventType.CLEAR_ITEMS :
			{
				c.removeItems(ev.removedItems) ;
				break ;
			}			
			case ModelChangedEventType.REMOVE_ITEMS :
			{
				c.removeItems(ev.removedItems) ;
				break ;
			}	
			case ModelChangedEventType.UPDATE_ITEMS : 
			{
				break ;
			}			
		}
		getViewContainer().update() ;
	}

}