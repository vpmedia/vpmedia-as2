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

/* -------- CornerRectangleComponent

	AUTHOR

		Name : CornerRectangle
		Package : neo.display.components.shape
		Version : 1.0.0.0
		Date : 2006-01-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- corner:Object [R/W]
		
		- fa:Number
		
			fill alpha
		
		- fc:Number
		
			fill color
		
		- la:Number
		
			line alpha
		
		- lc:Number
		
			line color
		
		- t:Number 
			
			thickness
	
	METHOD SUMMARY
	
		- draw():Void
		
		- getAlign():String
		
		- getCorner():Object
		
		- getMinMax():Object
		
		- initDraw():Void
		
		- setAlign(str:String):Void
		
		- setCorner(obj:Object):Void

	INHERIT
	
		Object 
			|
			AbstractComponent
				|
				RectangleComponent
					|
					CornerRectangleComponent

------------------ */

import neo.display.components.shape.RectangleComponent;
import neo.util.factory.PropertyFactory;

class neo.display.components.shape.CornerRectangleComponent extends RectangleComponent {

	// ----o Constructor

	public function CornerRectangle () {
		//
	}

	// ----o Public Methods
	
	public function getCorner():Object {
		return { tl:_tl , br:_br , tr:_tr , bl:_bl } ;
	}
	
	public function setCorner(obj:Object):Void {
		_tl = (typeof obj.tl == "boolean") ? obj.tl : true  ;
		_br = (typeof obj.br == "boolean") ? obj.br : true  ;
		_tr = (typeof obj.tr == "boolean") ? obj.tr : true  ;
		_bl = (typeof obj.bl == "boolean") ? obj.bl : true  ;
		update() ;
	}

	// ----o Virtual Properties

	static private var __CORNER__:Boolean = PropertyFactory.create(CornerRectangleComponent, "corner", true) ;

	// ----o Private  Properties

	private var _tl:Boolean = true ;
	private var _tr:Boolean = true ;
	private var _bl:Boolean = true ;
	private var _br:Boolean = true ;
	
}