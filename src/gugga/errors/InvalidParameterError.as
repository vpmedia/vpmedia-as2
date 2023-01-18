class gugga.errors.InvalidParameterError extends Error{	
	public var name:String = "InvalidParameterError";
	
	public function InvalidParameterError(message:String){
		super(" !!! Error: " + message);
	}
}
