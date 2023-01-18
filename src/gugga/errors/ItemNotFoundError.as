class gugga.errors.ItemNotFoundError extends Error{	
	public var name:String = "ItemNotFoundError";
	
	public function ItemNotFoundError(message:String){
		super(" !!! Error: " + message);
	}
}