class de.popforge.engine.mode7.Sprite
{
	public var x: Number;	public var y: Number;	public var z: Number;
	
	public var timeline: MovieClip;
	
	public function Sprite( timeline: MovieClip )
	{
		this.timeline = timeline;
	}
}