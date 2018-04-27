package hc.components.form
{
	import flash.events.Event;
	
	import spark.components.supportClasses.ItemRenderer;
	
	public class CheckBoxItemRenderer extends ItemRenderer
	{
		private var ck:CheckBox;
		
		public function CheckBoxItemRenderer()
		{
			super();
			ck = new CheckBox();
			ck.left = 5;
			ck.verticalCenter=0;
			this.height=25;
			ck.addEventListener(Event.CHANGE, ckChangeHandle);
			this.addElement(ck);
		}
		
		override public function set data(v:Object):void{
			super.data = v;
			ck.selected = v._selected;
			ck.label = v[(this.owner as ComboBox).labelField];
		}
		private function ckChangeHandle(event:Event):void{
			this.data._selected = ck.selected;
			var combobox:ComboBox = this.owner as ComboBox;
			if(combobox.type=='showAll'){//全选或反选
//				var itemObj:Object = null;
//				itemObj =  combobox.dataProvider.getItemAt(0);
//				var cb:CheckBox = this.getElementAt(0) as CheckBox;
//				if(cb.label == (event.target as CheckBox).label){
				if(ck.label == '--全部--'){
					selectAll(ck.selected,event);//只能全选中或全不选中，不能部分选中
				}
				//selectAll(itemObj._selected,event);
			}
			//应该用抛出事件的方法驱动combobox改变文本，暂时不会
//			this.dispatchEvent(new ListEvent('selectedChange'));
			combobox.updateText();
		}
		
		private function selectAll(flag:Boolean,event:Event):void{
			var combobox:ComboBox = this.owner as ComboBox;
			var itemShowAllObj:Object = null;
			for(var k:int=0;k<combobox.dataProvider.length; k++ ){
				itemShowAllObj=combobox.dataProvider.getItemAt(k);
				itemShowAllObj._selected=flag;
				combobox.dataProvider.itemUpdated(itemShowAllObj);
			}
		}
		
	}
}