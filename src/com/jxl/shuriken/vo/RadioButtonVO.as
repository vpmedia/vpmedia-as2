class com.jxl.shuriken.vo.RadioButtonVO
{
	public var label:String 			= "";
	public var selected:Boolean			= false;
	public var data:Object				= undefined;
	
	public function RadioButtonVO(p_label:String, p_selected:Boolean, p_data:Object)
	{
		if(p_label != null) 			label = p_label;
		if(p_selected != null) 			selected = p_selected;
		if(p_data != null) 				data = p_data;
	}
	
	// WARNING: gets reference to data property
	public function clone():RadioButtonVO
	{
		return new RadioButtonVO(label, selected, data);
	}
	
	public function toString():String
	{
		return "[RadioButtonVO label=" + label + ", selected=" + selected + ", data=" + data + "]";
	}
	
}