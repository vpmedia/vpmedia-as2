/*
	CopyFileDelegate
    
	Tell's SWFStudio to copy a file from one diretory to another.
    
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
import com.jxl.vidconverter.vo.parameters.CopyFileParametersVO;
import com.jxl.vidconverter.factories.FileSysParametersFactory;
import com.jxl.vidconverter.utils.FileSysUtils;
import com.jxl.vidconverter.constants.PathConstants;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.business.CopyFileDelegate extends JXLDelegate
{
	
	public function CopyFileDelegate(p_responder:Responder)
	{
		super(p_responder);
	}
	
	public function copyFile(p_encodeInfo:FCEncodeInfo):Void
	{
		var dirFrom:String 	= PathConstants.FFMPEG_ENCODE_DIR + "/" + p_encodeInfo.videoName;
		var dirTo:String 	= PathConstants.FCS_STREAMS_DIR + "/" + p_encodeInfo.videoName;
		
		var cfpVO:CopyFileParametersVO = FileSysParametersFactory.getCopyFileParams(dirFrom, dirTo, false);
		var result:CopyFileParametersVO = FileSysUtils.copyFile(cfpVO);
		// TODO: figure out what the result REALLY is... I don't think the docs were clear
		
		//if(result.exitCode == 0)
		//{
			responder.onResult(new ResultEvent(p_encodeInfo));
		//}
		//else
		//{
			//var fault:Fault = new Fault(p_videoName,
										//"error", 
										//"Error converting video. exitCode: " + result.exitCode + ", output: " + result.output);
			//var fe:FaultEvent = new FaultEvent(fault);
			//responder.onFault(fe);
		//}
	}
	
}