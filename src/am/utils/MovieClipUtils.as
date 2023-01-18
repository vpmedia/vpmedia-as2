class am.utils.MovieClipUtils
{
	static function makeDragAble(): Void
	{
		for ( var i in arguments )
		{
			var mc: MovieClip = arguments[i];
			mc.onPress = mc.startDrag;
			mc.onRelease = mc.onReleaseOutside = mc.stopDrag;
		}
	}
}