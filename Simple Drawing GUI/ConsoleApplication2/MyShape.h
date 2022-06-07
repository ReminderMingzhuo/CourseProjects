#pragma once
#include <ege.h>

using namespace ege;

class MyShape
{
public:
	MyShape();
	~MyShape();
	static mouse_msg msg;
	virtual void set(int, int, int, int) = 0;
	virtual void set(int, int) {};
	virtual int getx()const { return x; }
	virtual int gety()const { return y; }
	virtual void draw() {};
	virtual void paint() {};
protected:
	int x;
	int y;
	int r;
	bool bDraw;
};

