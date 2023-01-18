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

import vegas.events.EventListener;
import vegas.util.mvc.IController;
import vegas.util.mvc.IModel;

/**
 * Defines the representation of a view in a specific type of the MVC implementation.
 * @author eKameleon
 */
interface vegas.util.mvc.IView extends EventListener 
{

	/**
	 * Returns the controller reference of this view.
	 */
	function getController():IController;
	
	/**
	 * Returns the container reference of this view.
	 */
	function getViewContainer():MovieClip ;

	/**
	 * Sets the controller reference of this view.
	 */
	function setController(oController:IController):Void ;

	/**
	 * Sets a new model and register this model with this view. 
	 */
	function setModel(oModel:IModel):Void ;

	/**
	 * Sets the container reference of this view.
	 */
	function setViewContainer(mcContainer:MovieClip):Void ;
	
}