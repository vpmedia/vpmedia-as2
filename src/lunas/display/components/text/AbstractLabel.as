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

import lunas.display.components.AbstractComponent;
import lunas.display.components.ILabel;

import pegas.events.UIEvent;
import pegas.events.UIEventType;

/**
 * This abstract class is the skeletal implementation of the {@code ILabel} interface.
 * @author eKameleon
 */
class lunas.display.components.text.AbstractLabel extends AbstractComponent implements ILabel 
{

	/**
	 * Creates a new AbstractLabel instance.
	 */
	private function AbstractLabel() 
	{ 
		super() ;		
	}

	/**
	 * Returns the automatic sizing and alignment of labels value.
	 * @return the automatic sizing and alignment of labels value.
	 * @see TextFieldAutoSize
	 */
	public function get autoSize():Boolean
	{
		return getAutoSize() ;	
	}

	/**
	 * Sets the automatic sizing and alignment of labels value.
	 */
	public function set autoSize( b:Boolean ) 
	{
		setAutoSize( b ) ;	
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

	public function get label():String 
	{
		return getLabel() ;	
	}

	public function set label(s:String) 
	{
		setLabel(s) ;	
	}
		
	public function get multiline():Boolean 
	{ 
		return getMultiline() ; 
	}
	
	public function set multiline(b:Boolean) 
	{ 
		setMultiline(b); 
	}
	
	public function get text():String 
	{
		return getText() ;	
	}

	public function set text(s:String) 
	{
		setText(s) ;	
	}

	public function getAutoSize():Boolean
	{
		return _autoSize ;
	}

	public function getHTML():Boolean 
	{
		return _html ;
	}
	
	public function getLabel():String 
	{
		return _label || "" ;
	}

	public function getMultiline():Boolean 
	{ 
		return _multiline ; 
	}
	
	public function getText():String 
	{
		return getLabel() ;
	}

	public function setAutoSize( b:Boolean ):Void 
	{
		_autoSize = b ;
		update() ;
	}

	public function setHTML(b:Boolean):Void 
	{
		_html = b ;
		update() ;
	}

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
		dispatchEvent(new UIEvent( UIEventType.LABEL_CHANGE ) ) ;
	}
	
	public function setMultiline(b:Boolean):Void 
	{ 
		_multiline = b ;
		update() ;
	}
	
	public function setText(str:String):Void 
	{
		setLabel(str) ;
	}

	public function viewLabelChanged():Void 
	{
		// override this method when label property change
	}

	private var _autoSize:Boolean ;

	private var _html:Boolean ;

	private var _label:String ;

	private var _multiline:Boolean ;
	

}

