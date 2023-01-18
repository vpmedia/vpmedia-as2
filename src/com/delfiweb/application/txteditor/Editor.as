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


// delfiweb
import com.delfiweb.ui.TxtField;
import com.delfiweb.form.AbstractForm;
import com.bourre.commands.Delegate;
import com.bourre.log.Logger;



/**
 * @author Matthieu.
 * 
 */
class com.delfiweb.application.txteditor.Editor extends TxtField
{
	
	/* config */
	private var _oBtnAction				: Object;


	/* manage textField */
	public var _nBegin 				: Number;
	public var _nEnd 					: Number;

	private var _bEnableFocus : Boolean;

	private var _nIndent : Number;
	
	
	
	
/* ****************************************************************************
 * CONSTRUCTOR
 **************************************************************************** */
	
	public function Editor(sTxt:String, x:Number, y:Number, w:Number, h:Number, 
	otxtfield:Object, otxtformat:Object, oAbsForm:AbstractForm, oBtnAction:Object) 
	{
		super( sTxt, x, y, w, h, otxtfield, otxtformat, oAbsForm);
		_oBtnAction = oBtnAction;
		
		this._nIndent = 10;
		this.setName( "Editor"+random(1000) );
		Selection.addListener(this);
		Key.addListener(this);		
	}


	
/* ****************************************************************************
 * PRIVATE FUNCTIONS
 **************************************************************************** */
	
	
	
	/*----------------------------------------------------------*/
	/*---------------- Manage Focus ----------------------------*/
	/*----------------------------------------------------------*/


	private function getFocus():Void
	{
		Selection.setFocus(_oTxtField);
		Selection.setSelection(_nBegin,_nEnd);
	}
	
	
	/**
	 * Call by Selection
	 * Permet de savoir quand le textfield à le focus ou non
	 * 
	 * @usage   
	 * @param   o : Ancien objet qui avait le focus
	 * @param   n : Nouvel objet qui a le focus
	 * @return  
	 */
	
	private function onSetFocus( oldfocus:Object, newfocus:Object ):Void
	{
		if(newfocus == _oTxtField) _bEnableFocus = true;
		else _bEnableFocus = false;
	}
	
		
	/**
	 * La fonction appelée par la boucle de startProcess
	 * Ne s'execute qui si c'est le textfield qui a le focus
	 * 
	 * @usage   
	 * @return  
	 */
	private function onSelectionUpdate():Void
	{
		if(_bEnableFocus)
		{			
			/* update the text selection */
			_nBegin = Selection.getBeginIndex();
			_nEnd = Selection.getEndIndex();
			
			var oFormat:TextFormat =  _oTxtField.getTextFormat(_nBegin, _nEnd);
			this._oEventManager.broadcastEvent("_onUpdateLabelSize", oFormat.size.toString());				
		}
	}



	/**
	 * Call by Key.
	 * Tabulation of text.
	 * 
	 */
	private function onKeyDown():Void
	{
		// remove tabulation to the text
		if ( Key.isDown(Key.TAB) && Key.isDown(Key.SHIFT) )
		{
			this.getFocus();
			
			var oFormat:TextFormat = _oTxtField.getTextFormat(_nBegin, _nEnd);
			oFormat.indent = oFormat.indent-_nIndent;
			
			_oTxtField.setTextFormat(_nBegin,_nEnd,oFormat);
			
			this.getFocus();
		}
		// add tabulation to the text
		else if (Key.isDown(Key.TAB))
		{
			this.getFocus();
			
			var oFormat:TextFormat = _oTxtField.getTextFormat(_nBegin, _nEnd);
			oFormat.indent = oFormat.indent+_nIndent;
			
			_oTxtField.setTextFormat(_nBegin,_nEnd,oFormat);
			
			this.getFocus();
		}
		else this.updateSize();
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
	 * @return
	 */
	public function attach(mc:MovieClip,d:Number):Void
	{
		super.attach(mc, d);
	
		this.getFocus();
		_mcBase.onEnterFrame = Delegate.create(this, onSelectionUpdate);
	}

	
	/**
	 * Update the text (set bold, italic...) after an user commands.
	 * Call by class BuildEditor.
	 * 
	 */
	public function updateTxt(prop:String):Void
	{
		var oFormat:TextFormat = _oTxtField.getTextFormat(_nBegin,_nEnd);
		oFormat[prop] = !oFormat[prop];
		
		if(_nEnd - _nBegin > 0) _oTxtField.setTextFormat(_nBegin, _nEnd, oFormat);			
		else _oTxtField.setNewTextFormat(oFormat);
			
		this.getFocus();	
	}	
	
	
	/**
	 * Update the text (set bold, italic...) after an user commands.
	 * Call by class BuildEditor.
	 * 
	 */
	public function updateAlign(value:String):Void
	{
		var oFormat:TextFormat = _oTxtField.getTextFormat(_nBegin,_nEnd);
		oFormat.align = value;
		
		if(_nEnd - _nBegin > 0) _oTxtField.setTextFormat(_nBegin, _nEnd, oFormat);			
		else _oTxtField.setNewTextFormat(oFormat);
			
		this.getFocus();
	}	
	
	/**
	 * Update the size of the text after an user commands.
	 * Call by class BuildEditor.
	 * 
	 */
	public function updateTxtSize(nValue:Number):Void
	{
		if( nValue==undefined ) return;
		
		var oFormat:TextFormat = _oTxtField.getTextFormat(_nBegin,_nEnd);
		oFormat.size = nValue;
		
		_oTxtField.setTextFormat(_nBegin,_nEnd,oFormat);
	}
	
	
	/**
	 * Call by class BuildEditor.
	 * Change the color of the text.
	 * 
	 */
	public function setColor(nColor:Number):Void
	{
		var oFormat:TextFormat = _oTxtField.getTextFormat(_nBegin,_nEnd);
		oFormat.color = nColor;
		
		_oTxtField.setTextFormat(_nBegin,_nEnd,oFormat);
		
		this.getFocus();
	}
	
		
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */	
	public function destruct():Boolean
	{
		Selection.removeListener(this);
		Key.removeListener(this);
		return super.destruct();	
	}
	
	
	
}// end of class