/*
* creates unique targetClips for GSound Instances
* and GSoundGroups
*/

class org.audiopackage.util.ClipSupplier
{
	static private var timeline: MovieClip;
	static private var num: Number = 0;
	
	static function initialize( timeline: MovieClip ): Void
	{
		ClipSupplier.timeline = timeline;
	}
	
	static function getTargetClip(): MovieClip
	{
		return timeline.createEmptyMovieClip( num.toString() , num++ );
	}
}