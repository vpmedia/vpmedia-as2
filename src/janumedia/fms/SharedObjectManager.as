import janumedia.application;
class janumedia.fms.SharedObjectManager extends application {
	//var users_so:SharedObject;
	//var chat_so:SharedObject;
	function SharedObjectManager() {
		super();
		_global.layout_so = layout_so=SharedObject.getRemote("layout", __nc.uri, false);
		_global.users_so = users_so=SharedObject.getRemote("users", __nc.uri, false);
		_global.chat_so = chat_so=SharedObject.getRemote("message", __nc.uri, false);
		_global.poll_so = poll_so=SharedObject.getRemote("poll", __nc.uri, false);
		_global.files_so = files_so=SharedObject.getRemote("files", __nc.uri, false);
		_global.presentation_so = presentation_so=SharedObject.getRemote("presentation", __nc.uri, false);
		_global.sharedw_so = sharedw_so=SharedObject.getRemote("sharedwindow", __nc.uri, false);
		_global.videoaudio_so = videoaudio_so=SharedObject.getRemote("videoaudio", __nc.uri, false);
		layout_so.connect(__nc);
		// connect();
	}
	function connect() {
		_global.tt("[SharedObjectManager] connect");
		layout_so.connect(__nc);
		users_so.connect(__nc);
		chat_so.connect(__nc);
		poll_so.connect(__nc);
		files_so.connect(__nc);
		presentation_so.connect(__nc);
		sharedw_so.connect(__nc);
		videoaudio_so.connect(__nc);
	}
	function close() {
		_global.tt("[SharedObjectManager] close");
		//layout_so.close();
		users_so.close();
		chat_so.close();
		poll_so.close();
		files_so.close();
		presentation_so.close();
		sharedw_so.close();
		videoaudio_so.close();
	}
}
