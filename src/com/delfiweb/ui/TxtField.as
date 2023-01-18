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
import com.delfiweb.form.AbstractForm;
import com.delfiweb.display.MovieClipGraphic;
import com.bourre.log.Logger;


/**
 * Create some TextField.
 * 
 * 
 * 
 * @usage
	var txt:String = "hello";
	var coordX:Number = 10;
	var coordY:Number = 10;
	var largeurW:Number = 250;
	var hauteurH:Number = 18;
	var otxtfield:Object = {background:false, backgroundColor:0xcccccc};
	var otxtformat:Object = {font:"Times New Roman", size:14};
	var oBackground:Background = new Background("sun");
	
	var oTxtField:TxtField = new TxtField(txt, 
	coordX, coordY, largeurW, hauteurH, otxtfield, otxtformat,oBackground);
	oTxtField.attach(_root);
			
 * 
 * @author Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006
 */
class com.delfiweb.ui.TxtField extends AbstractContainer
{
	private var _oMcGraphic:MovieClipGraphic;
	
	
	/* caractéristiques du champ texte */	
	private var _sTxt:String; // string in TextField


	/* les objets utilisés */
	private var _oTextFieldProp:Object; // add some property to the TextField
	private var _oTextFormatProp:Object; // add some property to the TextFormat
	private var _oForm:AbstractForm; // object AbstractForm to create a background (Square, Circle, Background)


	/* constantes */
	private var _oTxtField:TextField; // object TextField



	/**
	 * CONSTRUCTOR
	 * 
	 * @param   txt			: texte   
	 * @param   x       	: Coordonnée initiale sur x de l'objet.
	 * @param   y       	: Coordonnée initiale sur y de l'objet.
	 * @param   w       	: widht
	 * @param   h      		: height
	 * @param   otxtfield  	: property of TextField
	 * @param   otxtformat 	: property of TextFormat
	 * @param   oAbsForm	: an objet AbstractForm (square, background...)
	 * @return  
	 */
    public function TxtField(txt:String, x:Number, y:Number, w:Number, h:Number, 
	otxtfield:Object, otxtformat:Object, oAbsForm:AbstractForm)
    {
		super("TxtField_"+random(1000), x, y); // création d'un AbstractContainer
		
		/* initialisation du TxtField */
		this._sTxt = txt ? txt : "";
		this._nWidth = w ? w : 0;
		this._nHeight = h ? h : 0;
		
		
		/* default property of the TextField */
		this._oTextFieldProp = new Object();
		this._oTextFieldProp.multiline=true; // Indique si le champ texte est multiligne.
		this._oTextFieldProp.background=false; // Indique si le champ texte a un remplissage d'arrière-plan.
		this._oTextFieldProp.backgroundColor=0xcccccc; // couleur de l'arrière-plan.
		this._oTextFieldProp.wordWrap=true; // Indique si le champ texte comporte un retour à la ligne.
		this._oTextFieldProp.autoSize=true; // Commande le dimensionnement et l'alignement automatique du champ texte.
		this._oTextFieldProp.selectable=false; // Indique si le champ texte est sélectionnable.
		this._oTextFieldProp.html = true; // Indique si le champ texte contient de HTML.
		this._oTextFieldProp.type = "dynamic"; // Spécifie le type de champ texte ("dynamic", "input")
		
		// applique les propriétés voulues au TextField
		for(var propFd in otxtfield)
		{
			this._oTextFieldProp[propFd] = otxtfield[propFd];
		}
		
		
		
		/* définis les propriétés par défaut du TextFormat */
		this._oTextFormatProp = {font:"Arial"};
		
		// applique les propriétés voulues au TextFormat
		for(var propFt in otxtformat)
		{
			this._oTextFormatProp[propFt] = otxtformat[propFt];
		}
		

		// si on a un arrière plan
		if( oAbsForm!=undefined)
		{
			_oForm = oAbsForm;
			
			// update size of Label
			if( _nWidth<_oForm.getWidth() ) _nWidth = oAbsForm.getWidth();
			if( _nHeight<_oForm.getHeight() ) _nHeight = oAbsForm.getHeight();
		}


		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
	}




/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/


	

	public function setHeight(iHeight:Number) : Void
	{
		this._oTxtField._height = iHeight;
		this.updateSize();
	}
	
	
	public function setWidth(iWidth:Number) : Void
	{
		this._oTxtField._width = iWidth;
		this.updateSize();
	}
	
	
	/**
	 * Update position of background
	 * 
	 * @param   x 
	 * @param   y 
	 * @return  
	 */
	public function moveBackground(x:Number, y:Number):Void
	{
		if(_oForm!=undefined)
		{
			_oForm.move(x,y);
		}
	}



	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct():Boolean
	{
		delete _oTextFieldProp;
		delete _oTextFormatProp;
		delete this;// supprime l'objet lui-même
		return true;
	}



	/**
	 * Apply a nex TextFormat on the TextField
	 * 
	 * @param   otxtformat : all property of the TextFormat
	 * @return  
	 */
	public function setTxtFormat(otxtformat:Object)
	{

		var oTextF:TextFormat = new TextFormat();
		
		for(var propFt in otxtformat)
		{
			// applique les propriétés voulues à l'objet TextFormat de la classe
			_oTextFormatProp[propFt] = otxtformat[propFt];
			
			// applique les propriétés définies au TextField
			oTextF[propFt] = _oTextFormatProp[propFt]; 
		}
		
		_oTxtField.setTextFormat(oTextF); // met à jour le format de texte
	}
	


	/**
	 * Update property of the TextField
	 * 
	 * @param   otxtfield : all property of the TextField
	 * @return  
	 */
	public function setTxtField(otxtfield:Object)
	{
		for(var propFt in otxtfield)
		{
			// applique les propriétés voulues à l'objet TextField de la classe
			_oTextFieldProp[propFt] = otxtfield[propFt];
			
			// applique les propriétés définies au TextField
			_oTxtField[propFt] = _oTextFieldProp[propFt]; 
		}
	}
	
	

	/*----------------------------------------------------------*/
	/*------------- Getter / Setter ----------------------------*/
	/*----------------------------------------------------------*/


		
	/**
	 * Update the text.
	 * 
	 * @param   sTxt	: new value of the text
	 * @return	text in the object TextField
	 */
	public function set txt (sTxt:String)
	{
		this._sTxt = sTxt;
		
		if(_oTxtField==undefined) return;
		
		if( _oTxtField.html )
		{
			if( this._sTxt!=undefined ) _oTxtField.htmlText = this._sTxt;
			else  _oTxtField.htmlText = "";
		}
			
		else
		{
			if( this._sTxt!=undefined ) _oTxtField.text = this._sTxt;
			else  _oTxtField.text = "";
		}
			
			
		/* applique de nouveau le format de texte */
		this.setTxtFormat(_oTextFormatProp);
		
		this.updateSize();		
	}
	
	public function get txt ():String
	{
		/* if we use an inpout text, update the value of variable */
		if( _oTxtField.html ) this._sTxt = _oTxtField.htmlText;			
		else this._sTxt = _oTxtField.text;
		
		return this._sTxt;
	}
	
	
	/**
	 * Return current TextField.
	 * 
	 * Perhaps, i delete this function on the future.
	 * I think it is to much.
	 * 
	 * Don't use it. (the version of package is beta)
	 * DEPRECIATED
	 * @return  
	 */
	public function getTxtField():TextField
	{
		return this._oTxtField;
	}




	/**
	 * Return a copy of current object.
	 * 
	 * @return  a copy of current object.
	 */
	public function clone ():TxtField
	{
		return new TxtField (this._sTxt, this._nX, this._nY, _nWidth, _nHeight, this._oTextFieldProp, this._oTextFormatProp);
	}
	


		
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/

	/**
	 * Called by class AbstractContainer when object is drawing
	 * 
	 * @return  
	 */
	private function endBuilding()
	{	
		if( _oForm!=undefined ) _oForm.attach(_mcBase, 1);
		
		_mcBase.createTextField("__TxtField__", 2, 0, 0, this._nWidth, this._nHeight);
		_oTxtField = _mcBase["__TxtField__"];
		
		/* applique les propriétés définies au TextField */
		for(var propFd in _oTextFieldProp)
		{
			_oTxtField[propFd] = _oTextFieldProp[propFd];
		}
		
		// si le texte utilise des balises HTML
		if( _oTxtField.html )
		{
			if( this._sTxt!=undefined ) _oTxtField.htmlText = this._sTxt;
			else  _oTxtField.htmlText = "";
		}
			
		else
		{
			if( this._sTxt!=undefined ) _oTxtField.text = this._sTxt;
			else  _oTxtField.text = "";
		}
		
		/* personnalise le champ texte */
		this.setTxtFormat(_oTextFormatProp);
		
		this.updateSize();
	}



	private function updateSize()
	{
		this._nWidth = this._oTxtField._width;
		this._nHeight = this._oTxtField._height;
	}



}//end TxtField