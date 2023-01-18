/**
 * data holder
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.data.info.MIEventInfo {
	
	public var hero:Object;
	public var event:Object;
	public var data;
	
	public function MIEventInfo(hero:Object, event:Object, $data) {
		this.hero=hero;
		this.event=event;
		this.data=$data;
	}//<>
	
}