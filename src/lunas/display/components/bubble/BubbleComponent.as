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

/** BubbleComponent

	AUTHOR
	
		Name : BubbleComponent
		Package : lunas.display.components.bubble
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net
	
	CONSTANT SUMMARY

		- BOTTOM:Number
		
		- BOTTOM_LEFT:Number
		
		- BOTTOM_RIGHT:Number		
		
		- LEFT:Number
		
		- RIGHT:Number
		
		- TOP:Number
		
		- TOP_LEFT:Number
		
		- TOP_RIGHT:Number

	PROPERTY SUMMARY
	
		- align [R/W] 
		
			a number :
			
				- BubbleComponent.BOTTOM
				- BubbleComponent.BOTTOM_LEFT
				- BubbleComponent.BOTTOM_RIGHT
				- BubbleComponent.LEFT 
				- BubbleComponent.RIGHT
				- BubbleComponent.TOP
				- BubbleComponent.TOP_LEFT
				- BubbleComponent.TOP_RIGHT
			
			a string :
			
				"l" : left
				"r" : right
				"t" : top
				"tl" : topLeft
				"tr" : topRight
				"bl" : bottomLeft
				"br" : bottomRight
		
			renvoi : un nombre
		
		- arrowMargin:Number [R/W]
		
			marge séparant la flèche de la bordure de la bulle en align TL/TR/BR/BL si les coins ne sont pas arrondis.
			
		- arrowHeight:Number [R/W]
		
			hauteur de la flèche
		
		- arrowWidth:Number [R/W]
		
			largeur de la flèche
		
		- cornerRadius:Number [R/W]
		
			défini l'arrondi des coins de la bulle en mode coin arrondi (cornerRadius > 0)		
		
		- fa:Number
		
			fill alpha
		
		- fc:Number
		
			fill color

		- h:Number [R/W]
		
			hauteur en pixel de l'info bulle
		
		- la:Number
		
			line alpha
		
		- lc:Number
		
			line color
		
		- w:Number [R/W]
		
			largeur en pixel de l'info bulle
		
	METHOD SUMMARY
	
		draw()
	
	INHERIT
	
		MovieClip → AbstractComponent → BubbleComponent
	
	TODO : Finaliser la détection des tailles minimales des ArrowMargin etc.. pour éviter d'avoir des bugs.

**/

import lunas.display.components.AbstractComponent;

import pegas.draw.Align;

class lunas.display.components.bubble.BubbleComponent extends AbstractComponent {

	// ----o Constructor

	public function BubbleComponent () {
		update() ;
	}

	// ----o Enumeration
	
	static public var BOTTOM:Number = Align.BOTTOM ;
	static public var BOTTOM_LEFT:Number = Align.BOTTOM | Align.LEFT ;
	static public var BOTTOM_RIGHT:Number = Align.BOTTOM | Align.RIGHT;
	static public var CENTER:Number = Align.CENTER;
	static public var LEFT:Number = Align.LEFT ;
	static public var RIGHT:Number = Align.RIGHT ;
	static public var TOP:Number = Align.TOP ;
	static public var TOP_LEFT:Number = Align.TOP | Align.LEFT ;
	static public var TOP_RIGHT:Number = Align.TOP | Align.RIGHT;

	// ----o Public  Properties

	// public var align:Number ; // [RW]
	// public var arrowHeight:Number ; // [RW]
	// public var arrowMargin:Number ; // [RW]
	// public var arrowWidth:Number ; // [RW]
	public var fa:Number = 100 ;
	public var fc:Number = 0xFFFFFF ;
	public var la:Number = 100 ;
	public var lc:Number = 0xCCCCCC ;
	public var t:Number = 2 ;
	
	// ----o Public Methods
	
	public function draw():Void {
		initDraw() ;
		switch (_align) {
			case Align.LEFT :
				_drawL() ; break ;
			case Align.RIGHT :
				_drawR() ; break ;
			case Align.BOTTOM :
				_drawB() ; break ;
			case Align.BOTTOM | Align.LEFT :
				_drawBL() ; break ;
			case Align.BOTTOM | Align.RIGHT :
				_drawBR() ; break ;
			case Align.TOP : 
				_drawT() ; break ;
			case Align.TOP | Align.RIGHT : 
				_drawTR() ; break ;
			case Align.TOP | Align.LEFT :
			default : 
				_drawTL() ; break ;
		}
	}

	public function getAlign():Number { 
		return _align ;
	}

	public function getMinMax():Object {
		var w1 , w2 , h1, h2 :Number ;
		var m:Number = (_cornerRadius > 0) ? _cornerRadius : _aM ;
		switch (_align) {
			case Align.LEFT :
				w1 = _aH ; h1 = - _h / 2 ;
				break ;
			case Align.RIGHT : 
				w1 = -w - _aH ; h1 = - _h / 2 ;
				break ;
			case Align.TOP :
				w1 = -_w / 2 ; h1 = _aH ;	
				break ;
			case Align.BOTTOM :
				w1 = -_w / 2 ; h1 = -h - _aH ;	
				break ;
			case BOTTOM_LEFT  :
				w1 = - m ; h1 = -h - _aH ;	
				break ;
			case BOTTOM_RIGHT:
				w1 = - _w +  m ; h1 = -h - _aH ;	
				break ;
			case TOP_RIGHT :
				w1 = - _w +  m ; h1 = _aH ;		
				break ;
			default :
			case TOP_LEFT : 
				w1 = - m ; h1 = _aH ;			
				break ;
		}
		w2 = w1 + _w ;
		h2 = h1 + _h ;
		_min = { x : w1 , y : h1 } ;
		_max = { x : w2 , y : h2 } ;
		return { min:_min , max:_max } ;
	}
		
	public function getCornerRadius():Number { 
		return _cornerRadius ;
	}
	
	public function getArrowMargin():Number { 
		return _aM ;
	}
		
	public function getArrowWidth():Number { 
		return _aW ;
	}
	
	public function getArrowHeight():Number { 
		return _aH ;
	}
	
	public function initDraw():Void {
		getMinMax () ;
		clear () ;
		lineStyle(t, lc, la);
		beginFill (fc, fa) ;
	}
	
	public function setAlign( arg ) : Void {
		var p = arguments[0] ;
		if (typeof(p) == "number" ) {
			_align = p ;
			break ;
		} else if (typeof(p) == "string") {
			_align = Align.toNumber(p) ;
		}
		update() ;
	}
	
	public function setArrowHeight(n:Number):Void { 
		_aH = (n>0) ? n : 0 ;
		update() ;
	}

	public function setArrowMargin(n:Number):Void { 
		_aM = (n>0) ? n : 0 ;
		update() ;
	}
	
	public function setArrowWidth(n:Number):Void { 
		_aW = (n>0) ? n : 0 ;
		update() ;
	}

	public function setCornerRadius(n:Number):Void {
		_cornerRadius = (isNaN(n) || n < 0) ? 0 : n ; 
		update() ;
	}

	// ----o Virtual Properties

	public function get align():Number {
		return getAlign() ;	
	}
	
	public function set align(nAlign:Number):Void {
		setAlign(nAlign) ;	
	}

	public function get arrowHeight():Number {
		return getArrowHeight() ;	
	}
	
	public function set arrowHeight(n:Number):Void {
		setArrowHeight(n) ;	
	}

	public function get arrowMargin():Number {
		return getArrowMargin() ;	
	}
	
	public function set arrowMargin(n:Number):Void {
		setArrowMargin(n) ;	
	}	

	public function get arrowWidth():Number {
		return getArrowWidth() ;	
	}
	
	public function set arrowWidth(n:Number):Void {
		setArrowWidth(n) ;	
	}	

	public function get cornerRadius():Number {
		return getCornerRadius() ;	
	}
	
	public function set cornerRadius(n:Number):Void {
		setCornerRadius(n) ;	
	}	

	// ----o Private  Properties

	private var _align:Number = Align.TOP | Align.LEFT ;
	private var _angle:Number ;
	private var _cornerRadius = 0 ; // 0 par défaut
	private var _c ; // current corner radius
	private var _max, _min:Object ;
	private var _w:Number = 200 ;
	private var _h:Number = 60 ;
	private var _theta:Number = Math.PI/4 ;
	
	private var _aM:Number = 20 ; // arrow margin
	private var _aW:Number = 10 ; // arrow width
	private var _aH:Number = 20 ; // arrow height
	
	// ----o Private Methods
	
	public function curve ( x , y ) {
		var cx, cy, px, py :Number  ;
		_angle = (_angle == null) ? (- Math.PI / 2) : (_angle + _theta) ;
		cx =  x + ( Math.cos ( _angle + ( _theta / 2 ) ) * _c / Math.cos ( _theta / 2 ) );
		cy = y +  ( Math.sin ( _angle + ( _theta / 2 ) ) * _c / Math.cos( _theta / 2 ) ) ;
		px = x  + ( Math.cos (_angle + _theta) * _c ) ;
		py = y  + ( Math.sin ( _angle + _theta ) * _c ) ;
		curveTo (cx, cy, px, py);
	}

	private function drawCorner(x, y) { 
		curve (x,y) ; 
		curve (x,y) ;
	}

	private function _drawL():Void {
		var hM:Number = _h / 2 ;
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _c ) ;
			lineTo(0,0) ;
			lineTo(_min.x, _max.y - hM  ) ;
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;
			lineTo (_max.x, _min.y);
			lineTo (_max.x, _max.y);
			lineTo (_min.x, _max.y);
			lineTo(_min.x, _max.y - hM + (_aH / 2) ) ;
			lineTo(0,0) ;
			lineTo(_min.x, _max.y - hM  ) ;
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}

	private function _drawR():Void {
		var hM:Number = _h / 2 ;
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo(_max.x, _max.y - hM ) ;
			lineTo(0,0) ;
			lineTo(_max.x, _c ) ;
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;
			lineTo (_max.x, _min.y);
			lineTo(_max.x, _max.y - hM ) ;
			lineTo(0,0) ;
			lineTo(_max.x, _max.y - hM + (_aH / 2) ) ;
			lineTo (_max.x, _max.y) ;
			lineTo (_min.x, _max.y) ;
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}

	private function _drawT():Void {
		var wM:Number = _w / 2 ;
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			lineTo (_min.x + wM , _min.y) ;
			lineTo(0,0) ;
			lineTo (_min.x + wM + _aW, _min.y) ;
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;
			lineTo (_min.x + wM , _min.y) ;
			lineTo(0,0) ;
			lineTo (_min.x + wM + _aW, _min.y) ;
			lineTo (_max.x, _min.y) ;
			lineTo (_max.x, _max.y) ;
			lineTo (_min.x, _max.y) ;
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}
	
	private function _drawB():Void {
		var wM:Number = _w / 2 ;
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo (_min.x + wM + _aW, _max.y) ;
			lineTo(0,0) ;
			lineTo (_min.x + wM , _max.y) ;
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;
			lineTo (_max.x, _min.y);
			lineTo (_max.x, _max.y);
			lineTo (_max.x - wM + _aW, _max.y) ;
			lineTo(0,0) ;
			lineTo (_max.x - wM , _max.y) ;
			lineTo (_min.x, _max.y);
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}

	private function _drawBL():Void {
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo (_min.x + _c + _aW, _max.y) ;
			lineTo(0,0) ;
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo(_min.x , _min.y) ;
			lineTo(_max.x, _min.y);
			lineTo(_max.x, _max.y);
			lineTo(_min.x + _aM + _aW, _max.y) ;
			lineTo(0,0) ;
			lineTo(_min.x + _aM , _max.y) ;
			lineTo(_min.x, _max.y);
			lineTo(_min.x, _min.y) ;
		}
		endFill() ;
	}
	
	private function _drawBR():Void {
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo(0,0) ;
			lineTo (_max.x - _c - _aW, _max.y) ;
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;				
			lineTo (_max.x, _min.y);
			lineTo (_max.x, _max.y);
			lineTo (_max.x - _aM , _max.y) ;
			lineTo(0,0) ;
			lineTo (_max.x - _aM - _aW, _max.y) ;
			lineTo (_min.x, _max.y) ;
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}	

	private function _drawTL():Void {
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			// ----- arrow
			lineTo(0,0) ;
			lineTo (_min.x + _c + _aW, _min.y) ;
			// -----
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;
			lineTo (_min.x + _aM, _min.y) ;
			lineTo(0,0) ;
			lineTo (_min.x + _aM + _aW, _min.y) ;
			lineTo (_max.x, _min.y) ;
			lineTo (_max.x, _max.y) ;
			lineTo (_min.x, _max.y) ;
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}

	private function _drawTR():Void {
		if (_cornerRadius > 0) {
			_angle = null ;
			var nC:Number = _cornerRadius ;
			_c = ( nC > Math.min (_w, _h) / 2 ) ? Math.max (_w, _h) / 2 : _cornerRadius ;
			moveTo( _min.x + _c, _min.y) ;
			// ---- Arrow
			lineTo (_max.x - _c - _aW, _min.y) ;
			lineTo(0,0) ;
			// ----
			lineTo( _max.x - _c , _min.y) ;
			drawCorner (_max.x - _c , _min.y + _c) ; // TR
			lineTo ( _max.x , _max.y - _c ) ;
			drawCorner (_max.x - _c, _max.y - _c) ; // BR
			lineTo( _min.x  + _c , _max.y ) ;
			drawCorner (_min.x + _c , _max.y - _c) ; // BL
			lineTo(_min.x, _min.y + _c) ;
			drawCorner(_min.x + _c, _min.y + _c) ; // TL
		} else {
			moveTo( _min.x , _min.y) ;
			lineTo (_max.x - _aM - _aW , _min.y) ;
			lineTo(0,0) ;
			lineTo (_max.x - _aM, _min.y) ;
			lineTo (_max.x, _min.y) ;
			lineTo (_max.x, _max.y) ;
			lineTo (_min.x, _max.y) ;
			lineTo (_min.x, _min.y) ;
		}
		endFill() ;
	}


}