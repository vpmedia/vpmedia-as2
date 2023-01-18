import janumedia.application;
import UI.controls.*;

class janumedia.components.peopleList extends MovieClip{
	
	private var bg,users,status:MovieClip;
	private var owner,data:Object;
	private var __userlist:Array;
	private var originalTitle:String;
	private var so:SharedObject;
	private var nc:NetConnection;
	
	function peopleList(Void){
		_global.peopleList = this;
		this.attachMovie("podType1","bg",10);
		this.attachMovie("List","users", 11, {_x:4,_y:bg.midLeft._y+4});
		this.attachMovie("ComboBoxFreeHeader","status", 12, {_x:4,_y:bg.subLeft._y});
		// user list
		users.rowColors = [15595519, 16777215];
		users.render = "userListRender";
		users.setSize(bg._width-8,bg.midLeft._height);
		// user status
		status.setSize(bg._width-8,bg.subLeft._height);
		status.addItem({label:"My Status", data:"clear_stat", icon:"icon_clear_stat"});
		status.addItem({label:"I Have a Question", data:"hand_up", icon:"icon_hands_up_stat"});
		status.addItem({label:"Go Faster", data:"go_faster", icon:"icon_go_faster_stat"});
		status.addItem({label:"Go Slower", data:"go_slower", icon:"icon_go_slower_stat"});
		status.addItem({label:"Speak Louder", data:"speak_louder", icon:"icon_speak_louder_stat"});
		status.addItem({label:"Speak Softer", data:"speak_softer", icon:"icon_speak_softer_stat"});
		status.addItem({label:"Thumbs Up", data:"thumbs_up", icon:"icon_thumbs_up_stat"});
		status.addItem({label:"Thumbs Down", data:"thumbs_down", icon:"icon_thumbs_down_stat"});
		status.addItem({label:"Away", data:"away", icon:"icon_away_stat"});
		status.listHeight = 200;
		status.addListener("open", onComboBoxOpen, this);
		status.addListener("change", onStatusChanged, this);
		status.selectedIndex = 0;
		//status.selectedItem.label = "Clear My Status";
		
		// scaller / scretch
		bg.addScaller(this);
		// fms
		nc = _global.nc;
		so = _global.users_so;
		so.owner = this;
		//so.onSync = this.onSync;
		so.onSync = function(list:Array){
			var p:peopleList = this.owner;
			p.onSync(list);
		}
		so.connect(nc);
		//onSync();
		//nc.call("peopleConnect", null);
		
		originalTitle = "PeopleList";
		
	}
	function setSize(w:Number,h:Number){
		status.setSize(w-8,bg.subLef._height);
		users.setSize(w-8,bg.midLeft._height);
	}
	function setPos(x:Number,y:Number){
		this._x = x;
		this._y = y;
	}
	function onComboBoxOpen(){
		bg.setOnTop();
	}
	function onStatusChanged(){
		/*switch(status.selectedItem.data){
			case "clear_stat":
				break
			case "hand_up":
				break;
			case "go_faster":
				break;
			case "go_slower":
				break;
			case "speak_louder":
				break;
			case "speak_softer":
				break;
			case "thumbs_up":
				break;
			case "thumbs_down":
				break;
			case "away":
				break;
		}*/
		nc.call("changeStatus", null, status.selectedItem.data);
	}
	function onSync(list:Array){
		
		bg.setTitle(originalTitle);
		users.removeAll();
		__userlist = new Array();
		_global.chatBox.users.removeAll();
		_global.chatBox.users.addItem({label:"Everyone"});
		for (var i in so.data) {
			var o 		= so.data[i];
			var mylabel = o.username;
			var mydata	= {
							id:o.id,
							username:o.username,
							firstname:o.name,
							lastname:o.lastname,
							mode:o.mode, // 0:admin, 1:host, 2: default: participant, 3 ussually as guest
							cam:o.cam,
							mic:o.mic
						}
			
			//_global.tt(o.username+" : mode "+o.mode);
			// set icon mode			
			switch(Number(o.mode)){
				case 0:
					var icon = "icon_userAdmin";
					break;
				case 1:
					var icon = "icon_userhost";
					break;
				case 2:
					var icon = "icon_userparticipant";
					break;
				default:
					var icon = "icon_userguest";
					break;
			}
			// set icon status
			switch(o.status){
				case "clear_stat": default:
					var iconStatus:String = "icon_clear_stat";
					break
				case "hand_up":
					var iconStatus:String = "icon_hands_up_stat";
					break;
				case "go_faster":
					var iconStatus:String = "icon_go_faster_stat";
					break;
				case "go_slower":
					var iconStatus:String = "icon_go_slower_stat";
					break;
				case "speak_louder":
					var iconStatus:String = "icon_speak_louder_stat";
					break;
				case "speak_softer":
					var iconStatus:String = "icon_speak_softer_stat";
					break;
				case "thumbs_up":
					var iconStatus:String = "icon_thumbs_up_stat";
					break;
				case "thumbs_down":
					var iconStatus:String = "icon_thumbs_down_stat";
					break;
				case "away":
					var iconStatus:String = "icon_away_stat";
					break;
			}
			
			users.addItem( {label:mylabel, data:mydata, icon:icon, iconStatus:iconStatus} );
			__userlist.push(mydata);
			
			//_global.tt(o.id +" : "+ _global.fmsID);
			if(o.id != _global.fmsID) {
				//_global.tt("add users : "+mylabel);
				_global.chatBox.users.addItem({label:mylabel,data:o.id});
			}
		}
		//_global.tt("Total users : "+__userlist.length);
		bg.setTitle(originalTitle+" ("+__userlist.length+")");
	}
	
	function get userlist():Array{
		return __userlist;
	}
}