import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.Renderer;
import de.popforge.engine.w3d.TriPoly;
import de.popforge.engine.w3d.Vertex;

import flash.geom.Matrix;

class de.popforge.engine.w3d.ZShader
implements Renderer
{
	private var g: MovieClip;
	private var matrix: Matrix;
	
	public function ZShader( clip: MovieClip )
	{
		g = clip;
		
		matrix = new Matrix();
	}
	
	public function dispose(): Void
	{
		delete g;		delete matrix;
	}
	
	public function clear(): Void
	{
		g.clear();
	}

	public function renderTriPoly( triPoly: TriPoly, p: Projection ): Void
	{
		var vert: Array = triPoly.vertices;
		
		var v0: Vertex = vert[0];
		var v1: Vertex = vert[1];
		var v2: Vertex = vert[2];
		
		//-- local
		var x0: Number = v0.sx;		var y0: Number = v0.sy;
		var x1: Number = v1.sx;
		var y1: Number = v1.sy;
		var x2: Number = v2.sx;
		var y2: Number = v2.sy;
		
		if( !triPoly.force2Sides )
		{
			if( ( x2 - x0 ) * ( y1 - y0 ) - ( y2 - y0 ) * ( x1 - x0 ) < 0 ) return;
		}
		
		//-- get zSort
		var zIndices: Array = vert.sortOn( "mz", Array.NUMERIC | Array.RETURNINDEXEDARRAY );
		
		v0 = vert[zIndices[0]];
		v1 = vert[zIndices[1]];
		v2 = vert[zIndices[2]];
		
		var zM: Number = p.zMin;
		
		if( v0.mz < zM || v2.mz > p.zMax )
		{
			trace( "out of zRange" );
			return;
		}
		
		//-- apply new sequence values
		x0 = v0.sx;
		y0 = v0.sy;
		x1 = v1.sx;
		y1 = v1.sy;
		x2 = v2.sx;
		y2 = v2.sy;
		
		//-- get projected normal
		var normal: Vertex = triPoly.normal;
		
		var nx: Number = normal.sx;		var ny: Number = normal.sy;
		
		//-- compute gray values
		var zR: Number = p.zRange;
		
		var g0: Number = 0xff - ( v0.mz - zM ) / zR * 0xff;
		var g1: Number = 0xff - ( v2.mz - zM ) / zR * 0xff;
		
		//-- compute gradient matrix
		var dx20: Number = x2 - x0;
		var dy20: Number = y2 - y0;
		
		var zLen: Number = nx * dx20 + ny * dy20;
		var zLen2: Number = zLen * 2;
		
		matrix.createGradientBox( zLen2, zLen2, Math.atan2( ny, nx ), x0 - zLen, y0 - zLen );

		//-- draw gradient
		g.beginGradientFill( "linear", [ ( g0 << 16 ) | ( g0 << 8 ) | g0, ( g1 << 16 ) | ( g1 << 8 ) | g1 ], [ 100, 100 ], [ 128, 0xff ], matrix );
		g.moveTo( x0, y0 );
		g.lineTo( x1, y1 );
		g.lineTo( x2, y2 );
		g.endFill();
	}
}

















