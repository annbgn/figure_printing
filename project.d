import std.stdio;
import std.algorithm;
import std.array;
import std.conv;
import std.math;

//TODO
//console input !!!
//solve a problem with copied but not inherited constructors
//rename and refactor parse_and_create
//add tests and think of exceptions
//add check for not a positive dimention
// global symbol  -- solved: passed to a method as an argument

void main()
{
    // еще нужны определения всех типов, чтобы не повторять их типа dtfine SQUAREWORD = 'sq'
	writeln("MANUAL\n rect = rectangle\n sq = square\n rtri = rectangular triangle\n frame = empty rectangle\n\nwhen enumerating shapes use comma as delimiter, and you should also provide size of each shape like AxB where A and B are numbers\nvalid example:\n\"rect 3x2, sq 4x4, rtri 5x6, frame 3x3\"\n\n\n");

    // тут ввод
    // entering and parsing
    string symbol = "#";
    string str= "rect 3x2, sq 4x4, rtri 8x6, frame 5x7";

    // тут превращение в норм код
    int amount = 0;
    if (str[$-1] != ',') {
        amount = count(str, ',') +1;
        writeln(amount);
        }
    else {
        amount = count(str, ',');
        writeln(amount);
        }
     foreach (num, elem; str.split(",")) {
        elem = strip(elem, ' ');
        parse_and_create(elem, symbol);
        }
}

class Form {
	protected: int dim1;
	protected: int dim2;

		
	//constructors
	this(int a, int b) {
	this.dim1 = a;
	this.dim2 = b;
	}

	this(){}

	//getters
	final int get_dim1(){
	return this.dim1;
	}
	
	final int  get_dim2(){
	return this.dim2;
	}

	//logic here
	abstract void draw(string symbol);
}

class Rectangle:  Form {
	override void draw(string symbol){
		writeln("Hi, i'm rectangle");
		foreach (d1; 0..this.get_dim1()){
			foreach (d2; 0..this.get_dim2()){  //TODO rewrite this loop as "*" multiplied by this.get_dim2()
				write(symbol);
			} 
			write("\n");
		}
	}

	this(int a, int b) {
	super(a,b);
	}
}

class Square:  Form {
	override void draw(string symbol){
		writeln("Hi, i'm square");
		foreach (d1; 0..this.get_dim1()){
			foreach (d2; 0..this.get_dim1()){  //TODO rewrite this loop as "*" multiplied by this.get_dim2()
				write(symbol);
			} 
			write("\n");
		}
	}
	
	this(int a, int b) {
	super(a,b);
	}
}

class RectTriangle:  Form {
	override void draw(string symbol){
		writeln("Hi, i'm rect triangle");
		
		float hypo = sqrt (to!float(this.dim1 * this.dim1 + this.dim2 * this.dim2));
		float rate = hypo / this.dim1;

		foreach (i; 0..this.dim1) {
			//float current_hypo = i * rate;
			//float sin_vert_hypo = this.dim2 / hypo;
			//float current_line = current_hypo * i / hypo;
			//int amount_current_line = to!int(current_line);
			float current_line = this.dim2 *i / this.dim1;
			int amount_current_line = to!int(round(current_line));
			if (amount_current_line == 0) {
				write("|");
			}
			else {
				foreach (j; 0..amount_current_line) {
					write(symbol);
				}
			}
			write("\n");
		}
	}
	
	this(int a, int b) {
	super(a,b);
	}
}	

class Frame:  Form {
	override void draw(string symbol){
		writeln("Hi, i'm frame");
		if ((this.dim1 < 3) || (this.dim2 < 3)) {
			foreach (d1; 0..this.get_dim1()){
				foreach (d2; 0..this.get_dim2()){  //TODO rewrite this loop as "*" multiplied by this.get_dim2()
					write(symbol);
			} 
			write("\n");
		}
		}
		else {
			foreach (d2; 0..this.get_dim2()){  //TODO rewrite this loop as "*" multiplied by this.get_dim2()
				write(symbol);
			}  //first line
			write("\n");
			foreach (d1; 0..this.get_dim1()-2){
				write(symbol);
				foreach (d2; 0..this.get_dim2()-2){  //TODO rewrite this loop as "*" multiplied by this.get_dim2()
					write("_");
				}
				write(symbol);
				write("\n");
			}
			foreach (d2; 0..this.get_dim2()){  //TODO rewrite this loop as "*" multiplied by this.get_dim2()
				write(symbol);
			} //last line
		}
		
		
	}
	
	this(int a, int b) {
	super(a,b);
	}
}

void parse_and_create(string str, string symbol) {
    string[2] objectparams = str.split(' ');
    assert (objectparams.length == 2);  //to ensure the input elem has shape and size though i guess some REGEXP would be better
	auto shapeword = objectparams[0];
	int dim1 = to!int(objectparams[1].split('x')[0]);
	int dim2 = to!int(objectparams[1].split('x')[1]);

	switch (shapeword){
	default: 
	throw new Exception("error: shape is not valid");
	case "rect":
		Rectangle shape = new Rectangle(dim1, dim2);
		shape.draw(symbol);
		break;
	case "sq":
		if (dim1 != dim2){
			writeln("warning: square has different sizes, so it's a rectangle");
			Rectangle shape = new Rectangle(dim1, dim2);
			shape.draw(symbol);
			}
		else {
		Square shape = new Square(dim1, dim2);
		shape.draw(symbol);
		}
		break;
	case "rtri":
		RectTriangle shape = new RectTriangle(dim1, dim2);
		shape.draw(symbol);
		break;
	case "frame":
		Frame shape = new Frame(dim1, dim2);
		shape.draw(symbol);
		break;
	}
}

unittest{
string symbol = "test ";
string str1= "rect 3x2, sqx 4";
string str2= "rect 3x2, sq 4x4";
string str3= "rect 3x2, invalid 1x1";
string str4= "rect -3x-2,";
parse_and_create(str1, symbol);
parse_and_create(str2,symbol);
parse_and_create(str3, symbol);
parse_and_create(str4, symbol);
}