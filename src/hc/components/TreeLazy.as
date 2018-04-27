package hc.components
{
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	import mx.events.TreeEvent;
	
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	
	public class TreeLazy extends mx.controls.Tree
	{
		//取数据的url
		private var _url:String = null;
		
		//取下级数据的url
		private var _childUrl:String = null;
		
		public function TreeLazy()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{loadData()});
			this.addEventListener(TreeEvent.ITEM_OPEN,tree_itemOpenHandler);
		}
		/**
		 *远程服务端url 
		 */
		public function set url(value:String):void
		{
			_url = value;
			//加载数据
			if(this.initialized){
				loadData();
			}
		}
		/**
		 * 取下级数据的url
		 */
		public function set childUrl(value:String):void
		{
			_childUrl = value;
		}
		
		//加载数据
		private function loadData():void{
			if(Util.isNotBlank(_url)){
				HttpUtil.doPost(_url, null, function(obj:Object):void{
					dataProvider = obj;
				},null,false);
			}
		}
		
		protected function tree_itemOpenHandler(event:TreeEvent):void
		{
			if(event.type == TreeEvent.ITEM_OPEN){
				var cItem:Object = event.item;
				
				//当isLoad为false的时候才去后台去数据，取完之后把isLoad改为true
				if(String(cItem["isLoad"]) == "false" && String(cItem["isBranch"]) == "true"){
					
					if(Util.isNotBlank(_childUrl)){
						HttpUtil.doPost(_childUrl, cItem, function(obj:Object):void{
							var childArray:Array = obj as Array;
							
							if(childArray!=null && childArray.length>0){
								cItem["children"] = childArray;
								cItem["isLoad"] = true;
								
								this.dataProvider.itemUpdated(cItem);
								//aTree.dataProvider.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, -1, -1, [cItem]));
							}
						},null,false);
					}
				}
			}
		}
	}
}