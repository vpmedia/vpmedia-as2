import mx.events.EventDispatcher;
import mx.rpc.ResultEvent;
import mx.utils.Delegate;

import cinqetdemi.display.BitmapDataExporter;
import cinqetdemi.remoting.RemotingService;

import flash.display.BitmapData;
/**
 * @author Patrick
 */
class cinqetdemi.display.BitmapDataSaver 
{
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	private var bmpx : BitmapDataExporter;
	private var gatewayUrl : String;
	private var serviceName : String;

	private var service : RemotingService;

	private var bitmapId : String;

	private var exported : Boolean;
	private var blocksize:Number = 50000;

	private var bmp : BitmapData;

	private var step : Number;

	private var steps : Number;
	
	function BitmapDataSaver(gatewayUrl:String, serviceName:String)
	{
		this.gatewayUrl = gatewayUrl;
		this.serviceName = serviceName;
		EventDispatcher.initialize(this);
	}
	
	function export(bmp:BitmapData)
	{
		exported = false;
		bitmapId = null;
		
		this.bmp = bmp;

		
		var numSteps = Math.ceil(bmp.width*bmp.height/2500);

		bmpx = new BitmapDataExporter(bmp, numSteps);
		bmpx.addEventListener('progress', Delegate.create(this, onExportProgress));
		bmpx.addEventListener('complete', Delegate.create(this, onExportComplete));
		bmpx.export();
		
		service = new RemotingService(gatewayUrl, serviceName, RemotingService.NO_RETRY);
		service.getBitmapId([], this, onGetBitmapId);
	}
	
	function onExportProgress(evtObj:Object):Void
	{
		dispatchEvent({status:'export', type:'progress', complete:evtObj.complete/evtObj.total*25});
	}
	
	function onExportComplete()
	{
		trace('In onExportComplete');
		exported = true;
		if(bitmapId != null)
		{
			startSave();
		}
		else
		{
			dispatchEvent({status:'getid', type:'progress', complete:25});
		}
	}
	
	function onGetBitmapId(re:ResultEvent)
	{
		trace('in onGetBitmapId');
		trace(re.result);
		bitmapId = String(re.result);
		if(exported)
		{
			startSave();
		}
	}
	
	function startSave():Void
	{
		trace('In startSave');
		//Start saving the bitmap
		var bytes:String = bmpx.getCompressedData();
		steps = Math.ceil(bytes.length/blocksize);
		step = 0;
		sendImagePart();
		dispatchEvent({status:'send', type:'progress', complete:30});
	}
	
	function sendImagePart()
	{
		var bytes:String = bmpx.getCompressedData();
		bytes = bytes.substring(Math.floor(step/steps*bmp.height)*bmp.width*4, Math.floor((step + 1)/steps*bmp.height)*bmp.width*4); 
		service.saveImagePart([bitmapId, bytes], this, onSendImagePart);
	}
	
	function onSendImagePart()
	{
		trace('in onSendImagePart');
		step++;
		dispatchEvent({status:'send', type:'progress', complete:30+65*step/steps});
		if(step < steps)
		{
			sendImagePart();
		}
		else
		{
			//Done
			dispatchEvent({status:'save', type:'progress', complete:100});
			service.endSaveImage([bitmapId, bmp.width, bmp.height], this, onEndSaveImage);
		}
	}
	
	function onEndSaveImage()
	{
		bmp.dispose();
		dispatchEvent({type:'complete', target:this, id:bitmapId});
	}
	
	function getImageCompressed(format, quality, scope, handler):Void
	{
		service.getImageCompressed([bitmapId, format, quality], scope, handler);
	}
}