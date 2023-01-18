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

import asgard.display.ConfigurableDisplayObject;
import asgard.display.DisplayObject;

import lunas.core.IBuilder;
import lunas.core.IGroupable;
import lunas.core.IStyle;
import lunas.events.StyleEvent;

import pegas.events.UIEvent;

import vegas.events.Delegate;
import vegas.events.EventListener;
import vegas.events.TimerEvent;
import vegas.util.ConstructorUtil;
import vegas.util.FrameTimer;
import vegas.util.MathsUtil;

/**
 * This class provides a skeletal implementation of all the components in Lunas, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.display.abstract.AbstractComponentDisplay extends ConfigurableDisplayObject implements IGroupable
{

	/**
	 * Creates a new AbstractComponentDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	private function AbstractComponentDisplay( sName:String, target:MovieClip ) 
	{ 
		
		super ( (sName != null) ? sName : getDefaultName(this) , target ) ;
		
		view.onUnload = Delegate.create(this, _onUnload) ;
		view._focusrect = false ;
		
		initEvent() ;
		
		_listenerStyleChange = new Delegate(this, viewStyleChanged) ;
		
		initialize() ;
		
		var bF:Function = getBuilderRenderer() ; 
		if (bF != null) 
		{
			setBuilder( (new bF(this)) ) ;
		}
		
		var sF:Function = getStyleRenderer() ;
		if (sF != null) 
		{
			setStyle( (new sF()) ) ;
		}
		
		___timer___ = new FrameTimer(24, 1) ;
		___timer___.addEventListener(TimerEvent.TIMER, new Delegate(this, _redraw)) ;
		
		
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
	 * A Boolean value that, when set to true (the default), indicates whether a pointing hand (hand cursor) displays when the mouse rolls over a button. 
	 * If this property is set to false, the arrow pointer is used instead. 
	 */
	public function get useHandCursor():Boolean 
	{
		return view.useHandCursor ;
	}

	/**
	 * Sets A Boolean value that, when set to true (the default), indicates whether a pointing hand (hand cursor) displays when the mouse rolls over a button. 
	 * If this property is set to false, the arrow pointer is used instead. a Boolean value that indicates whether a movie clip is enabled. The default value of enabled is true. 
	 */
	public function set useHandCursor( b:Boolean ):Void 
	{
		view.useHandCursor = b ;
	}

	/**
	 * The view of the display.
	 */
	public var view:MovieClip ;
	
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
	 * Creates and returns a new child in the view of the display.
	 * @return a new Child in the view of the display
	 * @see DisplayFactory.createChild
	 */
	public function createChild( oChild , name:String, depth:Number, oInit) 
	{
		var child = super.createChild( oChild, name, depth, this, oInit) ;
		_eCreate.child = child ;
		dispatchEvent(_eCreate) ;
		return child ;
	}

	/**
	 * Launch an event with a delayed interval.
	 */
	public function doLater():Void 
	{
		if (isLocked()) 
		{
			return ;
		}
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
	 * Returns the constructor function of the {@code IBuilder} of this instance.
	 * @return the constructor function of the {@code IBuilder} of this instance.
	 */
	public function getBuilderRenderer():Function 
	{
		return null ; // override
	}
	
	/**
	 * Returns the default name of the component display passed-in argument.
	 * @return the default name of the component display passed-in argument.
	 */
	static public function getDefaultName( display:DisplayObject ):String
	{
		return ConstructorUtil.getName(display) + (_counterName ++) ;
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
	 * Initialize the component.
	 * You ca overrides this method and use the super.initialize() method inside.
	 */
	public function initialize():Void 
	{
		dispatchEvent( _eInit ) ;
	}
	
	/**
	 * Initialize all events dispatched in this components.
	 */
	public function initEvent():Void
	{
		_eAdded           = new UIEvent( UIEvent.ADDED   , this) ;
		_eChange          = new UIEvent( UIEvent.CHANGE  , this) ;
		_eCreate          = new UIEvent( UIEvent.CREATE  , this) ;
		_eDestroy         = new UIEvent( UIEvent.DESTROY , this) ;
		_eEnabledChanged  = new UIEvent( UIEvent.ENABLED_CHANGE , this) ;
		_eInit            = new UIEvent( UIEvent.INIT    , this) ;
		_eRemoved         = new UIEvent( UIEvent.REMOVED , this) ;
		_eRender          = new UIEvent( UIEvent.RENDER  , this) ;
		_eResize          = new UIEvent( UIEvent.RESIZE  , this) ;
		_eStyleChange     = new UIEvent( UIEvent.STYLE_CHANGE, this) ;	
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
		dispatchEvent( _eChange ) ;
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
		for (var each:String in oInit) 
		{
			this[each] = oInit[each] ;
		}
		update() ;
	}
	
	/**
	 * Sets the IBuilder instance use to create the view of the component.
	 * @return {@code true} if the new IBuilder is not null.
	 */
	public function setBuilder(b:IBuilder):Boolean 
	{
		if (_builder != null) 
		{
			_builder.clear() ;
			_builder = null ;
		}
		if ( b == null ) 
		{
			return false ;
		}
		else
		{
			_builder = b ;
			_builder.setTarget(this) ;
			_builder.run() ;
			return true ;
		}
	}

	/**
	 * Sets a Boolean value that indicates whether the display is enabled. The default value of enabled is true. 
	 */
	public function setEnabled( b:Boolean ):Void 
	{
		super.setEnabled( b ) ;
		if (___isLock___) 
		{
			return ;
		}
		viewEnabled() ;
		dispatchEvent(_eEnabledChanged) ;
	}

	/**
	 * Sets if the component is grouped or not.
	 * @param b a boolean flag to indicates if the component is grouped.
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
	 * Sets the virtuals width and height of the component.
	 */
	public function setSize( nW:Number, nH:Number):Void 
	{
		_w = MathsUtil.clamp( nW, minWidth, maxWidth) ; 
		_h = MathsUtil.clamp( nH, minHeight, maxHeight) ; 
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
	 * Updates the component. This method is invoqued when the component must be refreh.
	 */
	public function update():Void 
	{
		if ( isLocked() ) 
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
	
	private var _groupName:String ;
	
	private var _group:Boolean ;
	
	private var _h:Number ;
	
	private var ___timer___:FrameTimer ;
	
	private var _style:IStyle ;
	
	private var _w:Number ;

	private var _eAdded:UIEvent ;	
	
	private var _eChange:UIEvent ;
	
	private var _eCreate:UIEvent ;
	
	private var _eDestroy:UIEvent ;
	
	private var _eEnabledChanged:UIEvent ;
	
	private var _eInit:UIEvent ;
	
	private var _eRemoved:UIEvent ;
	
	private var _eRender:UIEvent ;
	
	private var _eResize:UIEvent ;
	
	private var _eStyleChange:UIEvent ;

	private var _listenerStyleChange:EventListener ;

	/**
	 * Redraw the component.
	 */	
	private function _redraw(ev:TimerEvent):Void 
	{
		___timer___.stop() ;
		update() ;
	}
	
	/**
	 * Register the IStyle reference.
	 */
	private function _registerStyle():Void
	{
		if (_style != null)
		{
			_style.addEventListener(StyleEvent.STYLE_CHANGED, _listenerStyleChange) ;
			_style.addEventListener(StyleEvent.STYLE_SHEET_CHANGED, _listenerStyleChange) ;
		}
	}

	/**
	 * Invoqued when the internal view of this display is unload.
	 */
	private function _onUnload():Void 
	{
		if (isLocked())
		{
			return ;
		}
		viewDestroyed() ;
		dispatchEvent(_eDestroy) ;
	}

	/**
	 * Unregister the IStyle reference of this instance.
	 */
	private function _unregisterStyle():Void
	{
		if ( _style != null ) 
		{
			_style.removeEventListener(StyleEvent.STYLE_CHANGED, _listenerStyleChange) ;
			_style.removeEventListener(StyleEvent.STYLE_SHEET_CHANGED, _listenerStyleChange ) ;
			_style = null ;
		}

	}
	
	/**
	 * The internal static counter name to create default component names.
	 */
	static private var _counterName:Number = 0 ; 
	
	
}