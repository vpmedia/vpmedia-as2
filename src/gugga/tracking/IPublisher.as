import gugga.tracking.IFilter;
import gugga.tracking.IFormatter;
import gugga.tracking.TrackRecord;

interface gugga.tracking.IPublisher
{
	public function publish(aTrackRecord:TrackRecord):Void;
	public function setFilter(aFilter:IFilter):Void;
	public function getFilter():IFilter;
	public function setFormatter(aFormatter:IFormatter):Void;
	public function getFormatter():IFormatter;
	public function setTrackableActions(aTrackableActions:String):Void;
	public function getTrackableActions():String;
	public function isLoggable(aTrackRecord:TrackRecord):Boolean;
}