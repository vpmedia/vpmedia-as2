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


/* -------- EasyRoundedRectangleComponent



	AUTHOR



		Name : EasyRoundedRectangleComponent

		Package : neo.display.components.shape

		Version : 1.0.0.0

		Date :  2005-02-06

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net



	PROPERTY SUMMARY

	

		- cornerRadius:Number [R/W]

		

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

		

		- getAlign():String (no active)

		

		- getCornerRadius():Number

		

		- getMinMax():Object

		

		- initDraw():Void

		

		- setAlign(str:String):Void (no active)

		

		- setCornerRadius(n:Number):Void



	INHERIT

	

		Object 

			|

			AbstractComponent

				|

				RectangleComponent

					|

					EasyRoundedRectangleComponent





-------- */



import neo.display.components.shape.RectangleComponent;
import neo.util.factory.PropertyFactory;



class neo.display.components.shape.EasyRoundedRectangleComponent extends RectangleComponent {



	// ----o Constructor



	public function EasyRoundedRectangleComponent () {

		super() ;

	}



	// ----o Public Methods

	

	public function draw():Void {

		if (_cornerRadius > 0) {

			initDraw() ;

			_currentRadius  = (_cornerRadius > Math.min (_w, _h) / 2 ) ? Math.min (_w, _h) / 2 : _cornerRadius ;

			moveTo ( __min__.x + _currentRadius, __min__.y);

			lineTo ( __max__.x - _currentRadius , __min__.y) ;

			drawCorner (__max__.x - _currentRadius , __min__.y + _currentRadius) ; // tr

			lineTo ( __max__.x , __max__.y - _currentRadius ) ;

			drawCorner (__max__.x - _currentRadius, __max__.y - _currentRadius) ; // br

			lineTo( __min__.x  + _currentRadius , __max__.y ) ;

			drawCorner (__min__.x + _currentRadius , __max__.y - _currentRadius) ; // tl

			lineTo(__min__.x, __min__.y + _currentRadius) ;

			drawCorner (__min__.x + _currentRadius, __min__.y + _currentRadius) ;

			endFill () ;

			_angle = undefined ;

		} else {

			super.draw () ;

		}

	}



	public function getCornerRadius(Void):Number { 

		return _cornerRadius ;

	}

	

	public function setCornerRadius(n:Number):Void {

		n = (isNaN(n) || n < 0) ? 0 : n ;

		_cornerRadius = n ; 

		update () ;

	}



	// ----o Virtual Properties



	static private var __CORNER_RADIUS__:Boolean = PropertyFactory.create(EasyRoundedRectangleComponent, "cornerRadius", true) ;



	// ----o Private  Properties



	private var _cornerRadius = 15 ;

	private var _theta:Number = Math.PI/4 ;

	private var _currentRadius ; // current corner radius

	private var _angle:Number ;



	// ----o Private Methods



	private function curve ( x:Number , y:Number ):Void {

		var cx, cy, px, py :Number  ;

		_angle = (_angle == undefined) ? (- Math.PI / 2) : (_angle + _theta) ;

		cx =  x + ( Math.cos ( _angle + ( _theta / 2 ) ) * _currentRadius / Math.cos ( _theta / 2 ) );

		cy = y +  ( Math.sin ( _angle + ( _theta / 2 ) ) * _currentRadius / Math.cos( _theta / 2 ) ) ;

		px = x  + ( Math.cos (_angle + _theta) *_currentRadius ) ;

		py = y  + ( Math.sin ( _angle + _theta ) * _currentRadius ) ;

		curveTo (cx, cy, px, py);

	}



	private function drawCorner(x:Number, y:Number):Void { 

		curve (x,y) ; 

		curve (x,y) ;

	}

	

}