import de.popforge.engine.mode7.Vertex;

 
class de.popforge.engine.mode7.Matrix4x3
{
	private var m11: Number, m12: Number, m13: Number;	
	private var m21: Number, m22: Number, m23: Number;	
	private var m31: Number, m32: Number, m33: Number;	
	private var  tx: Number,  ty: Number,  tz: Number;
	
	public function Matrix4x3()
	{
		identity();
	}
	
	public function identity(): Matrix4x3
	{
		m11 = 1;	m12 = 0;	m13 = 0;
		m21 = 0;	m22 = 1;	m23 = 0;
		m31 = 0;	m32 = 0; 	m33 = 1;
		 tx = 0;	 ty = 0;	 tz = 0;

		return this;
	}
	
	public function translate( x: Number, y: Number, z: Number ): Void
	{
		var r: Matrix4x3 = new Matrix4x3();
		
		r.tx = x;
		r.ty = y;
		r.tz = z;
		
		concat( r );
	}
	
	public function scale( sx: Number, sy: Number, sz: Number ): Void
	{
		var r: Matrix4x3 = new Matrix4x3();
		
		r.m11 = sx;
		r.m22 = sy;
		r.m33 = sz;
		
		concat( r );
	}
	
	public function rotationCAxis( axis: Number, theta: Number ): Void
	{
		var s: Number = Math.sin( theta );
		var c: Number = Math.cos( theta );
		
		var r: Matrix4x3 = new Matrix4x3();
		
		switch( axis )
		{
			case 1:
			
				//-- rotate about x-axis
				r.m21 = 0;	r.m22 = c;	r.m23 = s;
				r.m31 = 0;	r.m32 = -s;	r.m33 = c;
				break;
				
			case 2:
			
				//-- rotate about y-axis
				r.m11 = c;	r.m12 = 0;	r.m13 = -s;
				r.m31 = s;	r.m32 = 0;	r.m33 = c;
				break;
				
			case 3:
			
				//-- rotate about z-axis
				r.m11 = c;	r.m12 = s;	r.m13 = 0;
				r.m21 = -s;	r.m22 = c;	r.m23 = 0;
				break;
		}
		
		concat( r );
	}
	
	/*
	public function setUpRotationAAxis( axis: Vector, theta: Number ): Void
	{
		var s: Number = Math.sin( theta );
		var c: Number = Math.cos( theta );
		
		var a: Number = 1 - c;
		var ax: Number = a * axis.x;
		var ay: Number = a * axis.y;
		var az: Number = a * axis.z;
		
		var r: Matrix4x3 = new Matrix4x3();
		
		r.m11 = ax * axis.x + c;
		r.m12 = ax * axis.y + axis.z * s;
		r.m13 = ax * axis.z - axis.y * s;
		
		r.m21 = ay * axis.x - axis.z * s;
		r.m22 = ay * axis.y + c;
		r.m23 = ay * axis.z + axis.x * s;
		
		r.m31 = az * axis.x + axis.y * s;
		r.m32 = az * axis.y - axis.x * s;
		r.m33 = az * axis.z + c;
		
		concat( r );
	}
	*/
	
	public function concat( b: Matrix4x3 ): Void
	{
		var a: Matrix4x3 = clone();
		
		m11 = a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * b.m31;
		m12 = a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * b.m32;
		m13 = a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * b.m33;
		
		m21 = a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * b.m31;
		m22 = a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * b.m32;
		m23 = a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * b.m33;
		
		m31 = a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * b.m31;
		m32 = a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * b.m32;
		m33 = a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * b.m33;
		
		tx = a.tx * b.m11 + a.ty * b.m21 + a.tz * b.m31 + b.tx;
		ty = a.tx * b.m12 + a.ty * b.m22 + a.tz * b.m32 + b.ty;
		tz = a.tx * b.m13 + a.ty * b.m23 + a.tz * b.m33 + b.tz;
	}
	
	static public function inverse( m: Matrix4x3 ): Matrix4x3
	{
		var det: Number = m.determinant();
		
		if( det == 0 ) return null;
		
		var r: Matrix4x3 = new Matrix4x3();
		
		r.m11 = ( m.m22 * m.m33 - m.m23 * m.m32 ) / det;
		r.m12 = ( m.m13 * m.m32 - m.m12 * m.m33 ) / det;
		r.m13 = ( m.m12 * m.m23 - m.m13 * m.m22 ) / det;
		
		r.m21 = ( m.m23 * m.m31 - m.m21 * m.m33 ) / det;
		r.m22 = ( m.m11 * m.m33 - m.m13 * m.m31 ) / det;
		r.m23 = ( m.m13 * m.m21 - m.m11 * m.m23 ) / det;
		
		r.m31 = ( m.m21 * m.m32 - m.m22 * m.m31 ) / det;
		r.m32 = ( m.m12 * m.m31 - m.m11 * m.m32 ) / det;
		r.m33 = ( m.m11 * m.m22 - m.m12 * m.m21 ) / det;
		
		r.tx = -( m.tx * r.m11 + m.ty * r.m21 + m.tz * r.m31 );
		r.ty = -( m.tx * r.m12 + m.ty * r.m22 + m.tz * r.m32 );
		r.tz = -( m.tx * r.m13 + m.ty * r.m23 + m.tz * r.m33 );
		
		return r;
	}
	
	public function determinant(): Number
	{
		return m11 * ( m22 * m33 - m23 * m32 ) + m12 * ( m23 * m31 - m21 * m33 ) + m13 * ( m21 * m32 - m22 * m31 );
	}
	
	public function transformVertex( v: Vertex ): Void
	{
		var x: Number = v.wx;
		var y: Number = v.wy;
		var z: Number = v.wz;
		
		v.rx = x * m11 + y * m21 + z * m31 + tx;
		v.ry = x * m12 + y * m22 + z * m32 + ty;
		v.rz = x * m13 + y * m23 + z * m33 + tz;
	}
	
	public function clone(): Matrix4x3
	{
		var m: Matrix4x3 = new Matrix4x3();
		
		m.m11 = m11;	m.m12 = m12;	m.m13 = m13;
		m.m21 = m21;	m.m22 = m22;	m.m23 = m23;
		m.m31 = m31;	m.m32 = m32;	m.m33 = m33;
		m.tx  = tx;		m.ty  = ty;		m.tz  = tz;
		
		return m;
	}
	
	public function toString(): String
	{
		return [
				[int(m11*1000)/1000,int(m12*1000)/1000,int(m13*1000)/1000],
				[int(m21*1000)/1000,int(m22*1000)/1000,int(m23*1000)/1000],
				[int(m31*1000)/1000,int(m32*1000)/1000,int(m33*1000)/1000],
				[ int(tx*1000)/1000, int(ty*1000)/1000, int(tz*1000)/1000]
				].join( '\r' );
	}
}
