import mx.controls.Tree;
import mx.utils.Delegate;


import gugga.common.UIComponentEx;

 
//TODO: Redesign this class in order to work with new navigation model

//import gugga.navigation.Navigation;
class gugga.navigation.TreeNavigation extends UIComponentEx{ //Old Navigation class has been removed
	private var TreeComponent:Tree;
	private var newSelectionToBeSet:XMLNode;
	
	public function set cellRenderer(value:String):Void{
		TreeComponent.cellRenderer = value;
	}
	
	function TreeNavigation(){
	}
	
	function _initUI(){	
		TreeComponent.visible = false;

		TreeComponent.addEventListener("change",Delegate.create(this,onNavItemSelected));
		TreeComponent.addEventListener("nodeOpen",Delegate.create(this,onNavItemOpen));
		
		super._initUI();
	}
	
	public function initialize(itemsXmlFilePath:String, cellRenderer:String, style:Object, configurationFunction:Function){
		if(cellRenderer && cellRenderer!=""){
			TreeComponent.cellRenderer = cellRenderer;
		}
		
		if(style){
			TreeComponent.setStyle("styleName",style);
			//for(var key:String in style){}
		}
		if(configurationFunction){
			configurationFunction.call(this);
		}
		configure();
	
		if(itemsXmlFilePath && itemsXmlFilePath!=""){
			var navigationInfo:Object = new XML();
			navigationInfo.ignoreWhite = true;
			navigationInfo.TreeNavigationInstance = this;
			navigationInfo.onLoad = function(success) {
				this.TreeNavigationInstance.setTreeNodes(navigationInfo.toString());
			};
			navigationInfo.load(itemsXmlFilePath);
		}
	}
	
	public function setTreeNodes(nodesXmlAsString:String){
		TreeComponent.dataProvider = new XML(nodesXmlAsString);
		_itemsLoaded();
	}
	
	private function _itemsLoaded(){
		TreeComponent.visible = true;
		
		itemsLoaded();
	}
	
	private function configure(){} //overridable. user for configuration by the child objects
	private function itemsLoaded(){} //overridable
	
	//-----------------------------------------------------------------
	
	function onNavItemSelected(ev){
		var selection = TreeComponent.selectedNode.attributes.open_view;
		//dispatchChangedEvent(selection, TreeComponent.selectedNode);
				
		SetSelectedItem(TreeComponent.selectedNode.attributes.id, true);
	}
	
	function onNavItemOpen(ev){		
// 		if(newSelectionToBeSet.firstChild!=null && (!newSelectionToBeSet.attributes.open_view)){
// 			TreeComponent.selectedNode = newSelectionToBeSet.firstChild;
// 		}else{
// 			TreeComponent.selectedNode = newSelectionToBeSet;
// 		}
// 		dispatchChangedEvent(TreeComponent.selectedNode.attributes.open_view, TreeComponent.selectedNode);
	}
	
	//-----------------------------------------------------------------
	
	public function get SelectedItem():String{
		return TreeComponent.selectedNode.attributes.id;
	}
	
	public function set SelectedItem(value:String):Void{
		SetSelectedItem(value, false);
	}
	
	private function FindOpenedFolder():XMLNode{
		var xmlData = TreeComponent.dataProvider;
		var item = xmlData.firstChild;
		
		while(item){
			if(TreeComponent.getIsOpen(item)){
				return item;
			}
			item = item.nextSibling;
		}
	}
	
	private function FindFolderByID(folderID:String):XMLNode{
		var xmlData = TreeComponent.dataProvider;
		var item = xmlData.firstChild;
		
		while(item){
			if(item.attributes.id == folderID){
				return item;
			}
			item = item.nextSibling;
		}
	}
	
	private function FindFolderByChildID(childID:String):XMLNode{
		var xmlData = TreeComponent.dataProvider;
		var item = xmlData.firstChild;
		var child;
		
		while(item){
			child = item.firstChild;
			while(child){
				if(child.attributes.id == childID){
					return item;
				}
				child = child.nextSibling;
			}
			item = item.nextSibling;
		}
	}
	
	private function FindNodeByID(nodeID:String):XMLNode{
		var xmlData = TreeComponent.dataProvider;
		var item = xmlData.firstChild;
		var child;
		
		while(item){
			if(item.attributes.id == nodeID){
				return item;
			}
			
			child = item.firstChild;

			while(child){
				if(child.attributes.id == nodeID){
					return child;
				}
				child = child.nextSibling;
			}
			item = item.nextSibling;
		}
	}
	
	public function SetSelectedItem(value:String, fireEvent:Boolean){	
		var openNode:XMLNode;
		var closeNode:XMLNode = FindOpenedFolder();
		var newSelection = FindNodeByID(value);
		var selectedNodeParent:XMLNode = newSelection.parentNode;
		
		//select first child if folder (or node without open_view) is selected
		if(newSelection.firstChild!=null && (!newSelection.attributes.open_view)){
			newSelection = newSelection.firstChild;
		}
		
		if(!selectedNodeParent.parentNode){//the node is not just under the root
			openNode = FindFolderByID(value);
		}else{
			openNode = FindFolderByChildID(value);
		}
		
		if(openNode == closeNode){
			TreeComponent.selectedNode = newSelection;
			if(fireEvent){
				dispatchChangedEvent(TreeComponent.selectedNode.attributes.open_view, TreeComponent.selectedNode);
			}
			return;
		}
				
		if(closeNode){
			var listenerClose = new Object();
			listenerClose.OpenNode = openNode;
			listenerClose.TreeComponent = TreeComponent;
			listenerClose.nodeClose = function (){
				this.TreeComponent.removeEventListener("nodeClose",this);
				this.TreeComponent.setIsOpen(this.OpenNode, true, true, true);
			};
			
			var listenerOpen = new Object();
			listenerOpen.fireEvent = fireEvent;
			listenerOpen.SelectNode = newSelection;
			listenerOpen.TreeComponent = TreeComponent;
			listenerOpen.Controller = this;
			listenerOpen.nodeOpen = function (){
				//trace("---------- ON OPEN FINISHED " + this.TreeComponent.selectedNode);
				this.TreeComponent.removeEventListener("nodeOpen",this);
				
				this.TreeComponent.selectedNode = this.SelectNode;
				if(this.fireEvent){
		 			this.Controller.dispatchChangedEvent(this.TreeComponent.selectedNode.attributes.open_view, this.TreeComponent.selectedNode);
		 		}
			};
			
			TreeComponent.addEventListener("nodeClose",listenerClose);
			TreeComponent.addEventListener("nodeOpen",listenerOpen);
			
			TreeComponent.setIsOpen(closeNode,false,true,true);
		}else{
			this.TreeComponent.setIsOpen(openNode, true, true, true);
		}
		
		//newSelectionToBeSet = newSelection;
	}
	
	//-----------------------------------------------------------------
	
	public function GetFolderIDByItemID(id:String){
		var node = FindFolderByChildID(id);
		if(!node){
			node = FindFolderByID(id);
		}
		return node.attributes.id;
	}
	
	private function dispatchChangedEvent(item, id:String, additionalData){
		dispatchEvent({type:"navigate", item:item, id:id, additionalData:additionalData, target:this});
	}
}