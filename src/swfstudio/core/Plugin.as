intrinsic class swfstudio.core.Plugin
{
	public function getAliasPlugin(params:Object):Void;
	public function getPluginAliases(params:Object):Void;
	public function pluginIsLoaded(params:Object):Void;
	public function getList(params:Object,callback:Object,errorCallback:Object):Object;
	public function getCommands(params:Object,callback:Object,errorCallback:Object):Object;
	public function getManifest(params:Object,callback:Object,errorCallback:Object):Object;
	public function load(params:Object,callback:Object,errorCallback:Object):Object;
	public function unload(params:Object,callback:Object,errorCallback:Object):Object;
}
