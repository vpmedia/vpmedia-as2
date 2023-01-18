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
import vegas.util.mvc.IController;
import vegas.util.mvc.IModel;
import vegas.util.mvc.IView;

/**
 * Abstract class to creates IController implementations.
 * @author eKameleon
 */
class vegas.util.mvc.AbstractController extends CoreObject implements IController 
{

	/**
	 * Abstract contructor, creates an IController instance.
	 */
	private function AbstractController() {
		
	}
	
	/**
	 * Returns the model of this controller.
	 */
	public function getModel():IModel 
	{
		return _oModel ;
	}
	
	/**
	 * Returns the view of this controller.
	 */
	public function getView():IView 
	{
		return _oView ;
	}
	
	/**
	 * Sets the model of this controller. 
	 */
	public function setModel(oModel:IModel):Void 
	{
		_oModel = oModel ;
	}
	
	/**
	 * Sets the view of this controller.
	 */
	public function setView(oView:IView):Void 
	{
		_oView = oView ;
	}

	/**
	 * Internal view reference.
	 */
	private var _oView:IView ;
	
	/**
	 * Internal model reference.
	 */
	private var _oModel:IModel ;
	
}