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

/* ---------- PanelManager

	AUTHOR
	
		Name : PanelManager
		Package : neo.display.manager
		Version : 1.0.0.0
		Date : 2006-02-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	DESCRIPTION 
	
		Classe Singleton. Permet de gérer un PanelContainer situé sur la scène principale ou dans un clip.

	METHOD SUMMARY
		
			addChild(o, [oInit]):MovieClip
			
			show(key, [x, y, reference])
				
			hide()
			
			removeChildByKey(key)
			
			getIChildByKey(key)
		
			create()
			
			destroy()
			
			getPanel()
		
	EVENTS
		
			status(ev)
			
				ev.code : 
					- create : invoqué lors de la création du PanelContainer
					- destroy : invoqué lorsque l'on détruit le PanelContainer
					
			panelHide(ev)
				ev.item
				ev.key
				ev.target
				ev.type
				
			panelShow
				ev.item
				ev.key
				ev.target
				ev.type

	TODO   :: refaire la documentation 
	CHANGE :: La méthode initialize est maintenant automatiquement lancée à la création de l'instance Singleton.
	
----------  */

import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;

import neo.core.CoreObject;
import neo.core.IEventTarget;
import neo.display.components.container.PanelContainer;
import neo.events.PanelEvent;
import neo.events.PanelEventType;
import neo.util.factory.DisplayFactory;

class neo.display.manager.PanelManager extends CoreObject implements IEventTarget {

	// ----o CONSTRUCTOR

	private function PanelManager () {
		_oEB = new EventBroadcaster(this) ;
	}

	// ----o STATIC
	
	static public var ROOT:MovieClip ;
	static public var PANEL_RENDERER:Function = PanelContainer ;
	
	// ----o SINGLETON
	
	static private var _instance:PanelManager ;
	static public function getInstance():PanelManager {
		if (_instance == undefined) {
			 _instance = new PanelManager() ;
			 _instance.initialize() ;
		}
		return _instance ;
	}

	// ----o METHODS
	
	public function addChild(o, oInit):MovieClip { 
		return _mPanel.addChild(o, oInit) ;
	}
	
	public function addEventListener(e:EventType, oL, f:Function):Void {
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	public function addListener (oL, f:Function):Void {
		_oEB.addListener.apply(_oEB, arguments);
	}
	
	public function broadcastEvent(e:IEvent) : Void {	
		_oEB.broadcastEvent(e) ;
	}

	public function dispatchEvent(o:Object):Void {
		_oEB.dispatchEvent(o) ;
	}
		
	public function destroy():Void {
		_mPanel.removeMovieClip() ;
		_oEB.broadcastEvent( new PanelEvent(PanelEventType.DESTROY) ) ;
	}

	public function getChildByKey(key:Number):MovieClip {
		return _mPanel.getChildByKey(key) ;
	}
	
	public function getPanel():MovieClip { 
		return _mPanel ;
	}
	
	public function initialize():Void {
		if (!_mPanel) {
			Stage.addListener(this) ;
			_mPanel = DisplayFactory.createChild(PanelManager.PANEL_RENDERER, "__PANEL__" , 9775, ROOT || _root) ;
			_mPanel.addEventListener(PanelEventType.HIDE, this) ;
			_mPanel.addEventListener(PanelEventType.SHOW, this) ;
			_oEB.broadcastEvent( new PanelEvent(PanelEventType.CREATE)) ;
		}
	}

	public function hide():Void {
		_mPanel.hide() ;
		Mouse.removeListener(this) ;
	}
	
	public function onHide(ev:PanelEvent):Void {
		_currentItem = undefined ;
		_oEB.broadcastEvent( new PanelEvent(PanelEventType.HIDE, ev.key, ev.item) ) ; // use bubbling ??
	}

	public function onShow(ev:PanelEvent):Void {
		Mouse.addListener(this) ;
		_currentItem = ev.item ;
		_oEB.broadcastEvent( new PanelEvent(PanelEventType.SHOW, ev.key, ev.item) ) ; // use bubbling ??
	}
	
	public function removeChildBy(key:Number):Void {
		_mPanel.removeChild(getChildByKey(key)) ;
	}
	
	public function removeEventListener(e:EventType, oL):Void {
		_oEB.removeEventListener(e, oL);
	}
	
	public function removeAllEventListeners(type:String):Void {
		_oEB.removeAllEventListeners(type) ;
	}
	
	public function removeAllListeners():Void {
		_oEB.removeAllListeners() ;
	}
	
	public function removeListener(oL):Void {
		_oEB.removeListener(oL) ;
	}
	
	public function show(key:Number, x:Number, y:Number, reference:MovieClip):Void {
		var oP = { x : x , y : y } ;
		if (reference != undefined) reference.localToGlobal(oP) ;
		_mPanel.show(key, oP.x, oP.y) ;
	}
	
	// ----o Private Properties

	private var _currentItem:MovieClip ;
	private var _mPanel:MovieClip ;
	private var _oEB:EventBroadcaster ;

	// ----o Private Methods

	private function _isOut(mc:MovieClip):Boolean {
		var mX = mc._xmouse ;
		var mY = mc._ymouse ;
		var minX = 0 ;
		var minY = 0 ;
		var maxX = (mc.w > minX) ? mc.w : mc._width ;
		var maxY = (mc.h > minY) ? mc.h : mc._height ;
		return (mX < minX || mX > maxX || mY < minY || mY > maxY) ;
	}

	private function onMouseDown():Void {
		if (_isOut(_currentItem)) hide() ;
	}
	
	private function onResize():Void { 
		hide() ;
	}

}