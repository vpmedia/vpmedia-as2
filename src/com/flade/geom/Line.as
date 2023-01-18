import com.flade.geom.Vector;

/**
 * 
 * 	@author 	Alec Cove
 *	@author	Younes benaomar http://locobrain.com
 *	@history  2005/7/28   Rewrote for AS 2.0
 *
 */
class com.flade.geom.Line
{
	public var p1:Vector;
	public var p2:Vector;
	
	public function Line(p1:Vector, p2:Vector) 
	{
		this.p1 = p1;
		this.p2 = p2;
	}
}