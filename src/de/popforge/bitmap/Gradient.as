import de.popforge.bitmap.Shape;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

class de.popforge.bitmap.Gradient
{
	public static function createXYGradient(): BitmapData
	{
		/*
		 * get canvas
		 */
		var g: Shape = Shape.get();
			
		if( g == null )
		{
			return null;
		}
		
		var xyGradient: BitmapData = new BitmapData( 256, 256, false, 0 );
		
		var matrix: Matrix = new Matrix();
		
		/*
		 * create y as blue colorvalues
		 */
		
		matrix.createGradientBox( 256, 256, Math.PI/2, 0, 0 );
		
		g.beginGradientFill( 'linear', [ 0, 0x0000ff ], [ 100, 100 ], [ 0, 0xff ], matrix );
		g.moveTo( 0, 0 );
		g.lineTo( 256, 0 );
		g.lineTo( 256, 256 );
		g.lineTo( 0, 256 );
		g.lineTo( 0, 0 );
		g.endFill();
		
		matrix.identity();
		xyGradient.draw( g, matrix );
		
		g.clear();
		
		/*
		 * create x as green colorvalues
		 */
		
		matrix.createGradientBox( 256, 256, 0, 0, 0 );
		
		g.beginGradientFill( 'linear', [ 0, 0x00ff00 ], [ 100, 100 ], [ 0, 0xff ], matrix );
		g.moveTo( 0, 0 );
		g.lineTo( 256, 0 );
		g.lineTo( 256, 256 );
		g.lineTo( 0, 256 );
		g.lineTo( 0, 0 );
		g.endFill();
		
		matrix.identity();
		xyGradient.draw( g, matrix, null, 'add' );
		
		g.removeMovieClip();
		
		return xyGradient;
	}
	
	public static function createDisplacementMapFromMidMap( midmap: BitmapData ): BitmapData
	{
		var displace: BitmapData = createXYGradient();
		
		if( displace == null )
		{
			return null;
		}
		
		var colorTransform: ColorTransform = new ColorTransform();
		var m: Matrix = new Matrix();
		colorTransform.greenMultiplier = .5;
		colorTransform.blueMultiplier = .5;
		displace.draw( displace, m, colorTransform );
		colorTransform.greenOffset = 128;
		colorTransform.blueOffset = 128;
		displace.draw( midmap, m, colorTransform, 'difference' );
		
		return displace;
	}
	
	/*
	 * returns an array with 32bit colorvalues
	 * usefull to remap a bitmap using 'paletteMap'
	 */
	 
	public static function fillArray( colors: Array, alphas: Array, ratios: Array ): Array
	{
		var g: Shape = Shape.get();
		
		if( g == null )
		{
			return null;
		}
		
		var array: Array = new Array;
		
		var m: Matrix = new Matrix();
		
		m.a = m.d = .15625;
		m.b = m.c = 0;
		m.tx = m.ty = 128;
		
		g.beginGradientFill( 'linear', colors, alphas, ratios, m );
		g.moveTo( 0, 0 );
		g.lineTo( 256, 0 );
		g.lineTo( 256, 1 );
		g.lineTo( 0, 1 );		g.lineTo( 0, 0 );
		g.endFill();
		
		var bmp: BitmapData = new BitmapData( 256, 1, true, 0 );
		
		m.identity();
		
		bmp.draw( g, m );
		
		g.removeMovieClip();
		
		var x: Number = 256;
		
		while( --x > -1 )
		{
			array[x] = bmp.getPixel32( x, 0 );
		}
		
		return array;
	}
}