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


/* ---------- PanelContainer
	
	Name : PanelContainer
	Package : neo.display.components.container
	Version : 1.0.0.0
	Date : 2006-02-07
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

	METHODS
	
		show(key, [x, y])
		hide([noEvent])
		
	EVENTS
	
		panelHide
		panelShow
	
----------  */

import neo.display.components.container.AbstractContainer;
import neo.display.components.container.PanelContainerController;
import neo.display.components.container.PanelContainerView;
import neo.events.PanelEvent;
import neo.events.PanelEventType;

class neo.display.components.container.PanelContainer extends AbstractContainer {

	// ----o Private Constructor

	public function PanelContainer () {
		_oView = new PanelContainerView(_oModel, null, this) ;
		_oController = new PanelContainerController() ;
		_oController.setModel(_oModel) ;
		_oController.setView(_oView) ;
	}
	
	// ----o Public Methods

	public function show(key:Number, x:Number, y:Number, noEvent:Boolean):Void {
		hide(true) ;
		_oldItem = getChildByKey(key) ;
		if (_oldItem == null) return ;
		_oldKey = key ;
		_oldItem._visible = true ;
		_oldItem._x = x || 0 ;
		_oldItem._y = y || 0 ;
		if (noEvent != true) broadcastEvent(new PanelEvent(PanelEventType.SHOW, _oldKey, _oldItem, this) ) ;
	}
	
	public function hide(noEvent:Boolean):Void {
		if (_oldItem != undefined) {
			_oldItem._visible = false ;
		}
		if (noEvent != true) broadcastEvent(new PanelEvent(PanelEventType.HIDE, _oldKey, _oldItem, this) ) ;
		reset() ;
	}
	
	public function reset(Void):Void {
		_oldItem = undefined ;
		_oldKey = undefined ;
	}

	// ----o Private Properties
	
	private var _oldItem:MovieClip ;
	private var _oldKey:Number ;	
	
}