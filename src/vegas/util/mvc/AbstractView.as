/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/


import vegas.core.CoreObject;
import vegas.events.Event;
import vegas.util.mvc.AbstractModel;
import vegas.util.mvc.IController;
import vegas.util.mvc.IModel;
import vegas.util.mvc.IView;

/**
 * Abstract class to creates IView implementations.
 * @author eKameleon
 */
class vegas.util.mvc.AbstractView extends CoreObject implements IView 
{

	/**
	 * Abstract contructor, creates an IView instance.
	 */
	private function AbstractView(oModel:IModel, oController:IController, mcContainer:MovieClip) 
	{
		setModel(oModel) ;
		setController(oController) ;
		setViewContainer(mcContainer) ;
	}
	
	/**
	 * Returns the controller reference of this view.
	 */
	public function getController():IController 
	{
		return _oController ;
	}

	/**
	 * Returns the container reference of this view.
	 */
	public function getViewContainer():MovieClip 
	{
		return _mcContainer ;
	}
	
	/**
	 * This method is called whenever an event occurs of the type for which the EventListener interface was registered.
	 * @param e The Event contains contextual information about the event.
	 */
	public function handleEvent(e:Event) 
	{
		//
	}
	
	/**
	 * Register a model with this view.
	 */
	public function registerWithModel( oModel:IModel ):Void 
	{
		AbstractModel( oModel ).addView(this);
	}

	/**
	 * Sets the controller reference of this view.
	 */
	public function setController(oController:IController):Void 
	{
		_oController = oController;
	}
	
	/**
	 * Sets a new model and register this model with this view. 
	 */
	public function setModel(oModel:IModel):Void 
	{
		registerWithModel( oModel ) ;
	}

	/**
	 * Sets the container reference of this view.
	 */
	public function setViewContainer(mcContainer:MovieClip):Void 
	{
		_mcContainer = mcContainer ? mcContainer : _root ;
	}

	/**
	 * Internal view container reference.
	 */
	private var _mcContainer:MovieClip ;

	/**
	 * Internal controller.
	 */
	private var _oController:IController ;

	/**
	 * Internal model.
	 */
	private var _oModel:IModel ;
	
	
}