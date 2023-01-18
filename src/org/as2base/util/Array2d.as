/* class Array2d
* 
*  MODIFY RECTANGLE 2D MAPS
*/

class org.as2base.util.Array2d extends Array
{
	/*
	* CONSTRUCTOR
	*/
	function Array2d()
	{
		splice.apply( this , [ 0 , 0 ].concat( arguments ) );
	}
	
	/*
	* PUSHES A NEW ROW TO INSTANCE
	* RETURN NEW ROW NUM
	*/
	function pushRow( row: Array ): Number
	{
		if( row.length != this[0].length ) return null;
		
		return push( row );
	}
	
	/*
	* PUSHES A NEW COL TO INSTANCE
	* RETURN NEW COL NUM
	*/
	function pushCol( col: Array ): Number
	{
		if( col.length != this.length ) return null;
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			this[ len ].push( col[ len ] );
		}
		
		return this[0].length;
	}
	
	/*
	* UNSHIFT A NEW ROW TO INSTANCE
	* RETURN NEW ROW NUM
	*/
	function unshiftRow( row: Array ): Number
	{
		if( row.length != this[0].length ) return null;
		
		return unshift( row );
	}
	
	/*
	* UNSHIFT A NEW COL TO INSTANCE
	* RETURN NEW COL NUM
	*/
	function unshiftCol( col: Array ): Number
	{
		if( col.length != this.length ) return null;
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			this[ len ].unshift( col[ len ] );
		}
		
		return this[0].length;
	}
	
	/*
	* REMOVE LAST ROW FROM INSTANCE
	* RETURN REMOVED ROW
	*/
	function popRow( Void ): Array
	{
		return Array( pop() );
	}
	
	/*
	* REMOVE LAST COL FROM INSTANCE
	* RETURN REMOVED COL
	*/
	function popCol( Void ): Array
	{
		var col: Array = new Array;
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			col.unshift( this[ len ].pop() );
		}
		
		return col;
	}
	
	/*
	* REMOVE FIRST ROW FROM INSTANCE
	* RETURN REMOVED ROW
	*/
	function shiftRow( Void ): Array
	{
		return Array( shift() );
	}
	
	/*
	* REMOVE FIRST COL FROM INSTANCE
	* RETURN REMOVED COL
	*/
	function shiftCol( Void ): Array
	{
		var col: Array = new Array;
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			col.unshift( this[ len ].shift() );
		}
		
		return col;
	}
	
	/*
	* REMOVE ROWS FROM START TO END INDEX IN INSTANCE
	* RETURNS NEW ARRAY2D WITH REMOVED ROWS
	*/
	function sliceRow( start: Number, end: Number ): Array2d
	{
		start = start - 1 || 0;
		end   = end || length;
		
		var result: Array2d = new Array2d();
		
		while( --end > start )
		{
			result.unshift( this[ end ] );
		}
		
		return result;
	}
	
	/*
	* REMOVE COLS FROM START TO END INDEX IN INSTANCE
	* RETURNS NEW ARRAY2D WITH REMOVED COLS
	*/
	function sliceCol( start: Number, end: Number ): Array2d
	{
		start = start || 0;
		end   = end || length;
		
		var result: Array2d = new Array2d();
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			result.unshift( this[len].slice( start, end ) );
		}
		
		return result;
	}
	
	/*
	* REMOVE 'deleteCount' ROWS FROM STARTINDEX AND INSERT PASSED ROWS ARRAYS
	* RETURNS REMOVED ROWS
	*/
	function spliceRow( start: Number, deleteCount: Number )	//@ TODO: FIX RETURN TYPE( Array2d )
	{
		return splice.apply( this , [ start , deleteCount ].concat( arguments.slice( 2 ) ) );
	}
	
	/*
	* REMOVE 'deleteCount' COLS FROM STARTINDEX AND INSERT PASSED COLS ARRAYS
	* RETURNS REMOVED COLS AS COPY(!) <<< NOT LIKE FLASH ARRAY
	*/
	function spliceCol( start: Number, deleteCount: Number ): Array2d
	{
		var len: Number = length;
		
		var result: Array2d = new Array2d();
		
		var newCols: Array = arguments.slice( 2 );
		
		while( --len > -1 )
		{
			result.unshift( this[len].splice( start , deleteCount ) );
			
			var cn: Number = newCols.length;
			
			while( --cn > -1 )
			{
				this[len].splice( start , 0 , newCols[ cn ][ len ] );
			}
		}
		
		return result;
	}
	
	/*
	* ROTATE ALL ARRAY2D ENTRIES AROUND CENTER
	*/
	function rotateCW( Void ): Void
	{
		var copy: Array2d = clone();
		
		var len: Number = this[0].length;
	
		splice( 0 );
		
		while( --len > -1 )
		{
			var o = copy.shiftCol();
			o.reverse();
			push( o );
		}
	}
	
	/*
	* ROTATE ALL ARRAY2D ENTRIES AROUND CENTER
	*/
	function rotateCCW( Void ): Void
	{
		var copy: Array2d = clone();
		
		var len: Number = this[0].length;
	
		splice( 0 );
		
		while( --len > -1 )
		{
			this[ len ] = copy.shiftCol();
		}
	}
	
	/*
	* FLIP ALL ARRAY2D ENTRIES HORIZONTAL
	*/
	function flipHorizontal( Void ): Void
	{
		var len: Number = length;
		
		while( --len > -1 )
		{
			this[ len ].reverse();
		}
	}
	
	/*
	* FLIP ALL ARRAY2D ENTRIES VERTICAL
	*/
	function flipVertical( Void ): Void
	{
		reverse();
	}

	/*
	* RETURNS SUM OF ROW
	*/
	function sumRow( rowId: Number ): Number
	{
		var row: Array = this[ rowId ];
		
		var sum: Number = 0;
		
		var len: Number = row.length;
		
		while( --len > -1 )
		{
			sum += row[ len ];
		}
		
		return sum;
	}

	/*
	* RETURNS SUM OF COL
	*/
	function sumCol( colId: Number ): Number
	{
		var sum: Number = 0;
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			sum += this[ len ][ colId ];
		}
		
		return sum;
	}
	
	/*
	* RETURN NUMBER OF COLS
	*/
	function getNumCols( Void ): Number
	{
		return this[0].length;
	}
	
	/*
	* RETURN NUMBER OF ROWS
	*/
	function getNumRows( Void ): Number
	{
		return length;
	}
	
	/*
	* RETURNS TRUE IF ARRAY2D IS RECTANGLE
	* AND FALSE IF NOT > INVAID
	*/
	function isRect( Void ): Boolean
	{
		var l0: Number = 0;
		var l1: Number = Number.POSITIVE_INFINITY;
		var len: Number = length;
		
		var min: Function = Math.min;
		var max: Function = Math.max;
		
		while( --len > -1 )
		{
			l0 = max( this[ len ].length , l0 );
			l1 = min( this[ len ].length , l1 );
		}
		
		return l0 == l1;
	}
	
	/*
	* RETURNS A CLONE OF THE INSTANCE
	*/
	function clone( Void ): Array2d
	{
		var copy: Array2d = new Array2d;
		
		var len: Number = length;
		
		while( --len > -1 )
		{
			copy[ len ] = this[ len ].slice();
		}
		
		return copy;
	}
	
	/*
	* RETURN FORMATTED STRING (EACH ROW A LINE)
	*/
	function toString( Void ): String
	{
		return join( newline );
	}
}