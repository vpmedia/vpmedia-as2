import de.popforge.engine.mode7.Falloff;
import de.popforge.engine.mode7.Sprite;
import de.popforge.engine.mode7.Vertex;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class de.popforge.engine.mode7.Projector extends BitmapData
{
	/*
	 * displacement
	 */
	public var r: Number;	public var x: Number;	public var y: Number;
	
	/*
	 * projector members
	 */
	public var sprites: Array;	public var vertices: Array;
	public var texture: BitmapData;
	
	/*
	 * geom
	 */
	private var bounds: Rectangle;
	private var clipRect: Rectangle;
	private var matrix: Matrix;
	
	/*
	 * precompute
	 */
	private var res: Array;
	private var ze: Number;	private var z2: Number;
	private var w2: Number;	private var h2: Number;	private var hd: Number;	private var hz: Number;
	private var cp: Number;	private var cy: Number;
	private var sn: Number;
	private var cs: Number;
	private var ea: Number;
	private var ed: Number;
	private var hded: Number;
	
	/*
	 * fx
	 */
	public var background: Number;
	private var falloff: Falloff;
	
	/*
	 * get/set members
	 */
	private var _resolution: Number;
	private var _clip: Number;
	private var _fov: Number;
	private var _roll: Number;
	private var _z: Number;

	public function Projector( width: Number, height: Number )
	{
		super( width, height, false );
		
		w2 = width / 2;		h2 = height / 2;
		
		_clip = Number.POSITIVE_INFINITY;
		r = x = y = 0;
		_resolution = 1;
		
		bounds 		= new Rectangle( 0, 0, width, height );
		clipRect 	= new Rectangle( 0, 0, width, 1 );
		matrix 		= new Matrix();
		sprites 	= new Array;		vertices 	= new Array;
	}
	
	/*
	 * render function
	 */
	
	public function render(): Void
	{
		fillRect( bounds, background );
		
		/*
		 * render texture
		 */
		 
		var trans: Array = falloff.getTransforms();
		var m: Matrix = matrix;
		var t: BitmapData = texture;
		var c: Rectangle = clipRect;

		var scl: Number;
		var cscl: Number;
		var u: Number;
		var v: Number;
		
		var i: Number = res.length;
		var my: Number = int( cy );
		
		while( --i > -1 )
		{
			scl = ( my - hz ) / z2;

			u = x * scl;
			v = y * scl;
			cscl = cs * scl;
			m.a = m.d = -sn * scl;
			m.b = -cscl; m.c = cscl;
			m.tx = w2 - cs * v + sn * u;
			m.ty = hd + sn * v + cs * u;
			
			c.y = my;
			my += ( c.height = res[i] );
			draw( t, m, trans[my], null, c );
		}
		
		/*
		 * render sprites
		 */
		 
		var ct: ColorTransform;
		var tt: ColorTransform;
		var ce: Number;
		var ps: Number;
		var dd: Number;
		
		i = sprites.length;
		
		var sprite: Sprite;
		var tl: MovieClip;
		
		while( --i > -1 )
		{
			sprite = sprites[i];
			tl = sprite.timeline;
			
			u = sprite.x - x;
			v = sprite.y - y;
		
			dd = u * cs + v * sn;
			
			if( dd < 0 || dd > clip )
			{
				tl._x = 5000;
			}
			else
			{
				tl.transform.colorTransform = falloff.getTransform( dd );

				ps = hded / ( dd + z2 );
				tl._x = w2 + ( v * cs - u * sn ) * ps / 2;
				tl._y = hz - ( sprite.z - z ) * ps;
				tl._xscale = tl._yscale = ps * 50;
			}
		}
		
		i = vertices.length;
		
		var vertex: Vertex;
		
		while( --i > -1 )
		{
			vertex = vertices[i];
			
			u = vertex.rx - x;
			v = vertex.ry - y;
			
			dd = u * cs + v * sn;
			
			if( dd > 0 )
			{
				ps = hded / ( dd + z2 ) / 2;
				vertex.sx = w2 + ( v * cs - u * sn ) * ps;
				vertex.sy = hz - ( vertex.rz - z2 ) * ps;
			}
			else
			{
				vertex.sx = vertex.sy = null;
			}
		}
	}
	
	public function getFrustrumRect(): Rectangle
	{
		var bounds: Array =
		[
			globalToLocal( -1, height ),
			globalToLocal( width, height ),
			globalToLocal( -1, cy ),
			globalToLocal( width, cy )
		];
		
		var xMin: Number = Number.POSITIVE_INFINITY;
		var xMax: Number = Number.NEGATIVE_INFINITY;
		var yMin: Number = Number.POSITIVE_INFINITY;
		var yMax: Number = Number.NEGATIVE_INFINITY;
		
		var pt: Point;
		var px: Number;		var py: Number;
		
		var i: Number = bounds.length;
		
		while( --i > -1 )
		{
			pt = bounds[i];
			px = pt.x;			py = pt.y;
			
			if( px < xMin )
			{
				xMin = px;
			}
			if( px > xMax )
			{
				xMax = px;
			}
			if( py < yMin )
			{
				yMin = py;
			}
			if( py > yMax )
			{
				yMax = py;
			}
		}
		
		return new Rectangle( xMin, yMin, xMax - xMin, yMax - yMin );
	}
	
	public function globalToLocal( sx: Number, sy: Number ): Point
	{
		var symhz: Number = sy - hz;
		
		var ru: Number = ( symhz * z2 + hded * z ) / symhz - z2 * 2;
		var rv: Number = z2 * ( w2 - sx ) / symhz;
		
		var u: Number = x + ru * cs + rv * sn;
		var v: Number = y - rv * cs + ru * sn;
		
		return new Point( u, v );
	}
	
	public function getHorizont(): Number
	{
		return hz;
	}
	
	public function globalToLocalUnTranslate( sx: Number, sy: Number ): Point
	{
		var symhz: Number = sy - hz;
		
		var u: Number = z2 * ( w2 - sx ) / symhz;
		var v: Number = ( symhz * z2 + hded * z ) / symhz - z2 * 2;
		
		return new Point( u, v );
	}
	
	public function updateRotationMatrix(): Void
	{
		sn = Math.sin( r );
		cs = Math.cos( r );
	}
	
	/*
	 * falloff
	 */
	 
	public function applyFalloff( distance: Number, color: Number ): Void
	{
		falloff = new Falloff( this, distance, color );
		
		update();
	}
	
	public function removeFalloff(): Void
	{
		delete falloff;
	}
	
	/*
	 * slices resolution
	 */
	
	public function set resolution( resolution: Number ): Void
	{
		_resolution	= resolution;
		update();
	}
	
	public function get resolution(): Number
	{
		return _resolution;
	}
	
	/*
	 * clip fear plane
	 */
	 
	public function set clip( clip: Number ): Void
	{
		_clip = clip;
		update();
	}
	
	public function get clip(): Number
	{
		return _clip;
	}
	
	/*
	 * field of view
	 */
	
	public function set fov( fov: Number ): Void
	{
		_fov = fov;
		update();
	}
	
	public function get fov(): Number
	{
		return _fov;
	}
	
	/*
	 * camera 'roll'
	 */
	 
	public function set roll( roll: Number ): Void
	{
		_roll = roll;
		update();
	}
	
	public function get roll(): Number
	{
		return _roll;
	}
	
	/*
	 * camera 'height'
	 */
	 
	public function set z ( z: Number ): Void
	{
		if( z < 1 ) z = 1;
		_z = z;
		update();
	}
	
	public function get z(): Number
	{
		return _z;
	}
	
	private function update(): Void
	{
		ed = w2 / Math.tan( _fov / 2 );
		hd = height + ed;
		ze = _z * ed * 2;
		z2 = _z * 2;
		hz = h2 - _roll;
		hded = hd + ed + roll * 2;
		cp = hded / ( ( clip + z2 ) * 2 );
		cy = hz + z * ( hded / ( _clip + z2 ) );
		ea = ( ( height - hz ) * z2 + hded * z ) / ( height - hz ) - z2 * 2;
		
		if( falloff )
		{
			falloff.update();
		}
		
		res = new Array;
		var ra: Number = ( 1 + _resolution ) / 2;
		var th: Number = height - cy;
		var scl: Number;
		var sht: Number;
		var bas: Number;
		var my: Number = 0;
		
		for( var i = 0 ; my < th ; i++ )
		{
			bas = i / ( th / ra );
			sht = Math.round( 1 + ( _resolution - 1 ) * ( bas * bas ) );
			my += sht;
			res.unshift( sht );
		}
	}
}