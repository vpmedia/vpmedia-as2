// =========================================================================================
// Interface: Iterator_I
// 
// Ryan Taylor
// January 4, 2007
// http://www.boostworthy.com
// 
// Interface for all iterator data types.
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

interface com.boostworthy.collections.iterators.Iterator_I
{
	// =====================================================================================
	// INTERFACE DECLERATIONS
	// =====================================================================================
	
	public function HasNext():Boolean;
	public function Next():Object;
	public function Reset():Void;
}