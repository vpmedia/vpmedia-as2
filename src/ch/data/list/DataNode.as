/*
Class	DataNode
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 oct. 2005
*/

/**
 * Represent a Node into a {@code ch.data.List}.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since	28 oct. 2005
 * @version		1.0
 */
class ch.data.list.DataNode
{
	//---------//
	//Variables//
	//---------//
	private var			_data:Object; //data of the node
	
	/**
	 * Next node into a {@code List}.
	 * <p>This value is managed by the {@code List}. Don't
	 * modify it !</p> 
	 */
	public var			next:DataNode; //the next node
	
	/**
	 * Previous node into a {@code List}.
	 * <p>This value is managed by the {@code List}. Don't
	 * modify it !</p> 
	 */
	public var			previous:DataNode; //the previous node
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new DataNode.
	 * 
	 * @param	data	The data of the node.
	 */
	public function DataNode(data:Object)
	{
		setData(data);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the data of the {@code DataNode}.
	 * 
	 * @return	The data.
	 */
	public function getData(Void):Object
	{
		return _data;
	}
	
	/**
	 * Set a new data to the {@code DataNode}.
	 * 
	 * @param	data	The new data.
	 */
	public function setData(data:Object):Void
	{
		_data = data;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the DataNode instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.list.DataNode";
	}
}