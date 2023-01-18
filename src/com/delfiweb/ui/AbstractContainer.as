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
import com.delfiweb.ui.IContainer;
import com.delfiweb.events.EventManager;
import com.delfiweb.display.DisplayObject;


// classe Bourre
import com.bourre.commands.Delegate;


// class effect
import com.gskinner.geom.ColorMatrix;
import flash.filters.ColorMatrixFilter;


//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;



/**
 * AbstractContainer is used to build some object under scene.
 * 
 * 
 * @usage by extends class
 * 
	var oDisplay:AbstractContainer = new AbstractContainer("test");
	oDisplay.setDisplayObject(oDisplayObject);
	oDisplay.attach(_root, 10);
 * 
 * 
 * @author Matthieu DELOISON
 * @version 1.0
 * @since   05/11/2006
 */
class com.delfiweb.ui.AbstractContainer implements IContainer
{
	private var _sName				: String; // name of object
	
	private var _mcBase				: MovieClip; // instance of graphic object.
	
	private var _oEventManager		: EventManager; // instance of EventManager.
	
	public var _displayable			: Boolean = true;// used to identifie a AbstractContainer
	
	private var _oDisplayObject		: DisplayObject;
	
	
	/* caractéristiques */
	private var _nX					: Number; // used when AbstractForm is an external swf loaded.
	private var _nY					: Number; // used when AbstractForm is an external swf loaded.
	private var _nWidth				: Number;// used when AbstractForm is an external swf loaded.
	private var _nHeight			: Number;// used when AbstractForm is an external swf loaded.
	
	
	/* config */
	private var _oColorEffect		: Object; // used to update color effect on the movieclip
	
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 */
	private function AbstractContainer(sName:String, x:Number, y:Number)
	{	
		this._sName = sName;
		
		this._nX = x ? x : 0;
		this._nY = y ? y : 0;
		
		// create an event manager
		this._oEventManager = new EventManager();
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
	public function attach (mc:MovieClip, d:Number):Void
	{
		this._mcBase = _oDisplayObject.attach(mc, d);
		return;
	}
	
	
	
	/*----------------------------------------------------------*/
	/*--------- add some fonctionnality to object --------------*/
	/*----------------------------------------------------------*/
								

	public function move(nX:Number, nY:Number) : Void
	{
		if(nX!=undefined)
		{
			this._nX = nX;
			this._mcBase._x = nX;
		}
		if(nY!=undefined)
		{
			this._nY = nY;
			this._mcBase._y = nY;
		}
	}
	
	public function getPosition():Object
	{
		var oPoint:Object = new Object();
		oPoint.x = _mcBase._x;
		oPoint.y = _mcBase._y;
		
		return oPoint;
	}
	
	
	public function getName():String
	{
		return this._sName;
	}
	
	public function setName(sName:String)
	{
		this._sName = sName;
	}
	
	
	public function getMovieClip():MovieClip
	{
		return this._mcBase;
	}
	
	
	
	public function setScale(nX:Number, nY:Number) : Void
	{
		if(nX!=undefined) this._mcBase._xscale = nX;
		if(nY!=undefined) this._mcBase._yscale = nY;
		
		this.updateSize();
	}
	
	
	
	public function setSize(iWidth:Number, iHeight:Number) : Void
	{
		this._nWidth = iWidth;
		this._nHeight = iHeight;
		this._mcBase._width = _nWidth;
		this._mcBase._height = _nHeight;
	}
	
	public function setHeight(iHeight:Number) : Void
	{
		this._nHeight = iHeight;
		this._mcBase._height = _nHeight;
	}
	
	public function getHeight() : Number
	{
		return this._nHeight;
	}
	
	public function setWidth(iWidth:Number) : Void
	{
		this._nWidth = iWidth;
		this._mcBase._width = _nWidth;
	}
	
	public function getWidth() : Number
	{
		return this._nWidth;
	}
	
	
	public function setVisible( bVisible : Boolean ) : Void
	{
		if ( bVisible )
			this.show();
		else
			this.hide();
	}
	
	public function show() : Void
	{
		this._mcBase._visible = true;
	}
	
	public function hide() : Void
	{
		this._mcBase._visible = false;
	}
	
	
	/**
	 * Update contraste, hue , saturation, brigtness of the movieclip
	 * 
	 * @return  
	 */
	public function setColorEffect(oEffect:Object):Void
	{
		if( oEffect!=undefined ) _oColorEffect = oEffect;

		if( _mcBase==undefined ) return;
		
		var oColorM:ColorMatrix = new ColorMatrix();
		oColorM.adjustColor(_oColorEffect.lum, _oColorEffect.cont, _oColorEffect.sat, _oColorEffect.hue);
		
		var oColorMFilter:ColorMatrixFilter = new ColorMatrixFilter(oColorM);
		
		_mcBase.filters = [oColorMFilter];
	}



	
	/*----------------------------------------------------------*/
	/*------------------------- events -------------------------*/
	/*----------------------------------------------------------*/
				
	public function addListener(oInst:Object):Boolean
	{
		return _oEventManager.addListener(oInst);
	}
	
	public function removeListener(oInst:Object):Boolean
	{
		return _oEventManager.removeListener( oInst );
	}
	

	/**
	 * Remove only movieclip.
	 * 
	 * @return  Boolean	true -> movieclip is removed
	 */
	public function remove():Boolean
	{
		return _oDisplayObject.remove();
	}	
	


	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct():Boolean
	{
		this.remove();
		_oEventManager.destruct();
		_oDisplayObject.destruct();
		delete this;
		return true;
	}
	
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/


	/**
	 * Used by extends class
	 * 
	 * @param   oI 
	 * @return  
	 */
	private function setDisplayObject(oI:DisplayObject)
	{
		_oDisplayObject = oI;
		_oDisplayObject.addListener(this);
	}
	

	
	private function updateSize()
	{
		this._nWidth = this._mcBase._width;
		this._nHeight = this._mcBase._height;
	}
	
	
	/*----------------------------------------------------------*/
	/*------------------- EventManager -------------------------*/
	/*----------------------------------------------------------*/



	/**
	 * AbstractContainer is ready
	 * Event diffused by class DisplayObject
	 * 
	 * @usage   
	 * @return  
	 */
	private function _onDisplayObjectBuild(oInfo):Void
	{
		if(!oInfo.drawing)
		{
			Logger.LOG("error Displaying DisplayObject : "+_sName);
			return;
		}
		
		this._mcBase = oInfo.mcBase;
		
		/* on positionne le Container */
		this.move(_nX, _nY);
		if( _oColorEffect!=undefined ) this.setColorEffect();
		
		this.endBuilding();
		this._oEventManager.broadcastEvent("_onAbstractContainerBuild", oInfo);
		return;
	}
	


	/**
	 * End of building container.
	 * It's used by extends class.
	 * 
	 * @return  
	 */
	private function endBuilding():Void
	{
		return;
	}
	
	
	/*----------------------------------------------------------*/
	/*------------- Getter / Setter ----------------------------*/
	/*----------------------------------------------------------*/


	
	/**
	 * This property is used to know if Object is actually visible under scene.
	 * 
	 * 
	 * @return  Boolean 
	 */
	public function get displayed():Boolean
	{
		if(this._mcBase._y != undefined) return true;
		else return false;
	}
	
	
	
	/*----------------------------------------------------------*/
	/*------------- Divers -------------------------------------*/
	/*----------------------------------------------------------*/
	
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return the string representation of this instance
	 */
	public function toString():String
	{
		return "[object AbstractContainer : "+_sName+"]";
	}
	
}// end of class