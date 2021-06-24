package main

//#include "cb.h"
import "C"

import "fmt"

//export SayHello
func SayHello(s *C.char) {
	fmt.Println(C.GoString(s))
}

func main() {
	C.CallSayHelloInC()
}
