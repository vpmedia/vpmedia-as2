class de.popforge.engine.mode7.Vertex
{
	static public var updateTimer: Number = 0;
	
	//-- world coordinate
	public var wx : Number;
	public var wy : Number;
	public var wz : Number;
	
	//-- rotated coordinate
	public var rx : Number;
	public var ry : Number;
	public var rz : Number;

	//-- texture coordinate
	public var u : Number;
	public var v : Number;
	
	//-- screen coordinate
	public var sx: Number;
	public var sy: Number;
	
	public var updateTime: Number;
	
	function Vertex( wx: Number, wy: Number, wz: Number, u: Number, v: Number )
	{
		this.wx = rx = wx;
		this.wy = ry = wy;
		this.wz = rz = wz;
		
		this.u = u;
		this.v = v;
	}
	
	function toString(): String
	{
		return 'Vertex rx:' + ( rx ) + ' ry: ' + ( ry ) + ' rz: ' + ( rz );
	}
}