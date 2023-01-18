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



// class delfiweb
import com.delfiweb.events.EventManager;
import com.delfiweb.utils.LoadStack;


// debug
import com.bourre.log.Logger;



/**
 * Use this classes with some swf sharedfonts created with swfmill (http://www.swfmill.org)
 * 
 * It's diffuse some events : "onLoadFontProgress", "onLoadFontComplete" and "onLoadFontError".
 * 
 * 
 * @usage :

		_oSharedFont = new FontLoader();
		_oSharedFont.attach(_mcBase);
		_oSharedFont.addListener(this);
		_oSharedFont.addFont( "swf/fonts/Bienvenue.swf" );		_oSharedFont.addFont( "swf/fonts/Amaze.swf" );
		_oSharedFont.startLoad();	

 * 
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 23 Avril 2007  
 */
 
class com.delfiweb.utils.FontLoader
{
	/* clips principaux */
	private var _mcBase:MovieClip;
	private var _mcContainer:MovieClip; // le clip de contenu du SharedFontFree
	
	
	/* object */
	private var _oEventManager:EventManager; // instance of EventManager.
	private var _oLoadStack : LoadStack;
	
		
	/* config */
	private var _nDepth:Number;
	private var _nCurrentFont:Number;


	
	/**
	 * CONSTRUCTOR
	 * 
	 */
	public function FontLoader() 
	{
		this._nCurrentFont = 0;
		this._oEventManager = new EventManager();
		
		//this._oLibStack = new LibStack();
		this._oEventManager = new EventManager();
				
		_oLoadStack = new LoadStack();
		_oLoadStack.addListener( this );
		
		_nDepth = 10;		
	}
	
	
/* ***************************************************************************
* PUBLIC FUNCTIONS
******************************************************************************/
	
	
	
	/**
	 * It's used to attach mc at a movieclip put in parameter.
	 * Depth is optionnal, if is the depth is undefined, mc is build at the top depth of parent clip.
	 * 
	 * 
	 * @param   mc 			: movieclip used to build graphic object
	 * @param   d 			: depth of the MovieClip  
	 * @return
	 */
	public function attach(mc:MovieClip, d:Number):Void
	{
		if (!mc)
		{
			Logger.LOG("You must do specify a movieclip for method attach of class FontLoader.");
		}
		else
		{
			if(d == undefined) d = mc.getNextHighestDepth();
		
			// On crée le clip mcBase
			_mcBase = mc.createEmptyMovieClip("__FontLoader__", d);
			_mcBase._visible = false;
			
			// Creation du clip de contenu
			_mcContainer = _mcBase.createEmptyMovieClip("container", 1);
		}
				
		return;
	}
	
		
	/**
	 * Chargement d'un swf externe qui contient la police souhaitée
	 * 
	 * @param   sUrl : url du swf
	 * @return  
	 */
	public function addFont(sUrl:String)
	{
		var mc:MovieClip = _mcContainer.createEmptyMovieClip("FONT_"+_nCurrentFont.toString(), _nDepth++);
		
		_oLoadStack.addFile( sUrl, mc);	
		_nCurrentFont++;
	}
	
	
	/**
	 * Start to load all fonts.
	 * 
	 */
	public function startLoad()
	{
		// On lance le chargement
		_oLoadStack.startLoad();
	}
	
	
		
	public function addListener(oInst:Object):Boolean
	{
		return _oEventManager.addListener(oInst);	
	}
	
	
	public function removeListener (oInst:Object):Boolean
	{
		return _oEventManager.removeListener(oInst);	
	}
	
	
	public function removeAllListeners():Boolean
	{
		return _oEventManager.removeAllListeners();	
	}
	
	
	
	/**
	 * Remove all fonts loaded.
	 * 
	 */
	public function remove()
	{
		_oLoadStack.remove();
	}
	
	
	/**
	 * Remove all ressources used by class.
	 * 
	 * @usage   
	 * @return  
	 */
	public function destruct()
	{
		_oEventManager.destruct();
		delete _oEventManager;
				
		_oLoadStack.destruct();
		delete _oLoadStack;
		
		_mcBase.removeMovieClip();	
		delete this;	
	}
	
	
	
	/*----------------------------------------------------------*/
	/*------------- LoadStack Event ----------------------------*/
	/*----------------------------------------------------------*/
	
	
	
	public function onLoadStart()
	{
		
		
	}
	
	
	public function onLoadProgress(oInfos : Object)
	{		
		_oEventManager.broadcastEvent("onLoadFontProgress", oInfos);
	}
	
	
	public function onLoadComplete()
	{
		// Ici on peut lancer une fonction qui serra exécuté à la fin de tous les chargement.
		//Logger.LOG("--------> fonts entièrement chargé");
		/* lance une fonction après un certain temps (objet,nom de la fonction, durée en ms,
		[variables à transmettre])
		*/
		_global.setTimeout( this, "saveFont" , 200);// chargement externe de la librairie de la font
	}
	
	
	public function onLoadError( oInfos:Object )
	{
		_oEventManager.broadcastEvent("onLoadFontError", oInfos);
	}
	
	 
	

/* ***************************************************************************
* PRIVATE FUNCTIONS
******************************************************************************/
	
	
	
	/**
	 * Save a font (textField) for other TextFormat.
	 * 
	 */
	private function saveFont():Void
	{
		this._oEventManager.broadcastEvent("onLoadFontComplete");
	}
	
	
	
	/*----------------------------------------------------------*/
	/*------------- Divers -------------------------------------*/
	/*----------------------------------------------------------*/
	
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return the string representation of this instance
	 */
	public function toString ():String
	{
		return "[object FontLoader]";
	}
	


}// end of class