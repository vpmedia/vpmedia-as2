/*
	LICENCE
	
		Easing Equations v2.0
		September 1, 2003
		(c) 2003 Robert Penner, all rights reserved. 
		This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html.
		
*/	

import pegas.transitions.Ease;

class pegas.transitions.easing.Bounce extends Ease 
{

	/*override*/ static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	}
	
	/*override*/ static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number 
	{
		return c - Bounce.easeOut (d-t, 0, c, d) + b;
	}
	
	/*override*/ static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number 
	{
		if (t < d/2) return Bounce.easeIn (t*2, 0, c, d) * .5 + b ;
		else return Bounce.easeOut (t*2-d, 0, c, d) * .5 + c*.5 + b ;
	}
	
}
