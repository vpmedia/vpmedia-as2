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

/* -------- ListView

	AUTHOR

		Name : ListView
		Package : neo.display.components.list
		Version : 1.0.0.0
		Date :  2006-02-09
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

			ListView

----------------*/

import com.bourre.core.HashCodeFactory;
import com.bourre.mvc.AbstractView;
import com.bourre.mvc.IController;
import com.bourre.mvc.IModel;

import neo.display.components.container.ContainerModel;
import neo.display.components.list.AbstractListController;
import neo.events.ModelChangedEvent;
import neo.events.ModelChangedEventType;

class neo.display.components.list.ListView extends AbstractView {

	// ----o Constructor

	public function ListView(oModel:IModel, oController:IController, mcContainer:MovieClip) { 
		super(oModel, oController, mcContainer) ;
	}

	// ----o Public Methods


	public function modelChanged(ev:ModelChangedEvent):Void {


		var type:String = ev.getType() ;
		var target:ContainerModel = ev.getTarget() ;

		//Logger.LOG( "[ListView.modelChanged -> eventName : " + ev.eventName , LogLevel.INFO, NeoDebug.channel ) ;

		switch (ev.eventName) {
		
			case ModelChangedEventType.ADD_ITEMS : // ici ajouter une ou des cellules dans le container
				AbstractListController(getController()).viewCreateAt(ev.index) ;
				break ;
			
			case ModelChangedEventType.CLEAR_ITEMS :
				AbstractListController(getController()).viewClear() ;
				break ;
			

			case ModelChangedEventType.REMOVE_ITEMS :
				var first:Number = ev.firstItem ;
				var last:Number = ev.lastItem ;
				AbstractListController(getController()).viewRemove(first, last+1) ;
				break ;

			case ModelChangedEventType.SORT_ITEMS :
				AbstractListController(getController()).viewSort() ;
				break ;

			case ModelChangedEventType.UPDATE_ALL : 
			
				break ; 
			
			case ModelChangedEventType.UPDATE_ITEMS : 
				AbstractListController(getController()).viewUpdateItemAt(ev.index) ;
				break ;
			
			case ModelChangedEventType.UPDATE_FIELD : 

				// ici changer l'affichage d'une cellule en fonction d'un nouveau item
				break ;

			default :

				//
		}

		getViewContainer().update() ;
	}


	public function toString() : String {
		return '[ListView' + HashCodeFactory.getKey( this ) + ']' ;
	}


}