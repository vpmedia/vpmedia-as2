/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.model.IModelObject;
import andromeda.model.IValueObject;

import vegas.events.BasicEvent;

/**
 * The ModelObjectEvent is the basic event use in a IModelObject to notify changed.
 * @author eKameleon
 */
class andromeda.events.ModelObjectEvent extends BasicEvent 
{
	
	/**
	 * Creates a new ModelObjectEvent instance.
	 * @param type the type of the event.
	 * @param target the IModelObject reference of this event.
	 * @param (optional) the IValueObject of this event.
	 */	
	public function ModelObjectEvent( type:String, target:IModelObject , vo:IValueObject ) 
	{
		super( type, target ) ;
		setVO( vo ) ;	
	}

	/**
	 * Default event type when the addVO method is invoqued.
	 */
	static public var ADD_VO:String = "onAddVO" ;

	/**
	 * Default event type when the clear method is invoqued.
	 */
	static public var CLEAR_VO:String = "onClearVO" ;

	/**
	 * Default event type when the setVO method is invoqued.
	 */
	static public var CHANGE_CURRENT_VO:String = "onChangeCurrentVO" ;

	/**
	 * Default event type when the removeVO method is invoqued.
	 */
	static public var REMOVE_VO:String = "onRemoveVO" ;

	/**
	 * Default event type when the removeVO method is invoqued.
	 */
	static public var UPDATE_VO:String = "onUpdateVO" ;
	
	/**
	 * Returns the target reference of this event.
	 * @return the target reference of this event.
	 */
	public function getTarget():IModelObject
	{
		return IModelObject( super.getTarget() ) ;	
	}
	
	/**
	 * Returns a IValueObject reference.
	 * @return a IValueObject reference.
	 */
	public function getVO():IValueObject
	{
		return _vo ;	
	}

	/**
	 * Sets a IValueObject reference.
	 */
	public function setVO( vo:IValueObject ):Void
	{
		_vo = vo || null ;	
	}

	private var _vo:IValueObject ;

}