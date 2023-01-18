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



/**
 * TODO
 * 
 * - Prévoir un PlaceHolder contenant une zone de texte éditable.
 * - Prévoir le undo / redo.
 * - Insertion d'un lien.
 * - Insertion d'une image.
 * 
 */


// delfiweb
import com.delfiweb.application.txteditor.Editor;
import com.delfiweb.ui.Button;
import com.delfiweb.utils.ColorPicker;
import com.delfiweb.ui.PlaceHolder;
import com.delfiweb.ui.Label;


// bourre
import com.bourre.commands.Delegate;


// debug
import com.bourre.log.Logger;
import com.delfiweb.form.Square;


/**
 * An example of using textEditor is at the end of class.
 * 
 * /


/**
 * @author Matthieu
 * @since 18 Juillet 2007
 * @version 0.1
 * 
 */
class com.delfiweb.application.txteditor.BuildEditor
{

	/*----- Movies Clip ------*/
	private var _mcBase			: MovieClip; // master clip	


	/* caractéristiques */
	private var _nX					: Number; // used when AbstractForm is an external swf loaded.
	private var _nY					: Number; // used when AbstractForm is an external swf loaded.
	private var _nWidth				: Number;// used when AbstractForm is an external swf loaded.
	private var _nHeight			: Number;// used when AbstractForm is an external swf loaded.
	
	
	/* object */
	private var _oEditor 			: Editor;
	
	
	/* config */
	private var _aBtnAction			: Array;
	

	/* other */
	private var _nDepth 			: Number;

	private var _oColorPicker 		: ColorPicker;

	private var _oPlaceHolder 		: PlaceHolder;

	private var _oBTnSize 			: Label;




/* ****************************************************************************
 * CONSTRUCTOR
 **************************************************************************** */
	
	public function BuildEditor( x:Number, y:Number, w:Number, h:Number, 
	oConfigContainer:Object, oConfigEditor:Object, oConfigBtn:Object, oConfigBtnSize:Object ) 
	{
		_nDepth = 10;
		_aBtnAction = new Array();
		
		Key.addListener(this);
		
		this._nX = x ? x : 0;
		this._nY = y ? y : 0;
		this._nWidth = w ? w : 0;
		this._nHeight = h ? h : 0;
		
		// add a container for the editor
		_oPlaceHolder = new PlaceHolder( oConfigContainer.x, oConfigContainer.y, oConfigContainer.absform, 
		oConfigContainer.padding, oConfigContainer.scroll_size, oConfigContainer.scroll_type, oConfigContainer.url, 
		oConfigContainer.w, oConfigContainer.h);
		
		// add the text editor area
		_oEditor = new Editor( oConfigEditor.txt, oConfigEditor.x, oConfigEditor.y, oConfigEditor.w, oConfigEditor.h, 
		oConfigEditor.txtfield, oConfigEditor.txtformat, null);
		_oEditor.addListener(this);
		
		/* add all button action (bold, italic...). */
		var oBtnAction:Button;
		var oSqBtn:Square;
		var oDelegate:Delegate;
		var nX:Number = oConfigBtn.x;		var nY:Number = oConfigBtn.y;
		var nNewX:Number;
		
		for (var i : Number = 0; i < oConfigBtn.btn_action.length; i++)
		{
			oSqBtn = new Square(oConfigBtn.btn_action[i].square.url, oConfigBtn.btn_action[i].square.width, 
			oConfigBtn.btn_action[i].square.height, oConfigBtn.btn_action[i].square.round);
			
			oBtnAction = new Button( nX, nY, oConfigBtn.btn_action[i].padding, oConfigBtn.btn_action[i].txt, 
			oConfigBtn.btn_action[i].url_icon, oConfigBtn.btn_action[i].pos_icon_left, 
			oConfigBtn.btn_action[i].txt_tooltip, oSqBtn, 
			oConfigBtn.btn_action[i].w, oConfigBtn.btn_action[i].h);
			
			if(  oConfigBtn.btn_action[i].align == false ) 
			{
				oDelegate = new Delegate(this, _onButtonAction, oConfigBtn.btn_action[i].name);
				oBtnAction.onRelease = oDelegate.getFunction();
			}
			else
			{
				oDelegate = new Delegate(this, _onButtonAlign, oConfigBtn.btn_action[i].name);
				oBtnAction.onRelease = oDelegate.getFunction();
			}
			
			_aBtnAction.push(oBtnAction);
			
			// vérifier si assez de place en largeur
			nNewX = nX + oConfigBtn.space + oBtnAction.getWidth() + oConfigBtn.space;
			if( nNewX < this._nWidth ) nX += oConfigBtn.space + oBtnAction.getWidth();
			else
			{
				nX = oConfigBtn.x;
				nY += oConfigBtn.space + oBtnAction.getHeight();
			}
		}
		
		_oColorPicker = new ColorPicker(nX, nY, oConfigEditor.w_colorpicker, oConfigEditor.h_colorpicker);
		_oColorPicker.addListener(this);
		
		// vérifier si assez de place en largeur
		nNewX = nX + oConfigBtn.space + _oColorPicker.getWidth() + oConfigBtn.space;
		if( nNewX < this._nWidth ) nX += oConfigBtn.space + _oColorPicker.getWidth();
		else
		{
			nX = oConfigBtn.x;
			nY += oConfigBtn.space + _oColorPicker.getHeight();
		}
			
		_oBTnSize = new Label( nX, nY, oConfigBtnSize.padding, oConfigBtnSize.txt, 
			oConfigBtnSize.url_icon, oConfigBtnSize.pos_icon_left, 
			oConfigBtnSize.absform, oConfigBtnSize.w, oConfigBtnSize.h);
		
		var oTxtField:Object = {background:false, backgroundColor:0x0033FF, selectable:true, type:"input", 
			multiline:false, html:false, wordWrap:false, autoSize:"none"};
		_oBTnSize.setTxtField(oTxtField);
		// oConfigBtnSize.txt_tooltip, 
	}	
	
	
	
/* ****************************************************************************
 * PRIVATE FUNCTIONS
 **************************************************************************** */
	
	
	/**
	 * Call when user interaction in a button action (bold, italic...).
	 * 
	 */
	private function _onButtonAction(oBtn:Button, sProp:String) : Void 
	{
		_oEditor.updateTxt(sProp);
	}


	/**
	 * Call when user interaction in a button action (center, left...).
	 * 
	 */
	private function _onButtonAlign(oBtn:Button, sValue:String) : Void 
	{
		_oEditor.updateAlign(sValue);
	}	
	
	
	/**
	 * Listener of ColorPicker.
	 * Call when the selected color change.
	 * 
	 */
	private function _onColorSelected(nColor):Void
	{
		_oEditor.setColor(nColor);
	}
	

	/**
	 * Listener of Editor.
	 * Call when the selection of the text change.
	 * Set the correct size for the label.
	 * 
	 */
	private function _onUpdateLabelSize( nSize:Number):Void
	{
		if( nSize!=undefined ) _oBTnSize.value = nSize.toString();
		_oPlaceHolder.update();
	}
	
		
	/**
	 * Call by Key.
	 * Size of text.
	 * 
	 */
	private function onKeyDown():Void
	{
		if( Key.isDown(Key.ENTER) ) _oEditor.updateTxtSize( Number(_oBTnSize.value) );
	}
	
		
/* ****************************************************************************
 * PUBLIC FUNCTIONS
 **************************************************************************** */


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
		if(d == undefined) d = mc.getNextHighestDepth();
		_mcBase = mc.createEmptyMovieClip("__BuildEditor__", d);
		_mcBase._x = _nX;		_mcBase._y = _nY;
		
		this._mcBase._focusRect = false;// supprime le rectangle jaune lorsqu'il a le focus clavier
		
		for (var i : Number = 0; i < _aBtnAction.length; i++)
		{
			_aBtnAction[i].attach( _mcBase, _nDepth++);
		}
		
		_oPlaceHolder.attach(_mcBase, _nDepth++);
		_oPlaceHolder.addContent( _oEditor, "center");
		_oColorPicker.attach(_mcBase, _nDepth++);		_oBTnSize.attach(_mcBase, _nDepth++);
		
		return;
	}
	
	
	/**
	 * Get the text in the editor.
	 * 
	 * @return String
	 */	
	public function getText():String
	{
		return _oEditor.txt;
	}

	/**
	 * Get the text in the editor.
	 * 
	 * @return String
	 */	
	public function setText( sTxt:String) :Void
	{
		_oEditor.txt = sTxt;
	}
		
	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */	
	public function destruct():Void
	{
		_oEditor.destruct();
		_oColorPicker.destruct();
		Key.removeListener(this);
				
		for (var i : String in _aBtnAction)
		{
			_aBtnAction[i].destruct();
		}
	}
	
	
}// end of class

/**
 * An example of using textEditor.
 * 


var _mcToolTip:MovieClip = _mcBase.createEmptyMovieClip("viewToolTip", 1000);
		var oToolTip:ToolTip = ToolTip.instance;
		var oAbsForm:Square = new Square("template/default/tooltip.swf", 20, 20, 15);
		oToolTip.setTip(oAbsForm);
		oToolTip.attach(_mcToolTip);
		
		var oSqPlaceHolder:Square = new Square("template/default/square_btn_prev_next.swf", 250, 250);
		var oConfigContainer:Object = new Object();
		oConfigContainer.x = 5;
		oConfigContainer.y = 40;
		oConfigContainer.w = 250;
		oConfigContainer.h  = 250;
		oConfigContainer.padding  = 5;
		oConfigContainer.scroll_size  = 16;
		oConfigContainer.scroll_type  = PlaceHolder.SCROLL_VERTICAL;
		oConfigContainer.url  = "template/default/scrollbar_list.swf";
		oConfigContainer.absform = oSqPlaceHolder;
		
		var oConfigEditor:Object = new Object();
		oConfigEditor.txt = "Choisissez votre texte.";
		oConfigEditor.x = 0;
		oConfigEditor.y = 0;
		oConfigEditor.w = 220;
		oConfigEditor.h  = 250;
		oConfigEditor.w_colorpicker  = 20;
		oConfigEditor.h_colorpicker  = 20;
		oConfigEditor.otxtfield = {type:"input", selectable:true, autoSize:false};
		oConfigEditor.otxtformat = {};
		oConfigEditor.absform = null;
		
		var oSq:Square = new Square("template/default/square_btn_prev_next.swf", 20, 20);
		var oConfigBtn:Object = new Object();
		oConfigBtn.x = 6;
		oConfigBtn.y = 5;
		oConfigBtn.space = 10;
		
		oConfigBtn.btn_action = new Array();
		
		// one button action
		var oBtnAction:Object = new Object();
		oBtnAction.padding = 1;
		oBtnAction.txt = "<b>B</b>";
		oBtnAction.url_icon = null;
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Gras";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "bold";
		oBtnAction.align = false;
		oConfigBtn.btn_action.push(oBtnAction);
		
		oBtnAction = new Object();
		oBtnAction.padding = 1;
		oBtnAction.txt = "<i>I</i>";
		oBtnAction.url_icon = null;
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Italique";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "italic";
		oBtnAction.align = false;
		oConfigBtn.btn_action.push(oBtnAction);
		
		oBtnAction = new Object();
		oBtnAction.padding = 1;
		oBtnAction.txt = "<u>U</u>";
		oBtnAction.url_icon = null;
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Soulignage";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "underline";
		oBtnAction.align = false;
		oConfigBtn.btn_action.push(oBtnAction);
		
		oBtnAction = new Object();
		oBtnAction.padding = 2;
		oBtnAction.txt = null;
		oBtnAction.url_icon = "template/default_editor/align_left.swf";
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Aligné à gauche";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "left";
		oBtnAction.align = true;
		oConfigBtn.btn_action.push(oBtnAction);
			
		oBtnAction = new Object();
		oBtnAction.padding = 2;
		oBtnAction.txt = null;
		oBtnAction.url_icon = "template/default_editor/align_center.swf";
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Centré";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "center";
		oBtnAction.align = true;
		oConfigBtn.btn_action.push(oBtnAction);
		
		oBtnAction = new Object();
		oBtnAction.padding = 2;
		oBtnAction.txt = null;
		oBtnAction.url_icon = "template/default_editor/align_right.swf";
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Aligné à droite";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "right";
		oBtnAction.align = true;
		oConfigBtn.btn_action.push(oBtnAction);
			
		oBtnAction = new Object();
		oBtnAction.padding = 2;
		oBtnAction.txt = null;
		oBtnAction.url_icon = "template/default_editor/align_justify.swf";
		oBtnAction.pos_icon_left = true;
		oBtnAction.txt_tooltip = "Justifié";
		oBtnAction.absform = oSq.clone();
		oBtnAction.w = 0;
		oBtnAction.h = 0;
		oBtnAction.name = "justify";
		oBtnAction.align = true;
		oConfigBtn.btn_action.push(oBtnAction);
		
		var oSq1:Square = new Square("template/default/square_btn_prev_next.swf", 30, 30);
		
		var oConfigBtnSize:Object = new Object();
		oConfigBtnSize.padding = 1;
		oConfigBtnSize.txt = "12";
		oConfigBtnSize.url_icon = null;
		oConfigBtnSize.pos_icon_left = true;
		oConfigBtnSize.txt_tooltip = "Taille de police";
		oConfigBtnSize.absform = oSq.clone();
		oConfigBtnSize.w = 0;
		oConfigBtnSize.h = 0;
		
		_oTextEditor = new BuildEditor(10, 10, 300, 300, oConfigContainer, oConfigEditor, oConfigBtn, oConfigBtnSize);
		_oTextEditor.attach( _mcBase, _nDepth++);
*/