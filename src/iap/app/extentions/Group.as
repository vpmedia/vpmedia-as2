/*
 *This file is part of MovieClipCommander Framework.
 *
 *   MovieClipCommander Framework  is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    MovieClipCommander Framework is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with MovieClipCommander Framework; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
 import iap.app.GlobalParams;
import iap.app.groups.GroupsManager;

/**
* Group member identification and managment for AppCommander
* ----------------------------------------------------------
* Provids a port to manage one member id of a group.
* E.g. like "dog" in group of "animal"
* Can be instenciated several times for belonging to several groups
* 
* @TODO	this class needs to be refactored and seperated from exlosive group member
* 	then, a better documentation would be written...
* 
* @author      I.A.P Itzik Arzoni (itzik.mcc@gmail.com)
*/
class iap.app.extentions.Group extends iap.services.Service implements iap.app.groups.IGroupMember{
	private var __status:String;
	private var __groupName:String;
	private var __groupId:String;
	private var __exlusive:Boolean;
	private var __groupManager:iap.app.groups.Group;
	private var __paramName:String;
	
	/**
	* initialize group extention 
	* @param	groupName	a group name to join
	* @param	status	the initial	of the group member
	*/
	private function init(groupName:String, status:String) {
		if (groupName == undefined && status == undefined) {
			trace("~5ERROR: wrong number of parameters passed to group init of "+__commander);
		}
		__status = status;
		__groupName = groupName;
		__groupId = __name;
		setGroupManager(GroupsManager.joinToGroup(this, __groupName));
		__exlusive = true;
		__paramName = "selected";
		__commander.addEventListener("paramChange", this);
		GlobalParams.registerParamsSet([__groupName], __commander["_params"]);
	}

	/**
	* With a group of selectable objects, select (or deselect)
	* this group.
	* @param	flag	true, to select this and deselect all
	*/
	public function select(flag:Boolean) {
		setGroupStatus(__groupId);
		__status = String(flag);
		__groupManager.setStatus(this, flag);
	}
	
	public function registerGlobalGroup() {
		__commander["_params"].registerGlobalParam(__paramName);
	}
	
	/**
	* register a group manager to this group extention
	* @param	gmanager	a manager to register
	*/
	public function setGroupManager(gmanager:iap.app.groups.Group) {
		__groupManager = gmanager;
		__groupManager.exlusiveStatus = true;
		//__groupManager.addMember(this);
	}

	/**
	* sets a string status of the group member.
	* as oppose to "select" this method only changes this
	* group member
	* @param	status	a string status
	*/
	public function setGroupStatus(status:String) {
//		trace("~2 setGroupStatus: "+[this, status]);
		__status = status;
		__commander["_params"].setParam(__paramName, status);
	}
	
	/**
	* return the groups member status
	* @return	a string
	*/
	public function getGroupStatus():String {
		return __status;
	}
	
	/**
	* parameter change handler
	*/
	private function paramChange(evt:Object) {
		switch (evt.name) {
			case __paramName:
				__status = String(evt.value);
				__groupManager.select(this, (__status == "true"));
				break;
			case __groupName:
				__groupManager.selectMember(evt.value);
				break;
		}
	}
	
	/**
	* unique identification of the member for the group
	*/
	public function getGroupId():String {
		return __groupId;
	}
	public function setGroupId(val:String) {
		__groupId = val
	}
	
	/**
	* returns the selected member's id, in an exclsive group
	*/
	public function get selected():String {
		return	__groupManager.selected.getGroupId();
	}
	
	/**
	* The parameter name in _params extention that contain the
	* group status
	*/
	public function get paramName():String {
		return __paramName;
	}
	public function set paramName( val:String ):Void {
		__paramName = val;
	}
	
	/**
	* The name of the group.
	*/
	public function get groupName():String	{
		return __groupName;
	}
	public function set groupName(val:String):Void	{
		__groupName = val;
	}

	
	/**
	* Usualy with boolean status, only this member can get "true"
	* set exclusive to true, to make this happen
	*/
	public function get exlusive():Boolean	{
		return __exlusive;
	}
	public function set exlusive( val:Boolean ):Void	{
		__groupManager.exlusiveStatus = val;
		__exlusive = val;
	}
	
	/**
	* @return a string representation of the class
	*/
	public function toString():String {
		return "[Group "+__name+" for "+__commander["_name"]+"]";
	}
}
