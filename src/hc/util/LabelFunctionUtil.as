package hc.util
{
	
	import hc.components.datagrid.DataGridColumn;
	
	import mx.collections.IList;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.utils.StringUtil;
	
	import spark.components.gridClasses.GridColumn;


	public class LabelFunctionUtil
	{
		//格式化取整，四舍五入
		public static function labelFuncRound(item:Object,c:GridColumn):Object{
			if(item[c.dataField] == null) 
				return null;
			else
				return Math.round(Number(item[c.dataField]));
		}
		
		//保留两位小数
		public static function labelFuncNumTwo(item:Object,c:GridColumn):Object{
				if(item[c.dataField] != null)
					return new Number(item[c.dataField]).toFixed(2)
				else 
					return "0.00";
		}
		
		//把零转成空字符串
		public static function labelFuncRemoveZero(item:Object,c:GridColumn):String{
			if(item[c.dataField]==null || Number(item[c.dataField].toString())==0) 
				return '';
			else
				return item[c.dataField];
		}

		//格式化日期
		public static function labelFuncDate(item:Object,c:GridColumn):String{
			if(item[c.dataField] == null) 
				return null;
			else{
				var dateStr:String = item[c.dataField].toString();
				if(dateStr.length==8){
					dateStr=dateStr.substr(0,4) +"-"+dateStr.substr(4,2)+"-"+dateStr.substr(6,2);
				}
				return dateStr;
			}
		}
		
		//格式化文件大小
		public static function formatFileSize(item:Object,column:GridColumn):String {
			return Util.formatFileSize(item[column.dataField]);
		}
		
		//格式化千分位
		public static function formatThousandth(item:Object,column:GridColumn):String {
			if(Util.isBlank(item[column.dataField])){
				return null;
			}
			return NumberUtil.formatThousandth(item[column.dataField]);
		}
		
		/*****************AdvancedDataGrid***************/
		
		//把零转成空字符串
		public static function labelFuncRemoveZeroAdvance(item:Object,c:AdvancedDataGridColumn):String{
			if(item[c.dataField]==null || Number(item[c.dataField].toString())==0) {
				return "";
			}else
				return item[c.dataField];
		}
		
		//AdvancedDataGridColumn格式化日期
		public static function labelFuncDateAdvance(item:Object,c:AdvancedDataGridColumn):String{
			if(item[c.dataField] == null) 
				return null;
			else{
				var dateStr:String = item[c.dataField].toString();
				if(dateStr.length==8){
					dateStr=dateStr.substr(0,4) +"-"+dateStr.substr(4,2)+"-"+dateStr.substr(6,2);
				}
				return dateStr;
			}
		}
		
		//格式化千分位
		public static function formatThousandthAdvance(item:Object,c:AdvancedDataGridColumn):String {
			if(Util.isBlank(item[c.dataField])){
				return null;
			}
			return NumberUtil.formatThousandth(item[c.dataField]);
		}
		
		//保留两位小数
		public static function labelFuncNumTwoAdvance(item:Object,c:AdvancedDataGridColumn):Object{
			if(item[c.dataField] != null)
				return new Number(item[c.dataField]).toFixed(2)
			else 
				return "0.00";
		}
		
		/**
		 * datagrid列值格式化:显示枚举数据名称
		 * @param item		数据行记录.	item[column.dataField]为数据项
		 * @param column	数据列
		 * @return 
		 * 
		 */
		public static function columnFormatForEnumList(item:Object, column:DataGridColumn):String
		{
			if ((item == null) || (column == null) || (column.comboDataProvider == null))	return "";				
			
			var itemValue:Object =item[column.dataField];		
			if((itemValue == null) ||(StringUtil.trim(itemValue.toString())== ""))	return "";
			
			var valueOfGrid:String = itemValue.toString();
			var valueObject:Object=null;
			var valueOfCombo:String = null;
			
			var enumList:IList = column.comboDataProvider;
			
			//根据DataGrid的值，在集合中查找
			for(var i:int=0; i< enumList.length; i++)
			{					
				valueObject= enumList.getItemAt(i);
				valueOfCombo =valueObject[column.comboDataField];
				
				if (valueOfCombo != null){
					//如果找到相同数据，则返回枚举的名称
					if(valueOfGrid.toLowerCase() == valueOfCombo.toString().toLowerCase()){									
						return  valueObject[column.comboLabelField];
					}
				}
				
			}
			//若未找到匹配项，则返回数据值
			return valueOfGrid;		
		}
	}
}