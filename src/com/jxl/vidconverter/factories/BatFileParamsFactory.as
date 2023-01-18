/*
	BatFileParamsFactory
	
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

import com.jxl.vidconverter.vo.parameters.ShellParametersVO;
import com.jxl.vidconverter.constants.PathConstants;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.factories.BatFileParamsFactory
{
	
	public static function getConvertFLVParams(p_encodeInfo:FCEncodeInfo):ShellParametersVO
	{
		var batFile:String = PathConstants.FFMPEG_ENCODE_DIR + "/" + PathConstants.FLV_CONVERSION_BAT;
		//DebugWindow.debugHeader();
		//DebugWindow.debug("BatFileParamsFactory::getConvertFLVParams");
		//DebugWindow.debug("batFile: " + batFile);
		
		var sp:ShellParametersVO = new ShellParametersVO(batFile,
														 p_encodeInfo.videoName,
														 null,
														 null,
														 false,
														 true,
														 true); 
		
		return sp;
	}
	
}