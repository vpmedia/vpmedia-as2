/*
	LICENCE
	
		Easing Equations v2.0
		September 1, 2003
		(c) 2003 Robert Penner, all rights reserved. 
		This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html.
		
*/	


import pegas.transitions.Ease;

class pegas.transitions.easing.Circ extends Ease 
{

	/*override*/ static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	}
	
	/*override*/ static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	}
	
	/*override*/ static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	}
	
}
