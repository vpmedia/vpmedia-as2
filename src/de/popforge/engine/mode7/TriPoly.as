import de.popforge.engine.mode7.Vertex;

import flash.display.BitmapData;
import flash.geom.Matrix;

/**
 * @author Andre Michelle
 */
class de.popforge.engine.mode7.TriPoly
{
	public var w_vert: Array;
	public var texture: BitmapData;
	
	private var sMat: Matrix;
	private var tMat: Matrix;
	
	public function TriPoly( w_vert: Array, texture: BitmapData )
	{
		this.w_vert = w_vert;
		this.texture = texture;
		
		sMat = new Matrix();
		tMat = new Matrix();
	}
	
	public function paint( g: MovieClip ): Void
	{
		var vt0: Vertex = w_vert[0];		var vt1: Vertex = w_vert[1];		var vt2: Vertex = w_vert[2];
		
		if( vt0.sx == null || vt1.sx == null || vt2.sx == null ) return;
		
		var w: Number = texture.width;
		var h: Number = texture.height;
		
		var u0: Number = vt0.u;		var v0: Number = vt0.v;

		tMat.tx = u0;
		tMat.ty = v0;
		
		tMat.a = ( vt1.u - u0 ) / w;
		tMat.b = ( vt1.v - v0 ) / w;
		tMat.c = ( vt2.u - u0 ) / h;
		tMat.d = ( vt2.v - v0 ) / h;
		
		var x0: Number = vt0.sx;		var y0: Number = vt0.sy;
		var x1: Number = vt1.sx;
		var y1: Number = vt1.sy;
		var x2: Number = vt2.sx;
		var y2: Number = vt2.sy;
		
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
		g.lineTo( x0, y0 );
		g.endFill();
	}
	
	public function vDraw( g: MovieClip ): Void
	{
		var vt0: Vertex = w_vert[0];
		var vt1: Vertex = w_vert[1];
		var vt2: Vertex = w_vert[2];
		
		var sx: Number = vt0.sx;		var sy: Number = vt0.sy;
		
		g.moveTo( sx, sy );		g.lineTo( vt1.sx, vt1.sy );		g.lineTo( vt2.sx, vt2.sy );		g.lineTo( sx, sy );
	}
}