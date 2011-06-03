package com.zerojuan.ui
{
	import flash.display.DisplayObjectContainer;

	public class VScrollbar extends Scrollbar
	{
		public function VScrollBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			super(Slider.VERTICAL, parent, xpos, ypos, defaultHandler);
		}
	}
}