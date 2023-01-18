/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.core.ILabel;
import lunas.display.abstract.AbstractComponentDisplay;

import pegas.events.UIEvent;

/**
 * This abstract class is the skeletal implementation of the {@code ILabel} interface.
 * @author eKameleon
 */
class lunas.display.abstract.AbstractLabelDisplay extends AbstractComponentDisplay	implements ILabel 
{

	/**
	 * Creates a new AbstractLabelDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */
	private function AbstractLabelDisplay( sName:String, target:MovieClip ) 
	{ 
		super ( sName , target ) ;
	}

	/**
	 * Returns the automatic sizing and alignment of labels value.
	 * @return the automatic sizing and alignment of labels value.
	 * @see TextFieldAutoSize
	 */
	public function get autoSize():String
	{
		return getAutoSize() ;	
	}

	/**
	 * Sets the automatic sizing and alignment of labels value.
	 */
	public function set autoSize( type:String ) 
	{
		setAutoSize( type ) ;	
	}

	/**
	 * Returns a flag that indicates whether the label contains an HTML representation.
	 * @return a flag that indicates whether the label contains an HTML representation.
	 */
	public function get html():Boolean 
	{
		return getHTML() ;	
	}

	/**
	 * Sets the html flag that indicates whether the label contains an HTML representation.
	 */
	public function set html(b:Boolean) 
	{
		setHTML(b) ;	
	}

	/**
	 * Returns the label value of this component.
	 * @return the label value of this component.
	 */
	public function get label():String 
	{
		return getLabel() ;	
	}

	/**
	 * Sets the label value of this component.
	 */
	public function set label(s:String) 
	{
		setLabel(s) ;	
	}
	
	/**
	 * Indicates whether the component contains a multiline text field. 
	 * If the value is {@code true} the text field is multiline ; 
	 * if the value is {@code false} the text field is a single-line text field.
	 */	
	public function get multiline():Boolean 
	{ 
		return getMultiline() ; 
	}

	/**
	 * Indicates whether the component contains a multiline text field. 
	 * If the value is {@code true} the text field is multiline ; 
	 * if the value is {@code false} the text field is a single-line text field.
	 */
	public function set multiline(b:Boolean) 
	{ 
		setMultiline(b); 
	}
	
	/**
	 * Returns the text value of this component.
	 * @return the text value of this component.
	 */
	public function get text():String 
	{
		return getText() ;	
	}

	/**
	 * Sets the label value of this component.
	 */
	public function set text(s:String) 
	{
		setText(s) ;	
	}

	/**
	 * Returns the automatic sizing and alignment of labels value.
	 * @return the automatic sizing and alignment of labels value.
	 * @see TextFieldAutoSize
	 */
	public function getAutoSize():String
	{
		return _autoSize ;
	}

	/**
	 * Returns a flag that indicates whether the label contains an HTML representation.
	 * @return a flag that indicates whether the label contains an HTML representation.
	 */
	public function getHTML():Boolean 
	{
		return _html ;
	}

	/**
	 * Returns the label value of this component.
	 * @return the label value of this component.
	 */
	public function getLabel():String 
	{
		return _label || "" ;
	}

	/**
	 * Indicates whether the component contains a multiline text field. 
	 * If the value is {@code true} the text field is multiline ; 
	 * if the value is {@code false} the text field is a single-line text field.
	 */
	public function getMultiline():Boolean 
	{ 
		return _multiline ; 
	}
	
	/**
	 * Returns the text value of this component.
	 * @return the text value of this component.
	 */
	public function getText():String 
	{
		return getLabel() ;
	}

	/**
	 * Sets the automatic sizing and alignment of labels value.
	 * @see TextFieldAutoSize
	 */
	public function setAutoSize( autoSize:String ):Void 
	{
		_autoSize = autoSize ;
		update() ;
	}

	/**
	 * Set the flag value that indicates whether the label contains an HTML representation.
	 */
	public function setHTML(b:Boolean):Void 
	{
		_html = b ;
		update() ;
	}

	/**
	 * Sets the label value of this component.
	 */
	public function setLabel(str:String):Void 
	{
		_label = str.toString() ; 
		if ( arguments[1] == true )
		{
			//
		}
		else
		{
			viewLabelChanged() ;
			update() ;
		}
		dispatchEvent(new UIEvent( UIEvent.LABEL_CHANGE ) ) ;
	}

	/**
	 * Indicates whether the component contains a multiline text field. 
	 * If the value is {@code true} the text field is multiline ; 
	 * if the value is {@code false} the text field is a single-line text field.
	 */
	public function setMultiline(b:Boolean):Void 
	{ 
		_multiline = b ;
		update() ;
	}

	/**
	 * Sets the text value of this component.
	 */
	public function setText(str:String):Void 
	{
		setLabel(str) ;
	}
	
	/**
	 * Invoqued when the label value of this component is changed.
	 */
	public function viewLabelChanged():Void 
	{
		// override this method when label property change
	}

	private var _autoSize:String ;

	private var _html:Boolean ;

	private var _label:String ;

	private var _multiline:Boolean ;

}

