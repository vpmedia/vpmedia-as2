/*
	FileSysParametersFactory
	
	Gets the necessary object to use with SWFStudio's method.  Since it's
	a complicated object, using a Factory was easier for me to code since
	I could abstract all the parameters tha method takes into a simple function
	that returns a ValueObject.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/


import com.jxl.vidconverter.vo.parameters.CopyFileParametersVO;

class com.jxl.vidconverter.factories.FileSysParametersFactory
{
	
	public static function getCopyFileParams(p_from:String, p_to:String, p_failIfExists:Boolean):CopyFileParametersVO
	{
		var cfp:CopyFileParametersVO = new CopyFileParametersVO(p_from, p_to, p_failIfExists);
		return cfp;
	}
}