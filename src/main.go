package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	resp, err := http.Get(os.Getenv("FROMGOTOK8S_URL"))
	if err != nil {
		fmt.Fprint(os.Stderr, err.Error())
		return
	}
	defer resp.Body.Close()
	fmt.Print(resp.StatusCode)
}
