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

/** PanelContainer
	
	AUTHOR
	
		Name : PanelContainer
		Package : lunas.display.components.container
		Version : 1.0.0.0
		Date : 2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	METHOD SUMMARY

		- hide([noEvent:Boolean]):Boolean
		
		- show(oKey, [x:Number, [y:Number, noEvent:Boolean]]]):Boolean

	EVENT SUMMARY
	
		PanelEvent
	
	EVENT TYPE SUMMARY
			
		- PanelEventType.HIDE
		
		- PanelEventType.SHOW
	
	INHERIT
	
		AbstractComponent → AbstractContainer → PanelContainer
	
**/

import lunas.display.components.container.AbstractContainer;
import lunas.display.components.container.PanelContainerController;
import lunas.display.components.container.PanelContainerView;
import lunas.events.PanelEvent;
import lunas.events.PanelEventType;

import vegas.util.TypeUtil;

class lunas.display.components.container.PanelContainer extends AbstractContainer {

	// ----o Private Constructor

	public function PanelContainer () {
		_oView = new PanelContainerView(_oModel, null, this) ;
		_oController = new PanelContainerController() ;
		_oController.setModel(_oModel) ;
		_oController.setView(_oView) ;
	}
	
	// ----o Public Methods

	public function show( oKey, x:Number, y:Number, noEvent:Boolean):Boolean {
		hide(true) ;
		if ( TypeUtil.typesMatch(oKey, Number) ) {
			_oldItem = getChildByKey(oKey) ;
			_oldKey = oKey ;
		} else if (contains(oKey)) {
			_oldItem = oKey ;
			_oldKey = oKey.hashCode() ;
		} ;
		if (_oldItem == null) return false ;
		_oldItem._visible = true ;
		_oldItem._x = isNaN(x) ? 0 : x ;
		_oldItem._y = isNaN(y) ? 0 : y ;
		if (noEvent != true) {
			dispatchEvent(new PanelEvent(PanelEventType.SHOW, _oldKey, _oldItem, this) ) ;
		}
		return true ;
	}
	
	public function hide(noEvent:Boolean):Boolean {
		if (_oldItem != undefined) {
			_oldItem._visible = false ;
		} else {
			return false ;	
		}
		if (noEvent != true) {
			dispatchEvent(new PanelEvent(PanelEventType.HIDE, _oldKey, _oldItem, this) ) ;
		}
		reset() ;
		return true ;
	}
	
	public function reset(Void):Void {
		_oldItem = null ;
		_oldKey = null ;
	}

	// ----o Private Properties
	
	private var _oldItem:MovieClip = null ;
	private var _oldKey:Number = null ;	
	
}