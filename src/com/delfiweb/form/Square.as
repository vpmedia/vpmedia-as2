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
import com.delfiweb.form.AbstractForm;
import com.delfiweb.display.MovieClipGraphic;
import com.delfiweb.utils.ManageFunction;


// Classes Macromedia
import flash.geom.Rectangle;




/**
 * Square is used to draw a graphic object. 
 * It's possible to create some circle, rectangle, round rectangle.
 * 
 * All graphics object in library have a size of 100px (width) * 100px (height)
 * with a round (arrondi in french) of 10px and put on 1(_x) and 1(_y).
 * The movieclip have a clip named "back".
 * 
 * To understand, some examples are available at www.delfiweb.com
 * 
 * 
 * @notes : to create a square, it's possible to use a movieclip in library or 
 * an external swf (some examples will coming to explain who use some external 
 * graphics).
 * 
 * 
 * @usage
	var oSqr:Square = new Square ("SqDelfi.swf", 150, 120, 10);
	oSqr.attach(_root);
 * 
 * @author Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006
 */
class com.delfiweb.form.Square extends AbstractForm
{

	/* caractéristiques de l'objet graphique */
    private var _nCornerSize:Number; // value of round
	
	private var _nRatio:Number; // ratio between original round and wished round


	/* object used */
	private var _oManager:ManageFunction;// gestion d'une pile de fonctions à éxécuter
	private var _oMcGraphic:MovieClipGraphic;
	
	
	/* constantes */
	private static var _nOriginalCornerSize: Number = 10; // original value of movieclip in library
	private static var _nDefaultValue: Number = 100; // default size of movieclip in library
   
	

    /**
     * CONSTRUCTOR
	 * 
     * @param l		link of movieclip in library.
     * @param w 	Longueur initiale de l'objet.
     * @param h 	Hauteur initiale de l'objet.
     * @param cs	Rayon de l'arrondi des angles de l'objet. // 90 pour un cercle
     */
    public function Square(l:String, w:Number, h:Number, cs:Number)
    {
		super( "Square_"+random(100) ); // create an AbstractForm
		
		_nWidth = w ? w : Square._nDefaultValue;
		_nHeight = h ? h : Square._nDefaultValue;
		_nCornerSize = cs ? cs : 1;
		_nRatio = _nCornerSize/Square._nOriginalCornerSize;
		
		this._oManager = new ManageFunction(this); // gestion des actions à effectuer
		_oMcGraphic = new MovieClipGraphic(l);
		this.setDisplayObject(_oMcGraphic);
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
	 */
	public function attach (mc:MovieClip, d:Number):Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( attach.toString()+arguments.toString() ) )
		{
			super.attach(mc, d);// call method of AbstractForm
		}
		else
		{
			_oManager.addFunction(attach, arguments); // on l'ajoute à la liste des actions à faire
		}
		
		return;	
	}
	
	
	

	/**
	 * Return a copy of current object.
	 * 
	 * @return  a copy of current object.
	 */
	public function clone ():Square
	{
		return new Square (_oMcGraphic.getLink(), _nWidth, _nHeight, _nCornerSize);
	}
	
	
	

/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/



	/**
	 * Called by class AbstractContainer when object Square is drawing
	 * 
	 * @return  
	 */
	private function endBuilding()
	{		
		/* create a scale9grid on bottom of rounds */
		var coordX:Number = Square._nOriginalCornerSize;
		var coordY:Number = Square._nOriginalCornerSize;
		var nWitdh:Number = Square._nDefaultValue - (2*Square._nOriginalCornerSize);
		var nHeight:Number = Square._nDefaultValue - (2*Square._nOriginalCornerSize);
		
		var r:Rectangle = new Rectangle (coordX, coordY, nWitdh, nHeight);
		_mcBase.back.scale9Grid = r;
		
		/* ajuste le différentiel pour les coins arrondis */
		_mcBase._xscale = _nRatio*Square._nDefaultValue;
		_mcBase._yscale = _nRatio*Square._nDefaultValue;
		
		this.updateSize();
				
		_oManager.setReady(); // la fonction est terminée
	}
	
	
	/**
	 * update size of object with information's class
	 */
	private function updateSize()
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( updateSize.toString()+arguments.toString() ) )
		{
			if(_mcBase.back)
			{		
				_mcBase.back._width = _nWidth/_nRatio;
				_mcBase.back._height = _nHeight/_nRatio;
			}
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(updateSize, arguments); // on l'ajoute à la liste des actions à faire
		}
		
		
	}



	/*----------------------------------------------------------*/
	/*------------- Getter / Setter ----------------------------*/
	/*----------------------------------------------------------*/



	/**
	 * Update some round of Square
	 * 
	 * @usage   mySqr.corner = 30;
	 * @param   n	new value of angle
	 */
	public function setCorner (n:Number):Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( setCorner.toString()+arguments.toString() ) )
		{
			// on recalcule le ratio de redimensionnement
			_nCornerSize = n>0 ? n : _nCornerSize;
			_nRatio = _nCornerSize/Square._nOriginalCornerSize;
			
			// on remet le differentiel à 0
			_mcBase.back._width = Square._nDefaultValue;
			_mcBase.back._height = Square._nDefaultValue;
			
			/* recalcule le différentiel pour les coins arrondis */
			_mcBase._xscale = _nRatio*Square._nDefaultValue;
			_mcBase._yscale = _nRatio*Square._nDefaultValue;
			
			this.updateSize ();
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(setCorner, arguments); // on l'ajoute à la liste des actions à faire
		}
		
	}
	
	
	
	
	/**
	 * Update with of the object.
	 * 
	 * @param   n	new value. 
	 * @return	current value.
	 */
	public function setWidth (n:Number)
	{		
		if ( n >0 ) _nWidth = n;
		this.updateSize();
	}
	public function getWidth ():Number
	{
		return _nWidth;
	}


	/**
	 * Update height of the object.
	 * 
	 * @param   n	new value. 
	 * @return	current value.
	 */
	public function setHeight (n:Number)
	{
		if ( n >0 ) _nHeight = n;
		this.updateSize();
	}
	public function getHeight ():Number
	{
		return _nHeight;
	}


	

}//end Square