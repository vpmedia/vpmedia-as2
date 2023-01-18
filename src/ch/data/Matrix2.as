/*
Class	Matrix2
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	3 déc. 2005
*/

/**
 * Bidimentionnal Array.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		3 déc. 2005
 * @version		1.0
 */
class ch.data.Matrix2
{
	//---------//
	//Variables//
	//---------//
	private var			_data:Array;
	private var			_rows:Number;
	private var			_cols:Number;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new Matrix2.
	 */
	public function Matrix2(rows:Number, cols:Number)
	{
		_rows = rows;
		_cols = cols;
		_data = [];
		
		for (var i:Number=0 ; i<rows ; i++)
		{
			_data[i] = [];
		}
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the number of rows.
	 * 
	 * @return	The number of rows.
	 */
	public function getRowCount(Void):Number
	{
		return _rows;
	}
	
	/**
	 * Get the number of columns.
	 * 
	 * @return	The number of columns.
	 */
	public function getColumnCount(Void):Number
	{
		return _cols;
	}
	
	/**
	 * Get the data from a cell
	 * 
	 * @param	row		The row.
	 * @param	col		The column.
	 * @return	The data of the cell.
	 */
	public function getData(row:Number, col:Number):Object
	{
		return _data[row][col];
	}
	
	/**
	 * Set a data into a cell.
	 * 
	 * @param	row		The row.
	 * @param	col		The column.
	 * @param	data	The data.
	 */
	public function setData(row:Number, col:Number, data:Object):Void
	{
		_data[row][col] = data;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the Matrix2 instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.Matrix2";
	}
}