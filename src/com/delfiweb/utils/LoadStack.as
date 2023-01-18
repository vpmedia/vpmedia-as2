/**
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * 
 * The Initial Developer of the Original Code is
 * DELOISON Matthieu -- www.delfiweb.com.
 * Portions created by the Initial Developer are Copyright (C) 2006-2007
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s) :
 * 
 */
 


import com.delfiweb.events.EventManager;



/**
 * Manage a stack of files to load.
 * 
 * It's diffuse some events : "onLoadStart", "onLoadProgress", "onLoadComplete" and "onLoadError".
 * 
 * @usage :

var oLoadStack:LoadStack = new LoadStack();
oLoadStack.addListener(this);

oLoadStack.addFile( "biblio.delfiweb.swf", mc1); // mc1 -> a movieclip
oLoadStack.addFile( "delfiweb.swf", mc2); // mc2 -> a movieclip
oLoadStack.startLoad();


 * @author  Matthieu Deloison
 * @version 1.0
 * @since   
 */
class com.delfiweb.utils.LoadStack
{
	/* movie clip */
	private var _aMcLoad:Array;
	
	/* config */
	private var _aUrlToLoad:Array; // url to load
	private var _nCurrentId:Number; // current id of mc to be used
	private var _nProgress:Number; // progress of loading
	private var _bIsLoading:Boolean; // loading in progess (true)
	
	
	/* object */
	private var _oEvent:EventManager;
	private var _oLoader:MovieClipLoader;
	
	
	
	/* ****************************************************************************
	* CONSTRUCTOR
	**************************************************************************** */
	public function LoadStack ()
	{
		_oLoader = new MovieClipLoader ();
		_oLoader.addListener (this);
		
		_aUrlToLoad = new Array ();		_aMcLoad = new Array ();
		_nProgress = _nCurrentId = 0;
		_bIsLoading = false;
		
		_oEvent = new EventManager();
	}
	
	
	
	/* *****************************************************************************
	* PUBLIC FUNCTIONS
	*******************************************************************************/
	
	
	/**
	 * Add a url to be loaded
	 * 
	 * @usage   
	 * @param   url		: external url
	 * @param   cible	: movieclip used for the load
	 * @return  boolean : true if all is good else false
	 */
	public function addFile(url:String, cible:MovieClip):Boolean
	{
		if (!_bIsLoading)
		{
			_aUrlToLoad.push ({url:url, mc:cible});
			return true;
		}
		
		return false;
	}
	
	
	
	/**
	 * Start the loading
	 * 
	 * @usage   
	 * @return  
	 */
	public function startLoad ():Void
	{
		if(!_bIsLoading)
		{			
			_bIsLoading = true;		
			_aMcLoad.push(_aUrlToLoad[_nCurrentId].mc);
			_oLoader.loadClip (_aUrlToLoad[_nCurrentId].url, _aUrlToLoad[_nCurrentId].mc);		
			_oEvent.broadcastEvent("onLoadStart");
		}
	}	
	
	
	
	/**
	 * Remove a movieclip who has been loaded.
	 * 
	 * @usage   
	 * @param   cible 
	 * @return  
	 */
	public function remove(mc:MovieClip):Void
	{
		if( mc==undefined ) 
		{
			for(var i:String in _aMcLoad)
			{
				_oLoader.unloadClip( _aMcLoad[i] );
				_aMcLoad[i].removeMovieClip();
			}	
		}
		else
		{
			_oLoader.unloadClip(mc);
			mc.removeMovieClip();
		}
		
		return;
	}
	
	
	
	/**
	 * Remove all ressources used by class.
	 * 
	 * @usage   
	 * @return  
	 */
	public function destruct()
	{
		var mc:MovieClip;
		for(var i in _aUrlToLoad)
		{
			mc = _aUrlToLoad[i].mc;
			_oLoader.unloadClip(mc);
			mc.removeMovieClip();
		}
		
		delete _oLoader;
	}
	
	
	
	
	/**
	 * Fournit le contenu de la pile de fichiers
	 * 
	 * @see     
	 * @return  le tableau contenant tous les fichiers
	 */
	public function getStack():Array
	{
		return _aUrlToLoad;
	}
	
	
	
	/*----------------------------------------------------------*/
	/*---------- Listen event from MovieClipLoader -------------*/
	/*----------------------------------------------------------*/



	/**
	 * Progress of loading
	 * 
	 * @usage   
	 * @param   cible 
	 * @param   inO   
	 * @param   totO  
	 * @return  
	 */
	public function onLoadProgress (cible:MovieClip, inO:Number, totO:Number)
	{
		var part = 100/_aUrlToLoad.length;
		var pour = (inO/totO);
		var p = _nCurrentId*part +pour*part;
		_nProgress = Math.floor(p);
		
		var oInfos:Object = new Object();
		oInfos.value_pourc = _nProgress;
		// oInfos.value_size = _nProgress; // à calculer
		_oEvent.broadcastEvent("onLoadProgress", oInfos);			
	}
	
	
	
	/**
	 * End of loading a file
	 * 
	 * @usage   
	 * @param   cible 
	 * @return  
	 */
	public function onLoadInit (cible:MovieClip)
	{
		_nCurrentId++;
		
		// all files has been loaded
		if (_nCurrentId == _aUrlToLoad.length)
		{
			_bIsLoading = false;
			_nProgress = 100;
			var oInfos:Object = new Object();
			oInfos.value_pourc = _nProgress;
			// oInfos.value_size = _nProgress; // à calculer
			_oEvent.broadcastEvent("onLoadProgress", oInfos);
			_oEvent.broadcastEvent("onLoadComplete");
			_nCurrentId = 0;
			_aUrlToLoad = new Array ();
		}
		else
		{// there are some files to be loading
			_oLoader.loadClip (_aUrlToLoad[_nCurrentId].url, _aUrlToLoad[_nCurrentId].mc);
			var part = 100/_aUrlToLoad.length;
			var p = Math.floor((_nCurrentId)*part);
			_nProgress = p;
		}
	}
	
	
	
	/**
	 * When we have an error of loading
	 * 
	 * @usage   
	 * @param   cible      
	 * @param   codeerreur 
	 * @return  
	 */
	public function onLoadError (cible, codeerreur)
	{
		var oInfos:Object = new Object();
		oInfos.mc = cible;
		oInfos.error = codeerreur;
		
		_oEvent.broadcastEvent("onLoadError", oInfos);
	}
	


	/*----------------------------------------------------------*/
	/*---------------- Manage EventDispatcher ------------------*/
	/*----------------------------------------------------------*/



	public function addListener (o:Object):Boolean
	{
		return _oEvent.addListener(o);
	}
	
	
	public function removeListener (o:Object):Boolean
	{
		return _oEvent.removeListener(o);
	}
	
	
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString ()
	{
		return "[object LoadStack]";
	}
	
	
	/* *****************************************************************************
	* PRIVATE FUNCTIONS
	*******************************************************************************/
	

}



