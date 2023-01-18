import de.popforge.engine.w3d.Matrix4x3;
import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.TriPoly;

class de.popforge.engine.w3d.TriMesh
{
	public var onLoad: Function;
	
	public var triPolies: Array;
	public var matrix: Matrix4x3;
	
	public function TriMesh()
	{
		triPolies = new Array;
		
		matrix = new Matrix4x3();
	}
	
	public function force2Sides( force2Sides: Boolean ): Void
	{
		var i: Number = triPolies.length;
		
		while( --i > -1 )
		{
			triPolies[i].force2Sides = force2Sides;
		}
	}
}