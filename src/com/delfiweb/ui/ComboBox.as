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
import com.delfiweb.ui.Button;
import com.delfiweb.ui.List;
import com.delfiweb.ui.AbstractContainer;
import com.delfiweb.display.MovieClipGraphic;


// Classes Macromedia
import flash.geom.Rectangle;
import flash.geom.Point;


// Classes Bourre
import com.bourre.commands.Delegate;


// effect
import com.robertpenner.easing.Elastic;
import com.robertpenner.easing.Bounce;
import com.bourre.transitions.MultiTweenMS;


//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;



 /**
 * ComboBox :
 * 
 * Object comboBox can contain all item that accepted by an Object List.
 * 
 * @usage


	var coordX:Number = 0;
	var coordY:Number = 0;
	var largeurW:Number = _oSqTemplate.width;
	var hauteurH:Number = _oSqTemplate.square_list.height;
	var padding:Number = _oSqTemplate.square_list.padding;
	var tailleScroll:Number = 16;
	var typeScroll:Number = List.SCROLL_VERTICAL;
	var sGraphicsScroll:String = _oSqTemplate.scrollbar.url;
	var oSquare:Square = new Square (_oSqTemplate.square_list.url, largeurW, hauteurH, 2);
	var oList:List = new List(coordX, coordY, oSquare, padding, tailleScroll, typeScroll, sGraphicsScroll, largeurW, hauteurH );
	
	hauteurH = _oSqTemplate.square_title.height;
	padding = _oSqTemplate.square_title.padding;
	var txt:String = "<p align='center'>Modifier le template</p>";
	var urlIcon:String = _oSqTemplate.square_title.url_icon;
	var posIconeLeft:Boolean = false;
	var oSqBt:Square = new Square (_oSqTemplate.square_title.url, largeurW, hauteurH, 2);
	var txtTooltip:String = _oSqTemplate.text_tooltip;
	
	var oButton = new Button(coordX, coordY, padding, txt, urlIcon, posIconeLeft, txtTooltip, oSqBt, largeurW, hauteurH);
	
	_oCombo = new ComboBox(oButton, oList, coordX, coordY);
	_oCombo.attach(_mcBase);
	_oCombo.setTitle("Templates");

 * 
 * @author  Matthieu Deloison
 * @update 03/04/2007
 * @version 0.1
 */
class com.delfiweb.ui.ComboBox extends AbstractContainer
{
  
	/* clips principaux */
	private var _mcListe:MovieClip; // le clip qui contient la liste

	/* nouvelles propriétés */
	private var _nDepth:Number; // la profondeur des clips
	

	/* object */
	private var _oBtnTitle:Button;
	private var _oItemList:List;
	private var _oTweenMS:MultiTweenMS;
	private var _oMcGraphic : MovieClipGraphic;
	
		
	/* list */
	private var _nShowListY:Number; // position cachée de la liste
	private var _nHideListY:Number; // position visible de la liste
	private var _bContentPositionTop:Boolean; // true la liste de la combo est au dessus de la combo
	
	
	
	/* caractéristiques de la comboBox */
	private static var N_SPACE_COMBO:Number = 5; // l'espace entre la flèche combo et la liste
	private static var N_OPEN_DURATION:Number = 300; // la durée d'ouverture de la comboBox en ms

	
	
	

	/**
	 * CONSTRUCTOR
	 * 
	 * @see     
	 * @param   oBtn    : Position de le comboBox sur l'axe des x          
	 * @param   oListe  : Position de le comboBox sur l'axe des x          
	 * @param   xpos 	: largeur de la comboBox        
	 * @param   ypos 	: hauteur de la liste de la comboBox          
	 * @return  
	 */
	public function ComboBox(oBtn:Button, oListe:List, xpos:Number, ypos:Number)
	{
		super("ComboBox_"+random(100));
				
		_nDepth = 10;
		
		_oBtnTitle = oBtn;
		_oItemList = oListe;
		
		_nX = xpos ? xpos : 0 ;
		_nY = ypos ? ypos : 0 ;
		
		_nWidth = _oItemList.getWidth();
		_nHeight = _oItemList.getHeight();
		
		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
	}

	
/* ***************************************************************************
* PUBLIC FUNCTIONS
******************************************************************************/


	
	/**
	 * Fonction de remplissage de la comboBox. 
	 * Elle attend un objet qui sera ajouté au contenu de la liste.
	 * 
	 * @param  item : L'objet à ajouter à la Liste (peut être un Button ou un PlaceHolder)
	 * @param  pos : Position de l'objet sur l'axe des abscisses : left-center-right
	 */
	public function addContent(absContent:AbstractContainer, pos:String):Void
	{
		var fMethod:Function = _oItemList.addContent;
		fMethod.apply(_oItemList, arguments);
		
		return;
	}
	
	
	
	/**
	 * Supprime tout le contenu de la comboBox
	 * 
	 */
	public function clearListe()
	{
		_oItemList.removeContent();
	}
	

	

	/*----------------------------------------------------*/
	/*-------------- Actions sur les boutons -------------*/
	/*----------------------------------------------------*/
	
	
	/**
	 * Ferme la liste déroulante
	 * Appeler en externe
	 * 
	 * @see     
	 * @return  
	 */
	public function close()
	{
		var aMc:Array = new Array();
		var aProperty:Array = new Array();
		var aValueBegin:Array = new Array();
		var aValueEnd:Array = new Array();
		
		aMc.push( _mcListe );
		aValueBegin.push( _mcListe._y );
		aValueEnd.push( _nHideListY );
		aProperty.push("_y");		
		
		_oTweenMS = new MultiTweenMS( aMc, aProperty, aValueEnd, ComboBox.N_OPEN_DURATION, aValueBegin, com.robertpenner.easing.Bounce.easeOut); // en ms
		
		_oTweenMS.execute();
		_oBtnTitle.onRelease = Delegate.create(this, _openList);
		
		// annule l'évènement
		delete _mcBase.onMouseDown;
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
		//Positionnement de la combobox
		this.move(_nX, _nY);
		
		_oBtnTitle.attach(_mcBase);
		_oBtnTitle.onRelease = Delegate.create(this, _openList);
		
		//Construction du clip servant de masque
		var mcContainer:MovieClip = _mcBase.createEmptyMovieClip("masque", _nDepth++);
		mcContainer.cacheAsBitmap=true;
		
		
		//On crée le rectangle de la zone de scrolling		
		var r:Rectangle=new Rectangle(-2,-2, _nWidth+13, _nHeight+13);
		mcContainer.scrollRect = r;
		

		// le clip qui contiendra la liste
		_mcListe = mcContainer.createEmptyMovieClip("content",1);
		
		// la liste de la comboBox
		_oItemList.attach(_mcListe,2);


		// position du masque
		var oPt:Object = {x:mcContainer._x, y:mcContainer._y};
		_mcBase.localToGlobal(oPt);
		
		// la position cachée de la combobox est en dessous du titre
		if( oPt.y+_oItemList.getHeight() > Stage.height )
		{
			mcContainer._y = -1*(_oItemList.getHeight() + ComboBox.N_SPACE_COMBO);
			_bContentPositionTop = true; // la liste de la combo est au dessus
			/* détermination de la position de la liste par rapport au masque */
			_nShowListY = 0;
			_nHideListY = _oItemList.getHeight()+ ComboBox.N_SPACE_COMBO ;		
		}
		else
		{// la position cachée de la combobox est dessus du titre
			_bContentPositionTop=false;
			mcContainer._y = _oBtnTitle.getHeight() + ComboBox.N_SPACE_COMBO;
			/* détermination de la position de la liste par rapport au masque */
			_nShowListY = 0;
			_nHideListY = -1*(_oItemList.getHeight() + _oBtnTitle.getHeight() + ComboBox.N_SPACE_COMBO);
		}
		
		_mcListe._y = _nHideListY;
		

	}
	
	
	/**
	 * Ouvre la liste déroulante, crée un effet
	 * Appeler par le Btn titre
	 * 
	 */
	private function _openList()
	{
		var aMc:Array = new Array();
		var aProperty:Array = new Array();
		var aValueBegin:Array = new Array();
		var aValueEnd:Array = new Array();
		
		aMc.push( _mcListe );
		aValueBegin.push( _mcListe._y );
		aValueEnd.push( _nShowListY );
		aProperty.push("_y");		
		
		_oTweenMS = new MultiTweenMS( aMc, aProperty, aValueEnd, ComboBox.N_OPEN_DURATION, aValueBegin, com.robertpenner.easing.Bounce.easeOut); // en ms
		
		_oTweenMS.execute();
		
		_oBtnTitle.onRelease = Delegate.create(this, close); // à mettre à la fin l'évènement diffusé par la tween
		
		// permet de fermer la liste lors d'un click en dehors de la comboBox
		_mcBase.onMouseDown = Delegate.create(this, _testCloseList);
	}
	
	
	
	
	/**
	 * ferme la liste automatiquement uniquement si le joueur a clické en dehors de la liste
	 * 
	 * @see     
	 * @return  
	 */
	private function _testCloseList()
	{
		var oSouris:Object = {x:_mcListe._xmouse, y:_mcListe._ymouse};	
		
 		var spaceFlecheDefil:Number = 20; // largeur des flèches de défilements des éléments

		// test des coordonnées de la souris en x et en y -> la liste est positionnée au dessus de la combo.
		if(_bContentPositionTop)
		{
			if( oSouris.x > _mcListe._width || oSouris.x < _mcListe._x
			|| oSouris.y < 0|| oSouris.y > _mcListe._height )
				this.close();
		}
		// test des coordonnées de la souris en x et en y -> la liste est positionnée sous la combo.
		else if( oSouris.x > _mcListe._width || oSouris.x < _mcListe._x 
		|| oSouris.y > _mcListe._height || oSouris.y+spaceFlecheDefil < _mcListe._y)
			this.close();
		
	}
	
	
	

	/*----------------------------------------------------*/
	/*----------------- Getter/Setter --------------------*/
	/*----------------------------------------------------*/
	
	
	
	/**
	 * Met à jour le titre de la comboBox
	 * 
	 * @param  val : le nouveau titre de la comboBox 
	 */
	public function setTitle (val:String)
	{
		_oBtnTitle.value = val;
	}
	
	public function getTitle ():String
	{
		return _oBtnTitle.value;
	}	
	
	

}//end ComboBox