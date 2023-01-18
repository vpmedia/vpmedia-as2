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

import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.ModelChangedEvent;
import vegas.util.mvc.IModel;
import vegas.util.mvc.IView;

/**
 * Abstract class to creates IModel implementations.
 * @author eKameleon
 */
class vegas.util.mvc.AbstractModel extends AbstractCoreEventDispatcher implements IModel 
{

	/**
	 * Abstract contructor, creates an IModel instance.
	 */
	private function AbstractModel() 
	{
		//
	}
	
	/**
	 * Adds a view in the model.
	 */
	public function addView(view:IView):Void 
	{
		addGlobalEventListener(view) ;
	}

	/**
	 * Returns a shallow copy of this object.
	 */	
	public function clone() 
	{
		//
	}
	
	/**
	 * Notify a ModelChangedEvent to the views.
	 */
	public function notifyChanged(ev:ModelChangedEvent):Void 
	{
		dispatchEvent(ev) ;
	}
	
	/**
	 * Removes a view in the model.
	 */
	public function removeView(view:IView):Void 
	{
		removeGlobalEventListener(view) ;
	}


}