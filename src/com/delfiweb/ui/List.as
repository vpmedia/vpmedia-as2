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
import de.alex_uhlmann.animationpackage.animation.Volume;



/**
 * List is a container object. It's used a ScrollBar Object to scroll content.
 * 
 * We can add in the list some item ( all AbstractContainer).
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
	var typeScroll:Number = List.SCROLL_VERTICAL;
	var sGraphicsScroll:String = "ScrollBar";
	var oSquare:Square = new Square ("Square", largeurW, hauteurH, 2);
	var oList:List = new List(coordX, coordY, oSquare, padding, tailleScroll, typeScroll, sGraphicsScroll, largeurW, hauteurH );
	oList.attach(mcBase);
	
	
	// add items in the list	
	var coordX:Number = 0;
	var coordY:Number = 0;
	var largeurW:Number = 145;
	var hauteurH:Number = 30;
	var padding:Number = 3;
	var txt:String = "<p align='left'><i>Infos </i> <b>Bulle</b> !!!</p>";
	var urlIcon:String = "mini.jpg";
	var posIconeLeft:Boolean = false;
	var oSquare:Square = new Square ("Square2", largeurW, hauteurH, 2);
	var txtTooltip:String = "<p align='left'><i>Infos </i> <b>Bulle</b> un texte très long mais vraiment plus long!!!</p>";

		
	for (var iCpt:Number=0; iCpt<3; iCpt++)
	{
		var txt:String = "Button left __ "+iCpt.toString();
		var oButton = new Button(coordX, coordY, padding, txt, urlIcon, posIconeLeft, txtTooltip, oSquare.clone(), largeurW, hauteurH);
		oList.addContent(oButton, "left");
		oButton.onRelease = new Delegate(this, _onBtnRelease, oButton.value).getFunction();
	}

	
 * 
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 01/02/2007
 */
class com.delfiweb.ui.List extends AbstractContainer
{
		
	/* clips principaux */
	private var _mcContainer			: MovieClip; // contient tout le graphisme du List
    private var _mcContent				: MovieClip; // le contenu scrollé par le List
    private var _mcAbstract				: MovieClip; // the movieclip of AbstractContainer
	
	
	/* caractéristiques de la List */	
    private var _nPadding				: Number;// sa marge intérieur entre le contenu et le container
	private var _nNextPos				: Number;// the next position (_y) for the next AbstractContainer added in the list
	private var _aContentInst			: Array;// contain all instance of all object added in the list
	
	
	/* caractéristiques de la zone visible */
	private var _nLargeurCadre			: Number;// Largeur du rectangle de visualisation
	private var _nHauteurCadre			: Number;// Hauteur du rectangle de visualisation
	
	
	/* gestion de la scrollbarre */
	private var _nTypeScroll			: Number; // type de scroll (vertical, horizontal ou automatique)
	private var _oScrollBar				: ScrollBar;	// L'object scrollbar Vertical
	private var _nHScroll				: Number;// espace réservé pour l'affichage de la scrollBar
	private var _sGraphicsScroll		: String;// link of a clip contain in library or link of a swf who contain scrollbar element


	/* les objets utilisés */
	private var _oManager				: ManageFunction;// gestion d'une pile de fonctions à éxécuter
	private var _oForm					: AbstractForm;// l'object Form utilisé pour créer un arrière plan (Square, Circle, Background)
	private var _oMcGraphic				: MovieClipGraphic;
	
	
	/* constantes */
	private var _nDepth					: Number;// profondeur des clips
	public static var SCROLL_VERTICAL	: Number=1; // scroll Vertical autorisé
	public static var SCROLL_NO_USED	: Number=2; // never scrolling content
	
	

	
	/**
	 * CONSTRUCTOR
	 * 
	 * @see     
	 * @param  x            : La position du List sur l'axe des abscisses
	 * @param  y            : La position du List sur l'axe des ordonnées
	 * @param  oAbsForm (option): Objet AbstractForm for the background
	 * @param  pad          : padding of the List
	 * @param  tailleScroll : L'espace réservé à l'affichage de la scrollBar sur le clip qui l'attache. Selon si elle est verticale ou horizontale cela représente sa largeur ou sa hauteur
	 * @param  typeScoll    : Le type du scroll : (1-vertical+horizontal) (2-vertical) (3-horizontal)
	 * @param  sGraphicsScroll : link of a clip contain in library or link of a swf who contain scrollbar element
	 * @param  w            : La largeur du List
	 * @param  h            : La hauteur du List
	 * 
	 * @return  
	 */
	public function List(x:Number,y:Number, oAbsForm:AbstractForm,
	pad:Number,tailleScroll:Number, typeScoll:Number, sGraphicsScroll:String, w:Number,h:Number)
    {
		super("List_"+random(100), x, y); // création d'un AbstractContainer
		
		this._oManager = new ManageFunction(this); // gestion des actions à effectuer
		
		// dimensions du placeHolder
		_nWidth = w ? w : 0;
		_nHeight = h ? h : 0;
		_nDepth = 10;
		// si on a un arrière plan
		// si on a un arrière plan
		if( oAbsForm!=undefined)
		{
			_oForm = oAbsForm;
			
			// update size of Label
			if( _nWidth<_oForm.getWidth() ) _nWidth = oAbsForm.getWidth();
			if( _nHeight<_oForm.getHeight() ) _nHeight = oAbsForm.getHeight();
		}
		
			
		if(pad!=undefined) _nPadding=pad; // La marge interieur du List
		
		_nNextPos = 0;
		_aContentInst = new Array();
		
		/* scrollbar */
		_sGraphicsScroll = sGraphicsScroll ? sGraphicsScroll : "ScrollBar"; // TEMP
		
		_nHScroll = tailleScroll;// Espace réservé pour l'affichage de la scrollBar
		
		if( typeScoll>0 && typeScoll<3) _nTypeScroll = typeScoll;//Le type du scrolling
		else _nTypeScroll = List.SCROLL_VERTICAL;

		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
		
		Mouse.addListener(this); 
    }	
	
	

/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/




	/**
	 * Ajoute du contenu à un List
	 * 
	 * @param   oContent Un objet AbstractContainer, un BitmapData, une chaîne ou rien.
	 * @param   pos La position du contenu dans le placeHolder (left, center, right)
	 * @return  Le clip crée 
	 * @exceptions	Error	Si on essaye de mettre autre chose que ce qui est listé ci dessus.
	 */
	public function addContent(absContent:AbstractContainer, pos:String):Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( addContent.toString()+arguments.toString() ) )
		{
			// si aucun paramètre
			if(!absContent)
			{
				Logger.LOG("You must do specify an AbstractContainer to use addContent in class List");
				return;
			}		
			// add an AbstractContainer
			_mcAbstract = _mcContent.createEmptyMovieClip("item_"+_nDepth, _nDepth++);
			_mcAbstract._y = _nNextPos;
			
			var oContentInfos:Object = new Object();
			oContentInfos.mc = _mcAbstract;
			oContentInfos.item_inst = absContent;			oContentInfos.position = pos;
			
			_aContentInst.push(oContentInfos);
			
			absContent.addListener(this);
			absContent.attach(_mcAbstract);
		}
		else
		{
			_oManager.addFunction(addContent, arguments); // on l'ajoute à la liste des actions à faire
		}
	
	}

	
	/**
	 * Set the content of the list at the top (scrolling move her).
	 * 
	 */
	public function setContentAtTop():Void
	{
		_mcContent._y = 0;
		// repositionner la slide de la scrollbarre tout en haut.
		return;
	}
	

	/**
	 * Met à jour l'objet List, recalcule la visibilité du contenu.
	 * Ajoute d'une scrollBarre si nécessaire.
	 * 
	 */
	public function update(nSizeContent:Number)
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( update.toString()+arguments.toString() ) )
		{
			_oScrollBar.update(nSizeContent);
			_oManager.setReady(); // la fonction est terminée
		}
		else
		{
			_oManager.addFunction(update, arguments); // on l'ajoute à la liste des actions à faire
		}
	}
		
	
		
	
	/**
	 * Update background of List
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
		_oScrollBar.removeMouseListener();
				
		delete _oScrollBar;
		
		super.destruct(); // suprime le AbstractContainer associé
		delete this;// supprime l'objet lui-même
		return true;
	}
	
	
	
	
	/**
	 * Supprime le contenu du List.
	 * Permet ensuite d'insérer ensuite un nouveau contenu.
	 * 
	 * @see     
	 */
	public function removeContent():Void
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( removeContent.toString()+arguments.toString() ) )
		{
			this.update(0); // mise à jour du contenu
			
			this._nDepth = 10;
		
			var mc:MovieClip;
			var oContentInfos:Object = new Object();
			
			// remove all items
			for(var nCpt:Number=0; nCpt<_aContentInst.length; nCpt++)
			{
				oContentInfos = _aContentInst[nCpt];
				oContentInfos.mc.removeMovieClip();
				oContentInfos.item_inst.destruct();// we can use the same object in the list.
			}

			// set initial position of the content clip
			_mcContent._x = 0;
			_mcContent._y = 0;
			_nNextPos = 0;
			_aContentInst = new Array();
			
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
	 * Call by AbstractContainer when item AbstractContainer is ready
	 * 
	 * @return  
	 */
	private function _onAbstractContainerBuild()
	{
		var oContentInfos:Object = _aContentInst[ _aContentInst.length-1 ];
		
		var oInstAbstract:AbstractContainer = oContentInfos.item_inst;
		oInstAbstract.removeListener(this);
		
		// update position of the next container
		_nNextPos += oInstAbstract.getHeight()+ _nPadding;
		
		// set the position of the container
		if( oContentInfos.position!=undefined) 
			this.posElement(oContentInfos.item_inst, oContentInfos.mc, oContentInfos.position); // positionne le contenu
		
		// update scrollbarre size		
		var nSizeContent:Number = _nNextPos;//var nSizeContent:Number = _mcContent._height;
		this.update(nSizeContent);
		
		_oManager.setReady(); // free manage function
	}
	
	
	
	
	
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
		
		// on crée le clip qui contient le contenu du List (ce qui pourra être scrollé)
		_mcContent = _mcContainer.createEmptyMovieClip("scrollContent",1);
		_mcContent.cacheAsBitmap=true;
			
		// on positionne le contenu du List
		_mcContainer._x= _nPadding;			
		_mcContainer._y= _nPadding;
		
		this.createScrollBar();
		this.attachScrollBar();
		
		// ajoute un effet sur le contenu du List
		// distance, angle, color, alpha, blurX, blurY, strength, quality, inner
		var oDSFeffect:DropShadowFilter = new DropShadowFilter(0, 0, 0x000000, 1, 2, 2, 1, 2, true);
		_mcContent.filters = [oDSFeffect];
	}	
	
	


	/*----------------------------------------------------------*/
	/*------------- Gestion de la scrollbarre ------------------*/
	/*----------------------------------------------------------*/



	/**
	 * Ajoute une scrollBarre au List
	 * 
	 * 
	 */	
	private function createScrollBar()
	{
		if(_oScrollBar._displayable)
		{
			_oScrollBar.remove();
		}
		
		switch(_nTypeScroll)
		{
			// cas scroll vertical
			case List.SCROLL_VERTICAL:				
					_nLargeurCadre = _nWidth - 2*_nPadding - _nHScroll;
					_nHauteurCadre = _nHeight - 2* _nPadding;
					
					_oScrollBar = new ScrollBar(_sGraphicsScroll, _mcContent, null, null,_nWidth, _nHeight, _nHauteurCadre, "_y");
				break;
			
			case List.SCROLL_NO_USED:
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
				case List.SCROLL_VERTICAL:
						_oScrollBar.attach(_mcBase);
					break;
				
				case List.SCROLL_NO_USED:
					break;
					
				default:
					_oScrollBar.destruct();				
										
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
		if (_oScrollBar) _oScrollBar.addMouseListener();
	}
	
	
	/**
	 * Suppression de la gestion molette sur la scrollbar
	 * 
	 * @return  
	 */
	private function removeMouseListener()
	{
		if (_oScrollBar) _oScrollBar.removeMouseListener();
	}
	
	
	
	

	/**
	 * Fonction permettant de position un objet de type clip, image, swf, button, 
	 * bitmapData dans le placeHolder
	 * 
	 * @param  o   : Le movie clip à positioner (le contenu)
	 * @param  pos : La position : left-center-right
	 */
	private function posElement(oAbstract:AbstractContainer, mc:MovieClip, pos:String)
	{
		switch(pos)
		{
			case "left" :
				mc._x=0;
				break;
				
			case "center" :
				mc._x = (_nLargeurCadre/2) - (oAbstract.getWidth()/2);
				break;
				
			case "right" :
				mc._x = _nLargeurCadre - oAbstract.getWidth();
				break;
				
			default :
				mc._x=0;
				break;				
		}
	}


}// end of class
