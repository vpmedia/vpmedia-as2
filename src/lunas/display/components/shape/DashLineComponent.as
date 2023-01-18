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

/** DashLine

	AUTHOR
	
		Name : DashLine
		Package : lunas.display.components.shape
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net
	
	PROPERTY SUMMARY
	
		- alpha:Number [R/W]
		
		- color:Number [R/W]
		
		- end:Object [R/W]
		
		- length:Number [R/W]
		
			longueur d'un hachurage
			
		- start:Object [R/W]
		
		- spacing:Number [R/W]
		
			espace entre 2 hachurage.
		
		- thickness [R/W]

	METHOD SUMMARY

		- draw():Void
		
		- getAlpha():Number
		
		- getColor():Number
		
		- getEnd():Point
		
		- getLength():Number
		
		- getStart():Point
		
		- getSpacing():Number
		
		- getThickness():Number
		
		- setAlpha(n:Number):Void
		
		- setColor(n:Number):Void
		
		- setEnd(p:Object):Void
		
		- setLength(n:Number):Void
		
		- setStart(p:Object):Void
		
		- setSpacing(n:Number):Void
		
		- setThickness(n:Number):Void
	
	INHERIT
	
		AbstractComponent
			|
			LineComponent
				|
				DashLineComponent


**/

import lunas.display.components.shape.LineComponent;

class lunas.display.components.shape.DashLineComponent extends LineComponent {
	
	// ----o Constructor

	public function DashLineComponent () { 
		update() ;
	}
	
	// ----o Public Methods
	
	public function draw():Void {
		var segl:Number = _length + _spacing ;
		var dx:Number = _end.x - _start.x ;
		var dy:Number = _end.y - _start.y ;
		var delta = Math.sqrt((dx * dx) + (dy * dy));
		var nbSegs:Number = Math.floor(Math.abs(delta / segl)) ;
		__radians = Math.atan2 ( dy, dx ) ;
		__x = _start.x;
		__y = _start.y;
		dx = Math.cos(__radians)* segl ;
		dy = Math.sin(__radians)* segl ;
		clear () ;
		lineStyle (t, lc, la) ;
		for (var i:Number = 0; i < nbSegs; i++) {
			moveTo( __x, __y ) ;
			_lineRadiansTo ( _length ) ;
			__x += dx ;
			__y += dy ;
		}
		moveTo(__x, __y) ; 
		delta = Math.sqrt((_end.x - __x)*(_end.x - __x)+ (_end.y - __y)* (_end.y - __y)) ;
		if(delta>_length) _lineRadiansTo ( _length ) ;
		else if (delta > 0) _lineRadiansTo ( delta ) ;
		moveTo(_end.x,_end.y);
	}
	
	public function getLength():Number { 
		return _length ;
	}
	
	public function getSpacing():Number { 
		return _spacing ;
	}
	
	public function setLength(n:Number):Void { 
		n = Math.round ( Math.abs (n) ) ;
		_length = (n > 0) ? n : 0 ;
		update() ;
	}
	
	public function setSpacing(n:Number):Void { 
		n = Math.round ( Math.abs (n) ) ;
		_spacing = (n > 0) ? n : 0 ;
		update() ;
	}

	// ----o Virtual Properties

	public function get length():Number {
		return getLength() ;	
	}
	
	public function set length(n:Number):Void {
		setLength(n) ;	
	}

	public function get spacing():Number {
		return getSpacing() ;	
	}
	
	public function set spacing(n:Number):Void {
		setSpacing(n) ;	
	}
	

	// ----o Private  Properties

	private var _length:Number = 2 ;
	private var __radians:Number ;
	private var _spacing:Number = 2 ;
	private var __x:Number ;
	private var __y:Number ;

	// ----o Private Methods
	
	private function _lineRadiansTo ( n:Number ) : Void {
		lineTo ( __x + Math.cos(__radians) * n ,  __y + Math.sin(__radians) * n ) ;
	}
	
}