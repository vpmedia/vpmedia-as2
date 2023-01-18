
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


// Classe Bourre
import com.bourre.commands.Delegate;


// Classes Macromédia
import flash.geom.Rectangle;


//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;


/**
 * todo : 
 * 		- implémenter la classe ManageFunction (cas chargement d'une bibliothèque graphique externe.
 * 		- corriger le bug de déplacement sur la _slide (calcul de la valeur basse erronée --- arrondie).
 * 
 */


/**
 * ScrollBar can be used on all content.
 * It can make some vertical, horizontal movements.
 * 
 * In library or on a swf file, movieclip do have this names : _scrollUp, _scrollDown, _slide, _track.
 * 
 * It's possible to set the content of scrollbar with method setPos.
 * It's possible to update speed of movement's content with getter scrollDelta.
 * 
 * 
 * 
 * 
 * @usage

	_mcContent = _root.attachMovie("clip"," clip", 2);
	var _nWidth:Number = 100;
	var _nHeight:Number = 250;
	var _nPadding:Number = 10;
	_nHauteurCadre:Number = _nHeight - 2* _nPadding;
					
	_oScrollBar = new ScrollBar(_mcContent, null, null,_nWidth, _nHeight, _nHauteurCadre, "_y");
	_oScrollBar.attach(_root);			

 * 
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006
 * @update
 */
class com.delfiweb.ui.ScrollBar extends AbstractContainer
{
	/* clips principaux */
	private var _oCible							: MovieClip;// Cible à scroller
	
	
	/* clips de la scrollBarr */
	private var _mcScrollBar					: MovieClip;// Clip de la scrollbar
	private var _mcScrollUp						: MovieClip;// Clip de la flèche supérieure de la scrollbarre
	private var _mcScrollDown					: MovieClip;// Clip de la flèche inférieure de la scrollbarre
	private var _mcScrollSlide					: MovieClip;// Clip du fond de la scroll vertical
	private var _mcScrollTrack					: MovieClip;// Clip de la glissiere de la scroll vertical
	
	
	/* navigation de la scrollbar */
	private var _sSensScroll					: String; // direction du scroll horizontal ou vertical
	private var _sTargetScroll					: String; // la propriété cible du clip scrollé
	
	
	/* caractéristiques de la scrollbar */
	private var _nCoefSlide						: Number;// Coefficient multiplicateur du scroll avec le slide
	private var _nSizeVisible					: Number;// Taille de la zone de visualisation
	private var _nPadding						: Number = 4; // Padding interne de la scrollbar par rapport au contenu à déplacer
	
	
	/* constantes de calcul du scroll */
	private var _nScrollDelta					: Number=33;//Pas du scrolling en pixel
	
	private var _nLongueurUp					: Number;//Distance restant à parcourir vers le haut (ou gauche)
	private var _nLongueurDown					: Number;//Distance restant à parcourir vers le bas (ou droite)
	
	private var _nYInitScroll					: Number;//Position haut du slide de la scroll
	private var _nYFinalScroll					: Number;//Position basse du slide de la scroll
	

	/* écouteur sur la scrollbarre */
	private var _bMouseListener					: Boolean; // permet de savoir si l'écouteur sur la souris est déjà crée (true -> existant)

	private var _oMcGraphic						: MovieClipGraphic;
	
	
	/* constantes */
	private static var N_DECAL_FORM				: Number = 8;// compense le décalage de la taille du à la classe Form
	
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 * @see     
	 * @param   sGraphics	: link of a clip contain in library or link of a swf who contain scrollbar element
	 * @param   cible 		: le clip à scroller            
	 * @param   x 			: (option) position of the scrollbar       
	 * @param   y 			: (option) position of the scrollbar       
	 * @param   w 			: width of the visible area (permet de laisser une place pour la scrollbarre)
	 * @param   h 			: height of the visible area (permet de laisser une place pour la scrollbarre)
	 * @param   tailleZoneVisible : size of visible area for the scroll (une hauteur ou une largeur à scroller) 
	 * @param   sensScroll 	: sens of scroll (_x pour horizontale ou _y pour verticale)       
	 * @return  
	 */
	public function ScrollBar(sGraphics:String, cible:MovieClip, x:Number, y:Number, 
	w:Number,	h:Number, tailleZoneVisible:Number, sensScroll:String)
	{
		super("ScrollBar_"+random(100)); // création d'un AbstractContainer  
		
		// position de la scrollBar spécifiée
		_nX = x ? x : null;
		_nY = y ? y : null;
		
		// taille de la zone de visualisation
		_nWidth = w ? w : 0;
		_nHeight = h ? h : 0;
		
		/* sens du scroll */
		this._sSensScroll = sensScroll;
		if( _sSensScroll == "_x" )
			_sTargetScroll = "_width";
		else
			_sTargetScroll = "_height";

		_nSizeVisible=tailleZoneVisible;

		_oCible=cible;
		
		_oMcGraphic = new MovieClipGraphic(sGraphics);
		this.setDisplayObject(_oMcGraphic);
		
		_nLongueurUp = 0;// à déplacer sur un point unique
	}
	
	

/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/

	
	
	/**
	 * Call this function when the size of the cible is updated.
	 * This function update position, size of elements who compose a ScrollBar
	 * 
	 * 
	 * @param   nSize (option)	: height of the content
	 * @return  
	 */
	public function update( nSize:Number )
	{
		var nSizeContent:Number;
		if( nSize!=undefined ) nSizeContent = nSize;
		else nSizeContent = _oCible[_sTargetScroll];
		
		// calcul la distance non visible de la cible
		_nLongueurDown = nSizeContent - _nSizeVisible;
		
		
		/* redimensionne la glissière de déplacement en fonction de la taille de la zone visible */
		_mcScrollSlide._height = _nSizeVisible*_nSizeVisible / nSizeContent;
		
		// taille minimum pour la slide 
		if( _mcScrollSlide._height<30 ) _mcScrollSlide._height = 30;
		
		_nYInitScroll = this._mcScrollUp._y + this._mcScrollUp._height - this._nPadding;
		_nYFinalScroll = this._mcScrollDown._y - this._mcScrollSlide._height +this._nPadding ;
		
		// détermine le coefficient de déplacement de la cible
		var nDistanceScroll:Number = nSizeContent - _nSizeVisible;
		var nTrackSize:Number = _nYFinalScroll-_nYInitScroll;
		this._nCoefSlide = nDistanceScroll/nTrackSize;
		
		/*Logger.LOG("SCROLL_VERTICAL");
		Logger.LOG("_nSizeVisible : "+_nSizeVisible);		Logger.LOG(nSizeContent);
		Logger.LOG(_oCible._height);		Logger.LOG(_sTargetScroll);		Logger.LOG(nSize);
		*/
					
		// si la distance à scroller est positive (le contenu est trop grand)
		if( nDistanceScroll>5 )
			this.active(true);
		else // le contenu n'a pas besoin d'être scrollé pour être visible
			this.active(false);
	}
	
	
	/**
	 * Update the position of the cible.
	 * 
	 * 
	 * @see     
	 * @param   pos new value (between 0 and 1) ---> %
	 * @return  
	 */
	public function setPos(pos:Number)
	{
		// empêche les incohérences
		if( pos<0 ) pos =0;
		else if( pos>1 ) pos = 1;
		
		// si on peut scroller le contenu
		var nDistanceScroll:Number = _oCible[_sTargetScroll] - _nSizeVisible;
		if( nDistanceScroll>0 )
		{
			
			// On calcul la position qu'on veut atteindre et on repositionne le clip de contenu			
			var longueur:Number = _oCible[_sTargetScroll]-_nSizeVisible;
			
			var posCible:Number = pos*longueur;
			
			var deltaDistance:Number = _oCible[_sTargetScroll] - posCible;
			
			var deltaPos:Number;
			
			// Si la position à atteindre ne peut être amener tout en haut de la liste, on scroll
			// Le plus bas possible de façon à ce que toute la zone visible soit remplie de contenu
			if(deltaDistance <= _nSizeVisible)
				posCible = _oCible[_sTargetScroll]-_nSizeVisible;					
			

			deltaPos = posCible + _oCible[_sSensScroll];
			_oCible[_sSensScroll] = -posCible;
			
				
			//Mise à jours des variables de déplacement vers le haut et le bas				
			_nLongueurUp += deltaPos;
			_nLongueurDown -= deltaPos;
		}
	}	

	
	/**
	 * Remove only movieclip.
	 * 
	 * @return  Boolean	true -> movieclip is removed
	 */
	public function remove():Boolean
	{
		Mouse.removeListener(this);
		return super.remove();
	}
	
	
	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct()
	{
		Mouse.removeListener(this);
		super.destruct(); // suprime le AbstractContainer associé
		delete this;// supprime l'objet lui-même
	}
	
	
	
	
	/*---------------------------------------------------------*/
	/*---------------- Getter/Setter --------------------------*/
	/*---------------------------------------------------------*/


	/**
	 * Update speed of the scroll
	 * 
	 * @see     
	 * @param   p : new value in pixels
	 * @return  
	 */
	public function set scrollDelta(p:Number)
	{
		_nScrollDelta = p;
	}
	

	/**
	 * to know the speed of the scroll
	 * 
	 * @see     
	 * @return  
	 */
	public function get scrollDelta()
	{
		return _nScrollDelta;
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
		/* init des valeurs pour le scroll */
		_mcScrollUp = _mcBase._scrollUp;
		_mcScrollDown = _mcBase._scrollDown;
		_mcScrollSlide = _mcBase._slide;
		_mcScrollTrack = _mcBase._track;
		
		/* redimensionne la glissière de déplacement en fonction de la taille de la zone visible */
		var r:Rectangle = new Rectangle(3,7,10,56);
		_mcScrollSlide.scale9Grid = r;
		
		// si scroll Horizontal
		if( _sSensScroll == "_x" )
		{
			_mcBase._rotation = -90; // placement horizontale
			_mcBase._xscale = -100; // repositionne en (0;0)
		}
		
		
		/* création des actions sur la scrollbar */
		
		var refThis = this; // on stocke une référence à l'objet
		
		_mcScrollUp.onPress=function()
		{
			var oDelegate:Delegate = new Delegate(refThis, refThis.moveTarget, refThis._nScrollDelta);
			this.onEnterFrame = oDelegate.getFunction();
		};
		
		_mcScrollDown.onPress=function()
		{
			var oDelegate:Delegate = new Delegate(refThis, refThis.moveTarget, -refThis._nScrollDelta);
			this.onEnterFrame = oDelegate.getFunction();
		};
		
		_mcScrollUp.onRelease = _mcScrollUp.onReleaseOutside = function()
		{
			delete this.onEnterFrame;
		};
		
		_mcScrollDown.onRelease = _mcScrollDown.onReleaseOutside = function()
		{
			delete this.onEnterFrame;
		};
		
		
		_mcScrollSlide.onPress=function()
		{
			
			/* le clip à déplacer doit être verrouillé au point 
			* où l'utilisateur a cliqué sur le clip en premier lieu.
			* Valeurs relatives aux coordonnées du parent du clip qui spécifient 
			* un rectangle de délimitation pour le clip. (gauche, dessus, droite et bas)
			* */

			// la gauche et la droite sont inversées pour le scroll horizontale (rotation)			
			this.startDrag(false, this._x, refThis._nYInitScroll, this._x, refThis._nYFinalScroll);
			this.onEnterFrame=Delegate.create(refThis,refThis.scrollSlide);
			
		};
		
		_mcScrollSlide.onRelease = _mcScrollSlide.onReleaseOutside = function()
		{
			delete this.onEnterFrame;
			this.stopDrag();
		};
		
		_mcScrollTrack.onPress=Delegate.create(this, this._onPressTrack);
		_mcScrollTrack.useHandCursor=false;
		
		this.initScroll();
		this.update();
	
	}
	
	
	

	/**
	 * Initialise, positionne  les clips et 
	 * crée les comportements des clips de la scrollBar.
	 * 
	 */
	private function initScroll()
	{
		// si scroll horizontal
		if(_sSensScroll=="_x")
		{
			
			/* position de la scrollbar du cadre visible */
			
			if( _nX!= null )// Manuel
				_mcBase._x = _nX;
			else // Automatique
				_mcBase._x = 3;
			
			if( _nY!= null ) // Manuel
				_mcBase._y = _nY;
			else// Automatique
				_mcBase._y = _nHeight - _mcScrollUp._height + this._nPadding;
			
		}
		// sinon scroll vertical
		else
		{
			/* position de la scrollbar du cadre visible */
			if( _nX!= null )// Manuel
				_mcBase._x = _nX;
			else // Automatique
				_mcBase._x = _nWidth - _mcScrollUp._width;
				
			if( _nY!= null )// Manuel
				_mcBase._y = _nY;
			else// Automatique
				_mcBase._y = 3;

		}
		_mcScrollTrack._height= _nSizeVisible - _mcScrollDown._height/2 - ScrollBar.N_DECAL_FORM;
		_mcScrollDown._y = _mcScrollTrack._height;
	}
	
	
	
	/**
	 * Active / Désactive la scrollBar lorsque la cible doit être scrollée
	 * 
	 * @param   bState : true -> active la scrollbarre sinon la désactive
	 * @return  
	 */
	private function active( bState:Boolean )
	{
		// enable scrollbarr
		if(bState)
		{
			_mcScrollUp._alpha=100;
			_mcScrollDown._alpha=100;
			_mcScrollTrack._alpha=100;
			this.addMouseListener();
		}
		//disable scrollbarr
		else
		{
			_nLongueurUp = 0;
			_mcScrollSlide._y=_nYInitScroll;
			_mcScrollUp._alpha=50;
			_mcScrollDown._alpha=50;
			_mcScrollTrack._alpha=50;
			
			this.removeMouseListener();
		}
		
		_mcScrollSlide._visible = bState;
		_mcScrollUp.useHandCursor = bState;
		_mcScrollDown.useHandCursor = bState;
		
	}



	
	
	/*---------------------------------------------------------*/
	/*-------------- Gestion du contenu -----------------------*/
	/*---------------------------------------------------------*/
		
	
	/**
	 * Appelé lors du click sur un des boutons de scroll.
	 * Déplace l'objet cible de la valeur transmise en paramètre
	 * 
	 * @param   iPixels : le nombre de pixels dont on déplace la cible
	 * @return  
	 */
	private function moveTarget(iPixels:Number)
	{		
		// si il est possible de déplacer la cible vers le haut
		if( _nLongueurDown>0 && iPixels<0)
		{
			// si la taillle de la cible masqué est supérieur à la valeur de déplacement
			if( _nLongueurDown>=Math.abs(iPixels) )
			{
				_nLongueurDown -= Math.abs(iPixels); // taille cachée de la partie basse de la cible
				_nLongueurUp +=  Math.abs(iPixels);
				_oCible[_sSensScroll]+=iPixels;
				
			}
			else
			{// sinon la cible est déplacé en bas au maximum
				_oCible[_sSensScroll]-=_nLongueurDown;				
				_nLongueurUp += _nLongueurDown;
				_nLongueurDown -= _nLongueurDown;				
			}
			// faire suivre la slide en fonction du delta
			_mcScrollSlide._y = (_nLongueurUp/_nCoefSlide)+_nYInitScroll;
		}
		
		// si il est possible de déplacer la cible vers le bas
		else if( _nLongueurUp>0 && iPixels>0)
		{
			// si la taillle de la cible est masqué est supérieur à la valeur de déplacement
			if( _nLongueurUp>=Math.abs(iPixels) )
			{
				_nLongueurUp-=Math.abs(iPixels);
				_nLongueurDown+=Math.abs(iPixels);
				
				_oCible[_sSensScroll]+=iPixels;
			}
			else
			{
				_oCible[_sSensScroll]+=_nLongueurUp;
				
				_nLongueurDown += _nLongueurUp;
				_nLongueurUp -= _nLongueurUp;
			}
			// faire suivre la slide en fonction du delta
			_mcScrollSlide._y = (_nLongueurUp/_nCoefSlide)+_nYInitScroll;
		}
		
				
	}
	
	
	
	/**
	 * Appel lors d'un click sur la barre de track
	 * Déplace la cible et centre la souris par rapport à la slide (si possible)
	 * 
	 */
	private function _onPressTrack()
	{
		//On détermine les coordonnées de la souris dans le repère de la scrollbar
		//var oMousePt:Object = {x:_mcScrollUp._xmouse, y:_mcScrollUp._ymouse};
		var oMousePt:Object = {x:_mcBase._xmouse, y:_mcBase._ymouse};
		
		
		// enlève la demi-taille de la slide pour que la slide se centre par rapport à la nouvelle position
		oMousePt.y-=(_mcScrollSlide._height)/2;
		
		// calcul de la nouvelle position de la slide en fonction de la position actuelle de la souris
		if( oMousePt.y<=_nYFinalScroll )
		{
			if(oMousePt.y>=_nYInitScroll)
				_mcScrollSlide._y = oMousePt.y;
			else
				_mcScrollSlide._y= _nYInitScroll;

		}
		else
			_mcScrollSlide._y= _nYFinalScroll;

		
		// appel la fonction qui scroll le clip en fonction de la position de la slide
		this.scrollSlide();
	}
	
	
	
	/**
	 * Appel lors d'un click sur la slide.
	 * Permet de déplacer la cible
	 * 
	 * 
	 */
	private function scrollSlide()
	{
		var nPosNow:Number;
		// si la slide est à sa position initiale, alors la cible doit revenir à son point de départ
		if( _mcScrollSlide._y<=_nYInitScroll ) nPosNow =0;
		else nPosNow = _mcScrollSlide._y;
				
		// détermine le pourcentage de déplacement de la cible
		var nMove:Number =  nPosNow / (_nYFinalScroll-_nYInitScroll) ;
		
		this.setPos(nMove); // nombre entre 0 et 1
	}



	/*---------------------------------------------------------*/
	/*-------------- Gestion de la souris ---------------------*/
	/*---------------------------------------------------------*/
	
	
	/**
	 * Ajoute un écouteur sur la souris seulement si nécessaire.
	 * Appel par un PlaceHolder...
	 * 
	 * @see     
	 * @return  
	 */
	public function addMouseListener():Void
	{
		/* écouter la molette de la souris */
		if( !_bMouseListener && _mcScrollUp._alpha!=50 )
		{
			Mouse.addListener(this); 
			_bMouseListener = true;
		}
		return;
	}
	
	
	
	/**
	 * Supprime l'écouteur des évènements de la souris
	 * Appel par un PlaceHolder...
	 * 
	 * @return  
	 */
	public function removeMouseListener():Void
	{
		Mouse.removeListener(this);
		_bMouseListener = false;
	}
	
	
	/**
	 * Fonction appeler lorsque l'utilisateur utilise la molette de la souris
	 * Selon la valeur du parametre on scroll soit vers le haut soit vers le bas
	 * 
	 * @param  delta : indique dans quel sens doit défiler la cible.
	 */
	private function onMouseWheel(delta:Number)
	{
		// le contenu scrollé doit descendre
		if(delta<0) this.moveTarget(-_nScrollDelta);
		else this.moveTarget(_nScrollDelta);
	}
	

	
}