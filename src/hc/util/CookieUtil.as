package hc.util
{
    import flash.external.ExternalInterface;
    
    public class CookieUtil {
        private static var write_cookie:String = "function writeCookie(args){var cookie_string = args[0] + \"=\" + escape(args[1]);alert(cookie_string);switch (args.length){case 3:cookie_string += \"expires=\" + args[2];break;case 4:cookie_string += \"path=\" + args[3];break;case 5:cookie_string += \"domain=\" + args[4];break;case 6:cookie_string += args[5];break;}document.cookie = cookie_string;}";
        private static var write_cookie2:String = "function setCookie(c_name,value,expiredays) {var exdate = new Date();exdate.setDate(exdate.getDate() + expiredays);document.cookie= c_name + \"=\" + escape(value) + ((expiredays==null) ? \"\" : \";expires=\" + exdate.toGMTString());}";
        private static var get_cookie:String = "function getCookie(name){var allcookies = document.cookie;var pos = allcookies.indexOf(name + \"=\");if (pos != -1) {var start = allcookies.indexOf(\"=\", pos) + 1;var end = allcookies.indexOf(\";\", start);if (end == -1) end = allcookies.length;var value = allcookies.substring(start, end);value = unescape(value);return value;}}";
        private static var get_cookie2:String = "function getCookie(c_name) {if (document.cookie.length>0) {c_start=document.cookie.indexOf(c_name + \"=\");if (c_start!=-1) { c_start=c_start + c_name.length+1;c_end=document.cookie.indexOf(\";\",c_start);if (c_end==-1) {c_end=document.cookie.length;}return unescape(document.cookie.substring(c_start,c_end));} }return \"\"}";
        private static var remove_cookie:String = "function removeCookie(name){var cookie = name + \"=\";cookie += '; expires=Fri, 02-Jan-1970 00:00:00 GMT';document.cookie = cookie;}";
  
		/**
		 * 获取cookies值 
		 * @param name  cookies项的名称
		 * @return 		cookies值
		 */	
        public static function getCookie(name:String):* {
            var result:* = ExternalInterface.call(get_cookie2, name);
            return result;
        }
        
		/**
		 * 设置cookies值
		 * @param name	cookies项的名称
		 * @param value	cookies项的值
		 * @param days	cookies过期日期，如days=21，则表示21天后该cookies值失败
		 */	
        public static function setCookie(name:String, value:String, days:String):void {
            ExternalInterface.call(write_cookie2, name, value, days);
        }
    }
}