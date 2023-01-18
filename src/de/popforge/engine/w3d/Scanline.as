import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.Renderer;
import de.popforge.engine.w3d.TriPoly;
import de.popforge.engine.w3d.Vertex;

import flash.display.BitmapData;
import flash.geom.Rectangle;

class de.popforge.engine.w3d.Scanline extends BitmapData
	implements Renderer
{
	private var dizdx: Number;
	private var duizdx: Number;
	private var dvizdx: Number;
	private var dizdy: Number;
	private var duizdy: Number;
	private var dvizdy: Number;

	private var xa: Number;
	private var xb: Number;
	private var iza: Number;
	private var uiza: Number;
	private var viza: Number;

	private var dxdya: Number;
	private var dxdyb: Number;
	private var dizdya: Number;
	private var duizdya: Number;
	private var dvizdya: Number;

	private var texture: BitmapData;
	private var output: BitmapData;
	private var bounds: Rectangle;
	private var zBuffer: BitmapData;

	public function Scanline( w: Number, h: Number )
	{
		super( w, h, false );
		bounds = new Rectangle( 0, 0, w, h );
		zBuffer = new BitmapData( w, h, false, 0 );
	}
	
	public function clear(): Void
	{
		fillRect( bounds, 0 );		zBuffer.fillRect( bounds, 0 );
	}
	
	public function dispose(): Void
	{

	}

	public function renderTriPoly( poly: TriPoly, p: Projection ): Void
	{
		var pvert: Array = poly.vertices;
		
		var sySort: Array = pvert.sortOn( 'sy', Array.RETURNINDEXEDARRAY | Array.NUMERIC );

		var v0: Vertex = pvert[sySort[0]];
		var v1: Vertex = pvert[sySort[1]];
		var v2: Vertex = pvert[sySort[2]];
		
		//-- Shift XY coordinate system (+0.5, +0.5) to match the subpixeling technique
		
		var x1: Number = v0.sx + .5;
		var y1: Number = v0.sy + .5;
		var x2: Number = v1.sx + .5;
		var y2: Number = v1.sy + .5;
		var x3: Number = v2.sx + .5;
		var y3: Number = v2.sy + .5;
		
		//-- 2d backface culling
		//if( ( x2 - x1 ) * ( y3 - y1 ) - ( y2 - y1 ) * ( x3 - x1 ) > 0 ) return;
		
		//-- Calculate alternative 1/Z, U/Z and V/Z values which will be
		//-- interpolated
		
		var iz1: Number = 1 / v0.mz;
		var iz2: Number = 1 / v1.mz;
		var iz3: Number = 1 / v2.mz;
		
		texture = poly.texture;
		
		var tw: Number = texture.width;
		var th: Number = texture.height;
		
		var uv: Array = poly.uv_map;
		
		var uiz1: Number = uv[0].u * iz1 * tw;
		var viz1: Number = uv[0].v * iz1 * th;
		var uiz2: Number = uv[1].u * iz2 * tw;
		var viz2: Number = uv[1].v * iz2 * th;
		var uiz3: Number = uv[2].u * iz3 * tw;
		var viz3: Number = uv[2].v * iz3 * th;
		
		//-- convert 2 int (modified)
		var y1i: Number = y1 | 0;
		var y2i: Number = y2 | 0;
		var y3i: Number = y3 | 0;
	
		// Skip poly if it's too thin to cover any pixels at all
	
		// Calculate horizontal and vertical increments for UV axes (these
		// calcs are certainly not optimal, although they're stable
		// (handles any dy being 0)
	
		var denom: Number = ((x3 - x1) * (y2 - y1) - (x2 - x1) * (y3 - y1));

		var dy: Number;

		dizdx = ((iz3 - iz1) * (y2 - y1) - (iz2 - iz1) * (y3 - y1)) / denom;
		duizdx = ((uiz3 - uiz1) * (y2 - y1) - (uiz2 - uiz1) * (y3 - y1)) / denom;
		dvizdx = ((viz3 - viz1) * (y2 - y1) - (viz2 - viz1) * (y3 - y1)) / denom;
		dizdy = ((iz2 - iz1) * (x3 - x1) - (iz3 - iz1) * (x2 - x1)) / denom;
		duizdy = ((uiz2 - uiz1) * (x3 - x1) - (uiz3 - uiz1) * (x2 - x1)) / denom;
		dvizdy = ((viz2 - viz1) * (x3 - x1) - (viz3 - viz1) * (x2 - x1)) / denom;
	
		// Calculate X-slopes along the edges
	
		var dxdy1: Number = ( x2 - x1 ) / ( y2 - y1 );
		var dxdy2: Number = ( x3 - x1 ) / ( y3 - y1 );
		var dxdy3: Number = ( x3 - x2 ) / ( y3 - y2 );
	
		// Determine which side of the poly the longer edge is on
	
		var side: Boolean = dxdy2 > dxdy1;
	
		if( y1 == y2 )
		{
			side = x1 > x2;
		}
		if( y2 == y3 )
		{
			side = x3 > x2;
		}
	
		if( !side )	// Longer edge is on the left side
		{
			// Calculate slopes along left edge

			dxdya = dxdy2;
			dizdya = dxdy2 * dizdx + dizdy;
			duizdya = dxdy2 * duizdx + duizdy;
			dvizdya = dxdy2 * dvizdx + dvizdy;
	
			// Perform subpixel pre-stepping along left edge
	
			dy = 1 - ( y1 - y1i );
			
			xa = x1 + dy * dxdya;
			iza = iz1 + dy * dizdya;
			uiza = uiz1 + dy * duizdya;
			viza = viz1 + dy * dvizdya;
	
			if (y1i < y2i)	// Draw upper segment if possibly visible
			{
				// Set right edge X-slope and perform subpixel pre-stepping
	
				xb = x1 + dy * dxdy1;
				dxdyb = dxdy1;
	
				drawSubTri( y1i, y2i );
			}
			if (y2i < y3i)	// Draw lower segment if possibly visible
			{
				// Set right edge X-slope and perform subpixel pre-stepping
	
				xb = x2 + (1 - (y2 - y2i)) * dxdy3;
				dxdyb = dxdy3;
	
				drawSubTri( y2i, y3i );
			}
		}
		else	// Longer edge is on the right side
		{
			// Set right edge X-slope and perform subpixel pre-stepping
	
			dxdyb = dxdy2;
			dy = 1 - (y1 - y1i);
			xb = x1 + dy * dxdyb;
	
			if( y1i < y2i )	// Draw upper segment if possibly visible
			{
				// Set slopes along left edge and perform subpixel pre-stepping

				dxdya = dxdy1;
				dizdya = dxdy1 * dizdx + dizdy;
				duizdya = dxdy1 * duizdx + duizdy;
				dvizdya = dxdy1 * dvizdx + dvizdy;
				xa = x1 + dy * dxdya;
				iza = iz1 + dy * dizdya;
				uiza = uiz1 + dy * duizdya;
				viza = viz1 + dy * dvizdya;

				drawSubTri( y1i, y2i );
			}
			if( y2i < y3i )	// Draw lower segment if possibly visible
			{
				// Set slopes along left edge and perform subpixel pre-stepping

				dxdya = dxdy3;
				dizdya = dxdy3 * dizdx + dizdy;
				duizdya = dxdy3 * duizdx + duizdy;
				dvizdya = dxdy3 * dvizdx + dvizdy;

				dy = 1 - ( y2 - y2i );
				xa = x2 + dy * dxdya;
				iza = iz2 + dy * dizdya;
				uiza = uiz2 + dy * duizdya;
				viza = viz2 + dy * dvizdya;

				drawSubTri( y2i, y3i );
			}
		}
	}

	private function drawSubTri( y1: Number, y2: Number ): Void
	{
		//-- clip yMin
		/*if( y1 < 0 )
		{
			if( y2 < 0 )
			{
				y1 -= y2;
				
				xa -= dxdya * y1;
				xb -= dxdyb * y1;
				iza -= dizdya * y1;
				uiza -= duizdya * y1;
				viza -= dvizdya * y1;
				return;
			}
			
			xa -= dxdya * y1;
			xb -= dxdyb * y1;
			iza -= dizdya * y1;
			uiza -= duizdya * y1;
			viza -= dvizdya * y1;
			
			y1 = 0;
		}*/
		
		var x1: Number;
		var x2: Number;
		var z: Number;
		var u: Number;
		var v: Number;
		var dx: Number;
		var iz: Number;
		var uiz: Number;
		var viz: Number;
		
		var rw: Number = texture.width - 1;
		var rh: Number = texture.height - 1;
		
		//-- clip yMax
		//if( y2 > height ) y2 = height;
		
		while ( y1 < y2 )
		{
			//if( y1 > -1 )
			//{
				x1 = xa | 0;
				x2 = xb | 0;

				//-- clip x
				//if( x1 < -1 ) x1 = -1;
				//if( x2 > width - 1 ) x2 = width - 1;

				dx = 1 - ( xa - x1 );
				iz =   iza + dx * dizdx;
				uiz = uiza + dx * duizdx;
				viz = viza + dx * dvizdx;

				while ( x1++ < x2 )
				{
					if( ( z = 0xffffff * iz | 0 ) >= zBuffer.getPixel( x1, y1 ) )
					{
						u = uiz / iz & rw;
						v = viz / iz & rh;
						
						setPixel( x1, y1, texture.getPixel( u, v ) );

						//-- Store depth to zBuffer
						zBuffer.setPixel( x1, y1, z );
					}

					iz += dizdx;
					uiz += duizdx;
					viz += dvizdx;
				}
			//}
			
			xa += dxdya;
			xb += dxdyb;
			iza += dizdya;
			uiza += duizdya;
			viza += dvizdya;

			y1++;
		}
	}
}