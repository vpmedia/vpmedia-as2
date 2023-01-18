/**
 * @author Todor Kolev
 * TODO: We should implement functionality(may be done in separete class) 
 * for setting up the order of generated items in case when we are generating navigation.  
 */

import mx.core.UIObject;
import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.common.EventDescriptor;
import gugga.common.IEventDispatcher;
import gugga.common.ITask;
import gugga.common.UIComponentEx;
import gugga.debug.Assertion;
import gugga.sequence.ExecuteAsyncMethodTask;
import gugga.sequence.PreconditionsTask;
import gugga.utils.DoLaterUtil;
import gugga.utils.Listener;
import gugga.utils.XML2Object;
import gugga.utils.ObjectCloner;

[Event("generationFinished")]
[Event("itemGenerated")]
[Event("itemAvailable")]
class gugga.layout.LayoutGenerator extends EventDispatcher 
{
	private var SYMBOL_IDENTIFIER_ATTRIBUTE : String = "symbol_identifier";
	private var INSTANCE_NAME_ATTRIBUTE : String = "instance_name";
	private var SUB_ITEMS_OFFSET_ATTRIBUTE : String = "sub_items_offset";
	private var SUB_ITEMS_DIRECTION_ATTRIBUTE : String = "sub_items_direction";
	
	private var mContainer : MovieClip;

	private var mDistributeAttachments : Boolean = true;
	public function get DistributeAttachments() : Boolean { return mDistributeAttachments; }
	public function set DistributeAttachments(aValue:Boolean) : Void { mDistributeAttachments = aValue; }
	
	public static function getLayoutGenerationTask(aXmlObjectOrPath : Object, aContainer : MovieClip) : ITask
	{
		var generator : LayoutGenerator = new LayoutGenerator();
		
		var task : ExecuteAsyncMethodTask = ExecuteAsyncMethodTask.createBasic(
			"generationFinished", generator, generator.generate, [aXmlObjectOrPath, aContainer]);
			
		return task;
	}
	
	public function generate(aXmlObjectOrPath : Object, aContainer : MovieClip)
	{	
		mContainer = aContainer;
		
		if(typeof(aXmlObjectOrPath) == "string")	
		{
			var navDataXml:XML = new XML();
			navDataXml["containerObject"] = this;
			navDataXml["xmlPath"] = aXmlObjectOrPath;
			navDataXml.onLoad = function (success:Boolean)
			{
				Assertion.failIfFalse(success, "XML '" + this.xmlPath + "' not loaded", this, arguments);
				
				if(success)
				{
					this.containerObject.onXmlLoad(this);
				}
			};
			navDataXml.load(String(aXmlObjectOrPath));
		}
		else if(aXmlObjectOrPath instanceof XML)
		{
			onXmlLoad(XML(aXmlObjectOrPath));
		}
		else
		{
			generateActual(aXmlObjectOrPath, mContainer);
		}
	}

	private function onXmlLoad(aNavigationDataXml:XML)
	{
		var navData = XML2Object.parse(aNavigationDataXml);
		generateActual(navData, mContainer);
	}
	
	private function generateActual(aLayoutData : Object, aContainer : MovieClip)
	{
		var rootItemData : Array = aLayoutData["items"];
		var itemsData : Array = XML2Object.getAsArray(aLayoutData["items"]["item"]);
		var itemsInitializedPreconditions : PreconditionsTask = new PreconditionsTask();
		
		var items : Array = new Array();
		
		Listener.createSingleTimeMergingListener(
			new EventDescriptor(itemsInitializedPreconditions, "completed"),
			Delegate.create(this, onItemGenerationFinished),
			{isFinal:true, subItems: items, itemData: rootItemData, parentItem : aContainer, nestingDepth: 0});
			
		if(mDistributeAttachments)
		{
			//the generateNextItem() works as stack. item should be reversed first
			itemsData.reverse();
						
			DoLaterUtil.doLater(this, generateNextItem, 
				[itemsData, aContainer, 0, itemsInitializedPreconditions, items], 1);
		}
		else
		{
			var generatedItems : Array = generateItems(itemsData, aContainer, 0, itemsInitializedPreconditions);
			
			for (var i:Number = 0; i < generatedItems.length; i++)
			{
				items.push(generatedItems[i]);
			}
			
			itemsInitializedPreconditions.start();
		}
	}	
	
	private function generateNextItem(aItemsData:Array, aParentItem:MovieClip, aNestingDepth:Number,
		aItemsInitializedPredecessorManager:PreconditionsTask, aResultItems:Array)
	{
		var itemData : Object = aItemsData.pop();
		var item : MovieClip = generateWholeItem(itemData, aParentItem, aNestingDepth, aItemsInitializedPredecessorManager);
		
		aResultItems.push(item);
		
		if(aItemsData.length > 0)
		{
			DoLaterUtil.doLater(this, generateNextItem, 
				[aItemsData, aParentItem, aNestingDepth, aItemsInitializedPredecessorManager, aResultItems], 1);			
		}
		else
		{
			aItemsInitializedPredecessorManager.start();
		}
	}
	
	private function generateWholeItem(aItemData : Object, aParentItem:MovieClip, aNestingDepth:Number,
		aParentItemsInitializedPreconditions : PreconditionsTask) : MovieClip
	{
		var item : MovieClip = generateSingleItem(aItemData, aParentItem, aNestingDepth);
		
		var subItemsData : Array = XML2Object.getAsArray(aItemData["item"]);
		var subItems : Array = null;
		var itemsInitializedPreconditionsTask : PreconditionsTask = new PreconditionsTask();
			
		if(item instanceof UIComponentEx)
		{ 
			itemsInitializedPreconditionsTask.add(
				new EventDescriptor(IEventDispatcher(item), "uiInitialized"));
		}
		
		if(subItemsData)
		{
			subItems = generateItems(subItemsData, item, aNestingDepth, itemsInitializedPreconditionsTask);
		}
		
		var itemsItitializedEventDescriptor : EventDescriptor = 
			new EventDescriptor(itemsInitializedPreconditionsTask, "completed"); 
		
		Listener.createSingleTimeMergingListener(
			itemsItitializedEventDescriptor,
			Delegate.create(this, onItemGenerationFinished),
			{isFinal:false, item: item, subItems: subItems, itemData : aItemData, 
				parentItem : aParentItem, nestingDepth: aNestingDepth}
		);
			
		aParentItemsInitializedPreconditions.add(itemsItitializedEventDescriptor);
		
		itemsInitializedPreconditionsTask.start();
		
		dispatchEvent({type: "itemAvailable", target:this, 
 			item: item, subItems: subItems, 
 			itemData : aItemData, parentItem : aParentItem, 
 			nestingDepth: aNestingDepth});
		
		return item;
	}
	
	private function generateItems(aItemsData : Object, aParentItem : MovieClip, aNestingDepth:Number,
		aItemsInitializedPredecessorManager : PreconditionsTask) : Array
	{	
		var items : Array = new Array();
		
		for (var i:Number = 0; i < aItemsData.length; i++)
		{
			var item : MovieClip = generateWholeItem(aItemsData[i], aParentItem, aNestingDepth + 1, aItemsInitializedPredecessorManager);
			items.push(item);
		}
		
		return items;
	}
	
	private function generateSingleItem(aItemData : Object, aContainer:MovieClip, aParentNestingDepth:Number)
	{
		var symbolIdentifier : String = aItemData.attributes[SYMBOL_IDENTIFIER_ATTRIBUTE];
		var instanceName : String = aItemData.attributes[INSTANCE_NAME_ATTRIBUTE];			
			
		var instance : MovieClip = createInstance(aContainer, symbolIdentifier, instanceName, aParentNestingDepth);
		
		return instance;
	}
	
	private function onItemGenerationFinished(ev)
 	{
 		var isFinal : Boolean = ev.isFinal;
 		var item : MovieClip = ev.item;
 		var subItems : Array = ev.subItems;
 		var parentItem : MovieClip = ev.parentItem;
 		var itemData : Object = ev.itemData;
 		var nestingDepth : Number = ev.nestingDepth;
 		
 		handleItemGenerationFinished(item, subItems, parentItem, itemData, nestingDepth, isFinal);
 		
 		dispatchEvent({type: "itemGenerated", target:this, 
 			item: item, subItems: subItems, 
 			itemData : itemData, parentItem : parentItem, 
 			nestingDepth: nestingDepth, isFinal : isFinal});
 		
 		if(isFinal)
 		{
 			dispatchEvent({type: "generationFinished", target:this});
 		}
 	}
 	
 	private function handleItemGenerationFinished(aItem:MovieClip, aSubItems:Array, aParentItem:MovieClip,
 		aItemData:Object, aItemNestingDepth:Number, aIsFinal:Boolean)
 	{
 		//position items
 		if(aSubItems)
 		{
	 		positionSubItems(aSubItems, aItem, aParentItem, aItemData, aItemNestingDepth);
 		}		
 		
 		if(aItem)
 		{
	 		//item is ready to be showed
	 		aItem._visible = true;
	 		 
	 		//set properties from the xml
	 		for(var key : String in aItemData.attributes)
			{
				overrideItemPropertyFromXmlValue(aItem, key, aItemData.attributes[key]);
			}
 		}
 	}
 	
 	private function overrideItemPropertyFromXmlValue(aItem:Object, aName:String, aValue:Object)
 	{
 		if(aName != SYMBOL_IDENTIFIER_ATTRIBUTE && aName != INSTANCE_NAME_ATTRIBUTE 
 			&& aName != SUB_ITEMS_OFFSET_ATTRIBUTE && aName != SUB_ITEMS_DIRECTION_ATTRIBUTE)
		{
			aItem[aName] = aValue;
		}
 	}
	
	private function createInstance(aContainer:MovieClip, aSymbolName:String, aInstanceName:String, aNestingDepth:Number) : MovieClip
	{
 		return aContainer.attachMovie(aSymbolName, aInstanceName, aContainer.getNextHighestDepth(), {_visible: false});
 	}
 	
 	private function positionSubItems(aSubItems : Array, aItem : MovieClip, aParentItem : MovieClip, aItemData : Object, aItemNestingDepth:Number)
 	{
 		var previousItem : MovieClip = null;
	 		
 		for (var i:Number = 0; i < aSubItems.length; i++)
 		{
 			var subItemsOffset : Number = Number(aItemData.attributes[SUB_ITEMS_OFFSET_ATTRIBUTE]);
 			var subItemsDirection : String = aItemData.attributes[SUB_ITEMS_DIRECTION_ATTRIBUTE];
 			
 			positionItem(MovieClip(aSubItems[i]), previousItem, i, aItemNestingDepth, subItemsDirection, subItemsOffset, aItem, aItemData);
 			
 			previousItem = aSubItems[i];
 		}
 	}
 	
 	private function positionItem(aItem:MovieClip, aPreviousItem:MovieClip, aItemIndex:Number, aItemNestingDepth:Number, 
 		aDirection:String, aOffset:Number, aParentItem:MovieClip, aRawParentItemData:Object)
 	{
 		var nextItemCoordinates:Object = getNextItemCoordinates(aItem, aPreviousItem, aDirection, aOffset);
		
		aItem._x = Math.round(nextItemCoordinates.x);
		aItem._y = Math.round(nextItemCoordinates.y);
 	}
 	
 	private function getNextItemCoordinates(aItem:MovieClip, aPreviousItem:MovieClip, aDirection:String, aOffset:Number)
 	{
 		var nextItemX:Number;
 		var nextItemY:Number;
 		
 		if(aDirection == "right")
 		{
 			if(aPreviousItem)
 			{
 				nextItemX = getClipX(aPreviousItem) + getClipWidth(aPreviousItem) + aOffset;
 				nextItemY = getClipY(aPreviousItem);
 			}
 			else
 			{
 				nextItemX = 0;
 				nextItemY = 0;
 			}
 		}
 		else if(aDirection == "left")
 		{
 			if(aPreviousItem)
 			{
 				nextItemX = getClipX(aPreviousItem) - (getClipWidth(aItem) + aOffset);
 				nextItemY = getClipY(aPreviousItem);
 			}
 			else
 			{
 				nextItemX = (-1)*(aItem.width);
 				nextItemY = 0;
 			} 			
 		}
 		else if(aDirection == "down")
 		{
 			if(aPreviousItem)
 			{
 				nextItemX = getClipX(aPreviousItem);
 				nextItemY = getClipY(aPreviousItem) + getClipHeight(aPreviousItem) + aOffset;
 			}
 			else
 			{
 				nextItemX = 0;
 				nextItemY = 0;
 			}
 		}
 		
 		return {x:nextItemX, y:nextItemY};
 	}
 	
 	private function getClipX(aClip : MovieClip) : Number
 	{
 		if(aClip instanceof UIObject)
 		{
 			return UIObject(aClip).x;
 		}
 		else
 		{
 			return aClip._x;
 		}
 	}
 	
 	private function getClipY(aClip : MovieClip) : Number
 	{
 		if(aClip instanceof UIObject)
 		{
 			return UIObject(aClip).y;
 		}
 		else
 		{
 			return aClip._y;
 		}
 	}
 	
 	private function getClipWidth(aClip : MovieClip) : Number
 	{
 		if(aClip instanceof UIObject)
 		{
 			return UIObject(aClip).width;
 		}
 		else
 		{
 			return aClip._width;
 		}
 	}
 	
 	private function getClipHeight(aClip : MovieClip) : Number
 	{
 		if(aClip instanceof UIObject)
 		{
 			return UIObject(aClip).height;
 		}
 		else
 		{
 			return aClip._height;
 		}
 	}
}