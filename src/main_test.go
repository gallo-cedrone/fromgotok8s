package main

import (
	"github.com/magiconair/properties/assert"
	"io/ioutil"
	"net/http"
	"testing"
)

func TestMainFunction(t *testing.T) {
	config()
	server := startServer()
	resp, err := http.Get("http://localhost:8080")
	if err != nil {
		t.Fatal(err.Error())
	}
	defer resp.Body.Close()

	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		t.Fatal(err.Error())
	}
	assert.Equal(t, string(data), "https://google.com answered with statusCode: 200")

	err = server.Shutdown(nil)
	if err != nil {
		panic(err.Error())
	}

}
