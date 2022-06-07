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

		if (msg.is_down())						// ����������
		{
			if (msg.is_left())					// ��������
			{
				setwritemode(R2_XORPEN);		// ����XORģʽ
				set(msg.x, msg.y, msg.x, msg.y);
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
				int dx = msg.x;
				int dy = msg.y;
				set(dx, dy);
				draw();
			}
		}
		else if (msg.is_up())					// ̧����갴��
		{
			if (bDraw)
			{
				setwritemode(R2_COPYPEN);		// ��copyģʽ���»���ͼ��
				int dx = msg.x;
				int dy = msg.y;
				set(dx, dy);
				draw();						// �����ƹ̶�ͼ��
				bDraw = false;
			}
		}
	
}
