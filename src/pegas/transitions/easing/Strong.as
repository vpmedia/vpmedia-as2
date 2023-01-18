/*
	LICENCE
	
		Easing Equations v2.0
		September 1, 2003
		(c) 2003 Robert Penner, all rights reserved. 
		This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html.
		
*/

import pegas.transitions.Ease;

class pegas.transitions.easing.Strong extends Ease 
{

	/*override*/ static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return c*(t/=d)*t*t*t*t + b;
	}
	
	/*override*/ static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	}
	
	/*override*/ static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	}
	
	
}
