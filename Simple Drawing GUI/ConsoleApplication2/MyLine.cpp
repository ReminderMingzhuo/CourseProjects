#include "MyLine.h"



MyLine::MyLine()
{
	x1 = 0;
	y1 = 0;
}


MyLine::~MyLine()
{
}

void MyLine::set(int xx, int yy, int x11, int y11)
{
	x = xx;
	y = yy;
	x1 = x11;
	y1 = y11;
}

void MyLine::set(int x11, int y11)
{
	x1 = x11;
	y1 = y11;
}

void MyLine::paint()
{

		if (msg.is_down())						// 有鼠标键按下
		{
			if (msg.is_left())					// 是鼠标左键
			{
				setwritemode(R2_XORPEN);		// 设置XOR模式
				set(msg.x, msg.y, msg.x, msg.y);
				draw();
				bDraw = true;					// 开始跟踪鼠标画图
			}
			else if (msg.is_right())			// 是鼠标右键
			{
				if (bDraw)
				{
					draw();					// 清除图形
					setwritemode(R2_COPYPEN);	// 设置copy模式
					bDraw = false;
				}
			}
		}
		else if (msg.is_move())					// 移动鼠标
		{
			if (bDraw)
			{
				draw();
				int dx = msg.x;
				int dy = msg.y;
				set(dx, dy);
				draw();
			}
		}
		else if (msg.is_up())					// 抬起鼠标按键
		{
			if (bDraw)
			{
				setwritemode(R2_COPYPEN);		// 用copy模式重新绘制图形
				int dx = msg.x;
				int dy = msg.y;
				set(dx, dy);
				draw();						// 最后绘制固定图形
				bDraw = false;
			}
		}
	
}
