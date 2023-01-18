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

import andromeda.core.ApplicationID;

import asgard.config.Config;
import asgard.config.ConfigurableObject;
import asgard.display.StageDisplayState;
import asgard.system.Localization;

import vegas.events.Delegate;
import vegas.util.factory.ContextMenuFactory;

/**
 * This manager control the content of the ContextMenu of the application.
 * @author eKameleon
 */
class andromeda.ui.ApplicationContextMenu extends ConfigurableObject 
{
	
	/**
	 * Creates a new ApplicationContextMenu instance.
	 */
	private function ApplicationContextMenu() 
	{	
		Localization.getInstance().addEventListener(Localization.CHANGE, new Delegate(this, setup)) ;
		_cm = new ContextMenu( Delegate.create(this, changeContextMenu) ) ;
		_cm.hideBuiltInItems() ;
	}
	
	/**
	 * The ContextMenuItem used to passed the application in fullscreen mode.
	 */
	public var cmiFull:ContextMenuItem ;

	/**
	 * The ContextMenuItem used to passed the application in normal mode.
	 */
	public var cmiNormal:ContextMenuItem ;
	
	/**
	 * The fullscreen label in the context menu of the application.
	 * You can use the localization of the application to change this value.
	 */
	public var fullscreenLabel:String = "GO FULL SCREEN" ;

	/**
	 * The normal screen label in the context menu of the application.
	 * You can use the localization of the application to change this value.
	 */
	public var normalLabel:String = "EXIT FULL SCREEN" ;

	/**
	 * Insert a new contextMenuItem in the context menu of the application.
	 */
	public function addContextMenuItem( c:ContextMenuItem ):Void 
	{
		_cm.customItems.push(c) ;
	}

	/**
	 * Insert a new contextMenuItem to enter in the full screen mode.
	 */
	public function addFullScreen():Void 
	{
		
		if ( StageDisplayState.getInstance().available )
		{
			cmiFull = ContextMenuFactory.createItemProxy
			( 
				fullscreenLabel , this , setDisplayState , true, [StageDisplayState.FULLSCREEN] 
			) ;	
			cmiNormal = ContextMenuFactory.createItemProxy
			( 
				normalLabel , this , setDisplayState , null, [StageDisplayState.NORMAL]
			) ;	
			addContextMenuItem( cmiFull  ) ;
			addContextMenuItem( cmiNormal ) ;
		}
		
	}
	
	/**
	 * Adds this contextMenu in the specified target.
	 * @param target The target to attach the ContextMenu.
	 */
	public function addMenu( target ):Void
	{
		target.menu = _cm ;	
	}
	
	/**
	 * Insert a new contextMenuItem with the type "proxy" method in the context menu of the application.
	 */
	public function addProxy(label:String, o , f:Function, separator:Boolean , args:Array):Void 
	{
		addContextMenuItem( ContextMenuFactory.createItemProxy( label, o, f, separator, args) ) ;
	}

	/**
	 * Insert a new contextMenuItem with the type "url" method in the context menu of the application.
	 */
	public function addURL(label:String, url:String, target:String, separator:Boolean):Void 
	{
		addContextMenuItem( ContextMenuFactory.createItemURL(label, url, target, separator) ) ;
	}

	/**
	 * Invoqued when the ContextMenu is opened.
	 */
	public function changeContextMenu( target , menu ):Void
	{
		if ( StageDisplayState.getInstance().available )
		{
			var state:String = StageDisplayState.getInstance().displayState ;
			if ( state == StageDisplayState.NORMAL )
   			{
				cmiNormal.enabled = false ;
				cmiFull.enabled   = true ;
   			}	
   			else if (state == StageDisplayState.FULLSCREEN)
	   		{
   				cmiNormal.enabled = true ;
				cmiFull.enabled   = false ;
   			}
   			else
   			{
	   			cmiNormal.enabled = false ;
				cmiFull.enabled   = false ;
   			}
		}
	}

	/**
	 * Clear the contextMenu of the application.
	 */
	public function clear():Void 
	{
		_cm.customItems = [] ;	
	}

	/**
	 * Returns the singleton reference of this class.
	 * @return the singleton reference of this class.
	 */
	static public function getInstance():ApplicationContextMenu 
	{
		if (!_instance) 
		{
			_instance = new ApplicationContextMenu() ;
		}
		return _instance ;
	}

	/**
	 * Sets the current display state of the application.
	 */
	public function setDisplayState( target:MovieClip, menu, state:String ):Void
	{
		StageDisplayState.getInstance().displayState = state ;	
		cmiNormal.enabled = (state == StageDisplayState.NORMAL) ? false : true ;
		cmiFull.enabled   = (state == StageDisplayState.NORMAL) ? true : false ;
	}

	/**
	 * Setup the ApplicationContextMenu when configuration change.
	 */
	public function setup():Void 
	{
		
		clear() ;
		
		// check config
		
		var conf:Array = Array(Config.getInstance()[ ApplicationID.CONTEXT_MENU ]) ;
		if (conf) 
		{
			var l:Number = conf.length ;
			for (var i:Number = 0 ; i<l ; i++) 
			{
				var item = conf[i] ;
				getLogger().info( this + " label:" + item.label + ",url : " + item.url) ;
				addURL( item.label, item.url, item.target, item.separator ) ;
			}	
		}
		
		// check localization
		
		var locale:Object = Localization.getInstance().getLocale( ApplicationID.CONTEXT_MENU ) ;
		if ( locale != null )
		{
			for (var prop:String in locale)
			{
				this[prop] = locale[prop] ;	
			}
		}
		
		// check fullscreen mode in the config of the application.
		
		if ( Config.getInstance().isFullScreen )
		{
			addFullScreen() ;
		}

	}
	
	/**
	 * The internal ContextMenu reference.
	 */
	private var _cm:ContextMenu ;
	
	/**
	 * The sigleton reference of the application.
	 */
	private static var _instance:ApplicationContextMenu ; 
	

}