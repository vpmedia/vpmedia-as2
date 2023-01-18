class de.popforge.engine.w3d.Vertex
{
	public var wx: Number;	public var wy: Number;	public var wz: Number;
	
	public var mx: Number;
	public var my: Number;
	public var mz: Number;
	
	public var sx: Number;	public var sy: Number;
	
	public function Vertex( x: Number, y: Number, z: Number )
	{
		wx = mx = x;		wy = my = y;		wz = mz = z;
	}
	
	public function toString(): String
	{
		return '[Vertex x: ' + wx + ' y: ' + wy + ' z: ' + wz + ' ]';
	}
}