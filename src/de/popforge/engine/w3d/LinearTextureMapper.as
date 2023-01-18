import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.Renderer;
import de.popforge.engine.w3d.TriPoly;
import de.popforge.engine.w3d.UVCoord;
import de.popforge.engine.w3d.Vertex;

import flash.display.BitmapData;
import flash.geom.Matrix;

class de.popforge.engine.w3d.LinearTextureMapper
	implements Renderer
{
	private var g: MovieClip;
	
	private var tMat: Matrix;	private var sMat: Matrix;
	
	public function LinearTextureMapper( clip: MovieClip )
	{
		g = clip;
		
		tMat = new Matrix();		sMat = new Matrix();
	}
	
	public function clear(): Void
	{
		g.clear();
	}
	
	public function dispose(): Void
	{
		delete g;		delete tMat;		delete sMat;
	}
	
	public function renderTriPoly( triPoly: TriPoly, p: Projection ): Void
	{
		var vertices: Array = triPoly.vertices;
		
		var vt0: Vertex = vertices[0];
		var vt1: Vertex = vertices[1];
		var vt2: Vertex = vertices[2];
		
		var x0: Number = vt0.sx;
		var y0: Number = vt0.sy;
		var x1: Number = vt1.sx;
		var y1: Number = vt1.sy;
		var x2: Number = vt2.sx;
		var y2: Number = vt2.sy;
		
		if( !triPoly.force2Sides )
		{
			if( ( x2 - x0 ) * ( y1 - y0 ) - ( y2 - y0 ) * ( x1 - x0 ) < 0 ) return;
		}
		
		var texture: BitmapData = triPoly.texture;
		
		var w: Number = texture.width;
		var h: Number = texture.height;
		
		var uv_map: Array = triPoly.uv_map;
		
		var uv0: UVCoord = uv_map[0];		var uv1: UVCoord = uv_map[1];		var uv2: UVCoord = uv_map[2];
		
		var u0: Number = uv0.u * w;		var v0: Number = uv0.v * h;
		var u1: Number = uv1.u * w;
		var v1: Number = uv1.v * h;
		var u2: Number = uv2.u * w;
		var v2: Number = uv2.v * h;

		tMat.tx = u0;
		tMat.ty = v0;

		tMat.a = ( u1 - u0 ) / w;
		tMat.b = ( v1 - v0 ) / w;
		tMat.c = ( u2 - u0 ) / h;
		tMat.d = ( v2 - v0 ) / h;

		sMat.a = ( x1 - x0 ) / w;
		sMat.b = ( y1 - y0 ) / w;
		sMat.c = ( x2 - x0 ) / h;
		sMat.d = ( y2 - y0 ) / h;

		sMat.tx = x0;
		sMat.ty = y0;

		tMat.invert();
		tMat.concat( sMat );
		
		g.beginBitmapFill( texture, tMat, false, false );
		g.moveTo( x0, y0 );
		g.lineTo( x1, y1 );
		g.lineTo( x2, y2 );
		g.endFill();
	}
}