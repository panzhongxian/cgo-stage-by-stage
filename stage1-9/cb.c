#include "cb.h"

extern void SayHello(/*const*/ char *s);

void CallSayHelloInC() { SayHello("Hello, World"); }
