#include "MyShape.h"



MyShape::MyShape()
{
	x = 0; 
	y = 0; 
	r = 0;
	bDraw = false;
}


MyShape::~MyShape()
{
}

mouse_msg MyShape::msg = { 0 };