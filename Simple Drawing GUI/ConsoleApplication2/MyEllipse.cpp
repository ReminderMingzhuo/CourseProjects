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
	if (msg.is_down())						// ����������
	{
		if (msg.is_left())					// ��������
		{
			setwritemode(R2_XORPEN);		// ����XORģʽ
			set(msg.x, msg.y, 0, 0);
			draw();
			bDraw = true;					// ��ʼ������껭ͼ
		}
		else if (msg.is_right())			// ������Ҽ�
		{
			if (bDraw)
			{
				draw();					// ���ͼ��
				setwritemode(R2_COPYPEN);	// ����copyģʽ
				bDraw = false;
			}
		}
	}
	else if (msg.is_move())					// �ƶ����
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
	else if (msg.is_up())					// ̧����갴��
	{
		if (bDraw)
		{
			setwritemode(R2_COPYPEN);		// ��copyģʽ���»���ͼ��
			int dx = fabs(getx() - msg.x);
			int dy = fabs(gety() - msg.y);
			set(dx, dy);
			draw();						// �����ƹ̶�ͼ��
			bDraw = false;
		}
	}
}
