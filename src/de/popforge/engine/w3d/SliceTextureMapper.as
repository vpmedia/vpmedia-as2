import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.Renderer;
import de.popforge.engine.w3d.TriPoly;
import de.popforge.engine.w3d.Vertex;

import flash.geom.Matrix;

class de.popforge.engine.w3d.SliceTextureMapper
implements Renderer
{
	private var g: MovieClip;
	private var matrix: Matrix;
	
	public function SliceTextureMapper( clip: MovieClip )
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
		
		var x0: Number = v0.sx;		var y0: Number = v0.sy;
		var x1: Number = v1.sx;
		var y1: Number = v1.sy;
		var x2: Number = v2.sx;
		var y2: Number = v2.sy;
		
		if( !triPoly.force2Sides )
		{
			if( ( x2 - x0 ) * ( y1 - y0 ) - ( y2 - y0 ) * ( x1 - x0 ) < 0 ) return;
		}
		
		//-- compute Z gradient
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
		
		x0 = v0.sx;
		y0 = v0.sy;
		x1 = v1.sx;
		y1 = v1.sy;
		x2 = v2.sx;
		y2 = v2.sy;
		
		var normal: Vertex = triPoly.normal;
		
		var nx: Number = normal.sx;		var ny: Number = normal.sy;
		
		var nl: Number = Math.sqrt( nx * nx + ny * ny );
		
		nx /= nl;		ny /= nl;
		
		var zR: Number = p.zRange;
		
		var g0: Number = 0xff - ( v0.mz - zM ) / zR * 0xff;
		var g1: Number = 0xff - ( v2.mz - zM ) / zR * 0xff;
		
		var dx10: Number = x1 - x0;
		var dy10: Number = y1 - y0;
		var dx20: Number = x2 - x0;
		var dy20: Number = y2 - y0;
		var dx21: Number = x2 - x1;
		var dy21: Number = y2 - y1;
		
		var m: Matrix = new Matrix();
		var zLen: Number = nx * dx20 + ny * dy20;
	
		//-- normalize
		dx20 /= zLen;
		dy20 /= zLen;
		
		var angle: Number = Math.atan2( ny, nx );
		
		//-- tan for side 01
		var tn: Number = Math.tan( Math.atan2( dy10, dx10 ) - angle );
		
		//-- limit for side 01
		var l01: Number = ( dy10 * nx - dx10 * ny ) / tn;
		
		//-- for end on side 12;
		var u: Number;
		
		var t0x: Number;
		var t0y: Number;
		var t1x: Number;
		var t1y: Number;
	
		//-- start on side 20;
		var s0x: Number = x0;
		var s0y: Number = y0;
		var s1x: Number;
		var s1y: Number;
		
		var edge: Boolean = true;
		
		var zSteps: Number = 8;
		var zStep: Number = zLen / zSteps;
		var z: Number;
		
		var scl: Number;
		
		var sn: Number = Math.sin( angle - Math.PI/2 );
		var cs: Number = Math.cos( angle - Math.PI/2 );
		
		var iz0: Number = v0.mz / triPoly.texture.width;		var iz1: Number = v1.mz / triPoly.texture.height;
		
		//trace( [iz0,iz1]);
		
		for( var i: Number = 1 ; i <= zSteps ; i++ )
		{
			z = int( i * zStep );
			
			s1x = s0x;
			s1y = s0y;
			
			s0x = x0 + dx20 * z;
			s0y = y0 + dy20 * z;
			
			scl = iz1 + i / zSteps * ( iz0 - iz1 );
			
			m.a = cs * scl;
			m.b = sn;
			m.c = -sn;
			m.d = cs * scl;
			
			m.tx = s0x;
			m.ty = s0y;
			
			g.beginBitmapFill( triPoly.texture, m, false, false );
			
			if( i == 1 )
			{
				g.moveTo( x0, y0 );
				g.lineTo( s0x, s0y );
			}
			else
			{
				g.moveTo( s0x, s0y );
			}
			
			t1x = t0x;
			t1y = t0y;
			
			if( z < l01 )
			{
				// 10 side
				g.lineTo( t0x = x0 + nx * z - ny * tn * z, t0y = y0 + ny * z + nx * tn * z );
			}
			else
			{
				// 12 side
				u = -( ny * ( y1 - s0y ) + nx * ( x1 - s0x ) ) / ( nx * dx21 + ny * dy21 );
				g.lineTo( t0x = x1 + u * dx21, t0y = y1 + u * dy21 );
				
				if( edge )
				{
					g.lineTo( x1, y1 );
					edge = false;
				}
			}
			
			if( i == 1 )
			{
				g.lineTo( x0, y0 );
			}
			else
			{
				g.lineTo( t1x, t1y );
				g.lineTo( s1x, s1y );
				g.lineTo( x0 + dx20 * (z-zStep), y0 + dy20 * (z-zStep) );
				g.lineTo( s0x, s0y );
			}
		}
		
		var cx: Number = ( x0 + x1 + x2 ) / 3;		var cy: Number = ( y0 + y1 + y2 ) / 3;

		//g.lineStyle( 0, 0xff0000 );		
		//g.moveTo( cx, cy );
		//g.lineTo( cx + nx * 10, cy + ny * 10 );
	}
}

















