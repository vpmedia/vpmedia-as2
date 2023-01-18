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

/** LineComponent

	AUTHOR
	
		Name : LineComponent
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
		
		- start:Object [R/W]
		
		- thickness [R/W]

	METHOD SUMMARY

		- draw():Void
		
		- getAlpha():Number
		
		- getColor():Number
		
		- getEnd():Point
		
		- getStart():Point
		
		- getThickness():Number
		
		- setAlpha(n:Number):Void
		
		- setColor(n:Number):Void
		
		- setEnd(p:Object):Void
		
		- setStart(p:Object):Void
		
		- setThickness(n:Number):Void
	
	INHERIT
	
		AbstractComponent
			|
			LineComponent

------------------------- */


import lunas.display.components.AbstractComponent;

import pegas.geom.Point;

class lunas.display.components.shape.LineComponent extends AbstractComponent {
	
	// ----o Constructor

	public function LineComponent () { 
		_end = new Point(0,0);
		_start = new Point(0,0);
		update () ;
	}

	// ----o Public Methods

	public function draw():Void {
		clear () ;
		lineStyle (t, lc, la) ;
		moveTo( _start.x, _start.y ) ;
		lineTo (_end.x, _end.y) ;
	}

	public function getAlpha():Number { 
		return la ;
	}

	public function getColor():Number { 
		return lc ;
	}

	public function getEnd():Point { 
		return _end ;
	}

	public function getStart():Point { 
		return _start ;
	}

	public function getThickness():Number { 
		return t ;
	}

	public function setAlpha(n:Number):Void { 
		la = n || 0 ; 
		update() ;
	}
	
	public function setColor(n:Number):Void { 
		lc = isNaN(n) ? 0 : n ; 
		update() ;
	}
	
	public function setEnd(p):Void { 
		_end.x = isNaN(p.x) ? 0 : p.x ;
		_end.y = isNaN(p.y) ? 0 : p.y ;
		update() ;
	}

	public function setStart(p):Void { 
		_start.x = isNaN(p.x) ? 0 : p.x ;
		_start.y = isNaN(p.y) ? 0 : p.y ;
		update() ;
	}

	public function setThickness(n:Number):Void { 
		t = isNaN(n) ? 0 : n ; 
		update() ;
	}

	// ----o Virtual Properties

	public function get alpha():Number {
		return getAlpha() ;	
	}
	
	public function set alpha(n:Number):Void {
		setAlpha(n) ;	
	}
	
	public function get color():Number {
		return getColor() ;	
	}
	
	public function set color(n:Number):Void {
		setColor(n) ;	
	}

	public function get end():Point {
		return getEnd() ;	
	}
	
	public function set end(p:Point):Void {
		setEnd(p) ;	
	}

	public function get start():Point {
		return getStart() ;	
	}
	
	public function set start(p:Point):Void {
		setStart(p) ;	
	}

	public function get thickness():Number {
		return getThickness() ;	
	}
	
	public function set thickness(n:Number):Void {
		setThickness(n) ;	
	}

	// ----o Private  Properties

	private var _end:Point ;
	public var la : Number = 100 ;
	public var lc : Number = 0x000000 ;
	public var t : Number = 1 ;
	private var _start:Point ;

}