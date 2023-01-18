class org.as2base.util.BitMatrix
{
	private var dim: Number;
	private var byte: Number;
	
	private var dimP: Number;
	private var dimM: Number;
	private var dim2: Number;
	private var len: Number;
	
	function BitMatrix( byte: Number, dim: Number )
	{
		this.byte = byte;
		this.dim = dim;
		
		precompute();
	}
	
	private function precompute( Void ): Void
	{
		dimP = dim + 1;
		dimM = dim - 1;
		dim2 = dim * 2;
		
		len = dim * dim;
	}
	
	function rotateCW( Void ): Void
	{
		var shift: Number;
		
		var l: Number = len;
		var b: Number = 0;
		
		while( --l > -1 )
		{
			if( ( shift = dim2 - int( l / dim ) * dimP + ( l % dim * dimM - dimP ) ) > 0 )
			{
				b += ( ( 1 << l ) & byte ) <<  shift;
			}
			else
			{
				b += ( ( 1 << l ) & byte ) >> -shift;
			}
		}
		
		byte = b;
	}
	
	function rotateCCW( Void ): Void
	{
		var shift: Number;
		
		var l: Number = len;
		var b: Number = 0;
		
		while( --l > -1 )
		{
			if( ( shift = -( l % dim ) * dimP + dim * dimM - int( l / dim ) * dimM ) > 0 )
			{
				b += ( ( 1 << l ) & byte ) <<  shift;
			}
			else
			{
				b += ( ( 1 << l ) & byte ) >> -shift;
			}
		}
		
		byte = b;
	}
	
	function setByte( byte: Number ): Void
	{
		this.byte = byte;
	}
	
	function getByte( Void ): Number
	{
		return byte;
	}
	
	function toString( Void ): String
	{
		var o: String = new String( "" );
		
		for( var y = 0 ; y < dim ; y++ )
		{
			var row: String = new String( "" );
			
			for( var x = 0 ; x < dim ; x++ )
			{
				row += ( byte & ( 1 << x ) << ( y * dim ) ) ? "*" : " ";
			}
			
			o += row;
			
			if( y < dimM ) o += newline;
		}
		
		return o;
	}
}