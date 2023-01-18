/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* -------- AbstractLabel


	AUTHOR

		Name : AbstractLabel
		Package : neo.display.components.text
		Version : 1.0.0.0
		Date :  2006-02-19
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY

		- autoSize:Boolean [R/W]
	
		- html:Boolean [R/W]
		
		- label:String [R/W]

		- text:String [R/W] 
			Par défaut utilise 'label'

	METHOD SUMMARY

  		- getAutoSize():Boolean

		- getHTML():Boolean
	
		- getLabel():String
		
		- getText():String

			Par défaut utilise 'getLabel'

		- setHTML(b:Boolean):Void

		- setAutoSize(b:Boolean):Void
	
		- setLabel(str:String):Void

		- setText(str:String):Void

			Par défaut utilise 'setLabel'

		- viewLabelChanged():Void

			override this method !

	IMPLEMENTS 
	
		ILabel, IEventTarget

	EVENT SUMMARY

		UIEvent

 
 	EVENT TYPE SUMMARY

		UIEventType.LABEL_CHANGE

	INHERIT 
	
		MovieClip
			|
			AbstractComponent
				|
				AbstractLabel

	SEE ALSO
	
		IBuilder, IStyle
	
----------------*/


import neo.display.components.AbstractComponent;
import neo.display.components.ILabel;
import neo.events.UIEvent;
import neo.events.UIEventType;
import neo.util.factory.PropertyFactory;

class neo.display.components.text.AbstractLabel extends AbstractComponent implements ILabel {

	// ----o Constructor

	private function AbstractLabel() { 
		
	}

	// ----o Public Properties
	
	public var autoSize:Boolean ; // [R/W]
	public var html:Boolean ; // [R/W]
	public var label:String ; // [R/W]
	public var text:String ; // [R/W]
	
	// ----o Public Methods

	public function getAutoSize():String {
		return _autoSize ;
	}

	public function getHtml():Boolean {
		return _html ;
	}

	public function getLabel():String {
		return _label || "" ;
	}

	public function getText():String {
		return getLabel() ;
	}

	public function setAutoSize(s:String):Void {
		_autoSize = s ;
		update() ;
	}

	public function setHtml(b:Boolean):Void {
		_html = b ;
		update() ;
	}
	
	public function setLabel(str:String):Void {
		_label = str ; 
		viewLabelChanged() ;
		update() ;
		broadcastEvent(new UIEvent( UIEventType.LABEL_CHANGE )) ;
	}

	public function setText(str:String):Void {
		setLabel(str) ;
	}

	public function viewLabelChanged():Void {
		// override this method when label property change
	}

	// ----o Virtual Properties

	static private var __HTML__:Boolean = PropertyFactory.create(AbstractLabel, "html", true) ;
	static private var __LABEL__:Boolean = PropertyFactory.create(AbstractLabel, "label", true) ;
	static private var __TEXT__:Boolean = PropertyFactory.create(AbstractLabel, "text", true) ;

	// ----o Private Properties
	
	private var _autoSize:String ;
	private var _html:Boolean ;
	private var _label:String ;
	
}

