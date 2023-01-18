class eu.orangeflash.lib.managers.Depth 
{
	/**
	 * [static] Method, brings MovieClip, Button or Text field to fron
	 *
	 * @param	target	Reference to movie clip
	 * @param	swap	Boolean, if true target will be swaped with front display item otherwise it will appear on top
	 * @return			Nothing
	 */
	public static function bringToFront(target:MovieClip, swap:Boolean):Void 
	{
		trace("a");
		var depth:Number = target.getDepth();

		for (var mc in target._parent) 
		{
			var movie:MovieClip = target._parent[mc];
			if (movie instanceof MovieClip ||
				movie instanceof TextFiled ||
				movie instanceof Button) 
			{
				depth = Math.max(depth, movie.getDepth());
				trace(movie+":"+depth);
			}
		}
		if (!swap)
		{
			depth++;
		}
		target.swapDepths(depth);
	}
}
