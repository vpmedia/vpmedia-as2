import mx.events.EventDispatcher
import jxl.flashcom.core.Responder

class jxl.flashcom.admin.AdminAPIProxy
{
	/* Events
		- ping
	*/
	
	public var nc:NetConnection;
	
	private var inited:Boolean = false;
	private var startTime:Date;
	
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	function AdminAPIProxy()
	{
		init.apply(this, arguments);
	}
	
	public function init(p_nc:NetConnection):Void
	{
		nc = p_nc;
		if(!inited){
			inited = true;
			EventDispatcher.initialize(AdminAPIPRoxy.prototype);
		}
	}
	
	// Add an Admin
	public function addAdmin(adminName:String, password:String, scope)
	{
		var r:Responder = new Responder();
		r.setResultHandler("onAddAdmin", this);
		if(scope == null){
			nc.call("addAdmin", r, adminName, password);
		}else{
			nc.call("addAdmin", r, adminName, password, scope);
		}
	}
	
	private function onAddAdmin(o:Object):Void
	{
		dispatchEvent({type: "onAddAdmin", target: this, resultObject: o});
	}
	
	// Add an Application
	public function addApp(appName:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onAddApp", this);
		nc.call("addApp", r, appName);
	}
	
	private function onAddApp(o:Object):Void
	{
		dispatchEvent({type: "onAddApp", target: this, resultObject: o});
	}
	
	// Change Password
	public function changePswd(adminName:String, password:String, scope):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onChangePswd", this);
		if(scope == null){
			nc.call("changePswd", r, adminName, password);
		}else{
			nc.call("changePswd", r, adminName, password);
		}
	}
	
	private function onChangePswd(o:Object):Void
	{
		dispatchEvent({type: "onChangePswd", target: this, resultObject: o});
	}
	
	// Garbage Collection
	public function gc(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGC", this);
		nc.call("gc", r);
	}
	
	private function onGC(o:Object):Void
	{
		dispatchEvent({type: "onGC", target: this, resultObject: o});
	}
	
	// Active Application Instances
	public function getActiveInstances(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onActiveInstances", this);
		nc.call("getActiveInstances", r);
	}
	
	private function onActiveInstances(o:Object):Void
	{
		dispatchEvent({type: "onActiveInstances", target: this,
					  resultObject: o, activeInstances: o.data});
	}
	
	// Adaptors
	public function getAdaptors(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onAdaptors", this);
		nc.call("getAdaptors", r);
	}
	
	private function onAdaptors(o:Object):Void
	{
		dispatchEvent({type: "onAdaptors", target: this,
					  resultObject: o, adaptors: o.data});
	}
	
	// Administrator Context
	public function getAdminContext(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onAdminContext", this);
		nc.call("getAdminContext", r);
	}
	
	private function onAdminContext(o:Object):Void
	{
		dispatchEvent({type: "onAdminContext", target: this, resultObject: o, 
					  adminType: o.admin_type, adaptor: o.adaptor, vhost: o.vhost,
					  connected: o.connected});
	}
	
	// Get Applications
	public function getApps(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetApps", this);
		nc.call("getApps", r);
	}
	
	private function onGetApps(o:Object):Void
	{
		dispatchEvent({type: "onGetApps", target: this, resultObject: o,
					  apps: o.data});
	}
	
	// Get Application Stats
	public function getAppStats(appName:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetAppStats", this);
		nc.call("getAppStats", r, appName);
	}
	
	private function onGetAppStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetAppStats", target: this, resultObject: o,
					  launchTime: d.launch_time, upTime: d.up_time,
					  msgIn: d.msg_in, msgOut: d.msg_out,
					  msgDropped: d.msg_dropped, bytesIn: d.bytes_in, 
					  bytesOut: d.bytes_out, accepted: d.accepted,
					  rejected: d.rejected, connected: d.connected,
					  totalConnects: d.total_connects, totalDisconnects: d.total_disconnects,
					  totalInstancesLoaded: d.total_instances_loaded,
					  totalInstancesUnloaded: d.total_instances_unloaded});
	}
	
	// Get Configuration
	public function getConfig(key:String, scope):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetConfig", this);
		if(scope == null){
			nc.call("getConfig", r, key);
		}else{
			nc.call("getConfig", r, key, scope);
		}
	}
	
	private function onGetConfig(o:Object):Void
	{
		dispatchEvent({type: "onGetConfig", target: this, resultObject: o,
					  configXML: o.data});
	}
	
	// Get Application Instance Stats
	public function getInstanceStats(appInstance:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetInstanceStats", this);
		nc.call("getInstanceStats", r, appInstance);
	}
	
	private function onGetInstanceStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetInstanceStats", target: this, resultObject: o,
					  launchTime: d.launch_time, upTime: d.up_time,
					  msgIn: d.msg_in, msgOut: d.msg_out,
					  msgDropped: d.msg_dropped, bytesIn: d.bytes_in,
					  bytesOut: d.bytes_out, accepted: d.accepted,
					  rejected: d.rejected, connected: d.connected,
					  totalConnects: d.total_connects, totalDisconnects: d.total_disconnects,
					  scriptTimeHighWaterMark: d.script.time_high_water_mark,
					  scriptQueueSize: d.script.queue_size,
					  scriptTotalProcessed: d.script.total_processed,
					  scriptTotalProcessTime: d.script.totalProcessTime,
					  scriptQueueHighWaterMark: d.script.queue_high_water_mark});
	}
	
	// Get Network I/O Stats
	public function getIOStats(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetIOStats", this);
		nc.call("getIOStats", r, appInstance);
	}
	
	private function onGetIOStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetIOStats", target: this, resultObject: o,
					  msgIn: d.msg_in, msgOut: d.msg_out,
					  bytesIn: d.bytes_in, bytesOut: d.bytes_out,
					  reads: d.reads, writes: d.writes,
					  connected: d.connected, totalConnects: d.total_connects,
					  totalDisconnects: d.total_disconnects, msgDropped: d.msg_dropped,
					  tunnelBytesIn: d.tunnel_bytes_in, tunnelBytesOut: d.tunnel_bytes_out,
					  tunnelRequests: d.tunnel_requests, tunnelResponses: d.tunnel_responses,
					  tunnelIdleRequests: d.tunnel_idle_requests,
					  tunnelIdelResponses: d.tunnel_idle_responses});
					  
	}
	
	// Get License Info
	public function getLicenseInfo(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetLicenseInfo", this);
		nc.call("getLicenseInfo", r);
	}
	
	private function onGetLicenseInfo(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetLicenseInfo", target: this, resultObject: o,
					  name: d.name, version: d.version,
					  build: d.build, copyright: d.copright,
					  key: d.key, type: d.type,
					  family: d.family, edition: d.edition,
					  maxConnections: d.max_connections, maxAdaptors: d.max_adaptors,
					  maxVhosts: d.max_vhosts, maxCpu: d.max_cpu,
					  maxBandwidth: d.max_bandwidth,
					  keyDetails: d.key_details});
	}
	
	// Get Live Streams
	public function getLiveStreams(appInstance:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetLiveStreams", this);
		nc.call("getLiveStreams", r, appInstance);
	}
	
	private function onGetLiveStreams(o:Object):Void
	{
		dispatchEvent({type: "onGetLiveStreams", target: this, resultObject: o,
					  streams: o.data});
	}
	
	// Get Live Stream Stats
	public function getLiveStreamStats(appInstance:String, streamName:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetLiveStreamStats", this);
		nc.call("getLiveStreamStats", r, appInstance, streamName);
	}
	
	private function onGetLiveStreamStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetLiveStreamStats", target: this, resultObject: o,
					  publisher: d.publisher, subscribers: d.subscribers});
	}
	
	// Message Cache Stats
	public function getMsgCacheStats(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetMsgCacheStats", this);
		nc.call("getMsgCacheStats", r);
	}
	
	private function onGetMsgCacheStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetMsgCacheStats", target: this, resultObject: o,
					  allocated: d.allocated, reused: d.reused, size: d.size});
	}
	
	// Get NetStreams
	public function getNetStreams(appInstance:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetNetStreams", this);
		nc.call("getNetStreams", r, appInstance);
	}
	
	private function onGetNetStreams(o:Object):Void
	{
		dispatchEvent({type: "onGetNetStreams", target: this, resultObject: o,
					  streams: o.data});
	}
	
	// Get NetStream Stats
	public function getNetStreamStats(appInstance, netStreamID):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetNetStreamStats", this);
		nc.call("getNetStreamStats", r, appInstance, netStreamID);
	}
	
	private function onGetNetStreamStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetNetStreamStats", target: this, resultObject: o,
					streamID: d.stream_id, name: d.name, type: d.type,
					client: d.client, time: d.time});
	}
	
	// Script Stats
	public function getScriptStats(appInstance:String):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetScriptStats", this);
		nc.call("getScriptStats", r, appInstance);
	}
	
	private function onGetScriptStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetScriptStats", target: this, resultObject: o,
					  timeHighWaterMark: d.time_high_water_mark,
					  queueSize: d.queue_size, totalProcessed: d.total_processed,
					  totalProcessTime: d.total_process_time,
					  queueHighWaterMark: d.queue_high_water_mark});
	}
	
	// Get Server Stats
	public function getServerStats(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onGetServerStats", this);
		nc.call("getServerStats", r);
	}
	
	private function onGetServerStats(o:Object):Void
	{
		var d = o.data;
		dispatchEvent({type: "onGetServerStats", target: this, resultObject: o,
					  launchTime: d.launch_time, upTime: d.up_time,
					  
					  msgIn: d.io.msg_in, msgOut: d.io.msg_out,
					  bytesIn: d.io.bytes_in, bytesOut: d.io.bytes_out,
					  reads: d.io.reads, writes: d.io.writes,
					  connected: d.io.connected, totalConnects: d.io.total_connects,
					  totalDisconnects: d.io.total_disconnects,
					  
					  allocated: d.msg_cache.allocated,
					  reused: d.msg_cache.reused,
					  size: d.msg_cache.size,
					  
					  memoryUsage: d.memory_Usage,
					  cpuUsage: d.cpu_Usage});
					  
	}
	
	// Get Shared Objects
	public function getSharedObjects(appInstance:String):Void
	{
		
	}
	
	
	
	
	
	// Ping
	public function ping(Void):Void
	{
		var r:Responder = new Responder();
		r.setResultHandler("onPing", this);
		startTime = new Date();
		nc.call("ping", r);
	}
	
	private function onPing(o:Object):Void
	{
		var currentTime = o.timestamp;
		var ctm = currentTime.getMilliseconds();
		var stm = startTime.getMilliseconds();
		var time = (ctm - stm);
		dispatchEvent({type: "onPing", target: this,
					   resultObject: o, time: time});
	}
	
	

nc.call("getActiveInstances", r);

nc.call("getAdaptors", r);
nc.call("getAdminContext", r);
nc.call("getApps", r);
//nc.call("getAppStats", r, "appName");
nc.call("getConfig", r, "Server", "/");
//nc.call("getInstanceStats", r, "appInstance");
nc.call("getIOStats", r);
nc.call("getLicenseInfo", r);
//nc.call("getLiveStreams", r, "appInstance");
//nc.call("getLiveStreamStats", r, "appInstance", "streamName");
nc.call("getMsgCacheStats", r);
//nc.call("getNetStreams", r, "appInstance");
//nc.call("getNetStreamStats", r, "appInstance", "netStreamID");
//nc.call("getScriptStats", r, "appInstance");
nc.call("getServerStats", r);
//nc.call("getSharedObjects", r, "appInstance");
//nc.call("getSharedObjectStats", r, "app_instance", "object_name", "persistence");
//nc.call("getUsers", r, "appInstance");
//nc.call("getUserStats", r, "appInstance", "userID");
nc.call("getVHosts", r);
//nc.call("getVHosts", r, "adaptorName");
nc.call("getVHostStats", r);
//nc.call("getVHostStats", r, "adaptorName", "vhostName");

function u(){
d = new Date();
nc.call("ping", r);
}

setInterval(this, "u", 1000);
 
 
 

 
}