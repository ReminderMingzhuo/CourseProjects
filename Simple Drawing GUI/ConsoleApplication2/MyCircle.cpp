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
		if (msg.is_down())						// ����������
		{
			if (msg.is_left())					// ��������
			{
				setwritemode(R2_XORPEN);		// ����XORģʽ
				set(msg.x, msg.y, 0);
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
				draw();						// ���֮ǰ���Ƶ�ͼ��
				int dx = getx() - msg.x;
				int dy = gety() - msg.y;
				int rr = (int)sqrt(dx * dx + dy * dy);	// ����뾶
				set(rr);
				draw();						// �޸�����������ͼ��
			}
		}
		else if (msg.is_up())					// ̧����갴��
		{
			if (bDraw)
			{
				setwritemode(R2_COPYPEN);		// ��copyģʽ���»���ͼ��
				int dx = getx() - msg.x;
				int dy = gety() - msg.y;
				int rr = (int)sqrt(dx * dx + dy * dy);
				set(rr);
				draw();						// �����ƹ̶�ͼ��
				bDraw = false;
			}
		}
	
}

