import de.popforge.engine.mode7.Matrix4x3;
import de.popforge.engine.mode7.TriPoly;
import de.popforge.engine.mode7.Vertex;

import flash.display.BitmapData;

/**
 * @author Andre Michelle
 */
class de.popforge.engine.mode7.SegmentPlane
{
	private var width: Number;	private var height: Number;	private var vseg: Number;	private var hseg: Number;
	private var texture: BitmapData;

	public var matrix: Matrix4x3;
	public var vertices: Array;	public var polygons: Array;
	
	public function SegmentPlane( width: Number, height: Number, vseg: Number, hseg: Number, texture: BitmapData )
	{
		this.width = width;		this.height = height;		this.vseg = vseg;		this.hseg = hseg;
		this.texture = texture;
		
		matrix = new Matrix4x3();
		
		build();
	}
	
	public function applyMatrix(): Void
	{
		var i: Number = vertices.length;
		
		while( --i > -1 )
		{
			matrix.transformVertex( vertices[i] );
		}
	}
	
	public function paint( g: MovieClip ): Void
	{
		var i: Number = polygons.length;
		
		while( --i > -1 )
		{
			polygons[i].paint( g );
		}
	}
	
	private function build(): Void
	{
		vertices = new Array();
		polygons = new Array();

		var ix: Number;
		var iy: Number;

		var w2: Number = width / 2;
		var h2: Number = height / 2;

		var hsLen: Number = width / ( vseg + 1 );
		var vsLen: Number = height / ( hseg + 1 );

		var x: Number, y: Number;

		for ( ix = 0 ; ix < vseg + 2 ; ix++ )
		{
			for ( iy = 0 ; iy < hseg + 2 ; iy++ )
			{
				x = ix * hsLen;
				y = iy * vsLen;
				vertices.push( new Vertex( x, y, 0, x, y ) );
			}
		}

		for ( ix = 0 ; ix < vseg + 1 ; ix++ )
		{
			for ( iy = 0 ; iy < hseg + 1 ; iy++ )
			{
				createTriAngle( ix, iy, 1, [ vertices[ iy + ix * ( hseg + 2 ) ] , vertices[ iy + ix * ( hseg + 2 ) + 1 ] , vertices[ iy + ( ix + 1 ) * ( hseg + 2 ) ] ] );
				createTriAngle( ix, iy,-1, [ vertices[ iy + ( ix + 1 ) * ( hseg + 2 ) + 1 ] , vertices[ iy + ( ix + 1 ) * ( hseg + 2 ) ] , vertices[ iy + ix * ( hseg + 2 ) + 1 ] ] );
			}
		}
	}
	
	private function createTriAngle( x: Number, y: Number, align: Number, vertices: Array ): Void
	{
		var triPoly: TriPoly = new TriPoly( vertices, texture );
		
		polygons.push( triPoly );
	}
}



















