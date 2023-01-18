import de.popforge.engine.w3d.Matrix4x3;
import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.TriMesh;
import de.popforge.engine.w3d.Vertex;

import flash.display.BitmapData;

class de.popforge.engine.w3d.TriPoly
{
	public var vertices: Array;
	public var uv_map: Array;
	public var color: Number;
	public var texture: BitmapData;
	public var normal: Vertex;
	
	public var force2Sides: Boolean;
	
	private var triMesh: TriMesh;
	
	public function TriPoly( triMesh: TriMesh )
	{
		this.triMesh = triMesh;
		
		vertices = new Array;
		uv_map = new Array;
		
		force2Sides = false;
	}
	
	public function updateNormal(): Void
	{
		var v0: Vertex = vertices[0];
		var v1: Vertex = vertices[1];
		var v2: Vertex = vertices[2];
		
		var ax: Number = v1.wx - v0.wx;
		var ay: Number = v1.wy - v0.wy;
		var az: Number = v1.wz - v0.wz;
		
		var bx: Number = v2.wx - v0.wx;
		var by: Number = v2.wy - v0.wy;
		var bz: Number = v2.wz - v0.wz;
		
		var nx: Number = ay * bz - az * by;
		var ny: Number = az * bx - ax * bz;
		var nz: Number = ax * by - ay * bx;
		
		var nl: Number = Math.sqrt( nx * nx + ny * ny + nz * nz );
		
		normal = new Vertex( nx/nl, ny/nl, nz/nl );
	}
	
	public function project( p: Projection ): Void
	{
		var vertex: Vertex;
		var m: Matrix4x3 = triMesh.matrix;
		var i: Number = vertices.length;
		var r: Number;
		
		var cx: Number = p.center_x;		var cy: Number = p.center_y;
		var focus: Number = p.focus;
		
		while( --i > -1 )
		{
			vertex = vertices[i];
			
			m.transformVertex( vertex );
			
			r = focus / vertex.mz;
			
			vertex.sx = vertex.mx * r + cx;			vertex.sy = vertex.my * r + cy;
		}
		
		m.transformNormal( normal );
		
		r = p.focus / normal.mz;
		
		var nx: Number = normal.mx * r;		var ny: Number = normal.my * r;
		
		var nl: Number = Math.sqrt( nx * nx + ny * ny );
		
		nx /= nl;
		ny /= nl;
		
		normal.sx = nx;
		normal.sy = ny;
	}
}