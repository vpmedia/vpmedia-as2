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
import com.delfiweb.ui.AbstractContainer;
import com.delfiweb.display.MovieClipGraphic;
import com.delfiweb.form.AbstractForm;
import com.delfiweb.ui.ScrollBar;

import com.delfiweb.utils.ManageFunction;


// Classes Macromedia
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.filters.DropShadowFilter;

// Classe Bourre
import com.bourre.commands.Delegate;



//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;



/**
 * PlaceHolder is a container object. It's used a ScrollBar Object to scroll content.
 * Containers object are type of : clip of library, texte, picture, swf, bitmapData and some AbstractContainer.
 * 
 * 
 * 
 * 
 * @usage :
 * 
	var coordX:Number = 10;
	var coordY:Number = 10;
	var largeurW:Number = 180;
	var hauteurH:Number = 210;
	var padding:Number = 5;
	var tailleScroll:Number = 16;
	var typeScroll:Number = PlaceHolder.SCROLL_AUTO;
	var sGraphicsScroll:String = "ScrollBar";
	var oSquare:Square = new Square ("Square", largeurW, hauteurH, 2);
	var ph:PlaceHolder = new PlaceHolder(coordX, coordY, oSquare, padding, tailleScroll, typeScroll, sGraphicsScroll, largeurW, hauteurH );

	ph.attach(mcBase);
	//ph.addContent(oTxtField); // un champ texte
	//ph.addContent("background"); // clip de la bibliothèque

	//ph.addContent("Coucher_de_soleil_mini.jpg");// une image externe
	//ph.addContent("Collines_gde.jpg");// une image externe
	//ph.addContent("Hiver_haute.jpg");// une image externe
	//ph.addContent("Nenuphars_large.jpg");// une image externe
	ph.addContent("swf-externe.swf")// un swf externe
 * 
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006
 */
class com.delfiweb.ui.PlaceHolder extends AbstractContainer
{
		
	/* clips principaux */
	private var _mcContainer:MovieClip; // contient tout le graphisme du PlaceHolder
    private var _mcContent: MovieClip; // le contenu scrollé par le PlaceHolder
	
	
	/* caractéristiques du PlaceHolder */	
    private var _nPadding:Number=5;// sa marge intérieur entre le contenu et le container

	
	/* caractéristiques de la zone visible */
	private var _nLargeurCadre:Number;// Largeur du rectangle de visualisation
	private var _nHauteurCadre:Number;// Hauteur du rectangle de visualisation
	
	
	/* gestion de la scrollbarre */
	private var _nTypeScroll:Number; // type de scroll (vertical, horizontal ou automatique)
	private var _oScrollBarV:ScrollBar;	// L'object scrollbar Vertical
	private var _oScrollBarH:ScrollBar;	// L'objet scrollbar horizontal
	private var _nHScroll:Number;// espace réservé pour l'affichage de la scrollBar
	private var _sGraphicsScroll:String;// link of a clip contain in library or link of a swf who contain scrollbar element


	/* les objets utilisés */
	private var _oManager:ManageFunction;// gestion d'une pile de fonctions à éxécuter
	private var _oForm:AbstractForm;// l'object Form utilisé pour créer un arrière plan (Square, Circle, Background)
	private var _oMcGraphic:MovieClipGraphic;
	
	
	/* constantes */
	private var _nDepth:Number=10;// profondeur des clips
	public static var SCROLL_AUTO:Number=1; // ajout automatique des scrollBarre lorsque le contenu doit être déplacé
	public static var SCROLL_VERTICAL:Number=2; // scroll Vertical autorisé
	public static var SCROLL_HORIZONTAL:Number=3; // scroll Horizontale autorisé
	public static var SCROLL_NO_USED:Number=4; // never scrolling content
	
	
		
	/* divers */
	private var _oLoader:MovieClipLoader;// MovieClipLoader pour le chargement d'image
	

	
	/**
	 * CONSTRUCTOR
	 * 
	 * @see     
	 * @param  x            : La position du PlaceHolder sur l'axe des abscisses
	 * @param  y            : La position du PlaceHolder sur l'axe des ordonnées
	 * @param  oAbsForm (option): Objet AbstractForm for the background
	 * @param  pad          : padding of the PlaceHolder
	 * @param  tailleScroll : L'espace réservé à l'affichage de la scrollBar sur le clip qui l'attache. Selon si elle est verticale ou horizontale cela représente sa largeur ou sa hauteur
	 * @param  typeScoll    : Le type du scroll : (1-vertical+horizontal) (2-vertical) (3-horizontal)
	 * @param  sGraphicsScroll : link of a clip contain in library or link of a swf who contain scrollbar element
	 * @param  w            : La largeur du PlaceHolder
	 * @param  h            : La hauteur du PlaceHolder
	 * 
	 * @return  
	 */
	public function PlaceHolder(x:Number,y:Number, oAbsForm:AbstractForm,
	pad:Number,tailleScroll:Number, typeScroll:Number, sGraphicsScroll:String, w:Number,h:Number)
    {
		super("PlaceHolder_"+random(100), x, y); // création d'un AbstractContainer
		
		this._oManager = new ManageFunction(this); // gestion des actions à effectuer
		
		// dimensions du placeHolder
		_nWidth = w ? w : 0;
		_nHeight = h ? h : 0;
		
		// si on a un arrière plan
		// si on a un arrière plan
		if( oAbsForm!=undefined)
		{
			_oForm = oAbsForm;
			
			// update size of Label
			if( _nWidth<_oForm.getWidth() ) _nWidth = oAbsForm.getWidth();
			if( _nHeight<_oForm.getHeight() ) _nHeight = oAbsForm.getHeight();
		}
		
			
		if(pad!=undefined) _nPadding=pad; // La marge interieur du PlaceHolder
		
		/* scrollbarr*/
		_sGraphicsScroll = sGraphicsScroll ? sGraphicsScroll : "ScrollBar"; // TEMP
		
		_nHScroll = tailleScroll;// Espace réservé pour l'affichage de la scrollBar
		
		if( typeScroll>0 && typeScroll<5) _nTypeScroll = typeScroll;//Le type du scrolling
		else _nTypeScroll = PlaceHolder.SCROLL_AUTO;

		/* Objet MovieClipLoader pour le chargement des images et swf */
		_oLoader = new MovieClipLoader();
		var listener:Object=new Object();//Ecouteur sur le movieClipLoader qui charge les images
		
		listener.onLoadInit=Delegate.create(this,_onLoadComplete);		
		_oLoader.addListener(listener);
		
		
		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
		
		Mouse.addListener(this); 
    }	
	
	

/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/


	/**
	 * Ajoute du contenu à un PlaceHolder
	 * 
	 * @param   oContent Un objet AbstractContainer, un BitmapData, une chaîne ou rien.
	 * @param   pos La position du contenu dans le placeHolder (left, center, right)
	 * @return  Le clip crée 
	 * @exceptions	Error	Si on essaye de mettre autre chose que ce qui est listé ci dessus.
	 */
	public function addContent(oContent, pos:String)
	{
		this.removeContent(); // supprime l'ancien contenu du PlaceHolder

		// si aucun paramètre
		if(!oContent)
		{
			_mcContent.createEmptyMovieClip("content", _nDepth);
		}
		// si il s'agit d'un identifiant de liaison ou d'une url d'image ou d'un swf
		else if(typeof oContent == "string")
		{
			this.addClipOrImage(oContent);
		}
		// si c'est un BitmapData
		else if(oContent instanceof BitmapData)
		{
			this.addBitmapData(oContent);
		}			
		// si on a un AbstractContainer
		else if(oContent._displayable)
		{
			// permet de modifier le clip d'un objet AbstractContainer déjà attaché sur la scène
			_mcContent.content = oContent;
			oContent.attach(_mcContent, _nDepth);
		}
		// on n'a pas recu un objet valide
		else
		{
			Logger.LOG("You can't add this content : "+oContent+" ('"+(typeof oContent)+"') in the PlaceHolder.");
			return;
		}
		

		this.update(); // mise à jour du contenu
		if( pos!=undefined) this.posElement(_mcContent.content, pos); // positionne le contenu
		
		// ajoute un effet sur le contenu du PlaceHolder
		// distance, angle, color, alpha, blurX, blurY, strength, quality, inner
		/*var oDSFeffect:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 1, 2, 2, 1, 2, true);
		_mcContent.filters = [oDSFeffect];*/
		 
		_nDepth++;
	}


	/**
	 * Met à jour l'objet PlaceHolder, recalcule la visibilité du contenu.
	 * Ajoute d'une scrollBarre si nécessaire.
	 * 
	 */
	public function update()
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( update.toString()+arguments.toString() ) )
		{
			// set initial position of the content clip
			_mcContent._x = 0;
			_mcContent._y = 0;
			this.createScrollBar();
			this.attachScrollBar();// rajouter ScrollBar.update --> taille du contenu qui change
			
			/*_oScrollBarH.update();// test
			_oScrollBarV.update();// test
				*/	
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(update, arguments); // on l'ajoute à la liste des actions à faire
		}
	}
		
	
		
	
	/**
	 * Update background of PlaceHolder
	 * 
	 * @param   oAbsForm : an abject (Square, circle or Background)
	 * @return  
	 */
	public function updateBackground(oAbsForm:AbstractForm):Void
	{
		if( _oForm ) _oForm.destruct();
		
		_oForm = oAbsForm;
		_oForm.attach(_mcBase, 1);
		
		return;
	}
	

	/**
	 * Renvoie le movieClip contenu du PlaceHolder
	 * 
	 * @return  
	 */
	public function get content()
	{
		return _mcContent;
	}
	
	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct():Boolean
	{
		// si il y a un fond au placeholder
		if( _oForm )
		{
			_oForm.remove();
			delete _oForm;
		}
			
		Mouse.removeListener(this);
		_oScrollBarV.removeMouseListener();
		_oScrollBarH.removeMouseListener();
		
		delete _oLoader;		
		delete _oScrollBarV;
		delete _oScrollBarH;
		
		super.destruct(); // suprime le AbstractContainer associé
		delete this;// supprime l'objet lui-même
		return true;
	}
	
	
	
	
	/**
	 * Delete the content of PlaceHolder.
	 * Permet ensuite d'insérer ensuite un nouveau contenu.
	 * 
	 * @see     
	 */
	public function removeContent():Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( removeContent.toString()+arguments.toString() ) )
		{
			this._nDepth = 10;
		
			// si le contenu est un AbstractContainer
			if(_mcContent.content._displayable)
			{
				_mcContent.content.remove();
			}
			// si le PlaceHolder a du contenu
			else if( _mcContent.content )
			{
				_mcContent.content.removeMovieClip();
			}
			
			// set initial position of the content clip
			_mcContent._x = 0;
			_mcContent._y = 0;
			
			_oManager.setReady(); // la fonction est terminée

		}
		else
		{
			_oManager.addFunction(removeContent, arguments); // Si la fonction ne peut pas s'executer, on l'ajoute à la lsite des actions à faire
		}
		
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
		if(_oForm) _oForm.attach(_mcBase, 1);

		// clip qui va contenir tous le graphisme du placeHolder
		_mcContainer = _mcBase.createEmptyMovieClip("__PlaceHolder_container__", 2);
		_mcContainer.cacheAsBitmap=true;
		
		// on crée le clip qui contient le contenu du PlaceHolder (ce qui pourra être scrollé)
		_mcContent = _mcContainer.createEmptyMovieClip("scrollContent",1);
		_mcContent.cacheAsBitmap=true;
				
		// on positionne le contenu du PlaceHolder
		_mcContainer._x= _nPadding;			
		_mcContainer._y= _nPadding;
	}	
	
	
	/*----------------------------------------------------------------*/
	/*----- Gestion des différents types de contenu du PlaceHolder ---*/
	/*----------------------------------------------------------------*/
	
	
	/**
	 * Attache un bitmapData au placeHolder
	 * 
	 * @param  bitmap : BitmapData à attacher
	 */
	private function addBitmapData(bitmap:BitmapData):Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( addBitmapData.toString()+arguments.toString() ) )
		{
			var mcContent:MovieClip = _mcContent.createEmptyMovieClip("content", _nDepth);
		
			mcContent.attachBitmap(bitmap, 0);
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(addBitmapData, arguments); // Si la fonction ne peut pas s'executer, on l'ajoute à la lsite des actions à faire
		}

		
	}
	
	
	
	/**
	 * Affiche un clip si c'est un id de liaison de la bibliothèque
	 * Charge une image ou un swf externe si c'est une url
	 * 
	 * @param  clipImg : id de liaison ou une url de l'image ou du swf à charger
	 */
	private function addClipOrImage(clipImg:String)
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( addClipOrImage.toString()+arguments.toString() ) )
		{
			var mcContent:MovieClip = _mcContent.attachMovie(clipImg, "content", _nDepth);
			
			// si c'est une url de l'image ou du swf à charger
			if( !mcContent )
			{
				mcContent = _mcContent.createEmptyMovieClip("content", _nDepth);
				_oLoader.loadClip(clipImg, mcContent);
			}
			else// c'est un id de liaison pour le clip
				_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(addClipOrImage, arguments); // Si la fonction ne peut pas s'executer, on l'ajoute à la lsite des actions à faire
		}
		
		
	}
	
	
		
	/**
	 * Fonction appelée lorsqu'une image ou swf externe à fini d'être chargé
	 * 
	 * @param  target_mc : l'image ou le swf chargé
	 */
	private function _onLoadComplete(target_mc:MovieClip):MovieClip
	{
		_oManager.setReady(); // la fonction est terminée
		return target_mc;		
	}
	


	/*----------------------------------------------------------*/
	/*------------- Gestion de la scrollbarre ------------------*/
	/*----------------------------------------------------------*/



	/**
	 * Ajoute une scrollBarre au PlaceHolder
	 * 
	 * 
	 */	
	private function createScrollBar()
	{
		// si la scrollbarre existe, on la supprime
		if(_oScrollBarH._displayable)
		{
			_oScrollBarH.remove();
		}
		
		if(_oScrollBarV._displayable)
		{
			_oScrollBarV.remove();
		}
		
		switch(_nTypeScroll)
		{
			// cas scroll vertical
			case PlaceHolder.SCROLL_VERTICAL:				
					_nLargeurCadre = _nWidth - 2*_nPadding - _nHScroll;
					_nHauteurCadre = _nHeight - 2* _nPadding;
					
					_oScrollBarV = new ScrollBar(_sGraphicsScroll, _mcContent, null, null,_nWidth, _nHeight, _nHauteurCadre, "_y");
				break;
			
			// cas scroll horizontale
			case PlaceHolder.SCROLL_HORIZONTAL:					
				_nLargeurCadre = _nWidth - 2*_nPadding;
				_nHauteurCadre = _nHeight - 2* _nPadding - _nHScroll;
				
				_oScrollBarH = new ScrollBar(_sGraphicsScroll, _mcContent, null, null,_nWidth, _nHeight, _nLargeurCadre, "_x");
				break;
			
			// cas scroll horizontal et vertical
			case PlaceHolder.SCROLL_AUTO:
				_nLargeurCadre = _nWidth - 2*_nPadding - _nHScroll; 
				_nHauteurCadre = _nHeight - 2*_nPadding - _nHScroll;
				
				_oScrollBarV = new ScrollBar(_sGraphicsScroll, _mcContent, null, null,_nWidth, _nHeight, _nHauteurCadre, "_y");
				
				// prend en compte l'épaisseur de la scrollBar verticale
				_oScrollBarH = new ScrollBar(_sGraphicsScroll, _mcContent, null, null,_nWidth - _nHScroll, _nHeight, _nLargeurCadre, "_x");
				break;
			
			
			case PlaceHolder.SCROLL_NO_USED:
				_nLargeurCadre = _nWidth - 2*_nPadding;
				_nHauteurCadre = _nHeight - 2* _nPadding;
				break;
			
			default:
			
			
		}
		
		// On crée le clip rectangle de visualisation (le masque)
		var r:Rectangle = new Rectangle(0,0, _nLargeurCadre, _nHauteurCadre);
		_mcContainer.scrollRect = r;	
	}
	
	
	
	/**
	 * Appelle la fonction attach de la scrollBar, 
	 * ce qui permet de configurer et d'afficher la scrollBar sur le placeHolder
	 * 
	 */
	private function attachScrollBar()
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( attachScrollBar.toString()+arguments.toString() ) )
		{			
			switch(_nTypeScroll)
			{
				// cas scroll vertical
				case PlaceHolder.SCROLL_VERTICAL:
					// si le contenu est plus haut que le PlaceHolder -> ajout d'une scrollbarre
					if((_mcContent._height-_nHauteurCadre)>0)
					{
						_oScrollBarV.attach(_mcBase);
					}
					break;
				
				// cas scroll horizontale
				case PlaceHolder.SCROLL_HORIZONTAL:
					// si le contenu est plus large que le PlaceHolder -> ajout d'une scrollbarre
					if((_mcContent._width-_nLargeurCadre)>0)
					{
						_oScrollBarH.attach(_mcBase);
					}
					break;
				
				// cas scroll horizontal et vertical
				case PlaceHolder.SCROLL_AUTO:
					// si le contenu est plus haut que le PlaceHolder -> ajout d'une scrollbarre
					if((_mcContent._height-_nHauteurCadre)>0)
					{
						_oScrollBarV.attach(_mcBase);
					}
					
					// si le contenu est plus large que le PlaceHolder -> ajout d'une scrollbarre
					if((_mcContent._width-_nLargeurCadre)>0)
					{
						_oScrollBarH.attach(_mcBase);
					}
					break;
				
				case PlaceHolder.SCROLL_NO_USED:
					break;
					
				default:
					_oScrollBarV.destruct();
					_oScrollBarH.destruct();
				
										
			}
			_oManager.setReady(); // Lorsque la fonction est terminée on le précise ( cela peut très bien se produire dans une autre fonction si on souhaite enchainer plus choses à faire avant de libérer la place
		}
		else
		{
			_oManager.addFunction(attachScrollBar, arguments); // Si la fonction ne peut pas s'executer, on l'ajoute à la lsite des actions à faire
		}
	}
	
	
	/*---------------------------------------------------------*/
	/*-------------- Gestion de la souris ---------------------*/
	/*---------------------------------------------------------*/
	
	
	
	/**
	 * Signalé lorsque d'un clique sur la souris.
	 * Suppression de l'écouteur de la souris si l'internaute à cliqué en dehors de la cible
	 * 
	 * @see     
	 * @return  
	 */
	private function onMouseDown ():Void
	{
		/* détermine les coordonnées de la souris au niveau du clip de base */
		var oSouris:Object = {x:_mcBase._xmouse, y:_mcBase._ymouse};	
		//_mcBase.globalToLocal(oSouris);
		
		// if Mouse is under _mcBase
		if( oSouris.x < this._nWidth && oSouris.y < this._mcBase._height
		 && oSouris.x > 0 && oSouris.y > 0 )
		{
			this.addMouseListener();
		}
		else
			this.removeMouseListener();


		
		return;
	}
	
	
	/**
	 * Ajouter la gestion molette sur la scrollbar
	 * 
	 * @return  
	 */
	private function addMouseListener()
	{
		if (_oScrollBarV) _oScrollBarV.addMouseListener();
		if (_oScrollBarH) _oScrollBarH.addMouseListener();
	}
	
	
	/**
	 * Suppression de la gestion molette sur la scrollbar
	 * 
	 * @return  
	 */
	private function removeMouseListener()
	{
		if (_oScrollBarV) _oScrollBarV.removeMouseListener();
		if (_oScrollBarH) _oScrollBarH.removeMouseListener();
	}
	
	
	
	

	/**
	 * Fonction permettant de position un objet de type clip, image, swf, button, 
	 * bitmapData dans le placeHolder
	 * 
	 * @param  o   : Le movie clip à positioner (le contenu)
	 * @param  pos : La position : left-center-right
	 */
	private function posElement(mc:MovieClip,pos:String)
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( posElement.toString()+arguments.toString() ) )
		{
			switch(pos)
			{
				case "left" :
					mc._x=0;
					break;
					
				case "center" :
					mc._x = (_nLargeurCadre/2) - (mc._width/2);
					break;
					
				case "right" :
					mc._x = _nLargeurCadre - mc._width;
					break;
					
				default :
					mc._x=0;
					break;				
			}
			
			_oManager.setReady(); // Lorsque la fonction est terminée on le précise ( cela peut très bien se produire dans une autre fonction si on souhaite enchainer plus choses à faire avant de libérer la place
		}
		else
		{
			_oManager.addFunction(posElement, arguments); // Si la fonction ne peut pas s'executer, on l'ajoute à la lsite des actions à faire
		}
		
	}


}// end of class
