#include "MyEllipse.h"
#include <cmath>


MyEllipse::MyEllipse()
{
	xr = 0;
	yr = 0;
}


MyEllipse::~MyEllipse()
{
}

void MyEllipse::set(int xx, int yy, int xrr, int yrr)
{
	x = xx;
	y = yy;
	xr = xrr;
	yr = yrr;
}

void MyEllipse::set(int xrr, int yrr)
{
	xr = xrr;
	yr = yrr;
}

void MyEllipse::paint()
{
	if (msg.is_down())						// 有鼠标键按下
	{
		if (msg.is_left())					// 是鼠标左键
		{
			setwritemode(R2_XORPEN);		// 设置XOR模式
			set(msg.x, msg.y, 0, 0);
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
			int dx = fabs(getx() - msg.x);
			int dy = fabs(gety() - msg.y);
			set(dx, dy);
			draw();
		}
	}
	else if (msg.is_up())					// 抬起鼠标按键
	{
		if (bDraw)
		{
			setwritemode(R2_COPYPEN);		// 用copy模式重新绘制图形
			int dx = fabs(getx() - msg.x);
			int dy = fabs(gety() - msg.y);
			set(dx, dy);
			draw();						// 最后绘制固定图形
			bDraw = false;
		}
	}
}
