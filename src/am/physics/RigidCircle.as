import am.geom.*;

class am.physics.RigidCircle extends Circle
{
	var velocity: Vector;

	function RigidCircle( x: Number, y: Number, radius: Number )
	{
		super( x , y , radius );
		velocity = new Vector( 0 , 0 );
	}

}