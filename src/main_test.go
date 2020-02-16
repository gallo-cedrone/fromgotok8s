package main

import (
	"os"
	"testing"
)

func TestMainFunction(t *testing.T) {
	os.Setenv("FROMGOTOK8S_URL", "http://www.google.com")
	defer os.Clearenv()
	main()
}
