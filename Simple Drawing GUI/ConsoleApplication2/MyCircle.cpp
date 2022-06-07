#include "MyCircle.h"
#include <ege.h>
#include <cmath>

using namespace std;
using namespace ege;


MyCircle::MyCircle()
{
}


MyCircle::~MyCircle()
{
}

void MyCircle::set(int xx, int yy, int rr, int oo)
{
	x = xx;
	y = yy;
	r = rr;
}

void MyCircle::set(int rr, int oo)
{
	r = rr;
}

void MyCircle::draw()
{
	circle(x, y, r);
}

void MyCircle::paint()
{
		msg = getmouse();
		if (msg.is_down())						// 有鼠标键按下
		{
			if (msg.is_left())					// 是鼠标左键
			{
				setwritemode(R2_XORPEN);		// 设置XOR模式
				set(msg.x, msg.y, 0);
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
				draw();						// 清除之前绘制的图形
				int dx = getx() - msg.x;
				int dy = gety() - msg.y;
				int rr = (int)sqrt(dx * dx + dy * dy);	// 计算半径
				set(rr);
				draw();						// 修改坐标后绘制新图形
			}
		}
		else if (msg.is_up())					// 抬起鼠标按键
		{
			if (bDraw)
			{
				setwritemode(R2_COPYPEN);		// 用copy模式重新绘制图形
				int dx = getx() - msg.x;
				int dy = gety() - msg.y;
				int rr = (int)sqrt(dx * dx + dy * dy);
				set(rr);
				draw();						// 最后绘制固定图形
				bDraw = false;
			}
		}
	
}

