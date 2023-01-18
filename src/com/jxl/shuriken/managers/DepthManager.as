class com.jxl.shuriken.managers.DepthManager
{
	
	// Anything above this depth is reserved
	// for the Flash Player and cannot be removed.
	// You could swapDepths to a lower depth,
	// and then use removeMovieClip if needed,
	// but this is not recommended.
	public static var DEPTH_HIGHEST:Number 		= 1048575;
	public static var DEPTH_LOWEST:Number 		= -16383;
	
	public static var DEPTH_CURSOR:Number 		= 1000000;
	public static var DEPTH_TOOLTIP:Number 		= 900000;
	
}