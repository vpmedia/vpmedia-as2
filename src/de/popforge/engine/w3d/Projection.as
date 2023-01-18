import de.popforge.engine.w3d.FlatShader;
import de.popforge.engine.w3d.Renderer;
import de.popforge.engine.w3d.TriMesh;
import de.popforge.engine.w3d.TriPoly;

class de.popforge.engine.w3d.Projection
{
	public var meshes: Array;
	public var renderer: Renderer;
	
	public var zMin: Number;
	public var zMax: Number;
	public var zRange: Number;
	
	public var focus: Number;
	
	public var width: Number;	public var height: Number;
	
	public var center_x: Number;
	public var center_y: Number;
	
	public function Projection()
	{
		meshes = new Array;
	}
	
	public function setZPlanes( min: Number, max: Number ): Void
	{
		zMin = min;		zMax = max;		zRange = max - min;
	}
	
	public function setScreenSize( width: Number, height: Number ): Void
	{
		this.width = width;
		this.height = height;
		
		center_x = width / 2;		center_y = height / 2;
	}
	
	public function render(): Void
	{
		var triMesh: TriMesh;
		var triPoly: TriPoly;
		
		var triPolies: Array;
		
		var i: Number = meshes.length;
		var j: Number;
		
		while( --i > -1 )
		{
			triMesh = meshes[i];
			
			triPolies = triMesh.triPolies;
			
			j = triPolies.length;
			
			//---------------------------------------//
			//-- some pretests and clipping needed --//
			//---------------------------------------//
						
			while( --j > -1 )
			{
				triPoly = triPolies[j];
				triPoly.project( this );
				
				renderer.renderTriPoly( triPoly, this );
			}
		}
	}
}