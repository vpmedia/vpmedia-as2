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
import com.delfiweb.ui.Label;
import com.delfiweb.ui.ToolTip;
import com.delfiweb.form.AbstractForm;


// Classes Macromedia
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.filters.ColorMatrixFilter;
import flash.filters.BevelFilter;
import flash.filters.DropShadowFilter;


// Classes gskinner
import com.gskinner.geom.ColorMatrix;


// Classes Bourre
import com.bourre.commands.Delegate;







/**
 * Class Button 	: create a label with some most actions.
 * 
 * Button Object diffuse some events _onReleaseBtn et _onRollOutBtn to Listeners.
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
	var txtTooltip:String = "l'infos bulle du bouton";
	var oSquare:Square = new Square ("Square5", largeurW, hauteurH, 10);
	
	var oButton = new Button(coordX, coordY, padding, txt, urlIcon, posIconeLeft, txtTooltip, oSquare, largeurW, hauteurH);
	oButton.attach(_root, 10);
	
	var oDelegate1:Delegate = new Delegate(this, _onButtonMenuClik, id);
	oButton.onRelease = oDelegate1.getFunction();
	
	
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006 
 */
class com.delfiweb.ui.Button extends Label
{
	
	/* clips principaux */
		
	
	
	/* Les propriétés de type function */
	// permet de déclencher et propager les évènements du bouton */
	public var onRollOut:Function;
	public var onRollOver:Function;
	public var onRelease:Function;
	public var onPress:Function;
	public var onReleaseOutside:Function;
	public var onDragOut:Function;
	public var onDragOver:Function;
	
	
	/* effets RollOver du bouton */
	private var _nLum:Number = 5; // gestion de la luminosité
	private var _nContraste:Number = 5;// gestion du contraste
	private var _nSaturation:Number = 5;// gestion de la saturation
	private var _nTeinte:Number = 5;// gestion de la teinte

	
	/* options du bouton */
	private var _sTxtToolTip:String; // Le texte de l'infos bulle
	private var _oOldEffect:Object;
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 * @param  x	  		: Position du titre sur l'axe des x     
	 * @param  y   		  	: Position du titre sur l'axe des y 
	 * @param  pad  		: La marge interieur entre le titre et son contenu 
	 * @param  txt    		: Le label du titre  
	 * @param  urlIcon  	: L'url de l'icone du titre 
	 * @param  posIconeLeft : La position de l'icone : true = gauche / false=droite
	 * @param  oAbsForm    	: Objet Form servant de background au titre 
	 * @param  w  			: Largeur du titre  
	 * @param  h		  	: Hauteur du titre 
	 * @param  txtTooltip 	: Le texte sur le tooltip du bouton
	 */
	public function Button(x:Number, y:Number, pad:Number, txt:String,	
	urlIcon:String, posIconeLeft:Boolean, txtTooltip:String, oAbsForm:AbstractForm,
	w:Number, h:Number)
	{
		// création du Label
		super(x, y, pad, txt, urlIcon, posIconeLeft, oAbsForm, w, h);
		
		/* initialisation du Bouton */
		_sTxtToolTip = txtTooltip ? txtTooltip : null;
		
		this.setName( "Button_"+random(1000) );
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
	public function attach(mc:MovieClip,d:Number):MovieClip
	{
		super.attach(mc, d);
		
		/* Action à effectuer pour chaque type d'évenements sur le bouton */
		_mcBase.onRelease = Delegate.create(this,_onRelease);
		_mcBase.onReleaseOutside = Delegate.create(this,_onReleaseOutside);
		_mcBase.onRollOut = Delegate.create(this,_onRollOut);
		_mcBase.onRollOver = Delegate.create(this,_onRollOver);
		_mcBase.onPress = Delegate.create(this,_onPress);
		_mcBase.onDragOver = Delegate.create(this,_onDragOver);
		_mcBase.onDragOut = Delegate.create(this,_onDragOut);
		
		return _mcBase;
	}
		

	/**
	 * Gestion des effets sur le Button.
	 * 
	 */
	 
	
	/**
	 * Permet de personnaliser l'effet de RollOver sur le bouton
	 * 
	 * @param   lum : luminosité
	 * @param   cont : contraste
	 * @param   sat : saturation
	 * @param   teinte : teinte
	 * @return  
	 */
	public function setRollOverEffect(lum:Number,cont:Number,sat:Number,teinte:Number)
	{
		this._nLum = lum; // gestion de la luminosité
		this._nContraste = cont;// gestion du contraste
		this._nSaturation = sat;// gestion de la saturation
		this._nTeinte = teinte;// gestion de la teinte
	}

	
	
	/**
	 * Effet pressé sur l'objet Button
	 * 
	 * 
	 * @param   bEnabled 	: booléen à true pour activer l'effet
	 * @return  
	 */
	public function onReleaseEffect(bEnabled:Boolean)
	{
		if( bEnabled )
		{
			/* création de l'effet ombré */
			var nDistance:Number = 4;
			var nAngleInDegrees:Number = 60;
			var nColor:Number = 0x000000; // noir
			var nAlpha:Number = 1;
			var blurX:Number = 2;
			var blurY:Number = 2;
			var nStrength:Number = 0.6;
			var quality:Number = 2;
			var bInner:Boolean = true;
			var bKnockout:Boolean = false;
			
			var oDropShaFilter = new DropShadowFilter(nDistance, nAngleInDegrees, nColor, 
			nAlpha, blurX, blurY, nStrength, quality, bInner, bKnockout);
			
			/* effet de surbrillance sur la couleur */
			var oColorM:ColorMatrix = new ColorMatrix();
			oColorM.adjustColor(50, 0, 0, 0);
		
			var oColorMFilter:ColorMatrixFilter = new ColorMatrixFilter(oColorM);

			_mcBase.filters = [oDropShaFilter, oColorMFilter];			
		}
		else
		{
			_mcBase.filters = [];
		}
	
	
	}
	
	
	
		 
	/**
	 * Effet sur le Button au repos.
	 * 
	 * 
	 * @return  
	 */
	public function addDefaultEffect()
	{
		var distance_max:Number = 5;

		// création de 2 filtres
		var oBevelFilter:BevelFilter = new BevelFilter();
		var oDropShaFilter:DropShadowFilter = new DropShadowFilter();

		/* personnalisation des filtres */
		oBevelFilter.strength = .6;
		oBevelFilter.distance = 2;
		oBevelFilter.angle = 2;

		oDropShaFilter.color = 0x999999; // gris
		oDropShaFilter.alpha = .50;// 50 %
		oDropShaFilter.blurX = 8;
		oDropShaFilter.blurY = 8;
		oDropShaFilter.distance = 5;
		oDropShaFilter.angle = 45;		
		
		// applique les filtres
		_mcBase.filters = [oBevelFilter, oDropShaFilter];
	}



	/*----------------------------------------------------------*/
	/*------------- Getter / Setter ----------------------------*/
	/*----------------------------------------------------------*/

	

	/**
	 * Modifie le texte dans l'info bulle
	 * 
	 * @param   msg : le message à afficher
	 * @return  
	 */
	public function set tooltip(msg:String)
	{
		this._sTxtToolTip = msg;
	}
	


	/**
	 * Apply property enabled to movieclip
	 * 
	 * @param   bValue 
	 * @return  
	 */
	public function set enabled(bValue:Boolean)
	{
		this._mcBase.enabled = bValue;
	}


	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/

	/**
	 * Gestion des effets sur le Button.
	 * 
	 */
	 


	/**
	 * Ajoute un effet lors du RollOver de la souris sur le bouton
	 * 
	 * 
	 * @return  
	 */
	private function addRollOverEffect()
	{
		// modifie la couleur du bouton
		/*var oColorM:ColorMatrix = new ColorMatrix();
		oColorM.adjustColor(this._nLum, this._nContraste, this._nSaturation, this._nTeinte);
		
		var oColorMFilter:ColorMatrixFilter = new ColorMatrixFilter(oColorM);
		
		_mcBase.filters = [oColorMFilter];
		*/
		this._oOldEffect = _oColorEffect;
		
		var oColorEffect:Object = new Object();
		oColorEffect.lum = this._nLum;
		oColorEffect.sat = this._nSaturation;
		oColorEffect.cont = this._nContraste;
		oColorEffect.hue = this._nTeinte;
		this.setColorEffect(oColorEffect);
	}
	
	
	private function removeRollOverEffect()
	{
		this.setColorEffect( this._oOldEffect );
	}
	
	
	/**
	 * Evènements sur le clip _mcBase, 
	 * appelant eux même les propriétes membres de la classe de type Function. 
	 */
	
	
	/**
	 * Appelé lorsqu'un utilisateur relache le bouton de la souris sur le bouton
	 * Ferme le tooltip
	 * 
	 * @return  
	 */
	private function _onRelease()
	{
		ToolTip.close();
		this._oEventManager.broadcastEvent("_onReleaseBtn", this); // écouté par la classe Locked Button
		onRelease(this);
	}

	
	
	/**
	 * Les comportements au passage de la souris sont géré en interne.
	 * Crée un effet visuel sur le bouton.
	 * 
	 * @return  
	 */
	private function _onRollOver()
	{		
		
		this.addRollOverEffect();// Crée un effet visuel sur le bouton.			
			
		// si il y a un texte à afficher dans le tooltip
		if( _sTxtToolTip!=null )
		{
			// On récupère les coordonnées du bouton
			// Puis on converti ces coordonnées dans le référentiel de la scène
			var coord:Point = new Point(_nPadding, _nPadding);
			
			_mcBase.localToGlobal(coord);
			
			var oRect:Rectangle = new Rectangle(coord.x, coord.y, _mcBase._width-_nPadding, _mcBase._height-_nPadding);
			ToolTip.open(_sTxtToolTip, oRect);
		}
			
		
		onRollOver(this);
	}
	

		
	/**
	 * Supprime l'effet visuel lorsque la souris n'est plus au dessus du Button.
	 * Ferme le tooltip.
	 * 
	 * @return  
	 */
	private function _onRollOut()
	{
		_mcBase.filters = []; // désactive les effets sur le bouton
		ToolTip.close();
		
		this.removeRollOverEffect();
		
		this._oEventManager.broadcastEvent("_onRollOutBtn", this); // écouté par la classe Locked Button
		onRollOut(this);
	}
	
	
	
	
	
	/**
	 * On reçoit ici l'évènement lors d'un click à l'exterieur pour remettre le bouton
	 * dans son état normal.
	 * 
	 * @return  
	 */
	private function _onReleaseOutside()
	{
		ToolTip.close();
		onReleaseOutside(this);
	}
	
	
	
	/**
	 * Appelé lorsque l'utilisateur clique sur le bouton de la souris 
	 * quand le pointeur est placé sur le bouton.
	 * 
	 * @return  
	 */
	private function _onPress()
	{
		onPress(this);
	}
	

	
	
	
	/**
	 * Permet de déplacer le bouton
	 * 
	 * @return  
	 */
	private function _onDragOut()
	{
		onDragOut(this);
	}
	
	
	
	/**
	 * Appelé lorsque l'utilisateur fait glisser le pointeur hors du bouton, puis sur le bouton
	 * 
	 * @return  
	 */
	private function _onDragOver()
	{
		onDragOver(this);
	}

}