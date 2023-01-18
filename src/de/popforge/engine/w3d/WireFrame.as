import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.Renderer;
import de.popforge.engine.w3d.TriPoly;
import de.popforge.engine.w3d.Vertex;

class de.popforge.engine.w3d.WireFrame
implements Renderer
{
	private var g: MovieClip;
	
	public function WireFrame( g: MovieClip )
	{
		this.g = g;
	}
	
	public function clear(): Void
	{
		g.clear();
	}
	
	public function dispose(): Void
	{
		delete g;
	}

	public function renderTriPoly( triPoly: TriPoly, p: Projection ): Void
	{
		var vert: Array = triPoly.vertices;
		
		var v0: Vertex = vert[0];		var v1: Vertex = vert[1];		var v2: Vertex = vert[2];
		
		var x0: Number = v0.sx;
		var y0: Number = v0.sy;
		var x1: Number = v1.sx;
		var y1: Number = v1.sy;
		var x2: Number = v2.sx;
		var y2: Number = v2.sy;
		
		if( !triPoly.force2Sides )
		{
			if( ( x2 - x0 ) * ( y1 - y0 ) - ( y2 - y0 ) * ( x1 - x0 ) < 0 ) return;
		}
		
		//-- get projected normal
		var normal: Vertex = triPoly.normal;
		
		var nx: Number = normal.sx;
		var ny: Number = normal.sy;
		
		g.lineStyle( 0, 0xcccccc );
		g.moveTo( x0, y0 );		g.lineTo( x1, y1 );		g.lineTo( x2, y2 );
		g.lineTo( x0, y0 );
		var cx: Number = ( x0 + x1 + x2 ) / 3;		var cy: Number = ( y0 + y1 + y2 ) / 3;
		
		g.lineStyle( 0, 0xff0000 );
		g.moveTo( cx, cy );		g.lineTo( cx + nx * 4, cy + ny * 4 );
	}
}












