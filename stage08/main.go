package main

//#include "hello.h"
import "C"

import "fmt"

//export SayHello
func SayHello(s *C.char) {
	fmt.Println(C.GoString(s))
}

func main() {
	C.SayHello(C.CString("Hello, World"))
}
