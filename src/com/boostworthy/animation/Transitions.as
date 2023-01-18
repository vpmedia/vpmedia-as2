// =========================================================================================
// Class: Transitions
// 
// Ryan Taylor
// August 2, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

class com.boostworthy.animation.Transitions
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Transition references.
	public static var LINEAR:String                  = "Linear";
	public static var SINE_IN:String                 = "SineIn";
	public static var SINE_OUT:String                = "SineOut";
	public static var SINE_IN_AND_OUT:String         = "SineInAndOut";
	public static var QUAD_IN:String                 = "QuadIn";
	public static var QUAD_OUT:String                = "QuadOut";
	public static var QUAD_IN_AND_OUT:String         = "QuadInAndOut";
	public static var CUBIC_IN:String                = "CubicIn";
	public static var CUBIC_OUT:String               = "CubicOut";
	public static var CUBIC_IN_AND_OUT:String        = "CubicInAndOut";
	public static var QUART_IN:String                = "QuartIn";
	public static var QUART_OUT:String               = "QuartOut";
	public static var QUART_IN_AND_OUT:String        = "QuartInAndOut";
	public static var QUINT_IN:String                = "QuintIn";
	public static var QUINT_OUT:String               = "QuintOut";
	public static var QUINT_IN_AND_OUT:String        = "QuintInAndOut";
	public static var EXPO_IN:String                 = "ExpoIn";
	public static var EXPO_OUT:String                = "ExpoOut";
	public static var EXPO_IN_AND_OUT:String         = "ExpoInAndOut";
	public static var BOUNCE:String                  = "Bounce";
	public static var ELASTIC_IN:String              = "ElasticIn";
	public static var ELASTIC_OUT:String             = "ElasticOut";
	public static var ELASTIC_IN_AND_OUT:String      = "ElasticInAndOut";
	
	// Default values.
	private static var DEFAULT_TRANSITION:String     = LINEAR;
	private static var DEFAULT_ELASTIC_AMP:Number    = undefined;
	private static var DEFAULT_ELASTIC_PERIOD:Number = 400;
	
	// CLASS MEMBERS ///////////////////////////////////////////////////////////////////////
	
	// Set the amplitude and period of an elastic wave.
	private static var c_nElasticAmplitude:Number    = DEFAULT_ELASTIC_AMP;
	private static var c_nElasticPeriod:Number       = DEFAULT_ELASTIC_PERIOD;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	private function Transitions()
	{
	}
	
	// =====================================================================================
	// TRANSITION FUNCTIONS
	// =====================================================================================
	
	// Easing equation's syntax:
	// 
	// (t:Number, b:Number, c:Number, d:Number)
	// 
	// t -> TIME:      Current time during the tween. 0 to duration.
	// b -> BEGINING:  Starting value of the property being tweened.
	// c -> CHANGE:    Change in the properties value from start to target.
	// d -> DURATION:  Duration of the tween.
	// 
	// Elastic equations use two additional parameters:
	// 
	// c_nElasticAmplitude (Set by 'SetElasticAmplitude') -> The height of the elastic wave divided by two.
	// c_nElasticPeriod    (Set by 'SetElasticPeriod')    -> The time it takes a wave to complete a single cycle.
	
	// Linear
	// 
	// Linear easing equation.
	public static function Linear(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * t / d + b;
	}
	
	// SineIn
	// 
	// Sine in easing equation.
	public static function SineIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		return -c * Math.cos((t / d) * (Math.PI / 2)) + b + c;
	}
	
	// SineOut
	// 
	// Sine out easing equation.
	public static function SineOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * Math.sin((t / d) * (Math.PI / 2)) + b;
	}
	
	// SineInAndOut
	// 
	// Sine in and out easing equation.
	public static function SineInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return -c / 2 * (Math.cos((t / d) * Math.PI) - 1) + b;
	}
	
	// QuadIn
	// 
	// Quad in easing equation.
	public static function QuadIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * (t /= d) * t + b;
	}
	
	// QuadOut
	// 
	// Quad out easing equation.
	public static function QuadOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return -c * (t /= d) * (t - 2) + b;
	}
	
	// QuadInAndOut
	// 
	// Quad in and out easing equation.
	public static function QuadInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		if((t /= d / 2) < 1)
		{
			return c / 2 * t * t + b;
		}
		else
		{
			return -c / 2 * ((--t) * (t - 2) - 1) + b;
		}
	}
	
	// CubicIn
	// 
	// Cubic in easing equation.
	public static function CubicIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * (t /= d) * t * t + b;
	}
	
	// CubicOut
	// 
	// Cubic out easing equation.
	public static function CubicOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * ((t = t / d - 1) * t * t + 1) + b;
	}
	
	// CubicInAndOut
	// 
	// Cubic in and out easing equation.
	public static function CubicInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		if(( t /= d / 2) < 1)
		{
			return c / 2 * t * t * t + b;
		}
		else
		{
			return c / 2 * (( t -= 2) * t * t + 2) + b;
		}
	}
	
	// QuartIn
	// 
	// Quart in easing equation.
	public static function QuartIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * (t /= d) * t * t * t + b;
	}
	
	// QuartOut
	// 
	// Quart out easing equation.
	public static function QuartOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return -c * ((t = t / d - 1) * t * t * t - 1) + b;
	}
	
	// QuartInAndOut
	// 
	// Quart in and out easing equation.
	public static function QuartInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		if((t /= d / 2) < 1)
		{
			return c / 2 * t * t * t * t + b;
		}
		else
		{
			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}
	}
	
	// QuintIn
	// 
	// Quint in easing equation.
	public static function QuintIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * (t /= d) * t * t * t * t + b;
	}
	
	// QuintOut
	// 
	// Quint out easing equation.
	public static function QuintOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
	}
	
	// QuintInAndOut
	// 
	// Quint in and out easing equation.
	public static function QuintInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		if((t /= d / 2) < 1)
		{
			return c / 2 * t * t * t * t * t + b;
		}
		else
		{
			return c / 2 * (( t -= 2) * t * t * t * t + 2) + b;
		}
	}
	
	// ExpoIn
	// 
	// Expo in easing equation.
	public static function ExpoIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
	}
	
	// ExpoOut
	// 
	// Expo out easing equation.
	public static function ExpoOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
	}
	
	// ExpoInAndOut
	// 
	// Expo in and out easing equation.
	public static function ExpoInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		if(t == 0) 
		{
			return b;
		}
		
		if(t == d) 
		{
			return b + c;
		}
		
		if((t /= d / 2) < 1)
		{
			return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
		}
		
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
	}
	
	// Bounce
	// 
	// Bounce easing equation.
	public static function Bounce(t:Number, b:Number, c:Number, d:Number):Number
	{
		if((t /= d) < (1 / 2.75))
		{
			return c * (7.5625 * t * t) + b;
		}
		else if(t < (2 / 2.75))
		{
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
		}
		else if(t < (2.5 / 2.75))
		{
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
		}
		else
		{
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
		}
	}
	
	// ElasticIn
	// 
	// Elastic in easing equation.
	public static function ElasticIn(t:Number, b:Number, c:Number, d:Number):Number
	{
		var a:Number = c_nElasticAmplitude;
		var p:Number = c_nElasticPeriod;
		var s:Number;
		
		if(t == 0)
		{
			return b;
		}
		
		if((t /= d) == 1)
		{
			return b + c; 
		}
		
		if(!p)
		{
			p = d * 0.3;
		}
		
		if(!a || a < Math.abs(c))
		{
			a = c; 
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin (c / a);
		}
		
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
	}
	
	// ElasticOut
	// 
	// Elastic out easing equation.
	public static function ElasticOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		var a:Number = c_nElasticAmplitude;
		var p:Number = c_nElasticPeriod;
		var s:Number;
		
		if(t == 0)
		{
			return b;
		}
		
		if((t /= d) == 1)
		{
			return b + c;
		}
		
		if(!p)
		{
			p = d * 0.3;
		}
		
		if(!a || a < Math.abs(c))
		{
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin (c / a);
		}
		
		return (a * Math.pow(2, -10 * t) * Math.sin( (t * d - s)*(2 * Math.PI) / p) + c + b);
	}
	
	// ElasticInAndOut
	// 
	// Elastic in and out easing equation.
	public static function ElasticInAndOut(t:Number, b:Number, c:Number, d:Number):Number
	{
		var a:Number = c_nElasticAmplitude;
		var p:Number = c_nElasticPeriod;
		var s:Number;
		
		if(t == 0)
		{
			return b; 
		}
		
		if((t /= d / 2) == 2)
		{
			return b + c;
		}
		
		if(!p)
		{
			p = d * (0.3 * 1.5);
		}
		
		if(!a || a < Math.abs(c))
		{ 
			a = c;
			s = p / 4;
		}
		else
		{
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		
		if(t < 1)
		{
			return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t * d - s)*(2 * Math.PI) / p )) + b;
		}
		else
		{
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p ) * 0.5 + c + b;
		}
	}
	
	// =====================================================================================
	// SETTINGS FUNCTIONS
	// =====================================================================================

	// SetElasticAmplitude
	// 
	// Sets the wave amplitude for an elastic transition.
	public static function SetElasticAmplitude(nElasticAmplitude:Number):Void
	{
		// Store the amplitude.
		c_nElasticAmplitude = nElasticAmplitude;
	}
	
	// SetElasticPeriod
	// 
	// Sets the wave period for an elastic transition.
	public static function SetElasticPeriod(nElasticPeriod:Number):Void
	{
		// Store the period.
		c_nElasticPeriod = nElasticPeriod;
	}
}