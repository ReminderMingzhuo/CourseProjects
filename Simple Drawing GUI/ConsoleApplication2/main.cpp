#include <iostream>
#include <ege.h>
#include "MyFilledCircle.h"
#include "MyCircle.h"
#include "MyEllipse.h"
#include "MyFillEllipse.h"
#include "MyFillRectangle.h"
#include "MyRectangle.h"
#include "MyLine.h"
#include "menu.h"

using namespace std;
using namespace ege;

int main()
{
	initgraph(1440, 900, INIT_RENDERMANUAL);	//绘图窗口初始化
	menubar();									//绘制菜单界面

	MyCircle c;
	MyEllipse e;
	MyFilledCircle fc;
	MyFillEllipse fe;
	MyRectangle r;
	MyFillRectangle fr;
	MyLine l;
	MyShape* pt;
	int cc = -1;
	
	for (; is_run(); delay_fps(60))				//刷新率60
	{
		while (mousemsg()) { MyShape::msg = getmouse(); }
		ChooseColor1();
		ChooseWidth();
		ChooseShape(cc);						//选择颜色线宽图形
		switch (cc) {
		case 0: {pt = &e; pt->paint(); break; }
		case 1: {pt = &c; pt->paint(); break; }
		case 2: {pt = &r; pt->paint(); break; }
		case 3: {pt = &l; pt->paint(); break; }
		case 4: {pt = &fe; pt->paint(); break; }
		case 5: {pt = &fc; pt->paint(); break; }
		case 6: {pt = &fr; pt->paint(); break; }
		}
	}

	return 0;
}
