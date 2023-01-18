//
//	This class overrides the default NCManager class to :
//   1. Allow contentPath parameters with query strings to be used
//   2. Use the IDENT request mechanism to substitute the servername name with the IP
//       address of the optimal server, to avoid client-side proxy-server problems. 
//
//  Note: this class only works with progressive FLV and ondemand Akamai streams.
//        It does not work with live flash streams through Akamai.
//
//  Will Law - Akamai - Aug 18, 2006
//	
// distributed via Flashcomguru.com by kind permission of Akamai. 
//
// This source code is provided "as is", without warranty of any kind, express or implied. In no event shall Akamai
// Technologies be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise,
// arising from its usage. Akamai Technologies does not maintain or provide support for this source code.
//
//
import mx.utils.Delegate;
import mx.video.*;
//
class AkamaiNCManager extends NCManager implements INCManager {
	private var xml:XML;
	private var akamaiHost:String;
	public function connectToURL (url:String):Boolean {
		initOtherInfo ();
		_contentPath = url;
		if (_contentPath == null || _contentPath == undefined || _contentPath == "") {
			throw new VideoError (VideoError.INVALID_CONTENT_PATH);
		}
		// parse URL to determine what to do with it                         
		var parseResults:Object = parseURL (_contentPath);
		if (parseResults.streamName == undefined || parseResults.streamName == "") {
			throw new VideoError (VideoError.INVALID_CONTENT_PATH, url);
		}
		// connect to either rtmp or http or download and parse smil                         
		if (parseResults.isRTMP) {
			// Check to see if we are dealing with an Akamai URL
			if (isAkamaiStreamingURL (url)) {
				// Check to see if that serverName has already been processed
				if (akamaiHost == parseResults.serverName) {
					_streamName = _contentPath.slice (_contentPath.indexOf ("ondemand/") + 9, _contentPath.length);
					if (_streamName.slice (-4).toLowerCase () == ".flv") {
						_streamName = _streamName.slice (0, -4);
					}
					// if this hostname is already in use then reuse the existing connection        
					return true;
				}
				else {
					try {
						xml = new XML ();
						xml.ignoreWhite = true;
						xml.onLoad = Delegate.create (this, this.xmlOnLoad);
						xml.load ("http://" + parseResults.serverName + "/fcs/ident");
						return false;
					} catch (err:Error) {
						_nc = undefined;
						_owner.ncConnected ();
						throw err;
					}
				}
			}
			else {
				var canReuse:Boolean = canReuseOldConnection (parseResults);
				_isRTMP = true;
				_protocol = parseResults.protocol;
				_streamName = parseResults.streamName;
				_serverName = parseResults.serverName;
				_wrappedURL = parseResults.wrappedURL;
				_portNumber = parseResults.portNumber;
				_appName = parseResults.appName;
				if (_appName == undefined || _appName == "" || _streamName == undefined || _streamName == "") {
					throw new VideoError (VideoError.INVALID_CONTENT_PATH, url);
				}
				_autoSenseBW = (_streamName.indexOf (",") >= 0);
				return (canReuse || connectRTMP ());
			}
		}
		else {
			if (parseResults.streamName.toLowerCase ().indexOf (".flv") != -1) {
				var canReuse:Boolean = canReuseOldConnection (parseResults);
				_isRTMP = false;
				_streamName = parseResults.streamName;
				return (canReuse || connectHTTP ());
			}
			if (parseResults.streamName.indexOf ("/fms/fpad") >= 0) {
				try {
					return connectFPAD (parseResults.streamName);
				} catch (err:Error) {
					// just use SMILManager if there is any error
					//ifdef DEBUG
					//debugTrace("fpad error: " + err);
					//endif
				}
			}
			_smilMgr = new SMILManager (this);
			return _smilMgr.connectXML (parseResults.streamName);
		}
	}
	private function xmlOnLoad (success:Boolean) {
		try {
			if (!success) {
				_nc = undefined;
				_owner.ncConnected ();
			}
			else {
				var ipNode = xml.firstChild.firstChild;
				if (ipNode.nodeName != "ip") {
					throw new VideoError (VideoError.INVALID_XML, "URL: \"" + _contentPath + "\" did not return a valid XML when queried using IDENT");
				}
				else {
					var parseResults:Object = parseURL (_contentPath);
					akamaiHost = parseResults.serverName;
					_isRTMP = true;
					_protocol = parseResults.protocol;
					_streamName = parseResults.streamName;
					//_serverName = parseResults.serverName;
					_appName = parseResults.appName;
					_streamName = _contentPath.slice (_contentPath.indexOf ("ondemand/") + 9, _contentPath.length);
					_serverName = ipNode.firstChild.toString ();
					_wrappedURL = parseResults.wrappedURL;
					_portNumber = parseResults.portNumber;
					_appName = "ondemand?_fcs_vhost=" + parseResults.serverName;
					if (_streamName.slice (-4).toLowerCase () == ".flv") {
						_streamName = _streamName.slice (0, -4);
					}
					trace ("Using the Akamai FMS server at: " + _serverName);
					trace ("The stream name is:" + _streamName);
					if (_appName == undefined || _appName == "" || _streamName == undefined || _streamName == "") {
						throw new VideoError (VideoError.INVALID_CONTENT_PATH, _contentPath);
					}
					connectRTMP ();
				}
			}
		} catch (err:Error) {
			_nc = undefined;
			_owner.ncConnected ();
			throw err;
		}
	}
	private function isAkamaiStreamingURL (url:String):Boolean {
		return (url.toLowerCase ().indexOf ("edgefcs.net/") != -1);
	}
}
