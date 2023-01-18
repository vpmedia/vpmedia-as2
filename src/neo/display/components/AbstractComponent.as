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

/* -------- AbstractComponent


	AUTHOR


		Name : AbstractComponent
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2006-02-05
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net


	PROPERTY SUMMARY


		- enabled:Boolean [R/W]

		

			Défini si le clip doit recevoir les événements d'un bouton ou non.

		

		- h:Number [R/W]

		

			hauteur du composant - attention ne pas confondre avec _height la hauteur du 'clip'.

		
		- group:Boolean [R/W] 

		

			Défini si le composant peut appartenir à un groupe ou non.
		
		- groupName:String [R/W] 

		

			Défini via une chaine de caractère le nom d'un groupe auquel peut être attaché le composant.

			Si la propriété groupName est définie alors la propriété group prend pour valeur automatiquement 'true'.

		

		- minWidth:Number

		

		- minHeight:Number

		

		- maxWidth:Number

		

		- maxHeight:Number

		

		- style:IStyle [R/W] 

			

			renvoi et défini le style du composant.


		- w:Number [R/W]

		

			largeur du composant - attention ne pas confondre avec _width la largeur du 'clip'.


	METHOD SUMMARY
	

		- addEventListener(e:EventType, oL, f:Function):Void

		

		- addListener (oL, f:Function):Void

		

		- broadcastEvent(e:IEvent):Void

		

		- createChild( oChild , name:String, depth:Number, oInit)

		

		- dispatchEvent(o:Object):Void

		

		- doLater():Void

		

		- draw():Void

		

		- getBuilder():IBuilder

		

		- getEnabled():Boolean

		 

		- getGroup():Boolean

		

		- getGroupName():String

		

		- getH():Number

		

		- getBuilderRenderer():Function 

		

			override this method

			

		- getStyleRenderer():Function

		

			override this method

		

		- getStyle():IStyle

		

		- getW():Number

		

		- groupPolicyChanged():Void

		

			override this method when the groupName changed.

		

		- lock():Void

		

			appliquer une protection sur le composant pour désactiver les événements et les refresh.

		

		- initialize():Void

			initialize the component with this method

		

		- notifyAdded(child:MovieClip, index:Number):Void

		
		- notifyChanged():Void
		

		- notifyRemoved():Void

		

		- notifyResized():Void

		

		- refresh(oInit:Object):Void

		

			update and initialize the component.

		

		- removeEventListener(e:EventType, oL):Void

		

		- removeAllEventListeners(type:String):Void

		

		- removeAllListeners():Void

		

		- removeListener(oL):Void

		

		- setBuilder(b:IBuilder)::Boolean

		

		- setEnabled(bool:Boolean):Void

		

		- setGroup(b:Boolean):Void

		

		- setGroupName(sName:String, bInvalidate:Boolean):Void

		

		- setH(n:Number):Void

		

		- setSize(p_w:Number, p_h:Number):Void

		

		- setStyle(s:IStyle):Void

		

		- setW(n:Number):Void

		

		- unLock():Void

		

		- update():Void

		

		- viewChanged():Void

		

			override this method

		

		- viewEnabled():Void

		

			override this method

		

		- viewResize():Void

		

			override this method when component resize !

		

		- viewStyleChanged():Void

		

			override this method

		

		- viewStyleSheetChanged():Void

		

			override this method

		

		- viewDestroyed():Void

			

			override this method



	EVENT SUMMARY


	IMPLEMENTS 

	

		IEventTarget

	INHERIT 

	

		MovieClip


	SEE ALSO

	

		IBuilder, IStyle

	

----------------*/

import com.bourre.core.HashCodeFactory;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;

import neo.core.IEventTarget;
import neo.display.components.IBuilder;
import neo.display.components.IStyle;
import neo.display.components.StyleEventType;
import neo.events.TimerEvent;
import neo.events.TimerEventType;
import neo.events.UIEvent;
import neo.events.UIEventType;
import neo.util.factory.DisplayFactory;
import neo.util.factory.PropertyFactory;
import neo.util.FrameTimer;
import neo.util.MathsUtil;

class neo.display.components.AbstractComponent extends MovieClip implements IEventTarget {

	// ----o Constructor

	private function AbstractComponent () { 
		
		_oEB = new EventBroadcaster(this) ;
		
		_eAdded           = new UIEvent( UIEventType.ADDED, this) ;
		_eChange          = new UIEvent( UIEventType.CHANGE, this) ;
		_eDestroy         = new UIEvent( UIEventType.DESTROY, this) ;
		_eEnabledChanged  = new UIEvent( UIEventType.ENABLED_CHANGE , this) ;
		_eInit            = new UIEvent( UIEventType.INIT , this) ;
		_eRemoved         = new UIEvent( UIEventType.REMOVED, this) ;
		_eRender          = new UIEvent( UIEventType.RENDER, this) ;
		_eResize          = new UIEvent( UIEventType.RESIZE , this) ;
		_eStyleChange     = new UIEvent( UIEventType.STYLE_CHANGE, this) ;
		
		___timer___ = new FrameTimer(24, 1) ;
		___timer___.addEventListener(TimerEventType.TIMER, this, _redraw) ;
		
		initialize() ;
		
		// ---- init Builder
		var bF:Function = getBuilderRenderer() ; 
		if (bF != null) setBuilder( (new bF(this)) ) ;
		// ---- init Style		
		var sF:Function = getStyleRenderer() ;
		if (sF != null) setStyle( (new sF()) ) ;
		
		_oEB.broadcastEvent(_eInit) ;
		
	}

	// ----o Init HashCodeFactory (security)

	static private var __bInitHashCodeFactory:Boolean = HashCodeFactory.initialize(AbstractComponent.prototype) ;

	// ----o Public Properties
	
	public var enabled:Boolean ; // [RW]
	public var group:Boolean ; // [RW]
	public var groupName:String ; // [RW]

	public var h:Number ; // [RW]

	public var minWidth:Number ;

	public var minHeight:Number ;

	public var maxWidth:Number ;

	public var maxHeight:Number ;

	public var style:IStyle ; // [RW]
	public var tabEnabled:Boolean = false ; // not supposed to receive focus

	public var w:Number ; // [RW]

	// ----o Public Methods
	
	public function addEventListener(e:EventType, oL, f:Function):Void {
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	

	public function addListener (oL, f:Function):Void {
		_oEB.addListener.apply(_oEB, arguments);
	}

	public function broadcastEvent(e:IEvent) : Void {	
		_oEB.broadcastEvent(e) ;
	}

	public function createChild( oChild , name:String, depth:Number, oInit) {
		var c:MovieClip = DisplayFactory.createChild( oChild, name, depth, this, oInit) ;
		var ev:UIEvent = new UIEvent( UIEventType.CREATE, this) ;
		ev.child = c ;
		_oEB.broadcastEvent(ev) ;
		return c ;
	}

	public function dispatchEvent(o:Object):Void {
		_oEB.dispatchEvent(o) ;
	}

	public function doLater():Void {
		if (___isLock___) return ;
		___timer___.start() ;
	}

	public function draw():Void {
		// Permet de redessiner le composant
	}

	public function getBuilder():IBuilder {
		return _builder ;
	}

	public function getBuilderRenderer():Function {
		return null ; // override
	}

	public function getEnabled():Boolean { 
		return _enabled ;
	} 


	public function getGroup():Boolean { 
		return _group ;
	}
	
	public function getGroupName():String { 
		return _groupName ;
	}

	public function getH():Number { 
		return isNaN(_h) ? 0 : _h ;
	}

	public function getStyleRenderer():Function {
		return null ; // override
	}

	public function getStyle():IStyle { 
		return _style; 
	}
	
	public function getW():Number { 
		return isNaN(_w) ? 0 : _w ;
	}

	public function groupPolicyChanged():Void {
		// override this method when the groupName changed.
	}
	
	public function lock():Void {
		___isLock___ = true ;
	}

	public function initialize():Void {
		// initialize the component !
	}

	public function notifyAdded(child:MovieClip, index:Number):Void {
		_eAdded.child = child ;
		_eAdded.index = index ;
		_oEB.broadcastEvent(_eAdded ) ;
	}

	public function notifyChanged():Void {
		_oEB.broadcastEvent(_eChange) ;
	}

	public function notifyRemoved():Void {
		_oEB.broadcastEvent(_eRemoved) ;
	}

	public function notifyResized():Void {
		viewResize() ;
		_oEB.broadcastEvent(_eResize) ;
	}

	public function refresh (oInit):Void {
		for (var each:String in oInit) this[each] = oInit[each] ;
		update() ;
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

	public function setBuilder(b:IBuilder):Boolean {
		if (_builder) _builder.clear() ;
		if (!b) return false ;
		_builder = b ;
		_builder.setTarget(this) ;
		_builder.execute() ;
		return true ;
	}

	public function setEnabled(bool:Boolean):Void {
		_enabled = (bool == true) ;
		if (___isLock___) return ;
		viewEnabled() ;
		_oEB.broadcastEvent(_eEnabledChanged) ;
	}

	public function setGroup(b:Boolean):Void {
		_group = b ;
		groupPolicyChanged() ;
	}
	
	public function setGroupName(sName:String):Void {
		_group = (sName != undefined) ;
		_groupName = sName ;	
		groupPolicyChanged() ;
	}

	public function setH( n:Number ) : Void {
		_h = MathsUtil.clamp(n, minHeight, maxHeight) ;
		notifyResized() ;
		update() ;
	}

	public function setSize(p_w:Number, p_h:Number) : Void {
		_w = MathsUtil.clamp(p_w, minWidth, maxWidth) ; 
		_h = MathsUtil.clamp(p_h, minHeight, maxHeight) ; 
		notifyResized() ;
		update() ;
	}
	
	public function setStyle(s:IStyle):Void {
		if (_style != undefined) {
			_style.removeEventListener(StyleEventType.STYLE_CHANGED, this) ;
			_style = undefined ;
		}
		if (s == undefined) return ;
		_style = s ; 
		_style.addEventListener(StyleEventType.STYLE_CHANGED, this, viewStyleChanged) ;
		_style.addEventListener(StyleEventType.STYLE_SHEET_CHANGED, this, viewStyleChanged) ;

		if (___isLock___) return ;
		_oEB.broadcastEvent(_eStyleChange) ;
		update() ;
	}
	
	public function setW( n:Number ) : Void {
		_w = MathsUtil.clamp(n, minWidth, maxWidth) ; 
		notifyResized() ;
		update() ;
	}
	
	public function unLock():Void {
		___isLock___ = false ;
	}
		
	public function viewChanged():Void {
		// Permet de mettre à jour l'affichage une fois que le composant est réinitialisé
	}

	public function viewDestroyed():Void {
		// changer le composant quand le style change
	}	

	public function viewEnabled():Void {
		// changer le composant en fonction de la propriété enabled
	}
	
	public function viewResize():Void {
		// changer le composant en fonction du dernier resize.
	}

	public function viewStyleChanged():Void {
		update() ;
		// changer le composant quand le style change.
	}
	
	public function viewStyleSheetChanged():Void {
		update() ;
		// changer le composant quand sa feuille de style change.
	}

	public function update():Void {
		if (___isLock___) return ;
		draw() ;
		if (_builder) _builder.update() ;
		viewChanged() ;
		_oEB.broadcastEvent(_eRender) ;
	}
	
	// ----o Virtual Properties
	
	static private var __ENABLED__:Boolean     = PropertyFactory.create(AbstractComponent, "enabled", true) ;
	static private var __GROUP__:Boolean       = PropertyFactory.create(AbstractComponent, "group", true) ;
	static private var __GROUP_NAME__:Boolean  = PropertyFactory.create(AbstractComponent, "groupName", true) ;
	static private var __H__:Boolean           = PropertyFactory.create(AbstractComponent, "h", true) ;
	static private var __STYLE__:Boolean       = PropertyFactory.create(AbstractComponent, "style", true) ;
	static private var __W__:Boolean           = PropertyFactory.create(AbstractComponent, "w", true) ;
	
	// ----o Private Properties

	private var _builder:IBuilder ;
	private var _eAdded:UIEvent ;	
	private var _eChange:UIEvent ;
	private var _eDestroy:UIEvent ;
	private var _eEnabledChanged:UIEvent ;
	private var _eInit:UIEvent ;
	private var _eRemoved:UIEvent ;
	private var _eRender:UIEvent ;
	private var _eResize:UIEvent ;
	private var _eStyleChange:UIEvent ;
	private var _enabled:Boolean = MovieClip.prototype.enabled ;
	private var _groupName:String ;
	private var _group:Boolean ;
	private var _h:Number ;
	private var ___isLock___:Boolean ;
	private var ___timer___:FrameTimer ;
	private var _oEB:EventBroadcaster ;
	private var _style:IStyle ;
	private var _w:Number ;

	// ----o Private Methods

	private function _redraw(ev:TimerEvent):Void {
		___timer___.stop() ;
		update() ;
	}
	
	private function onUnload():Void {
		if (___isLock___) return ;
		getBuilder().clear() ;
		viewDestroyed() ;
		_oEB.broadcastEvent(_eDestroy) ;
	}

	
}