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

import asgard.display.DisplayLoaderCollector;
import asgard.events.DisplayLoaderEvent;
import asgard.net.AbstractLoader;
import asgard.net.URLRequest;

import vegas.core.HashCode;
import vegas.errors.IllegalArgumentError;

/**
 * The DisplayLoader class is used to load SWF files or image (JPG, PNG, or GIF) files. 
 * <p>Use the load() method to initiate loading.</p>
 * <p><b>Example :</b></p>
 * {@code
 * import asgard.display.DisplayLoader ;
 * import asgard.events.LoaderEvent ;
 * import asgard.events.LoaderEventType ;
 * import asgard.net.URLRequest ;
 * 
 * import vegas.events.Delegate ;
 * 
 * var onLoadError = function(ev:LoaderEvent):Void
 * {
 *     trace("> " + ev.getType() + " : " + ev.error ) ;
 * }
 * 
 * var onLoadComplete = function(ev:LoaderEvent):Void
 * {
 *     trace(ev.getTarget() + " > " + ev.getType() ) ;
 * }
 * 
 * var onLoadInit = function(ev:LoaderEvent):Void
 * {
 *     trace(ev.getTarget() + " > " + ev.getType() ) ;
 * }
 * 
 * var onLoadProgress = function (ev:LoaderEvent):Void
 * {
 *     trace(ev.getTarget() + " > " + ev.getType() + " : " + ev.getPercent() + "%") ;
 * }
 * 
 * var onLoadStart = function (ev:LoaderEvent):Void
 * {
 *     trace(ev.getTarget() + " > " + ev.getType() ) ;
 * }
 * 
 * var url:String = "pic/picture.jpg" ;
 * var mc:MovieClip = createEmptyMovieClip("container", 1) ;
 * 
 * mc._x = 25 ;
 * mc._y = 25 ;
 * 
 * var loader:DisplayLoader = new DisplayLoader(mc) ;
 * loader.addEventListener(LoaderEventType.COMPLETE, new Delegate(this, onLoadComplete)) ;
 * loader.addEventListener(LoaderEventType.IO_ERROR, new Delegate(this, onLoadError)) ;
 * loader.addEventListener(LoaderEventType.INIT, new Delegate(this, onLoadInit)) ;
 * loader.addEventListener(LoaderEventType.PROGRESS, new Delegate(this, onLoadProgress)) ;
 * loader.addEventListener(LoaderEventType.START, new Delegate(this, onLoadStart)) ;
 * 
 * var request:URLRequest = new URLRequest(url);
 * loader.load(request) ;
 * 
 * }
 * @author eKameleon
 */
class asgard.display.DisplayLoader extends AbstractLoader 
{
	
	/**
	 * Creates a new DisplayLoader instance.
	 * @param mcTarget the target of this loader.
	 * @param nDepth the depth of the internal movieclip use to load the external content.
	 * @param bAutoShow indicates if the external content (picture, swf) is show when is loading.
	 */
	function DisplayLoader( mcTarget:MovieClip, nDepth:Number, bAutoShow:Boolean ) 
	{
		
		super() ;
		
		if (! mcTarget) 
		{
			throw new IllegalArgumentError(this + " mcTarget argument not must be 'undefined' or 'null'.") ;
		}
		
		nDepth = (isNaN(nDepth)) ? _uniqueID++ : nDepth ;
		
		HashCode.identify( mcTarget ) ;
		
		_container = mcTarget.createEmptyMovieClip("__container__" +  HashCode.nextName(), nDepth ) ;
		
		HashCode.identify( _container ) ;
		
		_isAutoShow = (bAutoShow == null) ? true : bAutoShow ;
		_isCollected = false ;
		
	}

	/**
	 * Returns the absolute url of the root swf object.
	 * @return the absolute url of the root swf object.
	 */
	static public function getLoaderUrl():String 
	{
		return _root._url ;
	}

	/**
	 * Returns the view of this loader.
	 * @return the view of this loader.
	 */
	public function getView():MovieClip 
	{
		return super.getContent() ;
	}
	
	/**
	 * Hide the view of this loader.
	 */
	public function hide():Void 
	{
		_container._visible = false ;
	}

	/**
	 * Init the internal event of this loader.
	 */
	/*override*/ public function initEvent():Void 
	{
		_e = new DisplayLoaderEvent(null, this) ;
	}

	/**
	 * Return {@code true} if the view of this loader is visible when is loading.
	 * @return {@code true} if the view of this loader is visible when is loading
	 */
	public function isAutoShow():Boolean 
	{
		return _isAutoShow ;	
	}
	
	/**
	 * Return {@code true} if the view of this loader is visible.
	 * @return {@code true} if the view of this loader is visible.
	 */
	public function isVisible():Boolean 
	{
		return _container._visible ;	
	}

	/**
	 * Load the current URLRequest.
	 */
	/*override*/ public function load(request:URLRequest):Void 
	{
		if (request.getUrl() != undefined) 
		{
			setUrl( request.getUrl() );
		}
		release() ;
		setContent( _container.createEmptyMovieClip("__mcExternal", 1) ) ;
		getContent().loadMovie( super.getUrl() );
		hide();
		super.load() ;
	}

	/**
	 * Invoqued when the loading is finish and the loader is init.
	 */
	/*override*/ public function onLoadInit():Void 
	{
		if (_sName) 
		{
			
			if (!(DisplayLoaderCollector.contains(_sName))) 
			{
				
				_isCollected = true ;
				DisplayLoaderCollector.insert( _sName, this ) ;
				
			} 
			else 
			{
				_isCollected = false ;
				// TODO créer une erreur.
				notifyError( this + " can't be collected to [DisplayCollector] with '" + _sName + "' name. This name already exists." ) ;
			}
		}
		
		super.onLoadInit();
		
		if (_isAutoShow)
		{
			show() ;
		}
		
	}
	
	/**
	 * Release the loader.
	 */
	/*override*/ public function release():Void 
	{
		super.release() ;
		getContent().removeMovieClip() ;
		_container._visible = _isAutoShow ;
		if (_isCollected) 
		{
			DisplayLoaderCollector.remove(_sName) ;
			_isCollected = false ;	
		}	
	}
	
	/**
	 * Sets if the view is show when the content is loading.
	 */
	public function setAutoShow(b:Boolean):Void 
	{
		_isAutoShow = b ;
	}

	/**
	 * Show the view of the loader.
	 */
	public function show():Void 
	{
		_container._visible = true ;
	}

	/**
	 * The internal container of this loader.
	 */
	private var _container:MovieClip ;

	/**
	 * The boolean value to indicated if the view is auto show when the content is loading.
	 */
	private var _isAutoShow:Boolean ;

	/**
	 * The boolean to indicated if the loader is collected.
	 */
	private var _isCollected:Boolean ;

	/**
	 * The internal uniqueID to creates a new container.
	 */
	static private var _uniqueID:Number = 0 ;


}