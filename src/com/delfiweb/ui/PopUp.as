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

// Classes delfiweb
import com.delfiweb.ui.AbstractContainer;
import com.delfiweb.display.MovieClipGraphic;
import com.delfiweb.form.AbstractForm;
import com.delfiweb.ui.Button;
import com.delfiweb.ui.TxtField;


// Classe Bourre
import com.bourre.commands.Delegate;



/**
 * todo : 
 * 		- ajouter des effets de tween (Francis Bourre) sur l'apparition et la
 * disparition de la pop up.
 */


/**
 * This class build a pop up center on the scene.
 * It's possible to add some texte and to add zero -> three button with personnalised action.
 * 
 * PopUp Object diffuse some events onPopUpVisible to Listeners.
 * 
 * 
 * @usage	

	var oSquareBack:Square = new Square ("PopUpSqBackground", 280, 100, 5);
	var oSquareBtn:Square = new Square ("PopUpSqButton",  80, 25, 5);
	var oBack:Background = new Background ("icon_pop_up");


	var oPopup:PopUp = new PopUp(this, oSquareBack, oSquareBtn);
	oPopup.attach(_root, 10000); // at the top
	oPopup.addListener(this);
	oPopup.addLogo(oBack); // add a logo to the pop up
	
	
	oBack.setScale(250, 250);
	oBack.move( -oBack.getWidth()/2, -oBack.getHeight()/2);


	// init config of pop up
	var aContent:Array = new Array();
	
	// config button of pop up
	// argument of the function called by button of pop up
	var aArgumentsFunct:Array = new Array();
	
	// create an object who contain name and arguments of function
	var oAction:Object = new Object();
	
	oAction = new Object();
	aArgumentsFunct = new Array();
	aArgumentsFunct.push("isVisible");
	oAction.sFunction = onPopUpSee;
	oAction.aArguments = aArgumentsFunct;
	var oBtn1:Object={label:"See",action:oAction};

	
	oAction = new Object();
	aArgumentsFunct = new Array();
	aArgumentsFunct.push("isHidden");
	oAction.sFunction = onPopUpHid;
	oAction.aArguments = aArgumentsFunct;
	var oBtn2:Object={label:"Hide",action:oAction};


	oAction = new Object();
	oAction.sFunction = onPopUpClose;
	oAction.aArguments = "";
	var oBtn3:Object={label:"Close",action:oAction};
	
	aContent.push(oBtn1);
	aContent.push(oBtn2);
	aContent.push(oBtn3);

	var sMsg:String = "Test of the Pop Up.";
	
	_oPopup.addContent(sMessage, aContent);

 *
 * 
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since  	28/11/2006
 */
class com.delfiweb.ui.PopUp extends AbstractContainer
{
	/* configuration de la classe */
	private var _oObjectInstance:Object; // référence à l'objet utilisé pour appeler les fontions

	
	/* les objets utilisés */
	private var _oFormBackground:AbstractForm;// l'object Form utilisé pour créer un arrière plan (Square, Circle, Background)
	private var _oFormLogo:AbstractForm;// l'object Form utilisé pour créer un arrière plan (Square, Circle, Background)
	private var _oTxtField:TxtField; // le texte
	private var _oMcGraphic:MovieClipGraphic;
	
	
	/* caractéristiques de la pop-up */
	private var _nHeightBackground:Number = 100;// sa hauteur
	
	private var _nPadding:Number = 5;// sa marge intérieur entre le contenu et le container
	
	
	/* caractéristiques des boutons */
	private var _nWidthButton:Number;// Largeur des boutons
	private var _nHeightButton:Number;// hauteur des boutons
	
	
	private var _nMaxBouton:Number = 3;// le nombre de bouton maximum
	private var _nNbBouton:Number = 0;// Le nombre de bouton actuel
	private var _nPaddingButton:Number = 3;// Padding des boutons
	
	
	private var _mcContentButton:MovieClip;// Clip contenant les boutons
	private var _oFormButton:AbstractForm;// l'object Form utilisé pour créer un arrière plan pour les boutons (Square, Circle, Background)
	
	private var _aButton:Array;// Tableau contenant la référence aux boutons
	
	
	/* les options */

	
	/* constantes */
	private var _nNiveau:Number=10;// profondeur des clips



	/**
	 * CONSTRUCTOR
	 * 
	 * @param   oRef        	 	: référence à l'instance de l'objet sur lequel appeler les fonctions des boutons
	 * @param   oAbsFormBackground	: l'object Form utilisé pour créer un arrière plan (Square, Circle, Background)
	 * @param   oAbsFormButton     	: l'object Form utilisé pour créer un arrière plan (Square, Circle, Background) des boutons
	 * @return  
	 */
	public function PopUp(oRef:Object, oAbsFormBackground:AbstractForm, oAbsFormButton:AbstractForm)
	{
		super("PopUp_"+random(100)); // création d'un AbstractContainer
		
		/* Initialisation du fond de la pop up */			
		this._oFormButton = oAbsFormButton;
		this._nWidthButton = this._oFormButton.getWidth();
		this._nHeightButton = this._oFormButton.getHeight();
		
		this._oObjectInstance = oRef;
		
		// si on a un arrière plan
		if( oAbsFormBackground!=undefined)
		{
			_oFormBackground = oAbsFormBackground;
			_nHeightBackground = _oFormBackground.getHeight();
		}
		
		this._aButton = new Array();
		
		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
	}
	
	
	

/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/

	
	/**
	 * Add content to the pop up.
	 *    
	 * @param   msg 		: message in the pop up
	 * @param   aBtnPerso 	: an array who contain some object for create the buttons (in the pop up)
	 * @return  
	 */
	public function addContent(msg:String,aBtnPerso:Array):Void
	{		
		this.removeContent(); // suppression des éléments graphiques crées
		
		if(msg!=null) this._oTxtField.txt = msg;// mise à jour du texte de la pop up
	
		/* les boutons */
		this._nNbBouton=0; // remet le compteur de bouton à 0
		
		//On ajoute chaque bouton contenu dans le tableau
		for(var i:Number=0; i<aBtnPerso.length; i++)
		{
			this.addButton(aBtnPerso[i].label, aBtnPerso[i].action)
		}
		
		this.setSizeBox();// ajuste la taille de la boite de dialogue
		
		// centre le texte		
		var oPoint:Object = _oFormBackground.getPosition();
		
		var nX:Number = oPoint.x+_nPadding;
		var nY:Number = oPoint.y+_nPadding;
		if( _oFormLogo.getWidth()>0 )
		{
			oPoint = _oFormLogo.getPosition();
			nY +=  oPoint.y + _oFormLogo.getHeight() - _nPadding;
		}
		_oTxtField.move( nX, nY);
			
		
		this.setPosButton();// positionne les boutons
		
		
		// On positonne la boite de dialogue
		this.setPosPopUp();
		
		// On affiche la boite de dialogue
		this.show();		
	}
	
	
	/**
	 * Add a logo to the pop up
	 * 
	 * @param  oAbsFormLogo : an object AbstractForm
	 */
	public function addLogo(oAbsFormLogo:AbstractForm):Void
	{
		_oFormLogo = oAbsFormLogo;
		_oFormLogo.attach(_mcBase);
	}
	

	/**
	 * Close (hide) the pop-up
	 * 
	 * @return  
	 */
	public function close()
	{
		this._mcBase._visible=false;
		// averti les objets en écouteurs que la pop up se masque
		this._oEventManager.broadcastEvent("onPopUpVisible", false);
	}
	
	

/*****************************************************************************
* PRIVATE FUNCTIONS
******************************************************************************/


	/**
	 * Called by class AbstractContainer when object Square is drawing
	 * 
	 * @return  
	 */
	private function endBuilding()
	{	
		// le fond de la pop-up
		this._oFormBackground.attach(this._mcBase)
		
		
		// Création de la zone de texte
		var largeurW:Number = _oFormBackground.getWidth()-2*this._nPadding;
		var hauteurH:Number = _oFormBackground.getHeight();
		var otxtfield:Object = {background:false, autoSize:true, multiline:true, wordWrap:true};
		var otxtformat:Object = {size:12, align:"center", font:"Arial"};		

		_oTxtField = new TxtField("", 0, 0, largeurW, hauteurH, otxtfield, otxtformat);
		_oTxtField.attach(this._mcBase);
		

		//Création du clip sur lequel sera attaché les boutons
		this._mcContentButton = this._mcBase.createEmptyMovieClip("contentButton", this._nNiveau++);

		
		// masque la pop-up
		this.close();
	}
	
	
	/**
	 * Affiche la pop up
	 * 
	 * @return  
	 */
	private function show()
	{
		this._mcBase._visible = true;
		// averti les objets en écouteurs que la pop up se masque
		this._oEventManager.broadcastEvent("onPopUpVisible", true);
	}
	
	
	/**
	 * Ajoute un bouton à la pop-up
	 * 
	 * @see     
	 * @param   sTxt : le texte du bouton
	 * @param   action : le nom de la fonction qu'il doit appeler
	 * @return  
	 */
	//private function addButton(sTxt:String, action:String) 
	private function addButton(sTxt:String, oFunctContent:Object)
	{
		var coordX:Number = 0;
			
		if(this._nNbBouton < this._nMaxBouton)
		{			
			// crée le bouton
			coordX += (this._nNbBouton) * (this._nPadding + this._nWidthButton);
			var coordY:Number = 0;
			var largeurW:Number = this._nWidthButton;
			var hauteurH:Number = this._nHeightButton;
			var padding:Number = this._nPaddingButton;
			var txt:String = sTxt;
			var urlIcon:String = null;
			var posIconeLeft:Boolean = false;
			var txtTooltip:String = null;
			var oAbsForm:AbstractForm = this._oFormButton.clone();

			var oButton = new Button(coordX, coordY, padding, txt, urlIcon, posIconeLeft, txtTooltip, oAbsForm, largeurW, hauteurH);
			oButton.attach(this._mcContentButton);
			
			// modifie le format du texte du bouton
			/*var otxtformat:Object = {size:10, align:"center", font:"Arial"};
			oButton.setTxtFormat(otxtformat);*/
		
			// stocke une référence au bouton
			this._aButton[this._nNbBouton-1] = oButton;
			
			// assigne l'action sur bouton
			//var oDelegate:Delegate = new Delegate(this, _setBtnAction, action);
			var oDelegate:Delegate = new Delegate(this, _setBtnAction, oFunctContent);
			oButton.onRelease= oDelegate.getFunction()
			
			this._nNbBouton++;// bouton ajouté
		}		
		
	}
	
	
	
	
	/**
	 * Redimenssionne le fond de la pop up en fonction de la taille de son contenu
	 * 
	 * @return  
	 */
	private function setSizeBox()
	{
		var nHeight:Number;
		// il faut prévoir la place des boutons
		if( this._nNbBouton>0 )
			nHeight = this._nPadding+this._oTxtField.getHeight() + this._nPadding+this._mcContentButton._height + this._nPadding*2;
		else
			nHeight = this._nPadding+this._oTxtField.getHeight() + this._nPadding+this._mcContentButton._height;
		
		if( _oFormLogo.getHeight()>0 )
		{
			var oPoint:Object = _oFormLogo.getPosition();
			nHeight += oPoint.y + _oFormLogo.getHeight();
		}
		this._oFormBackground.setHeight(nHeight);
	}
	


	/**
	 * Centre les boutons dans la pop up
	 * 
	 * @return  
	 */
	private function setPosButton()
	{
		this._mcContentButton._x = this._oFormBackground.getWidth()/2 - this._mcContentButton._width/2
		
		this._mcContentButton._y = this._oTxtField.getHeight() + this._nPadding*2;
		
		var oPoint:Object = _oFormLogo.getPosition();
		if( _oFormLogo.getHeight()>0 ) this._mcContentButton._y += oPoint.y + _oFormLogo.getHeight()- _nPadding;
	}
	


	/**
	 * Centre la pop up sur la scène
	 * 
	 * @return  
	 */
	private function setPosPopUp()
	{
		this.updateSize();
		var nX:Number = (Stage.width - this.getWidth() )/2;
		var nY:Number = (Stage.height - this.getHeight() )/2;
		
		this.move(nX, nY);
	}
	

	
	/**
	 * Supprime le contenu de la Pop Up.
	 * Permet ensuite d'insérer ensuite un nouveau contenu.
	 * 
	 * @see     
	 */
	private function removeContent():Void
	{
		this._mcContentButton.removeMovieClip();
		
		// efface les boutons déjà existant		
		for(var i:Number=0; i<this._aButton.length ;i++)
		{
			this._aButton[i].destruct();
			delete this._aButton[i];
		}
		
		
		/* init des variables */
		this._nNiveau = 10;
		
		this._mcContentButton = this._mcBase.createEmptyMovieClip("contentButton", this._nNiveau++);
		
		this._oFormBackground.setHeight(this._nHeightBackground);
		this._oTxtField.txt = "";
		
		return;
	}
	

		
	
	/**
	 * Appel de la fonction correspondant au bouton choisi
	 * 
	 * @see     
	 * @param   obj 
	 * @param   oFunctContent : contient la fonction que doit appeler le bouton avec les arguments
	 * @return  
	 */
	private function _setBtnAction(obj:Delegate, oFunctContent:Object)
	{
		// appel de la fonction
		oFunctContent.sFunction.apply(_oObjectInstance, oFunctContent.aArguments);
	}


}