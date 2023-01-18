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
  Portions created by the Initial Developer are Copyright (C) 2004-2006
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.core.IStyle;
import lunas.display.components.IBuilder;
import lunas.events.StyleEvent;

import pegas.events.UIEvent;
import pegas.events.UIEventType;
import pegas.process.ILockable;

import vegas.core.HashCode;
import vegas.core.IHashable;
import vegas.data.Set;
import vegas.events.Delegate;
import vegas.events.Event;
import vegas.events.EventDispatcher;
import vegas.events.EventListener;
import vegas.events.EventListenerCollection;
import vegas.events.IEventDispatcher;
import vegas.events.TimerEvent;
import vegas.util.factory.DisplayFactory;
import vegas.util.FrameTimer;
import vegas.util.MathsUtil;

/**
 * This class provides a skeletal implementation of all the components in Lunas, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.display.components.AbstractComponent extends MovieClip implements IEventDispatcher, IHashable, ILockable
{

	/**
	 * Creates a new AbstractComponent instance.
	 */
	private function AbstractComponent() 
	{ 
		
		_dispatcher = initEventDispatcher() ;
		
		_focusrect = false ;
		
		_eAdded           = new UIEvent( UIEventType.ADDED, this) ;
		_eChange          = new UIEvent( UIEventType.CHANGE, this) ;
		_eDestroy         = new UIEvent( UIEventType.DESTROY, this) ;
		_eEnabledChanged  = new UIEvent( UIEventType.ENABLED_CHANGE , this) ;
		_eInit            = new UIEvent( UIEventType.INIT , this) ;
		_eRemoved         = new UIEvent( UIEventType.REMOVED, this) ;
		_eRender          = new UIEvent( UIEventType.RENDER, this) ;
		_eResize          = new UIEvent( UIEventType.RESIZE , this) ;
		_eStyleChange     = new UIEvent( UIEventType.STYLE_CHANGE, this) ;
		
		_listenerStyleChange = new Delegate(this, viewStyleChanged) ;
		
		___timer___ = new FrameTimer(24, 1) ;
		___timer___.addEventListener(TimerEvent.TIMER, new Delegate(this, _redraw)) ;
		
		initialize() ;
		
		var bF:Function = getBuilderRenderer() ; 
		if (bF != null) setBuilder( (new bF(this)) ) ;
		
		var sF:Function = getStyleRenderer() ;
		if (sF != null) setStyle( (new sF()) ) ;
		
		_dispatcher.dispatchEvent(_eInit) ;
		
	}

	/**
	 * Returns a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true. 
	 * @return a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true.
	 */
	public function get enabled():Boolean 
	{
		return getEnabled() ;
	}

	/**
	 * Sets a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true. 
	 */
	public function set enabled( b:Boolean ):Void 
	{
		setEnabled(b) ;
	}

	/**
	 * Returns {@code true} if this component is grouped.
	 * @return {@code true} if this component is grouped.
	 */
	public function get group():Boolean 
	{
		return getGroup() ;
	}

	/**
	 * Sets this component is grouped.
	 */
	public function set group( b:Boolean ):Void 
	{
		setGroup(b) ;
	}

	/**
	 * Returns the name of the group of this component.
	 * @return the name of the group of this component.
	 */
	public function get groupName():String 
	{
		return getGroupName() ;
	}

	/**
	 * Sets the name of the group of this component.
	 * @param sName the name of the group or null to unregister the component.
	 */	
	public function set groupName( sName:String ):Void 
	{
		setGroupName( sName ) ;
	}

	/**
	 * (read-only) Returns the virtual height value of this component.
	 * @return the virtual height value of this component.
	 */
	public function get h():Number 
	{
		return getH() ;	
	}

	/**
	 * (read-only) Sets the virtual width value of this component.
	 */
	public function set h( n:Number ):Void 
	{
		setH( n ) ;	
	}

	/**
	 * This property defined the mimimun height of this component.
	 */
	public var minHeight:Number ;

	/**
	 * This property defined the mimimun width of this component.
	 */
	public var minWidth:Number ;

	/**
	 * This property defined the maximum width of this component.
	 */
	public var maxWidth:Number ;
	
	/**
	 * This property defined the maximum height of this component.
	 */
	public var maxHeight:Number ;

	/**
	 * Returns the style of this component.
	 * @return the style of this component.
	 */
	public function get style():IStyle 
	{
		return getStyle() ;
	}
	
	/**
	 * Sets the style of this component.
	 */
	public function set style( s:IStyle ):Void 
	{
		setStyle( s ) ;
	}

	/**
	 * Specifies whether the movie clip is included in automatic tab ordering.
	 */
	public var tabEnabled:Boolean = false ; // not supposed to receive focus
	
	/**
	 * (read-only) Returns the virtual width value of this component.
	 * @return the virtual width value of this component.
	 */
	public function get w():Number 
	{ 
		return getW() ;	
	}
	
	/**
	 * (read-only) Sets the virtual width value of this component.
	 */
	public function set w( n:Number ):Void 
	{
		setW( n ) ;	
	}

	/**
	 * Allows the registration of event listeners on the event target.
	 * @param eventName A string representing the event type to listen for. If eventName value is "ALL" addEventListener use addGlobalListener
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the {@code EventListener} interface.
	 * @param useCapture Determinates if the event flow use capture or not.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addEventListener( eventName:String, listener:EventListener, useCapture:Boolean, priority:Number, autoRemove:Boolean):Void 
	{
		_dispatcher.addEventListener.apply(_dispatcher, arguments);
	}

	/**
	 * Allows the registration of global event listeners on the event target.
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the {@code EventListener} interface.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addGlobalEventListener(listener:EventListener, priority:Number, autoRemove:Boolean):Void 
	{
		_dispatcher.addGlobalEventListener(listener, priority, autoRemove) ;
	}
	
	/**
	 * Creates a child MovieClip, TextField or custom visual instance.
	 * @see DisplayFactory
	 */
	public function createChild( oChild , name:String, depth:Number, oInit) 
	{
		var c:MovieClip = DisplayFactory.createChild( oChild, name, depth, this, oInit) ;
		var ev:UIEvent = new UIEvent( UIEventType.CREATE, this) ;
		ev.child = c ;
		dispatchEvent(ev) ;
		return c ;
	}

	/**
	 * Dispatches an event into the event flow.
	 * @param event The Event object that is dispatched into the event flow.
	 * @param isQueue if the EventDispatcher isn't register to the event type the event is bufferized.
	 * @param target the target of the event.
	 * @param contect the context of the event.
	 * @return the reference of the event dispatched in the event flow.
	 */
	public function dispatchEvent(event, isQueue:Boolean, target, context):Event 
	{
		return _dispatcher.dispatchEvent(event, isQueue, target, context) ;
	}
	
	/**
	 * Launch an event with a delayed interval.
	 */
	public function doLater():Void 
	{
		if (___isLock___) return ;
		___timer___.start() ;
	}

	/**
	 * Draw the view of the component.
	 */
	public function draw():Void 
	{
		// Draw the component.
	}
	
	/**
	 * Returns the IBuilder reference of this instance.
	 */
	public function getBuilder():IBuilder 
	{
		return _builder ;
	}

	/**
	 * Returns the constructor of the IBuilder of this instance. 
	 */
	public function getBuilderRenderer():Function 
	{
		return null ; // override
	}
	
	/**
	 * Returns the internal EventDispatcher reference of this instance.
	 */
	public function getEventDispatcher():EventDispatcher 
	{
		return _dispatcher ;
	}

	/**
	 * Returns the {@code EventListenerCollection} of the specified event name.
	 */
	public function getEventListeners(eventName:String):EventListenerCollection 
	{
		return _dispatcher.getEventListeners(eventName) ;
	}

	/**
	 * Returns the {@code EventListenerCollection} of this EventDispatcher.
	 */
	public function getGlobalEventListeners():EventListenerCollection 
	{
		return getGlobalEventListeners() ;
	}

	/**
	 * Returns a {@code Set} of all register event's name in this EventListener.
	 * @return a {@code Set} of all register event's name in this EventListener.
	 */
	function getRegisteredEventNames():Set 
	{
		return _dispatcher.getRegisteredEventNames() ;
	}
	
	/**
	 * Returns the internal EventDispatcher of this EventTarget.
	 * @return the internal EventDispatcher of this EventTarget.
	 * @see {@link AbstractComponent#getEventDispatcher}
	 */
	public function getDispatcher():EventDispatcher 
	{
		return _dispatcher ;
	}
	
	/**
	 * Returns a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true. 
	 * @return a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true.
	 */
	public function getEnabled():Boolean 
	{ 
		return _enabled ;
	} 
	
	/**
	 * Returns {@code true} if this component is grouped.
	 * @return {@code true} if this component is grouped.
	 */
	public function getGroup():Boolean 
	{ 
		return _group ;
	}
	
	/**
	 * Returns the name of the group of this component.
	 * @return the name of the group of this component.
	 */
	public function getGroupName():String 
	{ 
		return _groupName ;
	}
	
	/**
	 * (read-only) Returns the virtual height value of this component.
	 * @return the virtual height value of this component.
	 */
	public function getH():Number 
	{ 
		return isNaN(_h) ? 0 : _h ;
	}

	/**
	 * Return the parent EventDispatcher of the internal EventDispatcher of this component.
	 */
	public function getParent():EventDispatcher 
	{
		return _dispatcher.parent ;
	}

	/**
	 * Returns the constructor of the IStyle of this instance. 
	 */
	public function getStyleRenderer():Function 
	{
		return null ; // override
	}
	
	/**
	 * Returns the style property from the style declaration or object.
	 */
	public function getStyle():IStyle 
	{ 
		return _style; 
	}

	/**
	 * (read-only) Returns the virtual width value of this component.
	 * @return the virtual width value of this component.
	 */
	public function getW():Number 
	{ 
		return isNaN(_w) ? 0 : _w ;
	}
	
	/**
	 * Invoqued when the group property or the groupName property changed.
	 * Overrides this method in concrete class.
	 */
	public function groupPolicyChanged():Void 
	{
		//
	}

	/**
	 * Returns a hash code value for the object.
	 * @return a hash code value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
	 * This allows you to determine where altered handling of an event type has been introduced in the event flow heirarchy by an EventDispatcher object.
	 */ 
	public function hasEventListener(eventName:String):Boolean 
	{
		return _dispatcher.hasEventListener(eventName) ;
	}

	/**
	 * Initialize in the constructor of this component the internal EventDispatcher reference.
	 * You can override this method to use a global event model.
	 * @see FrontController
	 */
	public function initEventDispatcher():EventDispatcher 
	{
		return new EventDispatcher(this) ;
	}
	
	/**
	 * Returns {@code true} if the components is locked.
	 * @return {@code true} if the components is locked.
	 */
	public function isLocked():Boolean 
	{
		return ___isLock___ ;
	}
	
	/**
	 * Lock the component.
	 */
	public function lock():Void 
	{
		___isLock___ = true ;
	}

	/**
	 * Initialize the component
	 */
	public function initialize():Void 
	{
		// initialize the component !
	}

	/**
	 * Notify when a new child is added in the component.
	 */
	public function notifyAdded(child:MovieClip, index:Number):Void 
	{
		_eAdded.child = child ;
		_eAdded.index = index ;
		dispatchEvent(_eAdded ) ;
	}

	/**
	 * Notify a change in this component.
	 */
	public function notifyChanged():Void 
	{
		dispatchEvent(_eChange) ;
	}

	/**
	 * Notify an event when a child is removed in the component.
	 */
	public function notifyRemoved():Void 
	{
		dispatchEvent(_eRemoved) ;
	}

	/**
	 * Notify an event when you resize the component.
	 */
	public function notifyResized():Void 
	{
		viewResize() ;
		dispatchEvent(_eResize) ;
	}

	/**
	 * Refresh the component with an object of initialization.
	 * This method launch the update() method.
	 */
	public function refresh (oInit):Void 
	{
		for (var each:String in oInit) this[each] = oInit[each] ;
		update() ;
	}

	/** 
	 * Removes a listener from the EventDispatcher object.
	 * If there is no matching listener registered with the EventDispatcher object, then calling this method has no effect.
	 * @param Specifies the type of event.
	 * @param the class name(string) or a EventListener object.
	 */
	public function removeEventListener(eventName:String, listener, useCapture:Boolean):EventListener 
	{
		return _dispatcher.removeEventListener(eventName, listener, useCapture) ;
	}

	/** 
	 * Removes a global listener from the EventDispatcher object.
	 * If there is no matching listener registered with the EventDispatcher object, then calling this method has no effect.
	 * @param the class name(string) or a EventListener object.
	 */
	public function removeGlobalEventListener( listener ):EventListener 
	{
		return _dispatcher.removeGlobalEventListener(listener) ;
	}
	
	/**
	 * Sets the IBuilder instance use to create the view of the component.
	 * @return {@code true} if the new IBuilder is not null.
	 */
	public function setBuilder(b:IBuilder):Boolean 
	{
		if (_builder) 
		{
			_builder.clear() ;
		}
		if (b == null) 
		{
			return false ;
		}
		_builder = b ;
		_builder.setTarget(this) ;
		_builder.run() ;
		return true ;
	}

	/**
	 * Sets a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true. 
	 */
	public function setEnabled(bool:Boolean):Void 
	{
		_enabled = (bool == true) ;
		if (___isLock___) return ;
		viewEnabled() ;
		dispatchEvent(_eEnabledChanged) ;
	}

	/**
	 * Sets if the component is grouped or not.
	 */
	public function setGroup(b:Boolean):Void 
	{
		_group = b ;
		groupPolicyChanged() ;
	}
	
	/**
	 * Sets the name of the group of this component.
	 * @param sName the name of the group or null to unregister the component.
	 */	
	public function setGroupName(sName:String):Void 
	{
		_group = (sName != undefined) ;
		_groupName = sName ;	
		groupPolicyChanged() ;
	}

	/**
	 * Sets the virtual height value of the component.
	 */
	public function setH( n:Number ) : Void 
	{
		_h = MathsUtil.clamp(n, minHeight, maxHeight) ;
		notifyResized() ;
		update() ;
	}

	/**
	 * Sets the parent of the internal EventDispatcher. Uses this method to creates an event flow (bubbling and capturing).
	 */
	public function setParent(parent:EventDispatcher):Void 
	{
		_dispatcher.parent = parent ;
	}

	/**
	 * Sets the virtuals width and height of the component.
	 */
	public function setSize(p_w:Number, p_h:Number) : Void 
	{
		_w = MathsUtil.clamp(p_w, minWidth, maxWidth) ; 
		_h = MathsUtil.clamp(p_h, minHeight, maxHeight) ; 
		notifyResized() ;
		update() ;
	}
	
	/**
	 * Sets the style property on the style declaration or object.
	 */
	public function setStyle(s:IStyle):Void 
	{
		_unregisterStyle() ;
		if (s == undefined) 
		{
			return ;
		}
		_style = s ; 
		_registerStyle() ;
		if (___isLock___) 
		{
			return ;
		}
		dispatchEvent(_eStyleChange) ;
		update() ;
	}
	
	/**
	 * Sets the virtual width value of the component.
	 */
	public function setW( n:Number ) : Void 
	{
		_w = MathsUtil.clamp(n, minWidth, maxWidth) ; 
		notifyResized() ;
		update() ;
	}

	/**
	 * Unlock the component.
	 */
	public function unLock():Void 
	{
		___isLock___ = false ;
	}

	/**
	 * Updates the component. This method is invoqued when the component must be refreh.
	 */
	public function update():Void 
	{
		if (___isLock___) 
		{
			return ;
		}
		draw() ;
		if (_builder) 
		{
			_builder.update() ;
		}
		viewChanged() ;
		dispatchEvent(_eRender) ;
	}
	
	/**
	 * Invoqued after the draw method and when the IBuilder is updated.
	 */
	public function viewChanged():Void 
	{
		// overrides
	}
	
	/**
	 * Invoqued when the component is destroyed with a removeMovieClip.
	 * Overrides this method.
	 */
	public function viewDestroyed():Void 
	{
		// overrides
	}	
	
	/**
	 * Invoqued when the enabled property of the component change.
	 * Overrides this method.
	 */
	public function viewEnabled():Void 
	{
		// overrides
	}
	
	/**
	 * Invoqued when the component is resized.
	 * Overrides this method.
	 */
	public function viewResize():Void 
	{
		// overrides
	}
	
	/**
	 * Invoqued when the component IStyle changed.
	 * Overrides this method.
	 */
	public function viewStyleChanged():Void 
	{
		// overrides
	}
	
	/**
	 * Invoqued when the StyleSheet in the IStyle is changed.
	 * Overrides this method.
	 */
	public function viewStyleSheetChanged():Void 
	{
		// overrides
	}

	private var _builder:IBuilder ;
	
	private var _enabled:Boolean = MovieClip.prototype.enabled ;
	
	private var _groupName:String ;
	
	private var _group:Boolean ;
	
	private var _h:Number ;
	
	private var ___isLock___:Boolean ;
	
	private var ___timer___:FrameTimer ;
	
	private var _dispatcher:EventDispatcher ;
	
	private var _style:IStyle ;
	
	private var _w:Number ;

	private var _eAdded:UIEvent ;	
	
	private var _eChange:UIEvent ;
	
	private var _eDestroy:UIEvent ;
	
	private var _eEnabledChanged:UIEvent ;
	
	private var _eInit:UIEvent ;
	
	private var _eRemoved:UIEvent ;
	
	private var _eRender:UIEvent ;
	
	private var _eResize:UIEvent ;
	
	private var _eStyleChange:UIEvent ;

	private var _listenerStyleChange:EventListener ;
	
	static private var _initHashCode:Boolean = HashCode.initialize(AbstractComponent.prototype) ;

	private function _redraw(ev:TimerEvent):Void 
	{
		___timer___.stop() ;
		update() ;
	}
	
	private function _registerStyle():Void
	{
		if (_style != null)
		{
			_style.addEventListener(StyleEvent.STYLE_CHANGED, _listenerStyleChange) ;
			_style.addEventListener(StyleEvent.STYLE_SHEET_CHANGED, _listenerStyleChange) ;
		}
	}
	
	private function onUnload():Void 
	{
		if (___isLock___) return ;
		viewDestroyed() ;
		dispatchEvent(_eDestroy) ;
	}

	private function _unregisterStyle():Void
	{
		if ( _style != null ) 
		{
			_style.removeEventListener(StyleEvent.STYLE_CHANGED, _listenerStyleChange) ;
			_style.removeEventListener(StyleEvent.STYLE_SHEET_CHANGED, _listenerStyleChange ) ;
			_style = null ;
		}

	}
	
}