class am.List extends Array
{
	function removeItem( item ): Void
	{
		for ( var e in this )
		{
			if ( this[e] == item )
			{
				this.splice( e , 1 );
			}
		}
	}
	function foreach( f: Function )
	{
		for ( var e in this ) f( this[e] );
	}
	function sortOn( prop: String ): Void
	{
		function( l: Number, r: Number )
		{
			var h, i = l, j = r, x = this[ ( l + r ) >> 1 ][ prop ];

			while ( i <= j )
			{
			    while ( this[i][ prop ] < x )
				i++;
			    while ( this[j][ prop ] > x )
				j--;

			    if ( i <= j )
			    {
					h = this[i];
					this[i++] = this[j];
					this[j--] = h;
			    }
			}

			if ( l < j ) arguments.callee.call( this , l , j );
			if ( i < r ) arguments.callee.call( this , i , r );

		}.call( this , 0 , length - 1 );
	}
	function sort(): Void
	{
		function( l: Number, r: Number )
		{
			var h, i = l, j = r, x = this[ ( l + r ) >> 1 ];

			while ( i <= j )
			{
			    while ( this[i] < x )
				i++;
			    while ( this[j] > x )
				j--;

			    if ( i <= j )
			    {
					h = this[i];
					this[i++] = this[j];
					this[j--] = h;
			    }
			}

			if ( l < j ) arguments.callee.call( this , l , j );
			if ( i < r ) arguments.callee.call( this , i , r );

		}.call( this , 0 , length - 1 );
	}
}