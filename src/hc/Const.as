package hc
{
	import spark.filters.ColorMatrixFilter;

	public final class Const
	{
		//图片变灰色的滤镜
		public static const DISABLED_FILTERS:Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0,0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
	
		public static const ENABLED_FILTERS:Array = [];
	}
}