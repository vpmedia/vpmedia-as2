class de.popforge.engine.w3d.UVCoord
{
	public var v: Number;
	public var u: Number;
	
	public function UVCoord( u: Number, v: Number )
	{
		this.u = u;		this.v = v;
	}
	
	public function toString(): String
	{
		return '[ UVCoord u: ' + u + ' v: ' + v + ' ]';
	}
}