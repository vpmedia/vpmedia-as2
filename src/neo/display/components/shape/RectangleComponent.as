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


/* ------- RectangleComponent



	AUTHOR

		

		Name : RectangleComponent

		Package : neo.display.components.shape

		Version : 1.0.0.0

		Date :  2006-01-06

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net



	PROPERTY SUMMARY

	

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

		

		- getMinMax():Object

		

		- initDraw():Void

		

		- setAlign(str:String):Void



	INHERIT

	

		Object 

			|

			AbstractComponent

				|

				RectangleComponent



	TODO : AlignType class !!!



------------------------- */



import neo.display.components.AbstractComponent;
import neo.util.factory.PropertyFactory;



class neo.display.components.shape.RectangleComponent extends AbstractComponent {



	// ----o Constructor



	public function RectangleComponent () { 

		update() ; 

	}



	// ----o Public  Properties



	public var t : Number = 1 ;

	public var lc : Number = 0x000000 ;

	public var la : Number = 100 ;

	public var fc : Number = null ;

	public var fa : Number = null ;



	// ----o Public Methods



	public function draw():Void {

		initDraw() ;

		moveTo (__min__.x, __min__.y) ;

		lineTo (__max__.x, __min__.y);

		lineTo (__max__.x, __max__.y);

		lineTo (__min__.x, __max__.y);

		lineTo (__min__.x, __min__.y) ;	

	}



	public function getMinMax():Object {

		var w1 , w2 , h1, h2 :Number ;

		switch (_align) {

			case "b" : // Bottom

				w1 = (_w / 2) * -1 ; 

				h1 = _h * -1 ; 

				w2 = _w / 2 ; 

				h2 = 0 ;

				break ;

			case "l" : // Left

				w1 = 0 ; 

				h1 = (_h / 2) * -1 ; 

				w2 = _w ; 

				h2 = _h / 2 ;

				break ;

			case "r" : // Right

				w1 = -_w ; 

				h1 = (_h / 2) * -1 ; 

				w2 = 0 ; 

				h2 = (_h / 2)   ;

			break ;

			case "t" : // Top

				w1 = -_w / 2 ; 

				h1 = 0 ; 

				w2 = _w/2 ; 

				h2 = _h  ;

				break ;

			case "tl" : // Top Left

				w1 = 0 ; 

				h1 = 0 ; 

				w2 = _w ; 

				h2 = _h ;

				break ;

			case "tr" : // Top Right

				w1 = - _w ; 

				h1 = 0 ; 

				w2 = 0 ; 

				h2 = _h ;

				break ;

			case "bl" : // Bottom Left

				w1 = 0 ; 

				h1 = -_h ; 

				w2 = _w ; 

				h2 = 0  ;

				break ;

			case "br" : // Bottom Right

				w1 = - _w ; 

				h1 = -_h ; 

				w2 = 0 ; 

				h2 = 0  ;

				break ;

			default : // Center

				_align = "" ;

				w1 = (_w / 2) * -1 ; h1 = (_h / 2) * - 1 ; w2 = (_w / 2)  ; h2 = (_h / 2)  ;

		}

		__min__ = { x : w1 , y : h1 } ;

		__max__ = { x : w2 , y : h2 } ;

		return { min:__min__ , max:__max__ } ;

	}



	public function getAlign():String { 

		return _align.toUpperCase(); 

	}

	

	public function initDraw():Void {

		getMinMax () ;

		clear () ;

		lineStyle(t, lc, la);

		beginFill (fc, fa) ;

	}

	

	public function setAlign(str:String):Void {

		_align = str.toLowerCase() ;

		update() ;

	}



	// ----o Virtual Properties



	static private var __ALIGN__:Boolean = PropertyFactory.create(RectangleComponent, "align", true) ;

	

	// ----o Private  Properties



	private var _w:Number = 0 ;

	private var _h:Number = 0 ;

	private var _align : String = "tl" ;

	private var __max__, __min__ : Object ;



}