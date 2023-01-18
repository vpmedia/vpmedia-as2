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

/** RoundedRectangleComponent

	AUTHOR

		Name : RoundedRectangleComponent
		Package : lunas.display.components.shape
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	PROPERTY SUMMARY
	
		- corner:Object [R/W]
		
		- cornerRadius:Number [R/W]
		
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
		
		- getCornerRadius():Number
		
		- getHBevel():Number
		
		- getMinMax():Object
		
		- getVBevel():Number
		
		- initDraw():Void
		
		- setAlign(str:String):Void
		
		- setCorner(obj:Object):Void
		
		- setCornerRadius(n:Number):Void
		
	INHERIT
	
		AbstractComponent
			|
			RectangleComponent
				|
				CornerRectangleComponent
					|
					RoundedRectangleComponent

------------------- */

import lunas.display.components.shape.CornerRectangleComponent;

class lunas.display.components.shape.RoundedRectangleComponent extends CornerRectangleComponent {

	// ----o Constructor

	public function RoundedRectangleComponent () {
		super() ;
	}

	// ----o Public Methods
	
	public function draw():Void {
		if (_cornerRadius > 0) {
			initDraw() ;
			_currentRadius  = (_cornerRadius > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( __min__.x + _currentRadius, __min__.y);
			lineTo( __max__.x - _currentRadius , __min__.y) ;
			if (_tr) {
				drawCorner (__max__.x - _currentRadius , __min__.y + _currentRadius) ;
			} else {
				lineTo( __max__.x , __min__.y ) ;
				lineTo(__max__.x , __min__.y + _currentRadius) ;
				simulateCorner () ;
			}
			lineTo ( __max__.x , __max__.y - _currentRadius ) ;
			if (_br) {
				drawCorner (__max__.x - _currentRadius, __max__.y - _currentRadius) ;
			} else {
				lineTo ( __max__.x , __max__.y ) ;
				lineTo (__max__.x - _currentRadius , __max__.y ) ;
				simulateCorner () ;	
			}
			lineTo( __min__.x  + _currentRadius , __max__.y ) ;
			if (_bl) {
				drawCorner (__min__.x + _currentRadius , __max__.y - _currentRadius) ;
			} else {
				lineTo( __min__.x , __max__.y ) ;
				lineTo(__min__.x  , __max__.y - _currentRadius ) ;
				simulateCorner () ;	
			}
			lineTo(__min__.x, __min__.y + _currentRadius) ;
			if (_tl) {
				drawCorner(__min__.x + _currentRadius, __min__.y + _currentRadius) ;
			} else {
				lineTo( __min__.x , __min__.y ) ;
			}
			endFill () ;
			_angle = undefined ;
		} else {
			super.draw () ;
		}
	}

	public function curve(x:Number , y:Number ):Void {
		var cx, cy, px, py :Number  ;
		_angle = (_angle == undefined) ? (- Math.PI / 2) : (_angle + _theta) ;
		cx =  x + ( Math.cos ( _angle + ( _theta / 2 ) ) * _currentRadius / Math.cos ( _theta / 2 ) );
		cy = y +  ( Math.sin ( _angle + ( _theta / 2 ) ) * _currentRadius / Math.cos( _theta / 2 ) ) ;
		px = x  + ( Math.cos (_angle + _theta) * _currentRadius ) ;
		py = y  + ( Math.sin ( _angle + _theta ) * _currentRadius ) ;
		curveTo (cx, cy, px, py);
	}

	public function drawCorner (x:Number, y:Number) { 
		curve (x,y) ; 
		curve (x,y) ;
	}

	public function getCornerRadius():Number { 
		return _cornerRadius ;
	}
	
	public function setCornerRadius(n:Number):Void {
		n = (isNaN(n) || n < 0) ? 0 : n ;
		_cornerRadius = n ; 
		update() ;
	}

	public function simulateCorner () {
		_angle = ((_angle == undefined) ? (- Math.PI / 2) : (_angle + _theta)) + _theta ;
	}

	// ----o Virtual Properties

	public function get cornerRadius():Number {
		return getCornerRadius() ;
	}
	
	public function set cornerRadius(n:Number):Void {
		setCornerRadius(n) ;	
	}

	// ----o Private  Properties

	private var _angle:Number ;
	private var _cornerRadius = 15 ; // 15 par défaut
	private var _theta:Number = Math.PI/4 ;
	private var _currentRadius ; // current corner radius


}