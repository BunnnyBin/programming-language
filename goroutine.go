package main

import (
	"fmt"
)

func main() {
	msgs := make(chan int, 5) //버퍼가 5개인 비동기 채널

	go func() {
		for i := 1; i <= 100; i++ {
			fmt.Println("Producer>", i)
			msgs <- i
			fmt.Println("Producer<", i)
		}
		close(msgs)
	}()

	for msg := range msgs {
		fmt.Println("Consumer=", msg)
	}
}
