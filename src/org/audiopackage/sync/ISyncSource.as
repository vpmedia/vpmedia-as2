import org.audiopackage.sync.ISyncListener;

interface org.audiopackage.sync.ISyncSource
{
	function startSync( Void ): Void;
	function stopSync( Void ): Void;
	function addListener( listener: ISyncListener ): Void;
	function removeListener( listener: ISyncListener ): Boolean;
}