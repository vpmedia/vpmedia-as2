import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.MCDuplicaton;
import pl.milib.mc.MCItem;

/**
 * @often_name *Items
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCItems extends MIBroadcastClass {
	
	public var _items : MIObjects; //of MCItem
	private var itemClass : Function;
	private var duplication : MCDuplicaton;
	private var items : MIObjects; //of MCItem
	public var objects : MIObjects;
	
	public function MCItems(itemClass:Function, $objects:MIObjects, ele0MC:MovieClip) {
		this.itemClass=itemClass;
		objects=$objects==null ? (new MIObjects()) : $objects;
		objects.addListener(this);
		items=new MIObjects();
		_items=items;
		items.addObject(new itemClass(ele0MC), 0);
		
		duplication=new MCDuplicaton(ele0MC);
		
		render();
		
	}//<>
	
	private function render(Void):Void {
		var objectsArr:Array=objects.getArray();
		for(var i=0,obj:Object;i<objectsArr.length;i++){
			obj=objectsArr[i];
			if(!items.gotValueAtIndex(i)){
				items.addObject(new itemClass(duplication.getNewMC()), i);
			}
			if(!MCItem(items.getMainValue(i))){
				logError_UnexpectedSituation(arguments, 'MCItem(items.getMainValue(i)); class must implement MCItem');
			}
			MCItem(items.getMainValue(i)).setModel(obj);
		}
		var itemsArr:Array=items.getArray();
		for(var i=objectsArr.length,item:MCItem;i<itemsArr.length;i++){
			item=itemsArr[i];
			item.disable();
		}
	}//<<
	
	public function getModelByItem(item:MCItem):Object {
		return objects.getMainValue(items.getSubByMain(item));
	}//<<
	
	public function getItemByNum(num:Number):MCItem {
		return items.getMainValue(num);
	}//<<
	
//****************************************************************************
// EVENTS for MCItems
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case objects:
				switch(ev.event){
					case objects.event_Changed:
						render();
					break;
				}
			break;
		}
	}//<<Events
	
}