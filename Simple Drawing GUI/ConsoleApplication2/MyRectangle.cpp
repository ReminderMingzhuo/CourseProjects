#include "MyRectangle.h"
#include <ege.h>

using namespace ege;

MyRectangle::MyRectangle()
{
	x1 = 0; 
	y1 = 0;
}


MyRectangle::~MyRectangle()
{
}

void MyRectangle::set(int xx, int yy, int x11, int y11)
{
	x = xx;
	y = yy;
	x1 = x11;
	y1 = y11;
}

void MyRectangle::set(int x11, int y11)
{
	x1 = x11;
	y1 = y11;
}

void MyRectangle::draw()
{
	rectangle(x, y, x1, y1);
}

void MyRectangle::paint()
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
				draw();						// ���֮ǰ���Ƶ�ͼ��
				int x11 = msg.x;
				int y11 = msg.y;
				set(x11, y11);
				draw();						// �޸�����������ͼ��
			}
		}
		else if (msg.is_up())					// ̧����갴��
		{
			if (bDraw)
			{
				setwritemode(R2_COPYPEN);		// ��copyģʽ���»���ͼ��
				int x11 = msg.x;
				int y11 = msg.y;
				set(x11, y11);
				draw();						// �����ƹ̶�ͼ��
				bDraw = false;
			}
		}
	
}
