package hc.util
{
	import mx.collections.IList;
	
	/**
	 * 集合统计工具
	 * 可用于DataGrid的列值统计
	 * @author Ouxd
	 * @date 2012-01-10
	 */
	public class SummaryUtil
	{	
		/**
		 * 统计集合中指定属性的累加值.
		 * 合计过程自动过滤掉非数字、空值 
		 * @param dataList 		数据集合
		 * @param field 		统计字段
		 * @return 				累计值		
		 * 
		 */
		public static function sum(dataList:IList,field:String):Number{			
			var total:Number = 0.00;
			if(dataList){
				var n:int = dataList.length;				
				var curObj:Object;
				var curNum:Number;
				
				for (var i:int = 0; i < n; i++)
				{
					//取出遍历项的相对属性值
					curObj = dataList.getItemAt(i)[field];
					//属性值处理：空值、非数字
					if(curObj){
						curNum = parseFloat(curObj.toString());
						if(! isNaN(curNum)){
							total += curNum;
						}
					}
				}
				//total = Number((Math.round(total*100)/100).toFixed(2));
			}
			return total;
		}
		
		/**
		 * 统计集合中指定属性的累加值,结果保留2位小数
		 * 合计过程自动过滤掉非数字、空值 
		 * @param dataList		数据集合
		 * @param field			统计字段
		 * @return 
		 * 
		 */
		public static function sumFloat(dataList:IList,field:String):String{			
			var total:Number = 0.00;
			if(dataList){
				var n:int = dataList.length;				
				var curObj:Object;
				var curNum:Number;
				
				for (var i:int = 0; i < n; i++)
				{
					//取出遍历项的相对属性值
					curObj = dataList.getItemAt(i)[field];
					//属性值处理：空值、非数字
					if(curObj){
						curNum = parseFloat(curObj.toString());
						if(! isNaN(curNum)){
							total += curNum;
						}
					}
				}				
			}
			return NumberUtil.toFixed(total,2);
		}
		
		
		/**
		 * 统计集合中指定属性的平均值 
		 * @param dataList 数据集合
		 * @param field 属性名称
		 * @return 平均值
		 * 
		 */
		public static function average(dataList:IList,field:String):String{
			var total:Number = 0;
			var count:int = 1;
			if(dataList){
				count = dataList.length;				
				var curObj:Object;
				var curNum:Number;
				
				for (var i:int = 0; i < count; i++)
				{
					//取出遍历项的相对属性值
					curObj = dataList.getItemAt(i)[field];
					//属性值处理：空值、非数字
					if(curObj){
						curNum = parseFloat(curObj.toString());
						if(! isNaN(curNum)){
							total += curNum;
						}
					}
				}				
			}
			return  (count > 0)? NumberUtil.toFixed(total/count,2):'0'; 
		}
		
		/**
		 * 统计表格行数.
		 * 合计过程自动过滤掉非数字、空值 
		 * @param dataList		数据集合
		 * @return  表格行数
		 * 
		 */
		public static function count(dataList:IList,field:String):int{			
			var n:int = 0;
			if(dataList){
				n = dataList.length;								
			}
			return n;
		}
	}
}