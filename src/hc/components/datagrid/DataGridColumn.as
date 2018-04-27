package hc.components.datagrid
{
	import hc.components.datagrid.itemeditor.DataGridNumberItemEditor;
	import hc.components.datagrid.itemeditor.DataGridTextItemEditor;
	import hc.components.datagrid.itemrenderer.DataGridCheckBoxHeaderRenderer;
	import hc.components.datagrid.itemrenderer.DataGridCheckBoxItemRenderer;
	import hc.components.datagrid.itemrenderer.DataGridNumberItemRenderer;
	import hc.components.datagrid.itemrenderer.DataGridRadioButtonItemRenderer;
	import hc.components.datagrid.itemrenderer.DataGridTextItemRenderer;
	import hc.util.LabelFunctionUtil;
	import hc.util.SummaryUtil;
	import hc.util.Util;
	
	import mx.collections.IList;
	import mx.core.ClassFactory;
	
	import spark.components.gridClasses.GridColumn;

	public class DataGridColumn extends GridColumn
	{
		public function DataGridColumn()
		{
			super();
			//默认不能编辑、不能排序
			this.editable = false;
			this.sortable = false;
		}
		
		/**
		 * 列类型
		 * text:     文本
		 * num :     数字
		 * checkboxHaveSelectAll: 有多选
		 * checkboxNoSelectAll ： 没有多选
		 * radio   ：单选
		 * */
		private var _dataType:String = 'text';
		
		[Inspectable(type="String", enumeration="text,num,rownum,checkboxHaveSelectAll,checkboxNoSelectAll,radio" , defaultValue="text")]
		public function set dataType(value:String):void
		{
			_dataType = value;
			onReadyColumnType();
		}
		
		//显示行号
		private function rowNumFunction(item:Object, column:int):String
		{
			var index:int=this.grid.dataProvider.getItemIndex(item) + 1;
			return String(index);
		}
		
		/**
		 * columbType初始化
		 * */
		private function onReadyColumnType():void{
			//文本
			if(_dataType =="text"){
				this.itemRenderer = new ClassFactory(DataGridTextItemRenderer);
				this.itemEditor = new ClassFactory(DataGridTextItemEditor);
			}
			
			/**
			 * 数字
			 * */
			else if(_dataType =="num"){
				this.itemRenderer = new ClassFactory(DataGridNumberItemRenderer);
				this.itemEditor = new ClassFactory(DataGridNumberItemEditor);
			}
			
			else if(_dataType == 'rownum'){
				this.labelFunction = rowNumFunction;
				this.width = 40;
				this.headerText = '序号';
				this.sortable = false;
				this.editable = false;
				this.itemRenderer = new ClassFactory(DataGridTextItemRenderer);
			}
			
			/**
			 * checkbox没有全选
			 * */
			else if(_dataType =="checkboxNoSelectAll"){
				this.sortable = false;
				this.editable = false;
				this.itemRenderer = new ClassFactory(DataGridCheckBoxItemRenderer);
			}
			
			/**
			 * checkbox有全选
			 * */
			else if(_dataType =="checkboxHaveSelectAll"){
				this.sortable = false;
				this.editable = false;
				this.width = 50;
				this.headerText ="";
				this.itemRenderer = new ClassFactory(DataGridCheckBoxItemRenderer);
				this.headerRenderer = new ClassFactory(DataGridCheckBoxHeaderRenderer);
			}
			
			/**
			 * radio
			 * */
			else if(_dataType =="radio"){
				this.sortable = false;
				this.editable = false;
				//TRUE | FALSE
				this.itemRenderer = new ClassFactory(DataGridRadioButtonItemRenderer);
			}
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
		
		//是否显示千分位
		private var _formatThousandth:Boolean = false;
		public function set formatThousandth(v:Boolean):void{
			_formatThousandth = v;
			if(v){
				this.labelFunction = LabelFunctionUtil.formatThousandth;
			}
			else{
				this.labelFunction = null;
			}
		}
		public function get formatThousandth():Boolean{
			return _formatThousandth;
		}
		
		
		//——————————————————————————————————
		//		列文本对齐 
		//——————————————————————————————————
		private var _textAlign:String = "left";
		
		/**
		 * 列文本对齐 
		 * @return 
		 * 
		 */
		[Inspectable(category="General", enumeration="center,left,right" , defaultValue="left")]
		public function get textAlign():String
		{
			return _textAlign;
		}
		
		public function set textAlign(value:String):void
		{
			_textAlign = value;
		}
		
		
		//——————————————————————————————————
		//		下拉框数据显示处理
		//——————————————————————————————————
		
		private var _comboDataProvider:IList;	
		private var _comboDataField:String = "id";
		private var _comboLabelField:String = "label";
		private var _associateDisplayField:String;
		private var _associateComboField:String="label";
		
		/**
		 * 数据关联字段集合.多个字段用','分隔，字段个数应与associateComboField一致
		 * 当下拉框选中时,将SelectedItem[_associateComboField] 赋值给对应字段。
		 * 
		 * @return 
		 * 
		 */
		public function get associateDisplayField():String
		{
			return _associateDisplayField;
		}
		
		public function set associateDisplayField(value:String):void
		{
			_associateDisplayField = value;
		}
		
		/**
		 * 下拉框的数据源的字段集合，多个字段用','分隔，字段个数应与associateDisplayField一致
		 * 用于当combobBox选中时，将数据源指定字段的值赋值到associateDisplayField
		 * @return 
		 * 
		 */
		public function get associateComboField():String
		{
			return _associateComboField;
		}
		
		public function set associateComboField(value:String):void
		{
			_associateComboField = value;
		}
		
		/**
		 * 获取Combo显示的数据源字段
		 * @return 
		 * 
		 */
		public function get comboLabelField():String
		{
			return _comboLabelField;
		}
		
		/**
		 * 设置Combo显示的数据源字段 
		 * 不设置时，为ComboBox默认labelField：label
		 * @param value
		 * 
		 */
		public function set comboLabelField(value:String):void
		{
			_comboLabelField = value;
		}
		
		/**
		 *获取Combo绑定的数据字段 
		 * @return 
		 * 
		 */
		public function get comboDataField():String
		{
			return _comboDataField;
		}
		
		/**
		 * 设置Combo绑定的数据字段 
		 * 不设置时，为ComboBox默认dataField：id
		 * @param value
		 * 
		 */
		public function set comboDataField(value:String):void
		{
			_comboDataField = value;
		}
		
		/**
		 * 返回ComboBox绑定的数据源 
		 * @return 
		 * 
		 */
		public function get comboDataProvider():IList
		{
			return _comboDataProvider;
		}
		
		/**
		 * 设置ComboBox绑定的数据源 
		 * @param value
		 * 
		 */
		public function set comboDataProvider(value:IList):void
		{
			_comboDataProvider = value;
			this.labelFunction = LabelFunctionUtil.columnFormatForEnumList;
		}
		
		//——————————————————————————————————
		//		处理颜色渲染
		//——————————————————————————————————
		private var _colorFunction:Function =null;
		
		/**
		 * 获取或设置列的颜色渲染过程 
		 * @return 
		 * 
		 */
		public function get colorFunction():Function
		{
			return _colorFunction;
		}
		
		public function set colorFunction(value:Function):void
		{	
			if (_colorFunction == value)
				return;
			
			_colorFunction = value;
			
			if (grid)
			{
				grid.invalidateSize();
				grid.invalidateDisplayList();					
				//grid.clearGridLayoutCache(true);
			}			
		}
	}
}