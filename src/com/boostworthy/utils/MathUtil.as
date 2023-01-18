// =========================================================================================
// Class: MathUtil
// 
// Ryan Taylor
// February 11, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

class com.boostworthy.utils.MathUtil
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// This is a utility class, so the constructor isn't actually used.
	private function MathUtil()
	{
	}
	
	// =====================================================================================
	// MATH FUNCTIONS
	// =====================================================================================
	
	// GetRandomNumber
	// 
	// Generates a random number between the minimum and maximum parameters.
	public static function GetRandomNumber(nMin:Number, nMax:Number):Number
	{
		// Return the random number.
		return Math.round(Math.random() * (nMax - nMin) + nMin);
	}
	
	// GetRandomColor
	// 
	// Generates a random color value.
	public static function GetRandomColor(Void):Number
	{
		// Return the random color value.
		return GetRandomNumber(0, 16777215);
	}
	
	// GetRandomID
	// 
	// Generates a random session ID.
	public static function GetRandomID(Void):Number
	{
		// Return the random ID.
		return Math.floor(Math.random()* 1000000);
	}
	
	// InterpolateRange
	// 
	// Takes a value and a range and outputs the value in the new range.
	public static function InterpolateRange(nValue:Number, nMin:Number, nMax:Number, nMin_New:Number, nMax_New:Number):Number
	{
		// Make sure the value is within the first range.
		if(nValue >= nMin && nValue <= nMax)
		{
			// Return the new value.
			return nMin_New + (((nValue - nMin) / (nMax - nMin)) * (nMax_New - nMin_New));
		}
	}
	
	// IsOdd
	// 
	// Checks the given number to see if it is odd.
	public static function IsOdd(nValue:Number):Boolean
	{
		// Return 'true' if the number is odd.
		return Boolean(nValue % 2);
	}
	
	// IsEven
	// 
	// Checks the given number to see if it is even.
	public static function IsEven(nValue:Number):Boolean
	{
		// Return 'true' if the number is even.
		return (nValue % 2 == 0);
	}
	
	// IsInteger
	// 
	// Checks the given number to see if it is an integer.
	public static function IsInteger(nValue:Number):Boolean
	{
		// Return 'true' if the number is an integer.
		return (nValue % 1 == 0);
	}
	
	// IsFloat
	// 
	// Checks the given number to see if it is a float.
	public static function IsFloat(nValue:Number):Boolean
	{
		// Return 'true' if the number is a float.
		return (nValue % 1 != 0);
	}
	
	// Round
	// 
	// Essentially a glorified version of 'Math.round'. The difference being that
	// there is support for a second parameter which indicates how many decimal points
	// you would like to round the number off to. If the number of decimals specified is
	// greater than the number of decimals the value being rounded has, the value is
	// returned untouched.
	public static function Round(nValue:Number, nDecimals:Number):Number
	{
		// Find our divisor so we can create the proper number of decimals.
		var nDivisor:Number = Math.pow(10, nDecimals);
		
		// Return the number rounded to the given number of decimal points.
		return Math.round(nValue * nDivisor) / nDivisor;
	}
	
	// FindDistance2D
	// 
	// Finds the distance between two points in 2D space.
	public static function FindDistance2D(nX1:Number, nY1:Number, nX2:Number, nY2:Number):Number
	{
		// Declare variable(s).
		var nDistX:Number, nDistY:Number;
		
		// Find the X and Y distances.
		nDistX = nX2 - nX1;
		nDistY = nY2 - nY1;
		
		// Return the distance between the two points.
		return Math.sqrt((nDistX * nDistX) + (nDistY * nDistY));
	}
	
	// FindDistance3D
	// 
	// Finds the distance between two points in 3D space.
	public static function FindDistance3D(nX1:Number, nY1:Number, nZ1:Number, nX2:Number, nY2:Number, nZ2:Number):Number
	{
		// Declare variable(s).
		var nDistX:Number, nDistY:Number, nDistZ:Number;
		
		// Find the X and Y distances.
		nDistX = nX2 - nX1;
		nDistY = nY2 - nY1;
		nDistZ = nZ2 - nZ1;
		
		// Return the distance between the two points.
		return Math.sqrt((nDistX * nDistX) + (nDistY * nDistY) + (nDistZ * nDistZ));
	}
	
	// DegreesToRadians
	// 
	// Converts an angle in degrees to radians.
	public static function DegreesToRadians(nDegrees:Number):Number
	{
		// Return the angle in radians.
		return nDegrees * (Math.PI / 180)
	}
	
	// RadiansToDegrees
	// 
	// Converts an angle in radians to degrees.
	public static function RadiansToDegrees(nRadians:Number):Number
	{
		// Return the angle in degrees.
		return nRadians * (180 / Math.PI);
	}
	
	// StandardizeAngle
	// 
	// Standardizes the given angle in degrees to fit into the 0 to 360 range.
	// For example: StandardizeAngle(450) will return 90. (450 - 360) = 90.
	public static function StandardizeAngle(nDegrees:Number):Number
	{
		// Find the remainder of the angle divied by 360.
		nDegrees %= 360;
		
		// Return the standardized angle.
		return (nDegrees < 0) ? nDegrees + 360 : nDegrees;
	}
	
	// Factorial
	// 
	// The factorial of a positive integer 'nValue' is the product of all positive 
	// integers less than or equal to 'nValue'.
	// For example: Factorial(5) = 1 * 2 * 3 * 4 * 5 = 120.
	public static function Factorial(nValue:Number):Number
	{
		// Starting with the given 'nValue', recursively multiply each lesser
		// value together to find the factorial.
		return nValue ? nValue * Factorial(nValue - 1) : 1;
	}
	
	// Permutations
	// 
	// Finds the number of permutations a sequence can have given the permutation length.
	// A permutation is an ordered sequence containing each element from a set once and only once.
	// For example: Permutations(3, 2) = (a, b), (a, c), (b, a), (b, c), (c, a), (c, b) = 6.
	public static function Permutations(nSequenceLength:Number, nPermutationLength:Number):Number
	{
		// Recursively find each permutation.
		return Factorial(nSequenceLength) / Factorial(nSequenceLength - nPermutationLength);
	}
	
	// Combinations
	// 
	// Finds the number of combinations a sequence can have given the combination length.
	// A combination is essentially the same as a permutation, however order doesn't matter.
	// For example: Combinations(3, 2) = (a, b), (a, c), (b, c) = 3.
	public static function Combinations(nSequenceLength:Number, nCombinationLength:Number):Number
	{
		// Recursively find each combination.
		return Permutations(nSequenceLength, nCombinationLength) / Factorial(nCombinationLength);
	}
}