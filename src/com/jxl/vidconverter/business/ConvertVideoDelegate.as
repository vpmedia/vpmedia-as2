/*
	ConvertVideoDelegate
    
	Tell's FFMPEG.exe to convert a video file to an FLV.  The whole app
	pretty much revolves around this very Delegate; this is the core piece of functionality.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.rpc.Responder;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.ResultEvent;
import com.jxl.arp.JXLDelegate;
import com.jxl.vidconverter.vo.parameters.ShellParametersVO;
import com.jxl.vidconverter.vo.returns.ShellExecuteReturnVO;
import com.jxl.vidconverter.factories.BatFileParamsFactory;
import com.jxl.vidconverter.utils.ShellUtils;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;
import com.jxl.vidconverter.constants.VideoConverterConstants;
import com.jxl.vidconverter.constants.PathConstants;

class com.jxl.vidconverter.business.ConvertVideoDelegate extends JXLDelegate
{
	
	public function ConvertVideoDelegate(p_responder:Responder)
	{
		super(p_responder);
		
		DebugWindow.debugHeader();
		DebugWindow.debug("ConvertVideoDelegate::constructor");
	}
	
	public function convertVideo(p_encodeInfo:FCEncodeInfo):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConvertVideoDelegate::convertVideo, p_encodeInfo.videoName: " + p_encodeInfo.videoName);
		
		//var spVO:ShellParametersVO = BatFileParamsFactory.getConvertFLVParams(p_encodeInfo);
		var args:String = "";
		args += "-i";
		args += " " + p_encodeInfo.videoName;
		args += " " + p_encodeInfo.videoName.split(".")[0] + ".flv";
		
		var spVO:ShellParametersVO = new ShellParametersVO(PathConstants.FFMPEG_ENCODE_DIR + VideoConverterConstants.FFMPEG_EXE,
														   args,
														   PathConstants.FFMPEG_ENCODE_DIR,
														   null,
														   null,
														   true,
														   true);
		DebugWindow.debug("spVO: " + spVO);
		DebugWindow.debugProps(spVO);
		
		
		//var result:ShellExecuteReturnVO = ShellUtils.execute(spVO);
		var result = ShellUtils.execute(spVO);

		/*
		var result = ssCore.Shell.execute({	currentDir: "C:\\Documents and Settings\\Syle\\Desktop\\ffmpeg flash test\\",
										  	path: "C:\\Documents and Settings\\Syle\\Desktop\\ffmpeg flash test\\ffmpeg.exe", 
											arguments: "-i test.mpg test.flv",
											waitForExit: true,
											saveStdOut: true});
		*/
		DebugWindow.debug("result: " + result);
		DebugWindow.debugProps(result);
		DebugWindow.debugProps(result.Error);
		if(result.exitCode == 0)
		{
			responder.onResult(new ResultEvent(p_encodeInfo));
		}
		else
		{
			var fault:Fault = new Fault("video encoding error",
										"error", 
										"Error converting video. exitCode: " + result.exitCode + ", output: " + result.output);
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
}