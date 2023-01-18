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
import com.delfiweb.ui.TxtField;
import com.delfiweb.ui.AbstractContainer;
import com.delfiweb.display.MovieClipGraphic;
import com.delfiweb.utils.ManageFunction;



// Classes Macromedia
import flash.geom.Rectangle;

// Classe Bourre
import com.bourre.commands.Delegate;

// debug
import com.bourre.log.Logger;



/**
 * Todo : 
 * 		- à voir pour la gestion des hauteur et largeur de la classe Label 
 * (référence soit AbstractForm ou paramètres du constructeur)
 * 
 */


/**
 * Classe Label
 * An graphic object with a background and an icon with text.
 * 
 * 
 * @usage
 	var coordX:Number = 50;
	var coordY:Number = 30;
	var largeurW:Number = 60;
	var hauteurH:Number = 30;
	var padding:Number = 0;
	var txt:String = "bonjour";
	var urlIcon:String = null;
	var posIconeLeft:Boolean = false;
	var oSquare:Square = new Square ("Square5", largeurW, hauteurH, 10);
	
	var oLabel = new Label(coordX, coordY, padding, txt, urlIcon, posIconeLeft, oSquare, largeurW, hauteurH);
	oLabel.attach(_root, 10);
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006 
 */
class com.delfiweb.ui.Label extends AbstractContainer
{
	/* clips principaux */
	private var _mcContainer:MovieClip; // contient tout le graphisme du LAbel
	private var _mcContent:MovieClip;// Clip du contenu
	private var _mcIcon:MovieClip;// Clip contenant l'icone
	
	/* les objets utilisés */
	private var _oManager:ManageFunction;// gestion d'une pile de fonctions à éxécuter
	private var _oForm:AbstractForm;// l'object Form utilisé pour créer un arrière plan (Square, Circle, Background)
	private var _oTxtField:TxtField; // le titre du Label
	private var _oMcGraphic:MovieClipGraphic;
	
	
	/* caractéristiques du Label */
	private var _nPadding:Number=5;// sa marge intérieur entre le contenu et le container
	
	
	/* options du label */
	private var _sLabel:String;// Label du titre : texte affiché
	private var _sIconOrClip:String;// id de liaison de la bibliothèque ou Charge une image ou un swf externe si c'est une url
	private var _largeurIcone:Number=0; //La largeur de l'icone
	private var _posIcone:String;//La position de l'icone : gauche - droite

	
	/* constantes */
	private var _nDepth:Number=10;

	private var _oTxtFieldConfig : Object;

	private var _oTxtFormatConfig : Object;// profondeur des clips
	
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 * @param  x	  		: Position du titre sur l'axe des x     
	 * @param  y   		  	: Position du titre sur l'axe des y 
	 * @param  pad  		: padding between text and background 
	 * @param  txt    		: the title  
	 * @param  urlIcon  	: url of the icon
	 * @param  posIconeLeft : position of the icon: true=left / false=right
	 * @param  oAbsForm    	:  an object AbstractForm for the background
	 * @param  w  			: widht 
	 * @param  h		  	: height
	 */
	public function Label(x:Number, y:Number, pad:Number, txt:String,	
	urlIcon:String, posIconeLeft:Boolean, oAbsForm:AbstractForm, w:Number, h:Number)
	{
		super("Label_"+random(1000), x, y); // création d'un AbstractContainer
		
		// Positions et dimensions du label
		_nX = x ? x : 0;
		_nY = y ? y : 0;
		_nWidth = w ? w : 0;
		_nHeight = h ? h : 0;
		
		// if there are a background
		if( oAbsForm!=undefined)
		{
			_oForm = oAbsForm;
			
			// update size of Label
			if( _nWidth<_oForm.getWidth() ) _nWidth = oAbsForm.getWidth();
			if( _nHeight<_oForm.getHeight() ) _nHeight = oAbsForm.getHeight();
		}
			
		_sLabel = txt;
		
		_sIconOrClip = urlIcon;
	
		if(pad!=undefined) _nPadding=pad; // La marge interieur du Label

		/* On défini la position de l'image */
		if(posIconeLeft || posIconeLeft==undefined) _posIcone="left";			
		else _posIcone="right";
		
		_oTxtFieldConfig = {background:false, backgroundColor:0x0033FF, autoSize:"none"};		_oTxtFormatConfig = {size:12, align:"center"};
		
		this._oManager = new ManageFunction(this); // gestion des actions à effectuer
		
		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
	}
	
	

/* ***************************************************************************
* PUBLIC FUNCTIONS
******************************************************************************/



	/**
	 * Update background of PlaceHolder
	 * 
	 * @param   oAbsForm : an abject AbstractForm (Square, circle or Background)
	 * @return  
	 */
	public function updateBackground(oAbsForm:AbstractForm):Void
	{
		if( _oForm ) _oForm.destruct();
		
		
		_oForm = oAbsForm;
		_oForm.attach(_mcBase, 1);
		
		return;
	}
	
	

	
	/*----------------------------------------------------------*/
	/*------------------- Getter/Setter  -----------------------*/
	/*----------------------------------------------------------*/
	

	/**
	 * Update the icon of the label
	 * 
	 * 
	 * @see         
	 * @param   icone : la nouvelle icône du bouton    
	 * @return  true if success
	 */
	public function setIcone(icone:String, posIconeLeft:Boolean)
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( setIcone.toString()+arguments.toString() ) )
		{
			_sIconOrClip = icone;
			var mcImg:MovieClip = _mcContent["iconOrClip"];

			// charge le clip dans la bibliothèque
			var mc:MovieClip = mcImg.attachMovie(_sIconOrClip, "clip" ,1);
						
			// si c'est l'url d'une image / swf externe
			if( !mc )
			{
				var oLoader:MovieClipLoader=new MovieClipLoader();
				
				var listener:Object = new Object();
				listener.onLoadInit = Delegate.create(this, _onSetIconeLoadComplete);		
				listener.onLoadError = Delegate.create(this, _onSetIconeLoadError);		
				oLoader.addListener(listener);
					
				oLoader.loadClip(_sIconOrClip, mcImg);
			}
			else
				_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(setIcone, arguments); // on l'ajoute à la liste des actions à faire
		}
		

	}
	
		
	/**
	 * Set a nex TextFormat to the TextField
	 * 
	 * @param   otxtformat : object with property of TextFormat
	 * @return  
	 */
	public function setTxtFormat(otxtformat:Object):Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( setTxtFormat.toString()+arguments.toString() ) )
		{	
			if( _oTxtField==undefined ) _oTxtFormatConfig = otxtformat;
			else _oTxtField.setTxtFormat(otxtformat);
		
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(setTxtFormat, arguments); // on l'ajoute à la liste des actions à faire
		}
	}
	
	
	/**
	 * Update property of the TextField
	 * 
	 * @param   otxtfield : object with the new property of the TextField
	 * @return  
	 */
	public function setTxtField(otxtfield:Object)
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( setTxtField.toString()+arguments.toString() ) )
		{	
			if( _oTxtField==undefined ) _oTxtFieldConfig = otxtfield;
			else _oTxtField.setTxtField(otxtfield);
			
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(setTxtField, arguments); // on l'ajoute à la liste des actions à faire
		}
	}

	

	/**
	 * Update text of the Label
	 * 
	 * @see     
	 * @param   s : new value
	 * @return  text of the Label
	 */
	public function set value (s:String)
	{
		_sLabel = s;
		_oTxtField.txt = _sLabel;
	}
	
	public function get value ():String
	{
		if(_oTxtField != undefined ) _sLabel = _oTxtField.txt;
		return _sLabel;
	}
	
	
	public function getTextField():TextField
	{
		return _oTxtField.getTxtField();
	}
	
	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct():Void
	{
		delete _oForm;
		super.destruct(); // suprime AbstractContainer
		delete this;// supprime l'objet lui-même
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
		// si on a spécifié un arrière-plan on l'ajoute
		if( _oForm!=undefined ) _oForm.attach(_mcBase, 1);
		
		// clip qui va contenir tous le graphisme du Label
		_mcContainer = _mcBase.createEmptyMovieClip("__Label_container__", 2 );
		_mcContainer.cacheAsBitmap=true;
		
		// Positionnement du clip qui contient le contenu en fonction de la marge
		_mcContainer._x=_nPadding;
		_mcContainer._y=_nPadding;
		
		// Creation du clip de contenu
		_mcContent = _mcContainer.createEmptyMovieClip("content", 1);
		
		// On crée le clip rectangle de visualisation (le masque)
		var r:Rectangle = new Rectangle(0, 0, _nWidth-2*_nPadding, _nHeight-2*_nPadding);
		_mcContainer.scrollRect = r;	
		
		// ajout du contenu
		this.addContent();		
	}
	
	
	/*----------------------------------------------------------------*/
	/*------- Gestion des différents types de contenu du Label -------*/
	/*----------------------------------------------------------------*/
	
	
	/**
	 * Affiche un clip si c'est un id de liaison de la bibliothèque
	 * Charge une image ou un swf externe si c'est une url
	 * 
	 */
	private function addContent()
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( addContent.toString()+arguments.toString() ) )
		{
			var mcImg:MovieClip = _mcContent.createEmptyMovieClip("iconOrClip", _nDepth++);
			// il y a un clip ou une url à charger
			if( _sIconOrClip!=undefined )
			{
				// charge le clip dans la bibliothèque
				var mc:MovieClip = mcImg.attachMovie(_sIconOrClip, "clip" ,1);
					
				// si c'est l'url d'une image / swf externe
				if( !mc )
				{
					var oLoader:MovieClipLoader=new MovieClipLoader();
			
					var listener:Object = new Object();
					listener.onLoadInit = Delegate.create(this,_onLoadComplete);		
					listener.onLoadError = Delegate.create(this,_onLoadError);		
					oLoader.addListener(listener);
				
					oLoader.loadClip(_sIconOrClip, mcImg);
						
				}
				else
					this._onLoadComplete(mcImg); // positionne l'icone et le texte
			}
			// chargement du texte, à gauche du titre et centré
			else if( _sLabel!=undefined )
				this.addTexte(0, "left");
			else
				_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(addContent, arguments); // on l'ajoute à la liste des actions à faire
		}
		
		
	}
	
	
	
	/**
	 * Fonction appelée lorsque l'icone a fini d'être chargée. Permet
	 * de déterminer la largeur de celle-ci, ce qui permet de définir la taille
	 * de la zone de texte au plus juste. Selon la position de l'image on détermine
	 * celle du texte
	 * 
	 * @param  mc : Une référence vers le clip contenant l'image chargée
	 */
	
	private function _onLoadComplete(mc:MovieClip)
	{
		if(mc)
		{
			// centrer l'image sur les ordonnées
			mc._y = ( (_nHeight - 2*_nPadding) - mc._height) /2;
				
			//On lance le positionnement de l'image en fonction du parametre _posIcone: left-right	
			this.posElement(mc, _posIcone);
			
			//On détermine la largeur de l'image
			_largeurIcone=mc._width;	
			
			//On déduit la position du texte selon celle de l'image: si image gauche, alors texte droite et inversement
			if(_posIcone=="left" && _sLabel!=undefined)
			{
				//Si l'image est à gauche, on calcul l'abscice du texte, il est à droite de l'image
				var posX:Number=mc._width; // pas de marge entre l'image et le texte + _nPadding;
				this.addTexte(posX,"left");
			}
			else if( _sLabel!=undefined )
				this.addTexte(0,"left");
			else
				_oManager.setReady(); // la fonction est terminée

		}
		else
			_oManager.setReady(); // la fonction est terminée
	}
	
	
	
	
	/**
	 * Appelé lorsque le chargement de l'icône à échoué
	 * 
	 * @param   mc         Une référence vers le clip qui devait contenir l'image chargée
	 * @param   httpStatus (facultatif) Code d'état HTTP renvoyé par le serveur (404 -> erreur 404)
	 * @return  
	 */
	private function _onLoadError(mc:MovieClip, httpStatus:Number)
	{
		if( _sLabel!=undefined )
				this.addTexte(0, "left");
		else
			_oManager.setReady(); // la fonction est terminée
	}
	
	
	
	
	
	/**
	 * Affiche le texte sur le Label.
	 * 
	 * @param  posX   : Position sur l'axe des x du texte
	 * @param  posTxt : Alignement du texte : left-center-right
	 */
	
	private function addTexte(posX:Number, posTxt:String)
	{
		var largeurW:Number = _nWidth-_largeurIcone-2*_nPadding;
		var hauteurH:Number = _nHeight-2*_nPadding;
		var otxtfield:Object = _oTxtFieldConfig;
		var otxtformat:Object = _oTxtFormatConfig;

		_oTxtField = new TxtField(_sLabel, posX, 0, largeurW, hauteurH, otxtfield, otxtformat);
		_oTxtField.attach(_mcContent);
		
		// centre le texte sur la hauteur si il est plus petit que la hauteur du Label
		if( _oTxtField.getHeight() < this._nHeight )
		{
			var nY:Number = ( (_nHeight - 2*_nPadding) - _oTxtField.getHeight() ) /2;
			_oTxtField.move(null, nY);
		}
		_oManager.setReady(); // la fonction est terminée
	}	
	
	
	
	/**
	 * Positonne un objet O à une position pos par rapport à sa largeur et celle du titre
	 * en tenant compte de la marge
	 * 
	 * @param  mc   : clip à positionner
	 * @param  pos : Position de l'objet : left-right
	 */
	private function posElement(mc:MovieClip ,pos:String)
	{
		switch(pos)
		{
			case "left" :
				mc._x=0;
				break;
				
			case "center" :
				mc._x = ((_nWidth-2*_nPadding)/2) - (mc._width/2);
				break;
				
			case "right" :
				mc._x = (_nWidth-2*_nPadding) - mc._width;
				break;
				
			default :
				mc._x=0;
				break;				
		}
	}
	

	
	/**
	 * Call when load of the icon is finished
	 * 
	 * @param  mc 
	 */
	private function _onSetIconeLoadComplete(mc:MovieClip)
	{
		/* redimensionne l'objet textfield */
		_largeurIcone = mc._width;// On détermine la largeur de l'image
		
		var largeurW:Number = _nWidth-_largeurIcone-2*_nPadding;
		_oTxtField.setWidth(largeurW);
		
		if(_posIcone=="left") _oTxtField.move(_largeurIcone);
		
		_oManager.setReady(); // la fonction est terminée
		
	}
	
	private function _onSetIconeLoadError(mc:MovieClip, httpStatus:Number)
	{
		_onSetIconeLoadComplete(mc);
	}
	
		
}// end of class


