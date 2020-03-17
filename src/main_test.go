package main

import (
	"github.com/gallo-cedrone/fromgotok8s/src/externalService"
	"github.com/magiconair/properties/assert"
	"io/ioutil"
	"net/http"
	"testing"
	"time"
)

func TestMainFunction(t *testing.T) {
	config()
	server := startServer(externalService.MockGoogleDependency{})
	defer server.Shutdown(nil)

	time.Sleep(500 * time.Millisecond)

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

}
