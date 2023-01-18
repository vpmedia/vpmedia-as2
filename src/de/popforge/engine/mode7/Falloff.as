import de.popforge.engine.mode7.Projector;

import flash.geom.ColorTransform;

/**
 * @author Andre Michelle
 */

class de.popforge.engine.mode7.Falloff
{
	public var distance: Number;
	public var color: Number;
	
	private var projector: Projector;
	private var clip: Number;
	
	private var r: Number;	private var g: Number;	private var b: Number;
	
	private var transforms: Array;
	private var transform: ColorTransform;
	private var noTransform: ColorTransform;
	
	public function Falloff( projector: Projector, distance: Number, color: Number )
	{
		this.projector 	= projector;
		this.distance 	= distance;		this.color 		= color;
		
		transform = new ColorTransform();
		noTransform = new ColorTransform();
		
		update();
	}
	
	public function getTransform( objDistance: Number ): ColorTransform
	{
		if( objDistance < distance ) return noTransform;
		
		var d: Number = ( objDistance - distance ) / ( clip - distance );
		
		transform.redMultiplier = transform.greenMultiplier = transform.blueMultiplier = 1 - d;
		transform.redOffset = r * d;
		transform.greenOffset = g * d;
		transform.blueOffset = b * d;
		
		return transform;
	}
	
	public function getTransforms(): Array
	{
		return transforms;
	}
	
	public function update(): Void
	{
		transforms = new Array();
		
		/*
		 * projector properties
		 */
		var horizont: Number = projector.getHorizont();
		clip = projector.clip;
		
		/*
		 * get projector private members
		 *   to increases performance
		 */
		var hded: Number = projector['hded'];		var z2: Number = projector['z2'];
		
		/*
		 * split color components
		 */
		r = ( color >> 16 ) & 0xff;
		g = ( color >> 8 ) & 0xff;
		b = color & 0xff;
		
		var fogTransform: ColorTransform = new ColorTransform( 0, 0, 0, 1, r, g, b, 0 );
		
		var i: Number = projector.height;
		var c: Number;
		var d: Number;
		var e: Number;
		
		while( --i > horizont )
		{
			c = 2 * ( horizont - i );
			d = -( c + hded ) * z2 / c;
			
			if( d < distance )
			{
				transforms[i] = null;
			}
			else if( d >= distance )
			{
				if( d < clip )
				{
					e = ( d - distance ) / ( clip - distance );
				
					transforms[i] = new ColorTransform( 1 - e, 1 - e, 1 - e, 1, r * e, g * e, b * e, 0 );
				}
				else
				{
					transforms[i] = fogTransform;
				}
			}
		}
	}
}