package hc.util
{
	import mx.controls.Tree;

	public class TreeUtil
	{
		//找出应该选中的节点
		public static function getItemFromTreeData(obj:Object, keyName:String, keyValue:String):Object{
			var item:Object;
			if(obj[keyName] == keyValue){
				item = obj;
			}
			else if(obj.hasOwnProperty("children")){
				for(var i:int = 0; i<obj.children.length; i++){
					item = getItemFromTreeData(obj.children[i], keyName, keyValue);
					if(item){
						break;
					}
				}
			}
			return item;
		}
		
		//展开Tree
		public static function expandTree(tree:Tree, expandChild:Boolean=true):void{
			//刷新
			tree.validateNow();
			//全部展开
			tree.selectedIndex=0;
			if(expandChild){
				tree.expandChildrenOf(tree.selectedItem, true);
			}
			else{
				tree.expandItem(tree.selectedItem, true);
			}
			tree.selectedIndex=-1;
		}
	}
}