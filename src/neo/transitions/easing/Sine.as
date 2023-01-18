/* ---------- Sine

	AUTHOR

		Name : Sine
		Package : neo.transitions.easing
		Author : RobertPenner

	LICENCE
	
		Easing Equations v2.0
		September 1, 2003
		(c) 2003 Robert Penner, all rights reserved. 
		This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html.
		
----------  */	

import neo.transitions.Ease;

class neo.transitions.easing.Sine extends Ease {

	// ----o Static Methods

	/*override*/ static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	}
	
	/*override*/ static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	}
	
	/*override*/ static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	}
	
}
