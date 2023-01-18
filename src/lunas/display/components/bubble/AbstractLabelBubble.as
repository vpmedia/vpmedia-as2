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

/** AbstractLabelBubble

	AUTHOR
	
		Name : AbstractLabelBubble
		Package : lunas.display.components.bubble
		Version : 1.0.0.0
		Date :  2006-04-20
		Author : eKameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	INHERIT
	
		MovieClip → AbstractComponent → BubbleComponent → AbstractLabelBubble

	IMPLEMENTS
	
		ILabel

**/

import lunas.display.components.bubble.BubbleComponent;
import lunas.display.components.ILabel;

import pegas.events.UIEvent;
import pegas.events.UIEventType;

/**
 * @author eKameleon
 */
class lunas.display.components.bubble.AbstractLabelBubble extends BubbleComponent implements ILabel {
	
	// ----o Constructor
	
	public function AbstractLabelBubble() {
		super() ;
	}

	// ----o Public Properties
	
	public var field:TextField ;

	// ----o Public Methods

	public function getAutoSize():Boolean {
		return _autoSize ;
	}

	public function getHTML():Boolean {
		return _html ;
	}
	
	public function getLabel():String {
		return _label || "" ;
	}

	function getMultiline() : Boolean {
		return _multiline ;
	}

	public function getText():String {
		return getLabel() ;
	}

	public function setAutoSize(b:Boolean):Void {
		_autoSize = b ;
		update() ;
	}

	public function setHTML(b:Boolean):Void {
		_html = b ;
		update() ;
	}

	public function setLabel(str:String):Void {
		_label = str.toString() ; 
		viewLabelChanged() ;
		dispatchEvent(new UIEvent( UIEventType.LABEL_CHANGE ) ) ;
	}

	function setMultiline(b : Boolean) : Void {
		_multiline = b ;
		update() ;
	}

	public function setText(str:String):Void {
		setLabel(str) ;
	}

	public function viewLabelChanged():Void {
		update() ;
	}

	// ----o Virtual Properties

	public function get autoSize():Boolean {
		return getAutoSize() ;	
	}

	public function set autoSize(b:Boolean) {
		setAutoSize(b) ;	
	}

	public function get html():Boolean {
		return getHTML() ;	
	}

	public function set html(b:Boolean) {
		setHTML(b) ;	
	}

	public function get label():String {
		return getLabel() ;	
	}

	public function set label(s:String) {
		setLabel(s) ;	
	}
		
	public function get multiline():Boolean { 
		return getMultiline() ; 
	}
	
	public function set multiline(b:Boolean) { 
		setMultiline(b); 
	}
	
	public function get text():String {
		return getText() ;	
	}

	public function set text(s:String) {
		setText(s) ;	
	}

	// ----o Private Properties

	private var _autoSize:Boolean = true ;
	private var _html:Boolean ;
	private var _label:String ;
	private var _multiline:Boolean ;

}