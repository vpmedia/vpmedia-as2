/*
	CopyFileParametersVO
	
	Strongly typed SWFStudio parameters.
	
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

class com.jxl.vidconverter.vo.parameters.CopyFileParametersVO
{
	
	public var from:String;
	public var to:String;
	public var failIfExists:Boolean = false;
	
	public function CopyFileParametersVO(p_from:String, p_to:String, p_failIfExists:Boolean)
	{
		from = p_from;
		to = p_to;
		failIfExists = p_failIfExists;
	}

}