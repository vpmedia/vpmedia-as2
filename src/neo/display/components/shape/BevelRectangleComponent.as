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


/* ------- BevelRectangleComponent



	AUTHOR

		

		Name : BevelRectangleComponent

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

		

		- hBevel:Number [R/W]

		

		- la:Number

		

			line alpha

		

		- lc:Number

		

			line color

		

		- t:Number 

			

			thickness

		

		- vBevel:Number [R/W]

	

	METHOD SUMMARY

	

		- draw():Void

		

		- getAlign():String

		

		- getCorner():Object

		

		- getHBevel():Number

		

		- getMinMax():Object

		

		- getVBevel():Number

		

		- initDraw():Void

		

		- setAlign(str:String):Void

		

		- setCorner(obj:Object):Void

		

		- setHBevel(n:Number):Void

		

		- setVBevel(n:Number):Void



	INHERIT

	

		Object 

			|

			AbstractComponent

				|

				RectangleComponent

					|

					CornerRectangleComponent

						|

						BevelRectangleComponent



------------------------- */



import neo.display.components.shape.CornerRectangleComponent;
import neo.util.factory.PropertyFactory;



class neo.display.components.shape.BevelRectangleComponent extends CornerRectangleComponent {



	// ----o Constructor



	public function BevelRectangleComponent () { 

		super() ;

	}



	// ----o Public Methods



	public function draw():Void {

		if (_hBevel > 0 && _vBevel > 0) {

			initDraw() ;

			moveTo ( __min__.x + getHBevel(), __min__.y) ;

			if (_tr) {

				lineTo( __max__.x - getHBevel() , __min__.y) ;

				lineTo( __max__.x , __min__.y + getVBevel() ) ;

			} else {

				lineTo( __max__.x , __min__.y ) ;

			}

			if (_br) {

				lineTo( __max__.x , __max__.y - getVBevel() ) ;

				lineTo( __max__.x - getHBevel() , __max__.y) ;		

			} else {

				lineTo( __max__.x , __max__.y ) ;

			}

			if (_bl) {

				lineTo( __min__.x  + getHBevel(), __max__.y ) ;

				lineTo( __min__.x  ,  __max__.y - getVBevel() ) ;

			} else {

				lineTo( __min__.x , __max__.y ) ;

			}

			if (_tl) {

				lineTo(__min__.x, __min__.y + getVBevel()) ;

				lineTo(__min__.x + getHBevel(), __min__.y);

			} else {

				lineTo( __min__.x , __min__.y ) ;

			}

			endFill () ;

		} else {

			super.refresh () ;

		}

	}

	

	public function getHBevel():Number {

		return (_hBevel <= _w ) ? _hBevel : 0 ;

	}



	public function getVBevel():Number {

		return (_vBevel <= _h ) ? _vBevel : 0 ;

	}

	

	public function setHBevel(n:Number):Void {

		_hBevel = ( n>0 ) ? n : 0 ; 

		update() ;

	}

	

	public function setVBevel(n:Number):Void {

		_vBevel = (n>0) ? n : 0 ; 

		update();

	}	



	// ----o Getter Setter Properties

	

	static private var __HBEVEL__:Boolean = PropertyFactory.create(BevelRectangleComponent, "hBevel", true) ;

	static private var __VBEVEL__:Boolean = PropertyFactory.create(BevelRectangleComponent, "vBevel", true) ;

	

	// ----o Private  Properties



	private var _hBevel:Number = 5 ;

	private var _vBevel:Number = 5 ;





}