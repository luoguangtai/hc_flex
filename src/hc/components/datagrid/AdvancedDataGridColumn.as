package hc.components.datagrid
{
	
	import hc.components.datagrid.itemeditor.AdvancedDataGridNumberItemEditor;
	import hc.components.datagrid.itemeditor.AdvancedDataGridTextItemEditor;
	import hc.components.datagrid.itemeditor.AdvancedDataGridZNumberItemEditor;
	import hc.components.datagrid.itemrenderer.AdvancedDataGridCheckBoxHeaderRenderer;
	import hc.components.datagrid.itemrenderer.AdvancedDataGridCheckBoxItemRenderer;
	import hc.components.datagrid.itemrenderer.AdvancedDataGridRadioButtonItemRenderer;
	import hc.util.LabelFunctionUtil;
	import hc.util.SummaryUtil;
	
	import mx.collections.ListCollectionView;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.ClassFactory;
	import mx.core.mx_internal;
	

	/**
	 * 列属性
	 * */
	public class AdvancedDataGridColumn extends mx.controls.advancedDataGridClasses.AdvancedDataGridColumn
	{
		
		//无参构造函数
		public function AdvancedDataGridColumn()
		{
			super();
			this.editable = false;
			this.setStyle("textAlign","left");
		}
		
		
		//——————————————————————————————————
		//		合计行
		//——————————————————————————————————
		/**
		 * 合计行文本
		 * 如果合计列没有设置合计函数summaryFunction,
		 * 则使用summaryText作为合计行的列值
		 */
		public var footerText:String;
		
		/**
		 * 合计计算函数
		 * summaryFunction(dataProvider, columnName):String; 
		 */
		public var summaryFunction:Function;
		
		/**
		 * 列类型
		 * text:     文本
		 * num :     数字
		 * checkboxHaveSelectAll: 有多选
		 * checkboxNoSelectAll ： 没有多选
		 * radio   ：单选
		 * */
		private var _dataType:String ;
		
		[Inspectable(type="String", enumeration="text,num,+num,rownum,checkboxHaveSelectAll,checkboxNoSelectAll,radio" , defaultValue="text")]
		public function get dataType():String
		{
			return _dataType;
		}
		public function set dataType(value:String):void
		{
			_dataType = value;
			onReadyColumnType();
		}
		
		private var _summaryFlag:String;
		
		/**
		 * 常用的统计类型 sum--求和,sum2--求和保留两位小数,avg--平均值,count--行数
		 */
		[Inspectable(category="General", enumeration="sum,sum2,avg,count")]
		public function set summaryFlag(value:String):void
		{
			switch(value.toLowerCase()){
				case "sum":
					this.summaryFunction = SummaryUtil.sum;
					break;
				case "sum2":
					this.summaryFunction = SummaryUtil.sumFloat;
					break;
				case "avg":
					this.summaryFunction = SummaryUtil.average;
					break;
				case "count":
					this.summaryFunction = SummaryUtil.count;
					break;
				default:
					break;
			}
		}
		
		//显示行号
		private function rowNumFunction(item:Object, column:int):String
		{
			var dg:AdvancedDataGrid = (this.mx_internal::owner as AdvancedDataGrid);
			if(dg.dataProvider is ListCollectionView){
				var index:int= (dg.dataProvider as ListCollectionView).getItemIndex(item)+1;
				return String(index);
			}
			else{
				return '';
			}
		}
		
		/**
		 * columbType初始化
		 * */
		private function onReadyColumnType():void{
			//文本文件
			if(_dataType =="text"){
				this.setStyle("textAlign","left");
				this.itemEditor = new ClassFactory(AdvancedDataGridTextItemEditor);
			}
			
			/**
			 * 数值
			 * */
			if(_dataType =="num"){
				this.setStyle("textAlign","right");
				this.itemEditor = new ClassFactory(AdvancedDataGridNumberItemEditor);
			}
			//正1位小数
			else if(_dataType =="+num"){
				this.setStyle("textAlign","right");
				this.itemEditor = new ClassFactory(AdvancedDataGridZNumberItemEditor);
			}
			else if(_dataType == 'rownum'){
				this.labelFunction = rowNumFunction;
				this.width = 40;
				this.headerText = '序号';
				this.sortable = false;
				this.editable = false;
			}
			/**
			 * checkbox没有多选
			 * */
			if(_dataType =="checkboxNoSelectAll"){
				this.sortable = false;
				this.editable = false;
				//TRUE | FALSE
				this.itemRenderer= new ClassFactory(AdvancedDataGridCheckBoxItemRenderer);
			}
			/**
			 * checkbox有多选
			 * */
			if(_dataType =="checkboxHaveSelectAll"){
				this.sortable = false;
				this.editable = false;
				this.width = 50;
				//TRUE | FALSE
				this.itemRenderer= new ClassFactory(AdvancedDataGridCheckBoxItemRenderer);
				this.headerRenderer= new ClassFactory(AdvancedDataGridCheckBoxHeaderRenderer);
			}
			/**
			 * radio
			 * */
			if(_dataType =="radio"){
				this.sortable = false;
				this.editable = false;
				//TRUE | FALSE
				this.itemRenderer= new ClassFactory(AdvancedDataGridRadioButtonItemRenderer);
				
			}
		}
		
		//是否显示千分位
		private var _formatThousandth:Boolean = false;
		public function set formatThousandth(v:Boolean):void{
			_formatThousandth = v;
			if(v){
				this.labelFunction = LabelFunctionUtil.formatThousandthAdvance;
			}
			else{
				this.labelFunction = null;
			}
		}
		public function get formatThousandth():Boolean{
			return _formatThousandth;
		}
		
	}
}