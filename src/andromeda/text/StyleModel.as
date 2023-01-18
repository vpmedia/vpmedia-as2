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

import andromeda.model.AbstractModel;

import asgard.events.StyleSheetEvent;
import asgard.text.StyleSheet;

/**
 * This model manage the style of the fields in the application with an external CSS.
 * @author eKameleon
 */
class andromeda.text.StyleModel extends AbstractModel 
{

	/**
	 * Creates a new StyleModel instance.
	 * @param id the id of the model.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function StyleModel(  id , bGlobal:Boolean , sChannel:String  ) 
	{
		super( id, bGlobal, sChannel ) ;
		_styleSheet = initStyleSheet() ;
		_eChange = new StyleSheetEvent( StyleSheetEvent.CHANGE ) ;
	}
	
	/**
	 * Returns the event name use when the model change.
	 * @return the event name use when the model change.
	 */
	public function getEventTypeCHANGE():String
	{
		return _eChange.getType() ;
	}

	/**
	 * Returns the styleSheet reference of this event.
	 * @return the styleSheet reference of this event.
	 */
	public function getStyleSheet():StyleSheet
	{
		return _styleSheet ;	
	}
	
	/**
	 * Creates and returns the internal defaut {@code StyleSheet} reference (this method is invoqued in the constructor).
	 * You can overrides this method if you wan use a global {@code StyleSheet} singleton.
	 * @return the default internal {@code StyleSheet} reference.
	 */
	public function initStyleSheet():StyleSheet 
	{
		return new StyleSheet() ;
	}

	/**
	 * Invoqued if the internal StyleSheet object  change.
	 */
	public function notifyChange():Void
	{
		_eChange.setStyleSheet( _styleSheet ) ;
		dispatchEvent( _eChange  ) ;
	}
	
	/**
	 * Returns the event name use when the model change.
	 * @return the event name use when the model change.
	 */
	public function setEventTypeCHANGE( type:String ):Void
	{
		_eChange.setType( type ) ;
	}

	/**
	 * Sets the styleSheet reference of this event.
	 */
	public function setStyleSheet( css:StyleSheet ):Void
	{
		_styleSheet = css ;
		notifyChange() ;
	}

	/**
	 * The internal Event use when the model change.
	 */
	private var _eChange:StyleSheetEvent ;

	/**
	 * The internal StyleSheet reference.
	 */
	private var _styleSheet:StyleSheet ;

}