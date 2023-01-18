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
 
 
// Classes Delfiweb
import com.delfiweb.display.DisplayObject;


// classe Bourre
import com.bourre.commands.Delegate;


//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;

 
 
/**
 * MovieClipGraphic is used to show a specific graphic object under scene.
 * For example : an external swf, a picture...
 * 
 * 
 * @usage 
 * 
	var oDisplay:MovieClipGraphic = new MovieClipGraphic("test.swf");
	oDisplay.attach(_root, 0);
 * 
 * 
 * @author Matthieu DELOISON
 * @version 1.0
 * @since   05/11/2006
 */
class com.delfiweb.display.MovieClipGraphic extends DisplayObject
{
	private var _sLink			: String; // value of url.
	
	
	
	/**
	 * CONSTRUCTOR.
	 * 
	 */
	public function MovieClipGraphic (sGraphics:String)
	{
		super();
		
		if( sGraphics!=undefined ) this._sLink = sGraphics;
		else this._sLink = "";
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
	 * @return  MovieClip	: a reference to created movieclip.
	 */
	public function attach (mc:MovieClip, d:Number):MovieClip
	{
		if (!mc)
		{
			Logger.LOG("You must do specify a movieclip for method attach of class MovieClipGraphic.");
		}
		else
		{
			// si pas de profondeur on prend la plus haute de la cible
			if(d == undefined) d=mc.getNextHighestDepth();
			
			if(this._mcBase) this.remove(); // si le clip existe déja on le supprime
			
			// si l'id de liaison existe
			if(this._sLink != "" && this._sLink != undefined)
			{
				// it's a clip in library
				_mcBase = mc.attachMovie(this._sLink, "__MovieClipGraphic__"+d, d);

				// it's an external link
				if(this._mcBase==undefined)
				{
					this._mcBase = mc.createEmptyMovieClip ("__MovieClipGraphicExternal__"+d,d);
					
					var oLoader:MovieClipLoader = new MovieClipLoader();
			
					var listener:Object = new Object();
					listener.onLoadInit = Delegate.create(this, _onLoadComplete);		
					listener.onLoadError = Delegate.create(this, _onDisplayError);		
					oLoader.addListener(listener);
										
					oLoader.loadClip(this._sLink, this._mcBase);
				}
				else
				{
					var oInfo:Object = new Object();
					oInfo.drawing = true;
					oInfo.mcBase = this._mcBase;
					this._onDisplayComplete(oInfo);
				}
			}
			else // we create an empty movieclip
			{
				this._mcBase = super.attach(mc, d);
			}	
				
			return this._mcBase;
		}
	}
	
								
	
	/**
	 * Get the value of url.
	 * 
	 * @return  
	 */
	public function getLink():String
	{
		return this._sLink;
	}
	
	
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/


	/*----------------------------------------------------------*/
	/*--------------- Events of MovieClipLoader ----------------*/
	/*----------------------------------------------------------*/




	/**
	 * Call by object MovieClipLoader when download of external link is finished
	 * 
	 * @return  
	 */
	private function _onLoadComplete()
	{
		var oInfo:Object = new Object();
		oInfo.drawing = true;
		oInfo.mcBase = this._mcBase;
		
		this._onDisplayComplete(oInfo); // diffuse an event to tell that DisplayObject is ready
	}


	/**
	 * Call by object MovieClipLoader when download failed
	 * 
	 * @param   mcTarget	: movie clip    
	 * @param   sErrorCode  : for example "URLNotFound" or "LoadNeverCompleted".
	 * @param   iHttpStatus : for example 404 error
	 * @return  
	 */
	private function _onDisplayError(mcTarget:MovieClip, sErrorCode:String, iHttpStatus:Number)
	{
		var oInfo:Object = new Object();
		oInfo.drawing = false;
		oInfo.mc = mcTarget+" -> "+_sLink;
		oInfo.error = sErrorCode;
		
		this._onDisplayComplete(oInfo);
	}
	
	
	/*----------------------------------------------------------*/
	/*-------------- Other -------------------------------------*/
	/*----------------------------------------------------------*/
	
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String
	{
		return "[object MovieClipGraphic]";
	}
	
}// end of class